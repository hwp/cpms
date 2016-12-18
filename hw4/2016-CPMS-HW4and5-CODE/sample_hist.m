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

c = cumsum(p);
c = c / c(end); % in case of floating point underflow 
c(end) = 1.0;

h = zeros(n, 1);

for i = 1:n
  h(i) = sum(rand > c) + 1;
end

