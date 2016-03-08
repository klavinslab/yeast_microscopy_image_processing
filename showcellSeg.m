close all;
for i=5:5
origin = getND2img(nd2,' ',i,'phz');
%subplot(1,2,1),imshow(colonyDB.segData(i).colonyMask);
%subplot(1,2,2),imshow(origin);
% mask=colonyDB.segData(i).colonyMask;
thre=70;
dbg=0;
I_eq = adapthisteq(origin);
%I_eq=origin;
% bw = edge(I_eq, 'sobel');
% [junk threshold] = edge(I_eq, 'sobel');
% fudgeFactor = var;
%bw = edge(I_eq,'sobel', threshold * fudgeFactor);
bw=edge(I_eq,'canny',0.39);
se = strel('disk',1); 
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
se45= strel('line',3,45);
se045= strel('line',3,-45);
bwdil = imdilate(bw, [se90 se0 se45 se045]); 
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
bw4=bw3;
imDims = size(I_eq);
  mrkr = zeros(imDims);
  mrkr(ceil(imDims(1)/2),ceil(imDims(2)/2)) = 1;
  mrkr = imdilate(mrkr,strel('disk',10)) > 0;
  mrkr = immultiply(bw4,mrkr);
  bw4 = imreconstruct(mrkr,bw4);
% bwperim
overlay=imoverlay(I_eq,bw4,[1,1,0]);
imshow(overlay);
datamask=bw3;
mask = datamask ==0;



imPhz=origin;
minPhz = double(min(min(imPhz)));
maxPhz = double(max(max(imPhz)))-minPhz;
cellTemplate = double(imPhz - minPhz)/maxPhz;
cellTemplate = round(cellTemplate*200)/200;
cellTemplate = uint8(cellTemplate*200);
diamR = [strel('disk',1),strel('disk',2),...
  strel('disk',3),strel('disk',4),...
  strel('disk',5),strel('disk',6),...
  ];


imInit = cellTemplate;

cols = bwareaopen(~mask(:,:,1),350);
%cols = imdilate(cols,diamR(1));
colStats = regionprops(cols,'Image','BoundingBox','Area');

imCellSeg = false(size(imPhz));

for colNum = 1:length(colStats)
bbox = colStats(colNum).BoundingBox;
  subRows = ceil(bbox(2)):floor(bbox(2))+bbox(4);
  subCols = ceil(bbox(1)):floor(bbox(1))+bbox(3);
  colImg = imInit(subRows,subCols);
  colImg(colStats(colNum).Image == 0) = 0;
  colBW = false(bbox(4),bbox(3));
  subImDims = size(colImg);
  tmp = colImg;
  colVals = unique(tmp);
  clear tmp
end
se = strel('diamond',1);
cellI_eq = adapthisteq(colImg);
imshow(cellI_eq)
bv = im2bw(colImg, graythresh(cellI_eq));
bv = edge(colImg,'canny',0.39);
bvd =imdilate(bv, [se90 se0 se45 se045]);
bv2= imfill(bv,'holes');
%bv3 = imopen(bv2, ones(5,5));
bv3 = imopen(bv2,strel('disk',3));
bv4 = bwareaopen(bv3, 50);
bv4_perim = bwperim(bv4);
celloverlay1 = imoverlay(cellI_eq, bv4_perim, [.3 1 .3]);
imshow(celloverlay1);

maskOrig = bvd;
windowSz = 10;
mask1 = imdilate(maskOrig, ones(windowSz));
imshow(~mask1);
A=~mask1;
A=imclearborder(A);
%A=imdilate(A,strel('disk',1));

mask_em = imextendedmax(cellI_eq, thre);
%mask_em = imextendedmax(bv4, 1);
imshow(mask_em)
% mask_em = imclose(mask_em, se);
% mask_em = imfill(mask_em, 'holes');
% mask_em = bwareaopen(mask_em, 100);
overlay2 = imoverlay(cellI_eq, bv4_perim | mask_em, [.3 1 .3]);
imshow(overlay2)
I_eq_c = imcomplement(cellI_eq);
%I_eq_c = cellI_eq;
I_mod = imimposemin(I_eq_c, A | mask_em);
L = watershed(I_mod);

% subplot(2,2,4);
% imshow(I_mod);
cellstats=regionprops(L,'Area','Solidity','Eccentricity');
LL=L;
I_modr=I_mod;
for j=1:max(max(L));
    if cellstats(j).Solidity <0.8 ||cellstats(j).Area<800 ||cellstats(j).Area>5000;
        LL(find(L==j))=0;
    else
        LL(find(L==j))=1;
    end
end
LL=imclearborder(LL);
LL=imfill(LL,'holes');

if dbg==1;
subplot(2,2,1);
imshow(label2rgb(L));
subplot(2,2,2);
imshow(A);
subplot(2,2,3)
imshow(I_mod);
subplot(2,2,4);
imshow(label2rgb(LL));
end;
Lnew=bwlabel(LL);

imCellSeg(subRows,subCols)=LL;
[Lcell, num] = bwlabel(imCellSeg);
overlay3=imoverlay(I_eq,imCellSeg,[1,1,0]);
subplot(1,2,1);
imshow(overlay3);
subplot(1,2,2);
imshow(label2rgb(Lcell));
% imshow(overlay3);
% AB=logical([newcolonyDB(i).newcellMask]);
% overlay4=imoverlay(I_eq,AB,[1,1,0]);
% imshow(overlay4)
%pause;
end

