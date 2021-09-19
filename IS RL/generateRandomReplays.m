## Copyright (C) 2021 tpylypenko
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} generateRandomReplays (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-13

function replayMemory = generateRandomReplays (initialBoard, numGames, REWARDS)
  replayMemory = {};

  #play 10 games of random moves to set up initial data
  for game = 1:numGames
    board = initialBoard;
    
    gameMemory = {};
    turn = 1;
    playing = true;
    while playing
      gameMemory{turn} = cell(1,4); #make a log.  1:s  2:a  3:r  4:s'
      gameMemory{turn}{1} = board; #save log of state
      action = randomMove(board);
      gameMemory{turn}{2} = action; #save log of action
      board = place1(board, action);
      
      if turn > 1
        gameMemory{turn-1}{4} = reverse(board);
      endif
      
      if checkWin(board, 1)
        gameMemory{turn}{3} = REWARDS(1); #save log of reward, 100 for win
        gameMemory{turn-1}{3} = REWARDS(3); #if I won, the last player gets punished
        gameMemory{turn-1}{4} = []; #the opponent does not get to keep playing
        playing = false;
      else
        gameMemory{turn}{3} = REWARDS(2); #still in game, save reward 1
      endif
      
      board = reverse(board);
      if countLegalMoves(board) == 0
        playing = false;
      endif
      
      turn += 1;
    endwhile
    
    replayMemory = [replayMemory, gameMemory];
  endfor
endfunction
