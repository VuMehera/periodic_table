#!/bin/bash

# Check if the user provided an argument
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1

# Detect if input is a number (atomic_number) or string (symbol/name)
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  QUERY="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type
         FROM properties
         JOIN elements USING(atomic_number)
         JOIN types USING(type_id)
         WHERE atomic_number=$INPUT;"
else
  QUERY="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type
         FROM properties
         JOIN elements USING(atomic_number)
         JOIN types USING(type_id)
         WHERE symbol='$INPUT' OR name='$INPUT';"
fi

RESULT=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "$QUERY")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS MELTING BOILING TYPE <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi