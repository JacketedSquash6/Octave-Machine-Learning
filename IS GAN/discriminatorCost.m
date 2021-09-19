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
## @deftypefn {} {@var{retval} =} discriminatorCost (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-03-28

function [J grad] = discriminatorCost (DT, DT_DIMS, X, y)
  #setting up variables
  numThetas = size(DT_DIMS, 1);
  DiscThetas = unrollTheta(DT, DT_DIMS);
  m = size(X, 1);J = 0;
  Theta_grads = cell(1, numThetas);
  for i = 1: numThetas
    Theta_grads{1, i} = zeros(size(DiscThetas{1, i}));
  endfor
  
  
  az  = forwardPropagation(DiscThetas, numThetas, X);
  yPrediction = az{1, numThetas + 1};  
  
  J = -(1/m)*sum(y .* log(yPrediction) + (1 - y) .* log(1 - yPrediction));
  
  #--------Linear Algebra---------#
  delta = cell(1, numThetas + 1);
  
  delta{1, 4} = (yPrediction - y)';
  delta{1, 3} = ((DiscThetas{1, 3}')*delta{1, 4})(2:end, :) .* (leakyReLuGradient(az{2,3})');
  delta{1, 2} = ((DiscThetas{1, 2}')*delta{1, 3})(2:end, :) .* (leakyReLuGradient(az{2,2})');
  
  Theta_grads{1, 3} = Theta_grads{1, 3} + delta{1, 4}*[ones(size(az{1, 3}, 1), 1), az{1, 3}];
  Theta_grads{1, 3} ./= m;
  
  Theta_grads{1, 2} = Theta_grads{1, 2} + delta{1, 3}*[ones(size(az{1, 2}, 1), 1), az{1, 2}];
  Theta_grads{1, 2} ./= m;
  
  Theta_grads{1, 1} = Theta_grads{1, 1} + delta{1, 2}*[ones(size(az{1, 1}, 1), 1), az{1, 1}];
  Theta_grads{1, 1} ./= m;
  
  
  grad = [];
  for i = 1: numThetas
    grad = [grad; Theta_grads{1, i}(:)]; #unroll gradients
  endfor
endfunction
