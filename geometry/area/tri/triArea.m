function A=triArea(faces,vertices,val,verbose)
% A=triArea(faces,vertics,val)
%
% If 'val' is not provided, then simply determine the area of a mesh
% specified via faces and 3D vertices using Heron's formula
%
% If 'val' is provided, then integrate over the mesh (val should had the
% same number of entries as pos, i.e. numel(val)==size(pos,1)
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx3)
%   val          - optional; scalar values at the vertices
%
% Output
%
%   A            - area or integral
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

if nargin<4, verbose=true; end

if verbose
    fprintf('%s: using Heron''s formula to compute the area ...\n',...
        mfilename);
end

if isempty(faces), A=0; return; end

x1=vertices(faces(:,1),:);
x2=vertices(faces(:,2),:);
x3=vertices(faces(:,3),:);

a=sqrt(sum((x1-x2).^2,2)); %vecnorm(x1-x2,2,2);
b=sqrt(sum((x2-x3).^2,2)); %vecnorm(x2-x3,2,2);
c=sqrt(sum((x3-x1).^2,2)); %vecnorm(x3-x1,2,2);

s=(a+b+c)/2;

if nargin>2 && ~isempty(val)
    
    % https://en.wikipedia.org/wiki/Triangular_prism
    h=mean(val(faces),2);
    A=sum(sqrt(s.*(s-a).*(s-b).*(s-c)).*h);
    
else

    A=sum(sqrt(s.*(s-a).*(s-b).*(s-c)));

end

end
