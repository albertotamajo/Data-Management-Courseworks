CREATE TABLE CoronavirusCases
(
dateRep NUMERIC NOT NULL,
day INTEGER NOT NULL CHECK(day >= 1 AND day <= 31),
month INTEGER NOT NULL CHECK(month >=1 AND month <= 12),
year INTEGER NOT NULL CHECK(year >= 2019),
cases INTEGER NOT NULL CHECK(cases >= 0),
deaths INTEGER NOT NULL CHECK(deaths >= 0),
countriesAndTerritories TEXT NOT NULL,
geoId TEXT NOT NULL CHECK(length(geoId)=2),
PRIMARY KEY (geoId ASC,dateRep),
FOREIGN KEY (geoId) REFERENCES CountryContinent (geoId)
ON UPDATE CASCADE ON DELETE RESTRICT 
)WITHOUT ROWID;


CREATE TABLE CountryContinent
(
geoId INTEGER PRIMARY KEY ASC NOT NULL CHECK(length(geoId)=2),
countryterritoryCode TEXT CHECK(length(countryterritoryCode)=3 OR countryterritoryCode IS NULL),
continentExp TEXT,
FOREIGN KEY (countryterritoryCode) REFERENCES CountryPopulation (countryterritoryCode)
ON UPDATE CASCADE ON DELETE RESTRICT
)WITHOUT ROWID;

CREATE TABLE CruiseShips
(
dateRep NUMERIC NOT NULL,
day INTEGER NOT NULL CHECK(day >= 1 AND day <= 31),
month INTEGER NOT NULL CHECK(month >=1 AND month <= 12),
year INTEGER NOT NULL CHECK(year >= 2019),
cases INTEGER NOT NULL CHECK(cases >= 0),
deaths INTEGER NOT NULL CHECK(deaths >= 0),
shipTerritory TEXT NOT NULL,
shipId TEXT NOT NULL,
passengersNumber INTEGER,
PRIMARY KEY (shipId ASC,dateRep)
)WITHOUT ROWID;

CREATE TABLE CountryPopulation
(
countryterritoryCode TEXT PRIMARY KEY ASC NOT NULL CHECK(length(countryterritoryCode)=3),
popData2018 INTEGER CHECK(popData2018 >= 0)
)WITHOUT ROWID;


CREATE INDEX countriesAndTerritoriesIndex ON CoronavirusCases(countriesAndTerritories);
CREATE INDEX countryterritoryCodeIndex ON CountryContinent(countryterritoryCode);

CREATE VIEW unitedKingdom AS
SELECT *
FROM CoronavirusCases
WHERE geoId="UK";

CREATE VIEW casesAndDeathsByCountry AS
SELECT SUM(cases) AS sumCases,SUM(deaths) AS sumDeaths,geoId,countriesAndTerritories
FROM CoronavirusCases
GROUP BY geoId;

CREATE VIEW populationCountry AS
SELECT *
FROM CountryContinent t, CountryPopulation q
WHERE t.countryterritoryCode=q.countryterritoryCode;

/*Use of the ”WITHOUT ROWID” keyword: all the tables have been created by using the ”WITH-
OUT ROWID” keyword in order to significantly improve the performance of the database. Indeed, by
default, in SQlite the primary key of each table is a UNIQUE SEQUENTIAL INTEGER INDEX. Thus,
even though a user provides a primary key, this one is replaced by the unique index which is called rowid.
This index is located in a B*-Tree and each node's index points to a location in secondary memory where the row
associated with the index is located. The real (natural) primary key instead is placed in a B-Tree where
each node’s key is the natural key of each tuple and each node’s value is the rowid index the natural key
is associated with. Therefore, retrieving a tuple by using the natural primary key consists of traversing
2 B-trees because firstly the rowid the given primary key value is associated with must be found (B-Tree
traversal) and only after this it is possible to locate the location of the tuple by traversing the B*-Tree
of the indexes. In conclusion, using ”WITHOUT ROWID” leads to retrieval operations which are twice
as fast as the retrieval operations on a table with rowid index. The only disadvantage associated with
”WITHOUT ROWID” is that the primary keys cannot be too large in size. Indeed, it is important to
notice that while the rowid indexes are stored in a B*-Tree (which stores the values in the leaves), the
natural primary keys are stored in a normal B-Tree which stores the values also in the intermediate nodes.
Such a difference could lead to worse performances if the primary keys values are large in size because
every intermediate nodes would take up more space in a single secondary memory page. However, this is
not the case because the primary keys of the relations built for this coursework are not large in size.
• CoronavirusCases relation: the CoronavirusCases table has been created so that none of its attributes
can be NULL. This choice has been made because otherwise some of the functional dependencies that
have been declared at the beginning of this paper could become not realisable. It is also important to
notice that the primary key of the CoronavirusCases has been declared to be NOT NULL because SQlite
does not prevent a primary key from being NULL automatically. However, other SQL database engines do
this because a primary key CAN NEVER BE NULL. The CoronavirusCases table contains a foreign
key which happens to be also a prime member of the CoronavirusCases relation itself. This foreign key
is the geoId attribute which is the primary key of the table CountryContinent. The attribute geoId is
a foreign key because it is evident that there exists a MANY-TO-ONE RELATIONSHIP from the
table CoronavirusCases to the table CountryContinent. Whenever there exists a many-to-one relationship
from X to Y it is good practice to bring the primary key of Y into X so that the primary key of Y becomes
the foreign key of X and is possible to join the two tables X and Y without a loss of information. This is
why geoId is a foreign key of CoronavirusCases. Some constraints have been applied to geoId so that it is
not possible to delete a row x in the CountryContinent table if a row y of the CoronavirusCases references
x as this would lead to a loss of useful information. Similarly, whenever the attribute geoId is updated
in a row x of the CountryContinet table, the value of the geoId attribute of all rows of CoronavirusCases
that reference to x will be updated as a consequence.
Since, the ”WITHOUT ROWID” keyword has been used then SQlite builds a Clustered Index on the
primary key of the table. This is why the keyword ”ASC” has been used so that all the rows are physically
stored into ascending order with respect to the attribute geoId.
The following additional indexes have been created:
– An index on the countriesAndTerritories attribute so that all the queries which involve a select-
from-where (condition on countriesAndTerritories) statements are sped up.

There is no need to create an index on the primary key because the primary key is already indexed by
a cluster index. Indeed, the tuples are physically stored into ascending order with respect to the geoId
attribute.For the same reason there is no need of creating an index on geoId. It is important to notice
that no index has been created for the attributes (dateRep, day, month, year, cases, deaths) because the main advantage
of using indexes is to retrieve the position of the tuples that contain a certain attribute value by bringing
5in main memory the least number of secondary memory pages as possible (in order to retrieve even a
single tuple from a table, a whole page must be fetched from secondary memory). However, the attributes
(dateRep, day, month, year, cases, deaths) are sparse over most pages (if not all of them).
• CountryContinent relation: in the CountryContinent relation all attributes, except the primary key
geoId, can have null values. Indeed, this can’t cause some functional dependencies to become not real-
isable. This table contains a foreign key which is the attribute countryterritoryCode. The attribute
countryterritoryCode is the primary key of the relation CountryPopulation. Unlike the relationship
between CoronavirusCases and CountryContinent, the relationship between CountryContinent is ONE-
TO-ONE because every tuple of CountryContinent can reference at most one tuple of the relation Coun-
tryPopulation as in the dataset provided not all rows contain a value for the countryterritoryCode
attribute. Since, some tuples of the dataset provided contain null values in the countryterritoryCode
attribute and it is the primary key of the relation CountryPopulation then countryterritoryCode must
be a foreign key of the CountryContinent relation. Indeed, if a row x of the CountryContinent relation
contains a non-null value for the attribute countryterritoryCode then it is possible to retrieve the
population of that country by joining the tuple x with the tuple of the CountryPopulation y which has
the same value for the attribute countryterritoryCode. Instead, if a tuple x of the CountryContinet
relation does have a null-value in the countryterritoryCode attribute, then performing the join of this
tuple x with the relation CountryPopulation won’t produce any result because none of the tuples of the
CountryPopulation can have a null value in the countryterritoryCode attribute as it is the primary
key of the relation itself. As regard the index created for this relation, the following have been created:
– An index on the countryterritoryCode attribute so that all the queries which involve a select-from-
where (condition on countryterritoryCode) statements are sped up.
The geoId attribute is already indexed by the cluster index. It is not convenient to create an index for
the continentExp attribute because the values of this attributes are sparse over many different disk pages
(if not all of them).
• CountryPopulation relation: the primary key of this relation is the countryterritoryCode attribute
and so it cannot be NULL. On the other hand the popData2018 attribute can have NULL values and
this won’t make any functional dependency not realisable. No indexes have been created in this table
because the primary key is already a cluster index and the popData2018 values are sparse over many
disk pages.*/

