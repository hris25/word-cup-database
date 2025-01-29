#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"

  tail -n +2 games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    TEAM_WINNER_EXIST=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_OPPONENT_EXIST=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_WINNER_EXIST ]]
    then
      TEAM_WINNER_INSERTION=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')");
      echo "$TEAM_WINNER_INSERTION"
    fi
    if [[ -z $TEAM_OPPONENT_EXIST ]]
    then
      TEAM_OPPONENT_INSERTION=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')");
      echo "$TEAM_OPPONENT_INSERTION"
    fi

    GET_CURRENT_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    GET_CURRENT_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    GAMES_INSERTION=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $GET_CURRENT_WINNER_ID, $GET_CURRENT_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
    echo "$GAMES_INSERTION"

  done
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
