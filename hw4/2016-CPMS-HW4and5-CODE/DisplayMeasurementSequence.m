function DisplayMeasurementSequence(Para)
%
% Display the sequence of points measured (First exercise)
%   
%

figure;
hold on;
title('Observations'); 

FinalT=size(Para.DataPts,1);

for time=1:FinalT
   z=[];
   for i=1:Para.DataPts(time,1)
    z=[z;Para.DataPts(time,2*i:2*i+1)];
   end
   % we assume there is at least one point
   plot(z(:,1),z(:,2),'*b');
   % all other points are noise
   plot(z(2:end,1),z(2:end,2),'*r');
   
   pause(0.1);
end


%r=input('Continue ?');
