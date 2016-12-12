function tagged_image=DrawMotionState(current_image,motion_type)
% plot a rectangle on upper left to indicate the motion state
% 

[nrow,ncol,imspace_dim]=size(current_image);

Boxrow=floor(min(nrow,max(nrow/10,20)));
Boxcol=floor(min(ncol,max(ncol/10,20)));

tagged_image=current_image;

tagged_image(1:Boxrow,1:Boxcol,:)=0;
if motion_type==1
    tagged_image(1:Boxrow,1:Boxcol,1)=255;
else
    tagged_image(1:Boxrow,1:Boxcol,3)=255;
end
