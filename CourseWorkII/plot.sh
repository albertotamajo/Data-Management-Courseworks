#!/bin/bash

cmd="SELECT DISTINCT countriesAndTerritories FROM CoronavirusCases GROUP BY geoId ORDER BY sum(deaths) DESC LIMIT 10"

cmd2="SELECT DISTINCT dateRep FROM CoronavirusCases ORDER BY dateRep"

`sqlite3 coronavirus.db "CREATE TABLE CumulationDeaths(dateRep NUMERIC, countriesAndTerritories TEXT, sumdeaths INTEGER, PRIMARY KEY(dateRep,countriesAndTerritories))WITHOUT ROWID"`

`sqlite3 coronavirus.db "INSERT INTO CumulationDeaths SELECT dateRep,countriesAndTerritories, SUM(deaths) OVER (PARTITION BY geoId ORDER BY dateRep) AS sumDeaths FROM CoronavirusCases"`

IFS=$'\n'
fqry=(`sqlite3 coronavirus.db "$cmd"`)
fqry2=(`sqlite3 coronavirus.db "$cmd2"`)

OUT=$(mktemp dataXXX --suffix=.dat)

printf "date" >> "$OUT"

for country in "${fqry[@]}"; do

    printf ",$country" >> "$OUT"

done

for date in "${fqry2[@]}"; do

	printf "\n$date" >> "$OUT"

	for country in "${fqry[@]}"; do

		sumDeaths=(`sqlite3 coronavirus.db "SELECT sumDeaths from CumulationDeaths where dateRep=\"$date\" AND countriesAndTerritories=\"$country\""`)

    		printf ",$sumDeaths" >> "$OUT"
	done
done

gnuplot -persist <<-EOFMarker
set datafile separator ","
set title "Cumulative deaths by top 10 countries and by date"
set terminal png  enhanced font "arial,18" fontscale 1.0 size 1920, 1080
set output 'graph.png'
set style data linespoint


set yrange [0:80000]
set grid
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set xlabel "Date"
set ylabel "Cumulative Deaths"
set xtics "2019-12-31",648000,"2020-04-27"
set xtic rotate by -45 font "Arial,18" scale 0



plot "$OUT" using 1:2 title column,for [i=3:*] '' using 1:i title columnheader(i)

EOFMarker

rm  "$OUT"

`sqlite3 coronavirus.db "DROP TABLE CumulationDeaths"`
