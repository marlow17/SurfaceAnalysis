function [ind,G]=triShortestPath(faces,vertices,x,G,verbose)
% [ind,G]=triShortestPath(faces,vertices,x,G)
%
% This function searches for the shortest paths between all points xi in a
% triangulated mesh with faces and vertices, or - if given - in its
% representation as a sparse graph G
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx2) or (Mx3)
%   x            - either the data points xi or an index of data points,
%                  which implies xi=x(xi,:)
%   G            - optional, sparse, weighted graph representation of
%                  the mesh [tri,x], i.e. the adjacency is given by the
%                  simplexes and weights by some distance between vertices
%
% Output
%
%   ind          - indices of resultant points, i.e. x(ind,:) gives the
%                  points on the mesh in 3D
%   G            - graph respresentation of the mesh [tri,x]
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

if nargin<5, verbose=true; end

% if the graph representation is not given, we compute it ...
if nargin<4 || isempty(G)
    G=tri2graph(faces,vertices); % adjacencies=edges, weights=distances
end

% if xi is given as 3D points determine the corresponding vertex indices
if size(x,2)>1
    indXi=find(ismember(vertices,x,'rows'));
else
    indXi=x;
end

% this is only needed for the progress report
k=0; N=floor(numel(indXi)*(numel(indXi)-1)/2/20);

ind=indXi;
for i=1:numel(indXi) % loop over all point pairs in the mesh/graph

    indPath=[];
    
    fXi=faces(any(faces==indXi(i),2),:);
    
    for j=i+1:numel(indXi)
        
        % check whether indXi(i) & indXi(j) are in a triangle
        if nnz(indPath==indXi(j))==0 && nnz(fXi==indXi(j))==0

            % if indXi(i) & indXi(j) are not already connected, estimate
            % the shortest distance of the undirected graph using
            % Dijkstra's algorithm ...
            [~,indP]=graphshortestpath(G,indXi(i),indXi(j),...
                'Directed',false,'Method','Dijkstra');
            indPath=unique([indPath,indP]);
        
        end
        
        % progress report
        if verbose && mod(k,N)==0, fprintf('.'); end; k=k+1;
        
    end
    
    ind=unique([indPath';ind]);
    
end

end
