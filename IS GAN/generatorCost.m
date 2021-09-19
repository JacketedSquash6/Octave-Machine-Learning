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
## @deftypefn {} {@var{retval} =} generatorCost (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-28

function [J grad] = generatorCost (GT, GT_DIMS, DT, DT_DIMS, Gaz, X, y)
  #setting up variables
  numDiscThetas = size(DT_DIMS, 1);
  numGenThetas = size(GT_DIMS, 1);
  DiscThetas = unrollTheta(DT, DT_DIMS);
  GenThetas = unrollTheta(GT, GT_DIMS);
  m = size(X, 1);J = 0;
  GenTheta_grads = cell(1, numGenThetas);
  for i = 1: numGenThetas
    GenTheta_grads{1, i} = zeros(size(GenThetas{1, i}));
  endfor
  
  Daz = forwardPropagation(DiscThetas, numDiscThetas, X); #(D)iscriminator (a) and (z)
  Daz{2, 1} = Gaz{2, 3}; #the z for the mX100 pictures is created in the Generator, but will be useful here
  
  yPrediction = Daz{1, numDiscThetas + 1};  
  
  J = -(1/m)*sum(y .* log(yPrediction) + (1 - y) .* log(1 - yPrediction)); #BCE loss
  
  #---------Linear Algebra---------#
  Ddelta = cell(1, numDiscThetas + 1);
  Gdelta = cell(1, numGenThetas + 1);
  
  Ddelta{1, 4} = (yPrediction - y)';
  Ddelta{1, 3} = ((DiscThetas{1, 3}')*Ddelta{1, 4})(2:end, :) .* (leakyReLuGradient(Daz{2,3})');
  Ddelta{1, 2} = ((DiscThetas{1, 2}')*Ddelta{1, 3})(2:end, :) .* (leakyReLuGradient(Daz{2,2})');
  Ddelta{1, 1} = ((DiscThetas{1, 1}')*Ddelta{1, 2})(2:end, :) .* (sigmoidGradient(Daz{2,1})');
  
  Gdelta{1, 3} = Ddelta{1, 1}; #both represent the delta of the images
  Gdelta{1, 2} = ((GenThetas{1, 2}')*Gdelta{1, 3})(2:end, :) .* (leakyReLuGradient(Gaz{2, 2})');
  
  
  GenTheta_grads{1, 2} = GenTheta_grads{1, 2} + Gdelta{1, 3}*[ones(size(Gaz{1, 2}, 1), 1), Gaz{1, 2}];
  GenTheta_grads{1, 2} ./= m;
  
  GenTheta_grads{1, 1} = GenTheta_grads{1, 1} + Gdelta{1, 2}*[ones(size(Gaz{1, 1}, 1), 1), Gaz{1, 1}];
  GenTheta_grads{1, 1} ./= m;
  
  
  grad = [];
  for i = 1: numGenThetas
    grad = [grad; GenTheta_grads{1, i}(:)]; #unroll gradients
  endfor
endfunction
