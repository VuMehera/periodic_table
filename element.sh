#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

RESULT=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, t.type,
p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE atomic_number='$1'
OR symbol='$1'
OR name='$1';
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else

echo "$RESULT" | while IFS="|" read NUM NAME SYMBOL TYPE MASS MELT BOIL
do
echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done

fi
fi