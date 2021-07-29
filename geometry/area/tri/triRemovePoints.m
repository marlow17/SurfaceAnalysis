function [faces,vertices]=triRemovePoints(faces,vertices)
% [faces,vertices]=triRemovePonts(faces,vertices)
%
% Remove points that are not used in triangular mesh.
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx3)
%
% Output
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx3)
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

j=false(size(vertices,1),1);
j(faces(:))=true(numel(faces),1);
k=cumsum(j); 
vertices=vertices(j,:);
faces=reshape(k(faces(:)),size(faces,1),3);

end
