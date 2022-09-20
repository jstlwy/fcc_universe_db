#!/bin/bash
# Script to insert data from courses.csv and students.csv into students database

# -c flag: run single command and exit
PSQL="psql -X --username=freecodecamp --dbname=universe --no-align --tuples-only -c"
echo $($PSQL "TRUNCATE galaxy, star, planet, moon RESTART IDENTITY;")

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

PRINT_START_MESSAGE() {
	echo -e "\nInserting data from: ${BOLD}$1${NORMAL}"  
}

GET_RESULT() {
	if [[ $1 = "INSERT 0 1" ]]; then
		echo -n "Success"
	else
		echo -n "Failure"
	fi
}

PRINT_START_MESSAGE "galaxies.csv"
cat galaxies.csv | while IFS="," read NAME GALAXY_TYPE_ID YEAR_DISCOVERED DISTANCE_IN_LY
do
	# Skip first line (column names)
	if [[ $NAME = "name" ]]; then
		continue
	fi
	# Check for null values
	if [[ -z $YEAR_DISCOVERED ]]; then
		YEAR_DISCOVERED="NULL"
	fi
	INSERT_STATUS=$($PSQL "INSERT INTO galaxy(name, galaxy_type_id, year_discovered, distance_in_ly) VALUES('$NAME', $GALAXY_TYPE_ID, $YEAR_DISCOVERED, $DISTANCE_IN_LY);")
	RESULT_MESSAGE=$(GET_RESULT "$INSERT_STATUS")
	echo "$RESULT_MESSAGE: $NAME, $GALAXY_TYPE_ID, $YEAR_DISCOVERED, $DISTANCE_IN_LY"
done


PRINT_START_MESSAGE "stars.csv"
cat stars.csv | while IFS="," read NAME GALAXY_ID DISTANCE_IN_LY TEMP_IN_K
do
	# Skip first line (column names)
	if [[ $NAME = "name" ]]; then
		continue
	fi
	INSERT_STATUS=$($PSQL "INSERT INTO star(name, galaxy_id, distance_in_ly, temp_in_k) VALUES('$NAME', $GALAXY_ID, $DISTANCE_IN_LY, $TEMP_IN_K);")
	RESULT_MESSAGE=$(GET_RESULT "$INSERT_STATUS")
	echo "$RESULT_MESSAGE: $NAME, $GALAXY_ID, $DISTANCE_IN_LY, $TEMP_IN_K"
done


PRINT_START_MESSAGE "planets.csv"
cat planets.csv | while IFS="," read NAME STAR_ID PLANET_TYPE_ID G DIAMETER TEMP HAS_RING_SYSTEM HAS_MAGNETIC_FIELD
do
	# Skip first line (column names)
	if [[ $NAME = "name" ]]; then
		continue
	fi
	# Check for null values
	if [[ -z $G ]]; then
		G="NULL"
	fi
	if [[ -z $DIAMETER ]]; then
		DIAMETER="NULL"
	fi
	if [[ -z $HAS_RING_SYSTEM ]]; then
		HAS_RING_SYSTEM="NULL"
	fi
	if [[ -z $HAS_MAGNETIC_FIELD ]]; then
		HAS_MAGNETIC_FIELD="NULL"
	fi
	INSERT_STATUS=$($PSQL "INSERT INTO planet(name, star_id, planet_type_id, surface_g_in_m_per_s2, diameter_in_km, mean_surface_temp_in_c, has_ring_system, has_global_magnetic_field) VALUES('$NAME', $STAR_ID, $PLANET_TYPE_ID, $G, $DIAMETER, $TEMP, $HAS_RING_SYSTEM, $HAS_MAGNETIC_FIELD);")
	RESULT_MESSAGE=$(GET_RESULT "$INSERT_STATUS")
	echo "$RESULT_MESSAGE: $NAME, $STAR_ID, $PLANET_TYPE_ID, $G, $DIAMETER, $TEMP, $HAS_RING_SYSTEM, $HAS_MAGNETIC_FIELD"
done


PRINT_START_MESSAGE "moons.csv"
cat moons.csv | while IFS="," read NAME PLANET_ID RADIUS TEMP G
do
	# Skip first line (column names)
	if [[ $NAME = "name" ]]; then
		continue
	fi
	INSERT_STATUS=$($PSQL "INSERT INTO moon(name, planet_id, mean_radius_in_km, mean_surface_temp_in_c, surface_g_in_m_per_s2) VALUES('$NAME', $PLANET_ID, $RADIUS, $TEMP, $G);")
	RESULT_MESSAGE=$(GET_RESULT "$INSERT_STATUS")
	echo "$RESULT_MESSAGE: $NAME, $PLANET_ID, $RADIUS, $TEMP, $G"
done
