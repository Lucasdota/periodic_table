PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  # get properties
  GET_PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$1")
  # get element name and symbol
  GET_NAMES=$($PSQL "SELECT name, symbol FROM elements WHERE atomic_number=$1")
  # get element type
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")

  # if argument is only one letter long
  elif [[ $1 =~ ^[[:alpha:]]$ ]]
  then
    # get atomic number  
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    # get properties
    GET_PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # get element name and symbol
    GET_NAMES=$($PSQL "SELECT name, symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    # get element type
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")

  else
    # get atomic number  
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    # get properties
    GET_PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # get element name and symbol
    GET_NAMES=$($PSQL "SELECT name, symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    # get element type
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  fi

  # if element not found
  if [[ -z $GET_PROPERTIES ]]
  then
    echo I could not find that element in the database.
  else
  # destructure variables from query and display message
  echo "$GET_PROPERTIES" | while IFS="|" read NUMBER MASS MELT BOIL
  do
   echo "$GET_NAMES" | while IFS="|" read NAME SYMBOL
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  done
  fi

else
  #ask an argument if none was given
  echo Please provide an element as an argument.
fi

