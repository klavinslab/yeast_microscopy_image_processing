%This function input grayscale cell image, colony mask and return individual cell level mask
function [imCellSeg CellStat] = cellSeg(imPhz,mask,maxHalfgap,minarea,thre)

%thre=70;
dbg=0; %for debug purpose, if dbg=1, will show intermediate processing images
se = strel('disk',1); 
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
se45= strel('line',3,45);
se045= strel('line',3,-45);

I_eq = adapthisteq(imPhz);

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
%imshow(cellI_eq)
bv = im2bw(colImg, graythresh(cellI_eq));
bv = edge(colImg,'canny',0.39);
bvd =imdilate(bv, [se90 se0 se45 se045]);
% bv2= imfill(bv,'holes');
% %bv3 = imopen(bv2, ones(5,5));
% bv3 = imopen(bv2,strel('disk',3));
% bv4 = bwareaopen(bv3, 50);
% bv4_perim = bwperim(bv4);
% celloverlay1 = imoverlay(cellI_eq, bv4_perim, [.3 1 .3]);
%imshow(celloverlay1);

maskOrig = bvd;
windowSz = maxHalfgap;
mask1 = imdilate(maskOrig, ones(windowSz));
%imshow(~mask1);
A=~mask1;
%A=imdilate(A,strel('disk',1));
A=imclearborder(A);
B=imdilate(A,strel('disk',4));


mask_em = imextendedmax(cellI_eq, thre);
%mask_em = imextendedmax(bv4, 1);
%imshow(mask_em)
mask_em = imclose(mask_em, se);
mask_em = imfill(mask_em, 'holes');
mask_em = bwareaopen(mask_em, minarea);
%overlay2 = imoverlay(cellI_eq, bv4_perim | mask_em, [.3 1 .3]);
%imshow(overlay2)
I_eq_c = imcomplement(cellI_eq);
%I_eq_c = cellI_eq;
I_mod = imimposemin(I_eq_c, A | mask_em);
L = watershed(I_mod);
%L=bwlabel(B);
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

imCellSeg(subRows,subCols)=LL;
[Lcell, num] = bwlabel(imCellSeg);
% overlay3=imoverlay(I_eq,imCellSeg,[1,1,0]);
% subplot(1,2,1);
% imshow(overlay3);
% subplot(1,2,2);
% imshow(label2rgb(Lcell));
imCellSeg=uint8(Lcell);
CellStat=regionprops(imCellSeg,'Area','Centroid','Orientation');
end