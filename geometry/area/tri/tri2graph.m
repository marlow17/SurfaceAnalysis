function [G,A]=tri2graph(faces,vertices,varargin)
% [G,A]=tri2graph(tri,x,varargin)
%
% Convert a triangulated mesh with faces and vertices into a sparse graph
% G; the adjacency A is given by the simplexes and the weights
% of G by some distance between the vertices x
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx2) or (Mx3)
%   varargin     - additional input arguments are pasted into pdist2
%
% Output
%
%   G            - weigthed graph respresentation of the mesh [tri,x]
%   A            - binary graph respresentation of the mesh [tri,x]
%
% See also pdist2
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

N=size(vertices,1);      % get the number of vertices
A=tri2adj(faces,N); % get the adjacency matrix (sparse)
G=double(A);      % initialize the weighted graph (sparse)

for i=1:N % loop over vertices

    j=A(i,:); % find all connected vertices
    G(i,j)=pdist2(vertices(i,:),vertices(j,:),varargin{:})'; % set the weights

end

end

%% convert triangulated mesh into sparse binary graph
function A=tri2adj(tri,N)

if nargin<2 % if not given, determine the number of vertices
    N=max(tri(:));
end

% estimate the max. number of connections (needed for memory allocation)
M=size(unique([tri(:,[1,2]);tri(:,[2,1]);tri(:,[2,3]);...
    tri(:,[3,2]);tri(:,[3,1]);tri(:,[1,3])],'rows'),1)/2;

% allocate memory for the sparse graph to increase speed
A=logical(spalloc(N,N,M));

for i=1:size(tri,1) % loop over simplexes
    
    A(tri(i,1),tri(i,2))=true;
    A(tri(i,2),tri(i,3))=true;
    A(tri(i,3),tri(i,1))=true;
    
end

% symmetrize the graph and reduce it to the lower diagonal (note that the
% graph is not directed!
A=tril(A|A');

end

