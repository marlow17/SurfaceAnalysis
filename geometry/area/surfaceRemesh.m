function [surf,data]=surfaceRemesh(surface,data,varargin)
% [surf,data]=surfaceRemesh(surface,data,varargin) - remeshing a surface
% given some query points defined in data
%
% Input
%
%   surface      - structure with fields .Vertices and .Faces
%   data         - query points
%   varargin     - is forwarded to point2trimesh
%
% Output
%
%   surf         - remeshed surface
%   data         - corresponding data
%
%
% see also point2trimesh
%
%                                       (c) Andreas Daffertshofer 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

assert(all(isfield(surface,{'Vertices','Faces'})),'Wrong input structure');
assert(exist('point2trimesh.m','file'),'Cannot find point2trimesh(...)');

fprintf('%s: re-meshing and projecting data points',mfilename);
t=tic;
[~,data,surf.Faces,surf.Vertices]= ...
    point2trimesh(struct('faces',surface.Faces, ...
    'vertices',surface.Vertices),'QueryPoints',data,varargin{:});

fprintf(': elapsed time %s\n',duration(0,0,toc(t)));

end

%% _ EOF__________________________________________________________________