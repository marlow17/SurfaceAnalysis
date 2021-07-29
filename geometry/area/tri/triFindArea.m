function [tri,y,cType]=triFindArea(faces,vertices,x,delta,maxNumSearch, ...
    verbose)
% [tri,y]=triFindArea(faces,vertices,x,delta,maxNumSearch)
%
% This function serves to estimate the area spanned by points x contrained
% to a triangulated mesh specified by faces and vertices
%
% Input
%
%   faces        - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   vertices     - vertices (Mx2) or (Mx3)
%   x            - data points spanning the to-be-estimate area (Kx3)
%   delta        - scalar defining the extra range for searching around the
%                  points x
%                  (if not provided, it defaults to 5% of the max range)
%   maxNumSearch - maximum number of iterations (default: 1000)
%
% Output
%
%   tri          - faces (index Nx3) specifying the indices of the vertices
%                  as standard after delaunay triangularization
%   y            - vertices (Mx3)
%   cType        - an index indicating whether a point is isolated (1), 
%                  part of a dyade (2) or part of a triangle (3) 
%
%                                          (c) marlow 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

% set the defaults
if nargin<4 || isempty(delta), delta=max(range(minmax(x')'))/10; end
if nargin<5 || isempty(maxNumSearch), maxNumSearch=1000; end
if nargin<6, verbose=true; end

if verbose, fprintf('%s: starting search ...\n',mfilename); end

% select the search area
[tra,z]=triSubSelect(faces,vertices,x,delta,[],verbose);
% tra=faces;
% z=vertices;

% find including points
y=triFindPoints(tra,z,x,maxNumSearch,verbose);

% determine corresponding face indices and return the triangles
indX=find(ismember(z,y,'rows'));
[iT,iX]=ismember(tra,indX);
indT=all(iT,2);
[~,tri]=ismember(tra(indT,:),indX);

% count the isolated nodes, dyads, and triads to enable a sanity check
cType=nan(size(indX));
for k=1:3
    i=sum(iT,2)==k; if sum(i)==0, continue; end
    i=unique(iX(i,:)); if i(1)==0, i=i(2:end); end
    cType(i)=k;
end

if verbose, fprintf('%s: found %d vertices and %d faces\n',mfilename, ...
        numel(indX),numel(tri)); end

%% if no output argument is given we plot the bugger
if ~nargout
        
    switch size(vertices,2)
        case 2
            plotP=@(p,varargin) plot(p(:,1),p(:,2),varargin{:});
        case 3
            plotP=@(p,varargin) plot3(p(:,1),p(:,2),p(:,3),varargin{:});
    end
    
    ho=ishold;
    if ~ho, cla; end
    
    % plot the original mesh
    patch('Faces',faces,'Vertices',vertices,'FaceColor',[1,1,1]*.5,...
        'FaceAlpha',.2,'Marker','none','EdgeColor','k','LineWidth',1);
    hold on;
    % plot the search region
    patch('Faces',tra,'Vertices',z,'FaceColor',[1,1,0],...
        'FaceAlpha',.4,'Marker','none','EdgeColor','r','LineWidth',1);
    % plot the identified area
    patch('Faces',tri,'Vertices',y,'FaceColor',[0,1,1],...
        'FaceAlpha',.6,'Marker','none','EdgeColor','b','LineWidth',1);
    % plot the data points
    plotP(x,...
        'o','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor','g');
    
    axis vis3d;
    axis equal;
    axis tight;
    
    if ~ho, hold off; end
    
    clear('tri');
    
end

end


