function varargout=measureArea(area,surface,verbose)
% varargout=measureArea(area,surface) - measure an area (and a surface)
%
% Input
%
%   area          - structure with fields .Vertices and .Faces
%   surface       - dito (optional)
%
% Output
%
%   if nargout==1 - structure with the area size, centroid and resolution
%                   (and if surface given, also the area of the surface)
%   else          - area size, centroid, ... as separate values
%
%
% see also triArea, weightArea
%
%                                       (c) Andreas Daffertshofer 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

assert(all(isfield(area,{'Vertices','Faces'})),'Wrong input structure');

if nargin<3, verbose=false; end

% compute the sum of areas of the area triangles using Heron's formula
result.Area=triArea(area.Faces,area.Vertices,[],verbose);
% compute the plain centroid
result.Centroid=mean(area.Vertices,1);
% compute the spatial resolution
result.Resolution=result.Area/size(area.Faces,1);

if nargin>1 % compute the sum of areas of all triangles over the surface
    assert(all(isfield(surface,{'Vertices','Faces'})), ...
        'Wrong input structure');
    result.Surface=triArea(surface.Faces,surface.Vertices,[],verbose);
end

if nargout>1
    result=struct2cell(result);
    varargout=result(1:min(numel(result),nargout));
else
    varargout{1}=result;
end

end

%% _ EOF__________________________________________________________________