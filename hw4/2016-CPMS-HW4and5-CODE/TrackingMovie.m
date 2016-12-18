function tracking_movie=TrackingMovie(tracking_list,estimated_states,Para)
%
% create a movie displaying the result of the tracking
% tracking_movie=TrackingMovie(tracking_list,estimated_states,Para);
%
% inputs:
% tracking_list: list of complete path to image files 
% estimated_states: estimated states to be displayed
%
% output:
% tracking_movie: matlab movie displaying tracking results
%

nframes=size(tracking_list,1)

counter=1;
for t=1:nframes
    
    current_image=double(imread(tracking_list(t,:)));

    tagged_image=DrawObjectLocation(current_image,estimated_states(t,1),estimated_states(t,2),...
                                    estimated_states(t,5),...
                                    Para.Object.halfheight, ...
                                    Para.Object.halfwidth);
    if Para.exercise==4
        tagged_image=DrawMotionState(tagged_image, estimated_states(t,6));
    end
    
    
%    figure;image(uint8(tagged_image))
    imwrite(uint8(tagged_image), sprintf('output/frame_%04d.png', t))
    tracking_movie(counter)=im2frame(uint8(tagged_image));
    
    counter=counter+1;
    if mod(t,100)==0
        disp(['frame ',int2str(t),'/',int2str(nframes)]);
    end
end



