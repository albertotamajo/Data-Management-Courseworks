UPDATE dataset SET countryterritoryCode=null WHERE countryterritoryCode="";
UPDATE dataset SET popData2018=null WHERE popData2018="";
UPDATE dataset SET dateRep=substr(dateRep, 7) || "-" || substr(dateRep,4,2)  || "-" || substr(dateRep, 1,2);
INSERT INTO CoronavirusCases SELECT dateRep,day,month,year,ABS(cases) AS cases,deaths,countriesAndTerritories,geoId FROM dataset WHERE length(geoId)=2;

INSERT INTO CountryContinent SELECT DISTINCT geoId,countryterritoryCode,continentExp FROM dataset WHERE length(geoId)=2;
INSERT INTO CountryPopulation SELECT DISTINCT countryterritoryCode,popData2018 FROM dataset WHERE countryterritoryCode IS NOT NULL AND length(geoId)=2;
INSERT INTO CruiseShips SELECT dateRep,day,month,year,ABS(cases) AS cases,deaths,countriesAndTerritories AS shipTerritory,geoId AS shipId,popData2018 AS passengersNumber FROM dataset WHERE length(geoId) !=2;
