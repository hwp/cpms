function [BBox Surface]=BoundingBox(mycol,myrow,scale,hheight,hwidth,ncol,nrow)
%
%
% Define the object bounding box in function of the state parameters
% Make sure it remains inside the image
%
%  Inputs:
%   - mycol,myrow,scale: center position of the bounding box, and scale
%   - hheight,hwidth: half height and width of the bounding box corresponding to 
%     a scale value of 1
%   - ncol,nrow: size of image where the bounding box should be
%
%  Out: 
%   - BBox.c1  BBox.c2 BBox.r1 BBox.r2  : first and last column (resp. row) of bounding box
%   - Surface: size of BBox; can be used to set a minimum size on BB

% Apply transform

% TO COMPLETE


