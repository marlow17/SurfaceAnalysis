function [y,ix,iy]=triClosestVertex(faces,vertices,x,varargin)
% y=triClosestVertex(faces,vertices,x,varargin)
%
% Find the closest vertex (or vertices) of points x in a mesh with
% faces and vertices under some distance
% 1. if tri is given the closest triangle is searched for and all unique
%    points are returned
% 2. if tri is not given, we only look for the closest vertices
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx2) or (Mx3)
%   x            - data points spanning the to-be-estimate area (Kx3)
%   varargin     - additional input arguments are pasted into pdist2
%
% Output
%
%   y            - closest points in the mesh [faces,vertices]
%
% See also pdist2
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

verbose=true;
i=strcmp(varargin,'verbose');
if ~isempty(i) 
    if find(i)==numel(varargin)
        verbose=true;
    else
        verbose=varargin{find(i)+1};
        i(find(i)+1)=true;
    end
    varargin=varargin(~i);
end

if isempty(faces) % use the closest vertex
    
    indX=nan(size(x,1),1);
    for k=1:size(x,1)
        [~,i]=min(pdist2(vertices,x(k,:),varargin{:}));
        indX(k)=i;
    end
    if verbose
        fprintf('%s: using the closest vertices ...\n',mfilename);
    end

else % search for the vertices of the closest surrounding triangle
        
    indX=findClosestTriangle(triangulation(faces,vertices),x,verbose);
    
end

[indX,ix,iy]=unique(indX); % remove dublicates
    
y=vertices(indX,:);

if verbose
    fprintf('%s: returning %d unique vertices for %d points\n',...
        mfilename,size(y,1),size(x,1));
end

end

