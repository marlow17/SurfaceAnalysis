function [c,h]=plotOnSurface(surface,varargin)
% plotOnSurface(surface,varargin) - a simple plotting function
%
%                                        (c) Andreas Daffertshofer 02/2021
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

sColor=[1,0.9749,0.8492];
aColor=[0,0.5,1];
pArgs={'o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none'};

assert(all(isfield(surface,{'Vertices','Faces'})),'Invalid surf. struct.');

options={'area','point','plain','vlim'};
params=cell2struct(cell(numel(options),1),options);

for n=1:numel(options)
    i=find(strncmpi(varargin,options{n},4));
    if ~isempty(i)
        assert(i<numel(varargin), ...
            ['''' varargin{i} ''' requires a parameter.']);
        params.(options{n})=varargin{i+1};
        varargin=varargin([1:i-1,i+2:end]);
    end
end

if ~isempty(params.area)
    assert(all(isfield(params.area,{'Vertices','Faces'})), ...
    'Invalid surf. struct.');
end

if ~isempty(params.point)
    if size(params.point,2)~=2 && size(params.point,2)~=3
        params.point=params.point';
    end
end

%%%% set to variable markersize!!
switch size(surface.Vertices,2)
    case 2
        plotP=@(p,varargin) plot(p(:,1),p(:,2),varargin{:});
    case 3
        plotP=@(p,varargin) plot3(p(:,1),p(:,2),p(:,3),varargin{:});
end

ho=ishold;
if ~ho, cla; end

C=repmat(sColor,size(surface.Vertices,1),1);

c=patch('Faces',surface.Faces,'Vertices',surface.Vertices, ...
    'FaceColor','interp','FaceVertexCData',C ,...
    'EdgeColor','none','FaceAlpha',1,'FaceLighting','gouraud');

hold on;

axis auto;    

if ~isempty(params.point)    
    if numel(varargin), pArgs=varargin; end
    h=plotP(params.point,pArgs{:});
    c.FaceAlpha=0.2;
end

if ~isempty(params.area)
    if ~isempty(params.area.Vertices) %&& ~isempty(params.area.Faces)
        li=ismember(surface.Vertices,params.area.Vertices,'rows');
    else
        li=[];
    end
    if isfield(params.area,'Values') && ~isempty(params.area.Values)
        if isempty(params.vlim)
            F=val2rgbFcn('cmap',hot,'vlim', ...
                minmax(params.area.Values(:)'));
        else
            F=val2rgbFcn('cmap',hot,'vlim',params.vlim);
        end
        c.FaceVertexCData(li,:)=F(params.area.Values);
    else
        c.FaceVertexCData(li,:)=repmat(aColor,sum(li),1);
    end
end

if ~ho, hold off; end
light;
axis vis3d;
axis equal;
axis off
view(-90,90);
    
end

%% _ EOF__________________________________________________________________
