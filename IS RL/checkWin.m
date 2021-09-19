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
## @deftypefn {} {@var{retval} =} checkWin (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-12

function victory = checkWin (board, side, connect = 3)
  victory = false;
  numRows = size(board, 1);
  numCols = size(board, 2);
  
  dirs = [-1, 1; 0, 1; 1, 1; 1, 0];
  for dirIdx = 1:4
    dirRow = dirs(dirIdx, 1);    
    dirCol = dirs(dirIdx, 2);
    for startRow = 1:numRows - 1
      for startCol = 1:numCols
        works = true;
        for steps = 0:connect-1
          newRow = startRow + steps*dirRow;
          newCol = startCol + steps*dirCol;
          if newRow < 1 || newRow > numRows - 1 || ...
            newCol < 1 || newCol > numCols || ...
            board(newRow, newCol) != side
             works = false;
             break
           endif
        endfor
        if works
          victory = true;
          return
        endif
      endfor
    endfor
  endfor
endfunction
