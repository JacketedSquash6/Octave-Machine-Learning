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
## @deftypefn {} {@var{retval} =} greedyMove (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: tpylypenko <tpylypenko@Y380-PYLYPENKO>
## Created: 2021-05-13

function move = greedyMove (Board, THETA_DIMS, theta, nonlinearity)
  legalMoves = findLegalMoves(Board);
  favoriteMove = -1;
  favoriteQuality = -inf;
  for i = find(legalMoves)
    [quality, az] = Q(Board, i, THETA_DIMS, theta, nonlinearity);
    if quality > favoriteQuality
      favoriteMove = i;
      favoriteQuality = quality;
    endif
  endfor
  move = favoriteMove;
endfunction
