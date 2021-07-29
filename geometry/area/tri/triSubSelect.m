function [tra,y]=triSubSelect(faces,vertices,x,delta,fullTriangle,verbose)
% [tra,y]=triSubSelect(faces,vertices,x,delta)
%
% Determine a submesh of the triangulated mesh with faces and vertices
% where the vertices y of the submesh tra results from
%
%         min(x)-delta<=y<=max(x)+delta
%
%         or
%
%         min(x(ind,:))-delta<=y<=max(x(ind,:)+delta
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx2) or (Mx3))
%   x            - either 3D points xi or index array implying x=x(x,:)
%   delta        - scalar defining the extra range (see above)
%   fullTriangle - optional; is set only triangles are included at fall 
%                  entirely in the bounding area, otherwise every it
%                  suffices the one vertex of a triangle is in the bounding
%                  area (default: false)
%
% Output
%
%   tra           - submesh faces (N_newx3)
%   y             - submesh vertices (M_newx2) or (M_newx3)
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

% set the defaults
if nargin<5, fullTriangle=false; end
if nargin<6, verbose=true; end

% determine the bounding area
if size(x,2)==1 % xi=index
    b=minmax(vertices(x,:)')';
else             % xi=3D-points
    b=minmax(x')';
end
if nargin>3 % add an extra range (see above)
    b=b+[-1;1]*delta;
end

indX=find(all(vertices>=b(1,:) & vertices<=b(2,:),2));

if fullTriangle
    indT=all(ismember(faces,indX),2);
else
    indT=any(ismember(faces,indX),2);
    indX=unique(faces(indT,:));
end

y=vertices(indX,:);
[~,tra]=ismember(faces(indT,:),indX);

if verbose
    fprintf('%s: including %d vertices in the search area\n',...
        mfilename,numel(indX));
end

end
