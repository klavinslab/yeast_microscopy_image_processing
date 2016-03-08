%This function input grayscale cell image and return colony level mask
function imColSeg = ...
  colSeg(imPhz,frameNum)
I_eq = adapthisteq(imPhz);
bw=edge(I_eq,'canny',0.39);
% se = strel('disk',1); 
% se90 = strel('line', 3, 90);
% se0 = strel('line', 3, 0);
% se45= strel('line',3,45);
% se045= strel('line',3,-45);
% bwdil = imdilate(bw, [se90 se0 se45 se045]); 
bwdilnew=imdilate(bw, strel('disk',4));
% bwdil = imdilate(bwdil,se);
% bwdil = imdilate(bwdil,se);
% bwdil = imdilate(bwdil,se);
% bwdil = imdilate(bwdil,se);
% bwdil = imdilate(bwdil,se);
bw2 = imfill(bwdilnew,'holes');
bw2= imfill(bw2,'holes');
bw2= imfill(bw2,'holes');
bw3=bwareaopen(bw2,2000); 
% bw4=bw3;
% imDims = size(I_eq);
%   mrkr = zeros(imDims);
%   mrkr(ceil(imDims(1)/2),ceil(imDims(2)/2)) = 1;
%   mrkr = imdilate(mrkr,strel('disk',10)) > 0;
%   mrkr = immultiply(bw4,mrkr);
%   bw4 = imreconstruct(mrkr,bw4);
% bwperim
% overlay=imoverlay(I_eq,bw4,[1,1,0]);
% imshow(overlay);
datamask=bw3;
imColSeg = datamask ==0;



