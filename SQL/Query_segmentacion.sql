-- ¿Cómo se distribuyen los ingresos entre los clientes y qué proporción 
-- de las ventas totales representan los principales clientes?
-- Empezamos a hacer el analisis de clientes, vamos a clasificarlos mediante RFM.

USE AdventureWorks2025;
-- 1. Identificar el tipo de cliente
WITH clientes AS (
    SELECT
        CustomerID,
        PersonID,
        StoreID,
        CASE
            WHEN StoreID IS NOT NULL
                THEN 'TIENDA/EMPRESA'
            WHEN PersonID IS NOT NULL
                THEN 'PERSONA'
            ELSE 'SIN ASOCIACION'
        END AS TipoEntidad,
        CASE
            WHEN PersonID IS NOT NULL
             AND StoreID IS NOT NULL
                THEN 'SI'
            ELSE 'NO'
        END AS TieneContactoAsociado
    FROM Sales.Customer
),
-- 2. Calcular gasto, frecuencia y última compra
aux AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS GastoTotal,
        COUNT(*) AS FrecuenciaCompra,
        MAX(OrderDate) AS UltimaFecha
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),

-- 3. Incorporar el tipo de cliente
base AS (
    SELECT
        c.CustomerID,
        c.TipoEntidad,
        c.TieneContactoAsociado,
        a.GastoTotal,
        a.FrecuenciaCompra,
        a.UltimaFecha,
        DATEDIFF(
            DAY,
            a.UltimaFecha,
            (SELECT MAX(OrderDate)
             FROM Sales.SalesOrderHeader)
        ) AS DiasRecencia
    FROM aux AS a
    INNER JOIN clientes AS c
        ON a.CustomerID = c.CustomerID
),

-- 4. Calcular quintiles dentro de cada tipo de cliente
--    R: menor cantidad de días = compra más reciente
--    F y M: valores mayores = mejores puntuaciones
puntuaciones AS (
    SELECT
        *,
        NTILE(5) OVER (
            PARTITION BY TipoEntidad
            ORDER BY DiasRecencia DESC, CustomerID
        ) AS R,
        NTILE(5) OVER (
            PARTITION BY TipoEntidad
            ORDER BY FrecuenciaCompra ASC, CustomerID
        ) AS F,
        NTILE(5) OVER (
            PARTITION BY TipoEntidad
            ORDER BY GastoTotal ASC, CustomerID
        ) AS M
    FROM base
),

-- 5. Asignar segmentos RFM
segmentacion AS (
    SELECT
        *,
        CASE
            WHEN R = 1 AND F = 1 AND M = 1
                THEN 'PERDIDOS'

            WHEN R >= 4 AND F >= 4 AND M >= 4
                THEN 'VIP'

            WHEN R >= 3 AND F >= 3 AND M >= 3
                THEN 'FIELES'

            WHEN R >= 4 AND F <= 2
                THEN 'PROMETEDOR'

            WHEN R <= 2 AND (F >= 3 OR M >= 3)
                THEN 'RIESGO'

            WHEN R <= 2 AND F <= 2 AND M <= 2
                THEN 'AUSENTES'

            ELSE 'SIN CLASIFICAR'
        END AS Segmentacion
    FROM puntuaciones
),
-- Nombres
nombres AS (
    SELECT 
        sg.*,
        CONCAT(pp.FirstName, ' ', pp.LastName) AS NombrePersona,
        ss.[Name] AS StoreName
    FROM segmentacion AS sg
    INNER JOIN Sales.Customer AS c 
        ON sg.CustomerID = c.CustomerID
    LEFT JOIN Person.Person AS pp 
        ON c.PersonID = pp.BusinessEntityID
    LEFT JOIN Sales.Store AS ss 
        ON c.StoreID = ss.BusinessEntityID
)

-- 6. Resultado final
SELECT
    CustomerID,
    TipoEntidad,
    TieneContactoAsociado,
    NombrePersona,
    StoreName,
    R,F,M,
    Segmentacion
--INTO dbo.DimCliente
FROM nombres
ORDER BY TipoEntidad, Segmentacion, CustomerID;
