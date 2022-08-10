SELECT continentExp,dateRep,SUM(cases) AS totalCases,SUM(deaths) AS totalDeaths
FROM CoronavirusCases t, CountryContinent q
WHERE t.geoId=q.geoId
GROUP BY q.continentExp, t.dateRep
ORDER BY t.dateRep;
