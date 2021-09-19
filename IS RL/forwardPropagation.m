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
## @deftypefn {} {@var{retval} =} forwardPropagation (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-28

function az = forwardPropagation (Thetas, numThetas, a1val, nonlinearity)
  az = cell(2, numThetas+1); #az{1,num} is a{num}. az{2,num} is z{num}
  
  az{1, 1} = a1val;
  for i = 2:numThetas + 1
    az{2, i} = [ones(size(az{1, i-1},1),1), az{1, i-1}] * Thetas{1, i-1}';
    az{1, i} = nonlinearity{1, i-1}(az{2, i});
  endfor

endfunction
