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
## @deftypefn {} {@var{retval} =} randomMove (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-12

function action = randomMove (board)
  numRows = size(board, 1);
  numCols = size(board, 2);
  
  legalCols = board(numRows, :) >= 1;
  legalMoves = sum(legalCols);
  moveOrder = randi(legalMoves); #random number between 1 and num nonfull cols
  
  for i = [1:numCols]
    if legalCols(i)
      moveOrder -= 1;
      if moveOrder == 0
        action = i;
        return
      endif
    endif
  endfor
  
endfunction
