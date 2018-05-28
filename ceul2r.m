%EUL2R Convert Euler angles to rotation matrix
%
% R = EUL2R(PHI, THETA, PSI, OPTIONS) is an SO(3) orthonornal rotation
% matrix (3x3) equivalent to the specified Euler angles.  These correspond
% to rotations about the Z, Y, Z axes respectively. If PHI, THETA, PSI are
% column vectors (Nx1) then they are assumed to represent a trajectory and
% R is a three-dimensional matrix (3x3xN), where the last index corresponds
% to rows of PHI, THETA, PSI.
%
% R = EUL2R(EUL, OPTIONS) as above but the Euler angles are taken from the
% vector (1x3)  EUL = [PHI THETA PSI]. If EUL is a matrix (Nx3) then R is a
% three-dimensional matrix (3x3xN), where the last index corresponds to
% rows of RPY which are assumed to be [PHI,THETA,PSI].
%
% Options::
%  'deg'      Angles given in degrees (radians default)
%
% Note::
% - The vectors PHI, THETA, PSI must be of the same length.
%
% See also EUL2TR, RPY2TR, TR2EUL, SO3.eul.




% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

function R = ceul2r(phi, varargin)
    opt.deg = false;
    [opt,args] = tb_optparse(opt, varargin);

    % unpack the arguments
    if numcols(phi) == 3
		theta = phi(:,2);
		psi = phi(:,3);
		phi = phi(:,1);
	elseif nargin >= 3
        theta = args{1};
        psi = args{2};
    else
        error('RTB:eul2r:badarg', 'expecting 3 inputs, 3-vector or 3-column matrix')
    end

    % optionally convert from degrees
    if opt.deg
        d2r = pi/180.0;
        phi = gpuArray(phi * d2r);
        theta = gpuArray(theta * d2r);
        psi = gpuArray(psi * d2r);
    end

    if numrows(phi) == 1
        R = pagefun(@mtimes,pagefun(@mtimes,crotz(phi), croty(theta)),crotz(psi));
    else
        R = gpuArray(zeros(3,3,numrows(phi)));
        for i=1:numrows(phi)
            R(:,:,i) = pagefun(@mtimes,pagefun(@mtimes,crotz(phi(i)),croty(theta(i))),crotz(psi(i)));
        end
    end