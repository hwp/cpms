function tagged_image=DrawObjectLocation(current_image,poscol,posli,scale,hheight,hwidth)
% draw object location
% fcall: tagged_image=DrawObjectLocation(current_image,poscol,posli,scale,hheight,hwidth)
% input:
%  - current_image: image in which we want to draw the box
%  - poscol,posli,scale,hheight,hwidth : bounding box location, scale, and corresponding 
%                    half height and width 
% output
% tagged_image: image with object location drawn
%

[nrow,ncol,imspace_dim]=size(current_image);

[B Surface]=BoundingBox(poscol,posli,scale,hheight,hwidth,ncol,nrow);

tagged_image=current_image;

% Make sure we remain within image when adding or removing 1 to
% line/col number

tagged_image(B.r1:B.r2,B.c1,[1 3])=0;
tagged_image(B.r1:B.r2,B.c1,2)=255;
tagged_image(B.r1:B.r2,min(B.c1+1,ncol),[1 3])=0;
tagged_image(B.r1:B.r2,min(B.c1+1,ncol),2)=255;

tagged_image(B.r1:B.r2,max(B.c2-1,1),[1 3])=0;
tagged_image(B.r1:B.r2,max(B.c2-1,1),2)=255;
tagged_image(B.r1:B.r2,B.c2,[1 3])=0;
tagged_image(B.r1:B.r2,B.c2,2)=255;

tagged_image(B.r1,B.c1:B.c2,[1 3])=0;
tagged_image(B.r1,B.c1:B.c2,2)=255;
tagged_image(min(nrow,B.r1+1),B.c1:B.c2,[1 3])=0;
tagged_image(min(nrow,B.r1+1),B.c1:B.c2,2)=255;

tagged_image(max(1,B.r2-1),B.c1:B.c2,[1 3])=0;
tagged_image(max(1,B.r2-1),B.c1:B.c2,2)=255;
tagged_image(B.r2,B.c1:B.c2,[1 3])=0;
tagged_image(B.r2,B.c1:B.c2,2)=255;
