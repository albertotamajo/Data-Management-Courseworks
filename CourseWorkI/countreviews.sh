#!/bin/bash

#Loops through all the files inside a directory  whose names start with "hotel" 
for file in $1/hotel*
do
   #The name of the hotel and its review count are printed out 
   echo $( echo $file | sed 's/.dat//'| awk -F/ '{print $NF}') $(grep -c  "<Overall>"  $file)
 

done | sort -nr -k 2   #Ranks the hotels into descending order based on their review count

