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
## @deftypefn {} {@var{retval} =} Q (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-13

function [quality, az] = Q (Boards, actions, THETA_DIMS, theta, nonlinearity)
  #roll theta into matrices
  numThetas = size(THETA_DIMS, 1);
  Thetas = unrollTheta(theta, THETA_DIMS);
    
  #make feature vector for each element of the batch
  
  features = [];
  
  assert(iscell(Boards) == iscell(actions))
  if iscell(Boards) #if we were given a cellarray of examples
    numRows = size(Boards{1}, 1);
    numCols = size(Boards{1}, 2);
    
    for i = 1:size(Boards, 2) #loop through all of them
      boardVec = (Boards{i}(1:numRows-1, :))(:);
      actionVec = (1:numCols == actions{i})(:);
      f = [boardVec; boardVec != 0; actionVec]'; #create feature row vector
      features = [features; f]; #add it to bottom of matrix
    endfor
  else
    numRows = size(Boards, 1);
    numCols = size(Boards, 2);
    
    boardVec = (Boards(1:numRows-1, :))(:);
    actionVec = (1:numCols == actions)(:);
    features = [boardVec; boardVec != 0; actionVec]'; #transpose to make it a row vector
  endif
  
  az = forwardPropagation(Thetas, numThetas, features, nonlinearity);
  
  quality = az{1, numThetas + 1};
endfunction
