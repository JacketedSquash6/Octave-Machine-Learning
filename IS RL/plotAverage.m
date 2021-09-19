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
## @deftypefn {} {@var{retval} =} plotAverage (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-15

function retval = plotAverage (data, kernelSize)
  length = size(data, 1);
  newLog = [];
  for i = 1:length/kernelSize
    sum = 0;
    for j = 1:kernelSize
      sum += data(kernelSize*(i-1) + j);
    endfor
    newLog = [newLog; sum];
  endfor
  plot(newLog);
endfunction
