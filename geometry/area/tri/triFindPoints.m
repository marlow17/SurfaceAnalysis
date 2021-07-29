function xi=triFindPoints(tri,x,xi,maxNumSearch,verbose)
% xi=triFindPoints(tri,x,xi,maxNumSearch)
%
% This function searches for points that fall in the area spanned by xi
% contrained by a triangulated mesh with simplexes tri and points x
%
% The mesh is converted into a sparse, weighted graph (adjacency is given
% by the simplexes and weights by the Euclidian distance between vertices
%
% Input
%
%   tri          - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   x            - vertices (Mx2) or (Mx3)
%   xi           - data points spanning the to-be-estimate area (Kx3)
%   maxNumSearch - maximum number of iterations 
%
% Output
%
%   xi           - vertices (Mx3)
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

if nargin<5, verbose=true; end

G=[]; % initialize the graph

for i=1:maxNumSearch % iterate until the number of points in the area
                     % does no longer increase; we start with the given xi    

    if verbose, fprintf('%s [run %d]: %5d ',mfilename,i,size(xi,1)); end
    
    % search of all points along all shorested paths between all points xi
    [ind,G]=triShortestPath(tri,x,xi,G,verbose);

    if verbose, fprintf('\n'); end
    
    % if the number of points does not increase we exit the loop
    if numel(ind)==size(xi,1), break; end
    
    % set the new points xi
    xi=x(ind,:);
    
end

if i==maxNumSearch
    warning('maximum number of searches reached in %s.',mfilename);
end

end
