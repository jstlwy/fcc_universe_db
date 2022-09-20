PSQL="psql -X --username=freecodecamp --dbname=universe -c"
echo $($PSQL "TRUNCATE galaxy, star, planet, moon RESTART IDENTITY;")
pg_dump -cC --inserts -U freecodecamp universe > universe.sql
