##   _____                            _     ____  
##  / ____|                          | |   |___ \ 
## | |     ___  _ __  _ __   ___  ___| |_    __) |
## | |    / _ \| '_ \| '_ \ / _ \/ __| __|  |__ < 
## | |___| (_) | | | | | | |  __/ (__| |_   ___) |
##  \_____\___/|_| |_|_| |_|\___|\___|\__| |____/ 
##

ROWS = 4;
COLS = 5;
CONNECT = 3;

ALPHA = 0.001;
GAMMA = 0.8;
EPSILON = 0.05;
BATCH_SIZE = 32;

REWARDS = [100; 0; -10];

##takes place on a 4x5 board with the lowest row to keep track of 
##the lowest available placement position (ie gravity)
## . . . . .
## . . @ . .
## . X X . .
## . @ @ X .
## 4 2 1 3 4

EmptyBoard = zeros(ROWS, COLS);
EmptyBoard = [EmptyBoard; ones(1, COLS)*ROWS];

replayMemory = generateRandomReplays(EmptyBoard, 10, REWARDS);

#Q network: takes game state and action, evaluates quality of action
#input: ROWSxCOLS vector with binary is there a piece here
#input: ROWSxCOLS vector with -1 enemy piece; 0 nothing; 1 my piece
#input: COLS vector with binary am I dropping here

# m x 45 input layer
# Theta1 46 x 40 
# Leaky ReLu
# m x 40 hidden layer
# Theta2 41 x 20
# Leaky ReLu
# m x 20 hidden layer
# Theta3 21 x 8
# Sigmoid
# m x 8 hidden layer
# Theta4 9 x 1
# [no nonlinearity]
# m x 1 output layer

THETA_DIMS = [40, 46; 20, 41; 8, 21; 1, 9];

Theta1 = rand(THETA_DIMS(1,1), THETA_DIMS(1,2)) - 0.5;
Theta2 = rand(THETA_DIMS(2,1), THETA_DIMS(2,2)) - 0.5;
Theta3 = rand(THETA_DIMS(3,1), THETA_DIMS(3,2)) - 0.5;
Theta4 = rand(THETA_DIMS(4,1), THETA_DIMS(4,2)) - 0.5;

theta = [Theta1(:); Theta2(:); Theta3(:); Theta4(:)];
theta_ = theta; #theta_ is the parameter vector for the target of Q

nl1 = @(M)leakyReLu(M);   nlg1 = @(M)leakyReLuGradient(M);
nl2 = @(M)leakyReLu(M);   nlg2 = @(M)leakyReLuGradient(M);
nl3 = @(M)sigmoid(M);     nlg3 = @(M)sigmoidGradient(M);
nl4 = @(M)M;              nlg4 = @(M)ones(size(M));
nonlinearity = {nl1, nl2, nl3, nl4};
nonlinearityGrad = {nlg1, nlg2, nlg3, nlg4};

##      if turn > 1
##        gameMemory{turn-1}{4} = reverse(board);
##      endif
##      
##      if checkWin(board, 1)
##        gameMemory{turn}{3} = 100; #save log of reward, 100 for win
##        gameMemory{turn-1}{3} = -10; #if I won, the last player gets punished
##        gameMemory{turn-1}{4} = []; #the opponent does not get to keep playing
##        playing = false;
##      else
##        gameMemory{turn}{3} = 1; #still in game, save reward 1
##      endif
##      
##      board = reverse(board);
##      if countLegalMoves(board) == 0
##        playing = false;
##      endif
##      
##      turn += 1;

lossLog = [];

for epsiode = 1:50
  Board = EmptyBoard;
  gameMemory = {};
  turn = 1;
  playing = true;
  while playing
    ## <play game>
    gameMemory{turn} = cell(1,4);
    gameMemory{turn}{1} = Board;
    move = epsilonGreedyMove(Board, THETA_DIMS, theta, nonlinearity, EPSILON);
    assert(move != -1);
    gameMemory{turn}{2} = move;
    Board = place1(Board, move);
    
    if turn > 1
      gameMemory{turn-1}{4} = reverse(Board);
    endif
    
    if checkWin(Board, 1)
      gameMemory{turn}{3} = REWARDS(1); #save log of reward, 100 for win
      gameMemory{turn-1}{3} = REWARDS(3); #if I won, the last player gets punished
      gameMemory{turn-1}{4} = []; #the opponent does not get to keep playing
      playing = false;
    else
      gameMemory{turn}{3} = REWARDS(2); #still in game, save reward 1
    endif
    
    Board = reverse(Board);
    
    if countLegalMoves(Board) == 0
      playing = false;
    endif
    
    turn += 1;
    ## </play game>
    
    ## <gradient descent>
    indices = randperm(size(replayMemory, 2), BATCH_SIZE);
    transitions = replayMemory(1, indices);
    
    [J, grad] = Qcost(transitions, THETA_DIMS, theta, theta_, nonlinearity, nonlinearityGrad, GAMMA);
    lossLog = [lossLog; J];
    theta = theta - ALPHA*grad;
    ## </gradient descent>
  endwhile
  replayMemory = [replayMemory, gameMemory]; #append this game to the running replayMemory
  theta_ = theta;
endfor
