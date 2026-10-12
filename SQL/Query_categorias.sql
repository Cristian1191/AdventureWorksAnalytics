/*
¿Cómo varía el rendimiento comercial entre las categorías 
y subcategorías de productos, considerando los ingresos, 
las unidades vendidas y su participación en las ventas totales?
*/

USE AdventureWorks2025;

WITH aux AS (
	SELECT soh.SalesOrderID, OrderDate,OnlineOrderFlag,TerritoryID,
		sod.OrderQty,ProductID,UnitPrice,
		sod.OrderQty*sod.UnitPrice * (1 - sod.UnitPriceDiscount) AS Total_x_Producto
	FROM Sales.SalesOrderHeader AS soh
	INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
),
-- Como solo nos interesa los productos en este apartado, nos olivdamos de SalesOrderID
totales AS (
	SELECT ProductID,
	SUM(OrderQty) AS Unidades_vendidas,
	SUM(Total_x_Producto) AS Ingreso_total
	FROM aux
	GROUP BY ProductID
)

SELECT	t.ProductID,p.[Name] AS NombreProducto,p.ProductNumber AS CodigoProducto,pds.ProductCategoryID,
pdc.[Name] AS NombreCategoria,
p.ProductSubcategoryID,
pds.[Name] AS NombreSubCategoria, 
	CASE 
		WHEN p.Color IS NOT NULL THEN p.Color
		ELSE 'Otros' END AS Color,
p.ListPrice
INTO dbo.DimProducto
FROM totales AS t
INNER JOIN Production.Product AS p
	ON t.ProductID = p.ProductID
lEFT JOIN Production.ProductSubcategory AS pds
	ON p.ProductSubcategoryID = pds.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pdc
	ON pdc.ProductCategoryID = pds.ProductCategoryID
ORDER BY t.Ingreso_total DESC ;