% This is an example script using TMS stimulation position and MEP
% amplitudes to-be-plotted on a cortical surface.
%
%                                      (c) Andreas Daffertshofer 07/2021
%
% This file is released under the terms of the GNU General Public License,
% version 3. See http://www.gnu.org/licenses/gpl.html

% load the data
cortex=load('cortex');           % a brainstorm cortex structure
stimulation=load('stimulation'); % stimulation points (already transformed
                                 % to the brainstorm coordinate system)

verboseLevel=2; % set an output level to monitor progress

% to mask to a certain area, e.g., left M1 uncomment the following lines
%
% ROI={'Mindboggle6','precentral L'};
% a=strcmp({cortex.Atlas.Name},ROI{1});
% r=strcmp({cortex.Atlas(a).Scouts.Label},ROI{2});
% roiV=cortex.Atlas(a).Scouts(r).Vertices;
% cortex=maskArea(cortex,cortex,roiV);
%

% analyze all 8 muscles in the set
for muscle=1:numel(stimulation.label)

    % select the to-be-included points 
    included=stimulation.included(muscle,:);
    position=stimulation.position(:,included)';
    value=stimulation.amplitude(muscle,included)'; % when kept empty, only
                                                   % geometry will be used
    
    % analyze the surface
    A=surfaceAnalysis(cortex,position,'vertex',value,verboseLevel);
    
    % plot the original points
    subplot(2,numel(stimulation.label),muscle);
    plotOnSurface(cortex,'points',A.OriginalPoints);
    
    title(stimulation.label{muscle}); axis tight;
    
    % plot the estimate surface weighted by the MEP amplitude
    subplot(2,numel(stimulation.label),muscle+numel(stimulation.label));
    plotOnSurface(cortex,'area',A);
    
    S=measureArea(A); % [values] = m
    % uncomment if interest in the amplitude weighted area size
    % S=weightArea(A); % [values] = mV^2

    title(sprintf('%.2f cm^2',S.Area*1e4)); axis tight;
    
end

%% _ EOF__________________________________________________________________
