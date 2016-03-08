% [tr newcolonyDB]=trackyeastCells(colonyDB,firstImg,frameNum,frameSkip);
% figure();
% subplot(2,1,1)
% imshow(label2rgb([newcolonyDB.segData(1:5).newcellMask]))
% subplot(2,1,2)
% imshow(label2rgb([colonyDB.segData(1:5).cellMask]))

%for showing tracking results during developing the codes

[tr newcolonyDB]=trackCells(colonyDB,firstImg,frameNum,frameSkip);
figure();
subplot(2,1,1)
imshow(label2rgb([newcolonyDB(31:35).newcellMask]))
subplot(2,1,2)
imshow(label2rgb([colonyDB.segData(31:35).cellMask]))
% figure();
% subplot(2,1,1)
% imshow(label2rgb([newcolonyDB.segData(6:10).newcellMask]))
% subplot(2,1,2)
% imshow(label2rgb([colonyDB.segData(6:10).cellMask]))
% figure();
% subplot(2,1,1)
% imshow(label2rgb([newcolonyDB.segData(11:15).newcellMask]))
% subplot(2,1,2)
% imshow(label2rgb([colonyDB.segData(11:15).cellMask]))
maskrows=350:1:750;
maskcols=500:1:900;
figure();
subplot(2,1,1)
imshow(label2rgb([newcolonyDB(26:30).newcellMask]))
subplot(2,1,2)
imshow(label2rgb([colonyDB.segData(26:30).cellMask]))

AAA=[];
for jj=35:39
    AA=newcolonyDB(jj).newcellMask;
    %subMask(jj).mask=uint8(AA(maskrows,maskcols));
    AAA=[AAA AA(maskrows,maskcols)];
    
end
BB=[];
for jj=40:44
    AA=newcolonyDB(jj).newcellMask;
    %subMask(jj).mask=uint8(AA(maskrows,maskcols));
    BB=[BB AA(maskrows,maskcols)];
    
end

imshow(label2rgb([AAA;BB]));



AAA=[];
for jj=1:5
    AA=colonyDB.segData(jj).cellMask;
    %subMask(jj).mask=uint8(AA(maskrows,maskcols));
    AAA=[AAA AA(maskrows,maskcols)];
    
end
imshow(label2rgb(AAA));

map = [1 1 1; 0 0 1; 0 1 0; 1 0 0;1 0 0;1 0 0;1 0 0]; 
for jj=1:5
    AA=newcolonyDB(jj).newcellMask;
    %subMask(jj).mask=uint8(AA(maskrows,maskcols));
    figure();imshow(label2rgb(AA));
    
end
maskrows=350:1:750;
maskcols=500:1:900;
map = colormap(hsv); 
map=[1 1 1; map];
close;
% white blue green red
for jj=1:45
    aa=newcolonyDB(jj).newcellMask;
    a=aa(maskrows,maskcols);
    %subMask(jj).mask=uint8(AA(maskrows,maskcols));
rout=[];
a=uint8(a);
a=a+1;
r = zeros(size(a)); r(:) = map(a*2-1,1);
g = zeros(size(a)); g(:) = map(a*2-1,2);
b = zeros(size(a)); b(:) = map(a*2-1,3);
  rout(:,:,1) = r;
  rout(:,:,2) = g;
  rout(:,:,3) = b;
%figure();imshow(rout);
imwrite(rout, ['Images/01track' int2str(jj) '.jpg'], 'JPEG')
end


