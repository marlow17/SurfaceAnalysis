function masked=maskArea(surface,area,mask)
% masked=maskArea(surface,area,mask) - mask an area on a surface
%
% Input
%
%   surface      - structure with fields .Vertices and .Faces
%   area         - dito
%   mask         - double array selecting the to-be-included points
%
% Output
%
%   masked       - masked area (otherwise identical to area)
%
%
% see also triRemovePoints
%
%                                      (c) Andreas Daffertshofer 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

assert(all(isfield(area,{'Vertices','Faces'})),'Wrong input structure');
assert(all(isfield(surface,{'Vertices','Faces'})),'Wrong input structure');

if any(size(mask)==1), mask=surface.Vertices(mask,:); end

masked=area;

if isempty(area.Faces) || isempty(area.Vertices), return; end

indX=find(ismember(area.Vertices,mask,'row'));
indT=sum(ismember(area.Faces,indX),2)==3;

[masked.Faces,masked.Vertices]=...
    triRemovePoints(area.Faces(indT,:),area.Vertices);

%% if no output is request then plot the bugger
if nargout==0 &&  exist('plotOnSurface','file')
    subplot(1,3,1)
    plotOnSurface(surface,'area',area);
    title('original area');
    subplot(1,3,2)
    plotOnSurface(surface,'points',area.Vertices(indX,:));
    title('selected vertices');
    subplot(1,3,3)
    plotOnSurface(surface,'area',masked);
    title('masked area');
    clear('masked');
end

end

%% _ EOF__________________________________________________________________