function like=StateLikelihood(Data,State,Para)
%
% Compute the likelihood for the given State
%

% TO COMPLETE

switch Para.exercise
  case {3,4}
   % Data = current image
   [nrow,ncol,imspace_dim]=size(Data);
   % get the bounding box corresponding to the state - make sure it remains inside image

   if Surface > 100
       % Extract Histogram in Bounding Box region
       
       % Compute weight

   else
       like=0.1*Para.Likemin;
   end
end


function Bsquare=SquareBattacharya(hist1,hist2)
%
% Compute the square of the Bhattacharyya distance
% Assumes both histograms are normalized
%
%

Bsquare=1-sum(sqrt(hist1.*hist2));

