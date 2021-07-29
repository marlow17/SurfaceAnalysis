function varargout=weightArea(area,verbose)
% varargout=weightArea(area,points,values) - measure an area with given
% weights at given points
%
% Input
%
%   area          - structure with fields .Vertices and .Faces
%   points        - a point set (3D)
%   values        - and values at the points
%
% Output
%
%   if nargout==1 - structure with the area size, centroid and values
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

if nargin<2, verbose=false; end

% compute the sum of areas of the area triangles using Heron's formula and
% weight the vertices by the values ... outcome has units m*unitOfValues
result.Area=triArea(area.Faces,area.Vertices,area.Values,verbose);
% compute the likewise weighted centroid
if ~isempty(area.Values)
    result.Centroid=mean(area.Vertices.*repmat(area.Values,1,3));
else
    result.Centroid=nan(1,3);
end

if nargout>1
    result=struct2cell(result);
    varargout=result(1:min(numel(result),nargout));
else
    varargout{1}=result;
end

end

%% _ EOF__________________________________________________________________