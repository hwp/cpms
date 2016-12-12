function D=ReadData(time,Para)
%
% Read the data (e.g. data point, or 
%   corresponding image)
%
switch Para.exercise
  case {0,1}
   z=[];
   for i=1:Para.DataPts(time,1)
     z=[z;Para.DataPts(time,2*i:2*i+1)];
   end
   D=z;

  case {3,4}
    D=double(imread(Para.ImageList(time,:)));

end
