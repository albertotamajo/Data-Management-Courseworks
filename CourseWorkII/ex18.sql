SELECT countriesAndTerritories,(1.0*sumDeaths/sumCases*100) AS mortalityRate
FROM casesAndDeathsByCountry
ORDER BY mortalityRate DESC
LIMIT 10;
