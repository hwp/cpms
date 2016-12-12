function Image=LikelihoodMap(Data,Para,AverageScale)
%
%

% Get only DataSample par line and column

DataSample=130;

[nrow ncol im_dim]=size(Data);

Image=zeros(nrow,ncol);

stepr=floor(max(1,nrow/DataSample));
stepcol=floor(max(1,ncol/DataSample));

for row=1:stepr:nrow
    for col=1:stepcol:ncol
        like=StateLikelihood(Data,[col;row;0;0;AverageScale],Para);
        Image(row,col)= like;
     end
end
maxI=max(Image(:));
Image=255*Image/maxI;