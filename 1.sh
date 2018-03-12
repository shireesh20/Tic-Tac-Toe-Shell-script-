#!/bin/bash

# Game of tic-tac-toe

cell_w=10

pink="\033[35m"
cyan="\033[36m"
blue="\033[34m"
green="\033[32m"
reset="\033[0m"
red="\033[0;31m"
BOLD='\033[1m'
UNDERLINE='\033[4m'

player_1_str=$green"Player One"$reset
player_2_str=$blue"Player Two"$reset

positions=(- - - - - - - - -)  # initial positions

player_one=true  # player switch init
game_finished=false  # is the game finished
stall=false  # stall - if an invalid or empty move was input
clear
cat f
echo
echo
echo

echo -n "enter the no. of games you want to play :"
read n
count=0
p1=0
p2=0
draw=0

# function that draws instructions and board based on positions arr
function draw_board {
  clear

  # passing an array as argument
  positions=("$@")

  # first lines - instructions
  echo -e "\n    7 8 9       _|_|_\n    4 5 6   →    | | \n    1 2 3       ‾|‾|‾\n\n"
  cat f
  echo
  echo
  echo
  echo -e "                                -------------------------------"
  for (( row_id=1; row_id<=3; row_id++ ));do
    # row
    row="                                |"
    empty_row="                                |"
    for (( col_id=1; col_id<$(($cell_w*3)); col_id++ ));do
      # column

      # every 10th is a separator
      if  	[ $(( $col_id%$cell_w )) == 0 ]; then
        row=$row"|"
        empty_row=$empty_row"|"
      else
        if [[ $(( $col_id%5 )) == 0 ]]; then  # get the center of the tile

          x=$(($row_id-1))
          y=$((($col_id - 5) / 10))

          if [[ $x == 0 ]]; then
            what=${positions[$y]}
          elif [[ $x == 1 ]]; then
            what=${positions[(($y+3))]}
          else
            what=${positions[(($y+6))]}
          fi

          # if it's "-", it's empty
          if [[ $what == "-" ]]; then what=" "; fi

          if [[ $what == "X" ]] ; then  # append to row
            row=$row$green$what$reset
          else
            row=$row$blue$what$reset
          fi

          empty_row=$empty_row" "  # advance empty row
        else  # not the center - space
          row=$row" "
          empty_row=$empty_row" "
        fi
      fi
    done
    echo -e "$empty_row|""\n""$row|""\n""$empty_row|"  # row is three lines high
    if [[ $row_id != 3 ]]; then
      echo -e "                                -------------------------------"
    fi
  done
  echo -e "                                -------------------------------"
  echo -e "\n"
}

# function that displays the prompt based on turn, reads the input and advances the game
function read_move {

  positions_str=$(printf "%s" "${positions[@]}")

  # finish game if all postiions have been taken or if a player has won
  test_position_str $positions_str

  if [[ $count -gt $(($n-1)) ]];then
    game_finished=true
    final_score
    exit 0
  fi
  if [ "$game_finished" = false ] ; then

    if [ "$stall" = false ] ; then
      if [ "$player_one" = true ] ; then
        prompt="Your move, "$player_1_str"?"
        sign="X"
        player_one=false
      else
        prompt="Your move, "$player_2_str"?"
        sign="O"
        player_one=true
      fi
    else
      stall=false
    fi

    echo -e $prompt
    read -d'' -s -n1 input  # read input

    index=10  # init with nonexistent
    case $input in
          7) index=0;;
          4) index=3;;
          1) index=6;;
          8) index=1;;
          5) index=4;;
          2) index=7;;
          9) index=2;;
          6) index=5;;
          3) index=8;;
    esac

    if [ "${positions["$index"]}" == "-" ]; then
      positions["$index"]=$sign
    else
      stall=true  # prevent player switch
    fi

    init_game  # reinit, because positions persist
  else
    echo "new game"
    positions=(- - - - - - - - -)
    game_finished=false
    init_game
  fi
}

function init_game {
  draw_board ${positions[@]}
  read_move
}

function end_game {
  game_finished=true
  draw_board ${positions[@]}
}

function final_score {
  echo -e "\n No. of wins of "$player_1_str" : "$p1"\n"
  echo -e "\n No. of wins of "$player_2_str" : "$p2"\n" 
  echo -e "\n No. of draws : "$draw"\n"
}

# function that tests the positions string and ends game if ending conditions are met
function test_position_str {
  rows=${1:0:3}" "${1:3:3}" "${1:6:8}
  cols=${1:0:1}${1:3:1}${1:6:1}" "${1:1:1}${1:4:1}${1:7:1}" "${1:2:1}${1:5:1}${1:8:1}
  diagonals=${1:0:1}${1:4:1}${1:8:1}" "${1:2:1}${1:4:1}${1:6:1}
  rows=$(echo "$rows" | sed $'s/ /\\\n/g')
  cols=$(echo "$cols" | sed $'s/ /\\\n/g')
  diagonals=$(echo "$diagonals" | sed $'s/ /\\\n/g')
  if [[ $( echo "$rows" | grep "XXX" ) = 'XXX' || $( echo "$cols" | grep "XXX" ) = 'XXX' ||
                                                 $( echo "$diagonals" | grep "XXX" | uniq ) = 'XXX' ]]; then
    count=$(bc<<<"scale=0;$count + 1")
    p1=`expr $p1 + 1`
    end_game
    echo -e "                                        "${BOLD} ${UNDERLINE}$player_1_str" "${BOLD} ${UNDERLINE}"wins !!!$reset\n"
    sleep 2
    return
  fi
  if [[ $( echo "$rows" | grep "OOO" ) = 'OOO' || $( echo "$cols" | grep "OOO" ) = 'OOO' ||
                                                 $( echo "$diagonals" | grep "OOO" | uniq ) = 'OOO' ]]; then
    count=$(bc<<<"$count + 1")
    p2=`expr $p2 + 1`
    end_game
    echo -e "                                        "${BOLD} ${UNDERLINE}$player_2_str" "${BOLD} ${UNDERLINE}"wins !!!$reset\n"
    sleep 2
    return
  fi
  if [[ ! $positions_str =~ [-] ]]; then  # all positions taken, not one has won
    count=$(bc<<<"$count + 1")
    draw=`expr $draw + 1`
    end_game
    echo -e "                                 " $red ${BOLD} ${UNDERLINE}"GAME ENDS"$reset ${BOLD} ${UNDERLINE}"in a DRAW !!!!"$reset"\n"
    echo -e "\n\n\n\n"
    sleep 2
  fi
}
init_game
