function   [ImageList TimeInstants]= GetFileList(seqbasename,ndigits,extension,inittime,endtime,tstep)
%
%
%  Return the list of image files as well as the list of their 
%  corresponding time instants
%  
%

TimeInstants=[];
ImageList=[];
for t=inittime:tstep:endtime
   TimeInstants=[TimeInstants; t];
   ImageList=[ImageList;[seqbasename GenerateStringNumber(t,ndigits) extension]];
end





%%-------------------------------------------------
function nums=GenerateStringNumber(number,ndigits)

nums=num2str(number);
l=ndigits-size(nums,2);
for i=1:l
  nums=['0' nums];
end
