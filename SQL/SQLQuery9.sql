SELECT st.TerritoryID,st.[Name], st.CountryRegionCode,st.[Group]
INTO dbo.DimTerritorio
FROM Sales.SalesTerritory AS st