#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # populate the teams table
    # get winner team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if winner is not in teams
    if [[ -z $WINNER_ID ]]
    then
      echo -e "\nWinner is not in teams table"
      # add winner to teams
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
        # get new winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
    # else
      # echo -e "\nWinner is in teams table"
    fi
    # get opponent team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if opponent is not in teams
    if [[ -z $OPPONENT_ID ]]
    then
      echo Opponent is not in teams table
      # add opponent to teams
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT=="INSERT 0 1" ]]
      then 
        echo  "Inserted into teams, $OPPONENT"
        # get new opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
    # else
      # echo Opponent is in teams table
    fi

    # insert the game into the games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ INSERT_GAME_RESULT="INSERT 0 1" ]]
    then
     echo "Inserted $YEAR, round $ROUND game. Final score: $WINNER $WINNER_GOALS, $OPPONENT $OPPONENT_GOALS"
    fi



  fi


done