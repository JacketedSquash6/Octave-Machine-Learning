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
## @deftypefn {} {@var{retval} =} classifyImages (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-25


##Discriminator
# m x 100 image input
# DiscTheta1 101 x 30
# Leaky ReLu
# m x 30 hidden layer
# DiscTheta2 31 x 10
# Leaky ReLu
# m x 10 hidden layer
# DiscTheta3 11 x 1
# Sigmoid
# m x 1 predictions

function classifications = classifyImages (DT, DT_DIMS, images)
  #setting up variables
  numThetas = size(DT_DIMS, 1);
  DiscThetas = unrollTheta(DT, DT_DIMS);
  
  az  = forwardPropagation(DiscThetas, numThetas, images);
  
  classifications = az{1, numThetas + 1};
endfunction
