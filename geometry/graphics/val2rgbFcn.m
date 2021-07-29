function F=val2rgbFcn(varargin)
% auxiliary function for the color mapping
%
%                                        (c) Andreas Daffertshofer 02/2021
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

cmap=[];
vlim=[0,1];

for i=1:2:nargin
    assert(nargin~=i,'Option have to come in pairs.');
    switch lower(varargin{i})
        case {'cmap','colormap','colourmap'}
            switch class(varargin{i+1})
                case 'double', cmap=varargin{i+1};
                case 'char', cmap=feval(varargin{i+1});
                case 'function_handle', cmap=varargin{i+1}();
            end                               
        case 'vlim'            
            vlim=varargin{i+1};
        otherwise
            error('Cannot interpret input.');
    end
end

if isempty(cmap), cmap=getCurrentColormap; end

assert(numel(vlim)==2,'Improper value range.');
assert(size(cmap,2)==3,'Colormap has be a Nx3 matrix.');

val=linspace(vlim(1),vlim(2),size(cmap,1))';

F=@(x) [ ...
    interp1(val,cmap(:,1),min(max(x(:),vlim(1)),vlim(2)),'linear') ...
    interp1(val,cmap(:,2),min(max(x(:),vlim(1)),vlim(2)),'linear') ...
    interp1(val,cmap(:,3),min(max(x(:),vlim(1)),vlim(2)),'linear') ...
    ];
    
end

%%
function c=getCurrentColormap

[fig_set,ax_set]=deal(false);

fig=get(0,'CurrentFigure');
if isempty(fig), fig=gcf; fig_set=true; end

ax=get(fig,'CurrentAxes');
if isempty(ax), ax=gca; ax_set=true; end
    
c=get(ax,'Colormap');

if fig_set, delete(fig); elseif ax_set, delete(ax); end

end

%% _ EOF__________________________________________________________________