function [hist_model,location_init,halfheight,halfwidth]=InitTracker(file,hist_bins_number)
%
% Initialize by hand a tracking location and color histogram model for the
% object of interest
%
% fcall:  [hist_model,location_init,halfheight,halfwidth]=InitTracker(file,hist_bins_number);
%
% Inputs:
% - file: full path to first image of sequence
% - hist_bins_number: number of histogram bins for color histogram model (currently hsv)
%
% Outputs:
% - hist_model      : color histogram modelling the object to be tracked
% - location_init   : initial object center position (given manually);
% - halfheight      : reference half height size
% - halfwidth       : reference half width size

% creating the tracking list

% reading first image
current_image=double(imread(file));                 

% manually initializing the tracker
[location_init,halfwidth,halfheight]=ManualInit(current_image); 

% initilization object hitogram template
hist_model=BuildObjectModel(current_image,location_init,halfwidth,halfheight,hist_bins_number);


%%% sub functions
function object_model=BuildObjectModel(current_image,state_init,halfwidth,halfheight,hist_bins_number)
% build object model
c1=state_init(1)-halfwidth;
c2=state_init(1)+halfwidth;

r1=state_init(2)-halfheight;
r2=state_init(2)+halfheight;

object_model=ColorHistogram(current_image(r1:r2,c1:c2,:),hist_bins_number);

%
function [state_init,halfwidth,halfheight]=ManualInit(current_image)
% manually initializing the tracker
disp('define the object to track by clicking on the top left');
disp('and bottom right of a tight box surrounding it');

quest='n';
while quest~='y'
    figure(1);image(uint8(current_image));
    [col,row]=ginput(2);
    col=floor(col);
    row=floor(row);
    Ic=current_image(row(1):row(2),col(1):col(2),:);
    figure(1);image(uint8(Ic));axis equal;
    quest=input('initialization OK? y or n: ','s');
end
close(1);

halfwidth=round((col(2)-col(1)+1)/2);
halfheight=round((row(2)-row(1)+1)/2);

state_init=[col(1)+halfwidth;row(1)+halfheight];

