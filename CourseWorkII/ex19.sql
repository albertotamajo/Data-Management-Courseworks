SELECT dateRep,SUM(deaths) OVER (ORDER BY dateRep) AS cumulativeDeaths,SUM(cases) OVER (ORDER BY dateRep) AS cumulativeCases
FROM unitedKingdom
ORDER BY dateRep;

