function area=...
    surfaceAnalysis(surface,points,typeOfProjection,values,verbose)
% area=surfaceAnalysis(surface,point,typeOfProjection) - identify points on 
% a given surface and determine the corresponding area that can be plotted,
% measured, masked, etc. In brief,
%
% 1. points are projected onto the surface either on the nearest vertex or
%    on the nearest triangle
% 2. the area containing all the points is estimated using triFindArea
%    a) the search area is reduced by simple minmax estimates of the
%       projected points vis-a-vis the surface vertices
%    b) the search area is transferred into a weighted graph (weights are
%       Euclidean distances between vertices (when calling triFindArea one
%       may use other ground distances but here the Euclidean seems proper)
%    c) in the graph we determine the shortest connecting path between all
%       pairs of points; every vertex in the paths is considered part of
%       the identified area, i.e. a new point
%    d) iterate c with the new, updated points until the point set does no
%       longer increase (a fixed maximum number of iterations guarantees
%       that the loop remains finite).
%
% Input
%
%   surface          - structure with fields .Vertices and .Faces - should
%                      be a triangulated mesh!
%   points           - a point set of Nx3 doubles
%   typeOfProjection - 'none' (use if points have been projected earlier)
%                    - 'vertex' = nearest vertex
%                    - 'triangle' = nearest triangle
%   values           - values at the points (must be as many a points = N)
%
% Output
%
%   area             - structure with fields .Vertices and .Faces; if some
%                      values are given as input, area will also contain a
%                      field .Values with as many entries as vertices in
%                      the area; these values are determined via natural
%                      interpolation/nearest extrapolation on the surface.
%
%
% see also triClosestVertex, triFindArea, pdist2, scatteredInterpolant

% the outcome may be quantified using measureArea, weightArea
%
%                                        (c) Andreas Daffertshofer 10/2019
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

fn={ 'Faces','Vertices','Values','FaceTypes', ...
    'ProjectedPoints','OriginalPoints', ...
    'Original2Projected','Projected2Original' };
area=cell2struct(cell(numel(fn),1),fn);

if nargin==0, return; end
if nargin<3 || isempty(typeOfProjection), typeOfProjection=1; end
if nargin<4, values=[]; end
if nargin<5, verbose=2; end

assert(all(isfield(surface,{'Vertices','Faces'})),'Wrong input structure');
assert(isempty(values) || numel(values)==size(points,1), ...
    'The numbers of points and values must commensurate.');

t=tic;
if verbose>1
    fprintf('%s: analyzing surface ...\n',mfilename);
end

% project the points onto the mesh
switch lower(typeOfProjection)
    
    case { 0, 'none' }
        assert(isfield(surface,'OriginalPoints'), ...
            ['Type of projection == ''none'' requires the field ' ...
            '''OriginalPoints'' in the surface structure.']);
        i=ismember(surface.OriginalPoints,points,'rows');
        assert(sum(i)==size(points,1),['Projection ''none'' failed ' ...
            'because not all points can be found as surface vertex.']);
        % for very large areas this should be replaced by an index search
        % instead of the pdist-minimization in triClosestVertex... for the
        % time being, though, this appears to be fast enough...
        [area.ProjectedPoints, ...
            area.Projected2Original,area.Original2Projected]=...
            triClosestVertex([],surface.Vertices,points, ...
            'verbose',verbose>1);
        area.OriginalPoints=points;
    case { 1, 'vertex', 'vertices' }
        area.OriginalPoints=points;
        [area.ProjectedPoints, ...
            area.Projected2Original,area.Original2Projected]=...
            triClosestVertex([],surface.Vertices,points, ...
            'verbose',verbose>1);
    case { 2, 'triangle', 'triangles' }
        area.OriginalPoints=points;
        [area.ProjectedPoints, ...
            area.Projected2Original,area.Original2Projected]=...
            triClosestVertex(surface.Faces,surface.Vertices,points, ...
            'verbose',verbose>1);
    otherwise
        error('type of projection not properly defined');
        
end

% find the corresponding triangles and points in the mesh
delta=max(range(minmax(area.ProjectedPoints')'))/10;
[area.Faces,area.Vertices,area.FaceTypes]=...
    triFindArea(surface.Faces,surface.Vertices,area.ProjectedPoints, ...
    delta,[],verbose>1);

if ~isempty(values)
    val=nan(size(area.ProjectedPoints,1),1);
    for i=1:numel(val)
        val(i)=mean(values(area.Original2Projected==i));
    end
    if numel(val)<4
        [~,j]=min(pdist2(area.ProjectedPoints,area.Vertices));
        area.Values=val(j);
    else
        F=scatteredInterpolant(area.ProjectedPoints,val, ...
            'natural','nearest');
        area.Values=F(area.Vertices);
    end
end

% generate a warning if more than 5% of the points are not in a triangle
if sum(area.FaceTypes~=3)/numel(area.FaceTypes)>5/100
    pointIsVertex=0;
    for k=1:size(area.ProjectedPoints,1)
        if min(pdist2(surface.Vertices, ...
                area.ProjectedPoints(k,:)))<=sqrt(eps)
            pointIsVertex=pointIsVertex+1;
        end
    end

    if verbose
        fprintf(['%s: found %d isolated node(s) and %d dyad(s) and ' ...
            '''only'' %d triad(s) --> RESULTS MIGHT BE INCORRECT\n'], ...
            mfilename,sum(area.FaceTypes==1),sum(area.FaceTypes==2), ...
            sum(area.FaceTypes==3));
    end
end

if verbose>1
    fprintf('%s: elapsed time %s\n',mfilename,duration(0,0,toc(t)));
end

%% if no output is request then plot the bugger
if ( nargout==0 || nargout==2 ) && exist('plotOnSurface','file')
    subplot(1,3,1)
    plotOnSurface(surface,'points',area.OriginalPoints);
    title('original points');
    subplot(1,3,2)
    plotOnSurface(surface,'points',area.ProjectedPoints);
    title('projected points');
    subplot(1,3,3)
    plotOnSurface(surface,'area',area);
    title('estimated area');
    clear('area');
end

end

%% _ EOF__________________________________________________________________
