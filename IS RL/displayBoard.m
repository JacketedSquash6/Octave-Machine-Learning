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
## @deftypefn {} {@var{retval} =} displayBoard (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-13

function retval = displayBoard (board)
  numRows = size(board, 1);
  numCols = size(board, 2);
  
  [p1Rows, p1Cols] = find(board(1:numRows-1, :) == 1);
  scatter(p1Cols, -p1Rows, 1000, 'r', 'filled');
  hold on;
  [p2Rows, p2Cols] = find(board(1:numRows-1, :) == -1);
  scatter(p2Cols, -p2Rows, 1000, 'b', 'filled');
  
  axis([0, numCols+1, -numRows, 0]);
endfunction
