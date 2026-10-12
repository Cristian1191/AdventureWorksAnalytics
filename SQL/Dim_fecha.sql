USE AdventureWorks2025;
WITH limites AS (
    SELECT
        CAST(MIN(OrderDate) AS DATE) AS FechaInicio,
        CAST(MAX(OrderDate) AS DATE) AS FechaFin
    FROM Sales.SalesOrderHeader
),
calendario AS (
    SELECT FechaInicio AS Fecha, FechaFin
    FROM limites
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha), FechaFin
    FROM calendario
    WHERE Fecha < FechaFin
)
SELECT
    Fecha,
    YEAR(Fecha) AS Anio,
    MONTH(Fecha) AS Mes,
    DATENAME(MONTH, Fecha) AS NombreMes,
    DATEPART(QUARTER, Fecha) AS Trimestre,
    CONCAT(
        YEAR(Fecha), '-',
        RIGHT('0' + CAST(MONTH(Fecha) AS VARCHAR(2)), 2)
    ) AS Anio_Mes
INTO dbo.DimFecha
FROM calendario
ORDER BY Fecha
OPTION (MAXRECURSION 0);