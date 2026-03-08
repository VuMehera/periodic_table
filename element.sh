#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ARG=$1

# Check if argument is an integer (atomic number)
if [[ $ARG =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p ON e.atomic_number=p.atomic_number 
  JOIN types t ON p.type_id=t.type_id
  WHERE e.atomic_number=$ARG")
else
  # Otherwise, search by symbol or name (text)
  ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p ON e.atomic_number=p.atomic_number 
  JOIN types t ON p.type_id=t.type_id
  WHERE e.symbol='$ARG' OR e.name='$ARG'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
