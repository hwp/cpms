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
   [box Surface] = BoundingBox(State(1), State(2), State(5), Para.Object.halfheight, Para.Object.halfwidth, ncol, nrow);

   if Surface > 100
     % Extract Histogram in Bounding Box region
     obsv = ColorHistogram(Data(box.r1:box.r2, box.c1:box.c2,:), Para.hist_bins_number);      
     % Compute weight
     like = exp(-Para.lambdah * SquareBattacharya(obsv, Para.Object.hist_model));
     like = max(like, Para.Likemin);
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

