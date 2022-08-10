
SELECT t.countriesAndTerritories,(1.0*t.sumCases/q.popData2018*100) AS percentageCases, (1.0*t.sumDeaths/q.popData2018*100) AS percentageDeaths
FROM casesAndDeathsByCountry t,populationCountry q
WHERE t.geoId=q.geoId;
