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
## @deftypefn {} {@var{retval} =} Qcost (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-15

function [J, grad] = Qcost (transitions, THETA_DIMS, theta, theta_, nonlinearity, nonlinearityGrad, GAMMA)
  numThetas = size(THETA_DIMS, 1);
  Thetas = unrollTheta(theta, THETA_DIMS);
  m = size(transitions, 2);
  J = 0;
  Theta_grads = cell(1, numThetas);
  for i = 1: numThetas
    Theta_grads{1, i} = zeros(size(Thetas{1, i}));
  endfor
  
  
  y = [];
  
  for i = 1:size(transitions, 2)
    sPrime = transitions{i}{4};
    y(i, 1) = transitions{i}{3}; #reward
    if any(size(sPrime) != 0) #if there is a next state, sPrime has nonzero dimensions
      optimalNextMove = greedyMove(sPrime, THETA_DIMS, theta_, nonlinearity);
      y(i, 1) += GAMMA * Q(sPrime, optimalNextMove, THETA_DIMS, theta_, nonlinearity);
    endif
  endfor
  
  states = {};
  actions = {};
  for i = 1:size(transitions, 2)
    states{1, i} = transitions{i}{1};
    actions{1, i} = transitions{i}{2};
  endfor
  
  [yPrediction, az] = Q(states, actions, THETA_DIMS, theta, nonlinearity);
  
  #--------Linear Algebra---------#
  delta = cell(1, numThetas + 1);
  
  delta{1, numThetas+1} = (yPrediction - y)'; 
  for i = flip(2:numThetas, 2) # ie 4 3 2
    delta{1, i} = ((Thetas{1, i}')*delta{1, i+1})(2:end, :) .* (nonlinearityGrad{i}(az{2,i})');
  endfor
  
  for i = flip(1:numThetas, 2) # ie 4 3 2 1
    Theta_grads{1, i} = Theta_grads{1, i} + delta{1, i+1}*[ones(size(az{1, i}, 1), 1), az{1, i}];
    Theta_grads{1, i} ./= m;
  endfor
  
  J = (1/m)*sum(delta{1, numThetas+1} .* delta{1, numThetas+1});
  grad = [];
  for i = 1: numThetas
    grad = [grad; Theta_grads{1, i}(:)]; #unroll gradients
  endfor
endfunction
