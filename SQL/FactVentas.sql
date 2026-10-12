USE AdventureWorks2025;

SELECT
    aux.SalesOrderID,
    aux.SalesOrderDetailID,
    aux.OrderDate,
    aux.CustomerID,
    aux.ProductID,
    aux.TerritoryID,
    aux.OrderQty,
    aux.UnitPrice,
    aux.UnitPriceDiscount,
    aux.LineTotal
INTO dbo.FactVentas
FROM (
    SELECT
        soh.SalesOrderID,
        soh.CustomerID,
        soh.OrderDate,
        sod.ProductID,
        sod.OrderQty,
        sod.UnitPrice,
        sod.SalesOrderDetailID,
        sod.UnitPriceDiscount,
        sod.LineTotal,
        soh.TerritoryID
    FROM Sales.SalesOrderHeader AS soh
    INNER JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
) AS aux;
