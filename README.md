# Tic-Tac-Toe-Shell-script-

Tic-Tac- Toe(1 vs 1 and 3*3) shows the basic features of Tic-Tac- Toe
game using the shell script(bash).The basic idea is to show how to use shell script to
implement this game. The program first asks the no. of matches that the players are willing to
play that whose results will be counted for an aggregate score. We also display how many
times player one wins, player two wins and no. of draws in the specified no. of games. The
program prompts the users (2 players playing the game) to input the position alternatively and
operates on the board. The player who chooses to play first is called the player one and is
assigned with symbol X and the second player is called player two and is assigned with
symbol O.Initially,the board is empty and each grid of the board is named by a separate
number ranging 1-9 and the user needs to select the grid using the respective number. In case,
the user gives an undefined number the program is not terminated abruptly but continuously
asks the user to give correct input until the user does so. That is, for each valid input it selects
the grid prompted by the user and modifies the board displayed on the console by placing
respective X or O in the specified grid. It makes use of certain functions to draw the board on
the console and make the proper moves as prompted by the user and checks the condition for
end of the game i.e. if 3 X’s or O’s are matched horizontally, vertically or diagonally the
game is ended. If one of the players wins at any stage of the game, the respective winning
message is displayed and the game is terminated otherwise if the entire board is filled and
still there is no winner a draw message is displayed and the game is terminated. The program
makes use of suitable attractive colours to distinguish the player’s choices etc.
