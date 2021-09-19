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
## @deftypefn {} {@var{retval} =} generateImages (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-25


function [images, az] = generateImages (GT, GT_DIMS, numPictures = 3600)
  #setting up variables
  numThetas = size(GT_DIMS, 1);
  GenThetas = unrollTheta(GT, GT_DIMS);
  
  a1val = rand(numPictures, GT_DIMS(1,2)-1);
  az = forwardPropagation(GenThetas, numThetas, a1val);
  
  images = az{1, numThetas + 1};
endfunction
