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
  echo $GET_NAMES
  # if argument is only one letter long
  elif [[ $1 =~ ^[[:alpha:]]$ ]]
  then
    echo only one letter
  else
    echo more than one letter
  fi
  # display message
  echo $GET_PROPERTIES | while read NUMBER BAR MASS BAR MELT BAR BOIL
  do
    echo $GET_NAMES | while read NAME BAR SYMBOL
    do
      echo -e "\nThe element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  done
  
else
  echo Please provide an element as an argument.  
fi

