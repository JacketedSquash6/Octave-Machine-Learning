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
## @deftypefn {} {@var{retval} =} unrollTheta (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-28

function Thetas = unrollTheta (RolledT, T_DIMS)
  #setting up variables
  numThetas = size(T_DIMS, 1);
  Thetas = cell(1, numThetas);
  
  #unrolling theta
  frontOfTheta = 0;
  for i = 1:numThetas
    backOfTheta = frontOfTheta + T_DIMS(i,1) * T_DIMS(i,2);
    
    Thetas{1, i} = RolledT(frontOfTheta + 1 : backOfTheta);
    Thetas{1, i} = reshape(Thetas{1, i}, T_DIMS(i,1), T_DIMS(i,2));
    
    frontOfTheta = backOfTheta;
  endfor
endfunction
