function h = sample_hist(p, n)
%SAMPLE_HIST     Sample from a multinomial distribution.
%
% Example:
%   indices=sample_hist([0.3; 0.6; 0.1],100)
%
%  if n=1, samples from the multinomal distributions whose probabilities
%  are given by the column vector p as input 
%

if nargin < 2
  n = 1;
end

if min(size(p))>1 
    display('sample_hist: input multinomial p is not a column vector');
end

if size(p,2)>1
    p=p';
end


h = zeros(size(p));
z = repmat(1,1,cols(p));
n = repmat(n,1,cols(p));
js = 1:cols(p);
% loop bins
for i = 1:(rows(p)-1)
  % the count in bin i is a binomial distribution
  for j = js
    h(i,j) = randbinom(p(i,j)/z(j), n(j));
  end
  n = n - h(i,:);
  z(js) = z(js) - p(i,js);
  js = find(z > 0);
end
h(end,:) = n;


%% modif jmo
indices=[];
for i=1:rows(p)
  indices=[indices;repmat([i],h(i),1)];
end

h=indices;