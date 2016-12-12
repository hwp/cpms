function color_histogram=ColorHistogram(color_patch,n_hist_bins)
%
% compute the 3 channels color histogram of an image patch
% color_histogram=ColorHistogram(color_patch,n_histogram_bins)
% inputs:
% color_patch: color patch
% n_hist_bins: number of histogram bins for a single channel
% outputs:
% color_histogram: color histogram
%

[nrow,ncolumn,dimspace]=size(color_patch);
color_patch=255*double(rgb2hsv(uint8(color_patch)));

%disp(length(color_histogram))

Nbins3=n_hist_bins^3;

% defining the 3 channel color histrogram bins
bins_step=256/n_hist_bins;
edge=0:1:Nbins3;

if length(edge) ~= Nbins3+1
     disp('problem occurred when computing color histogram');
end

hist_tmp=floor(color_patch(:,:,1)./bins_step)*(n_hist_bins*n_hist_bins)+floor(color_patch(:,:,2)./bins_step)*n_hist_bins+floor(color_patch(:,:,1)./bins_step);

if(nrow~=0)&(ncolumn~=0)
   color_histogram=histc(hist_tmp(:),edge)./(nrow*ncolumn);
else
    color_histogram=ones(Nbins3+1,1)/(Nbins3+1);
end


