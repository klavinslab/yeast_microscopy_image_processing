% main function to perform cell tracking, input colonyDB, output
% newcolonyDB that contains the cell segmentation results after tracking 
% track is a matrix that records that distances between cells during the
% tracking for debugging purpose.
function [track newcolonyDB] = trackCells(colonyDB,firstImg,endImg,frameSkip)
track=[];
rec=[];
newcolonyDB(1).newcellMask=colonyDB.segData(1).cellMask;
A=size([colonyDB.segData(1).cellMask]);
for frame = firstImg+1:frameSkip:endImg
cellMask=colonyDB.segData(frame).cellMask;
prevcellMask=newcolonyDB(frame-1).newcellMask;
newcellMask=uint8(zeros(A));
cellStats=colonyDB.segData(frame).cellStat;
prevcellStats=regionprops(prevcellMask,'Area','Centroid','Orientation');
rec(1:length(cellStats))=0;
rev(1:length(prevcellStats))=0;
%Calculate centroids based Euclidean distances d(i,j) with all cell j in
%previous image.
for idz=1:length(cellStats)
    for idp=1:length(prevcellStats) 
    d(idz,idp,frame)=norm(cellStats(idz).Centroid-prevcellStats(idp).Centroid);
    end
    [C,idm]=min(d(idz,1:length(prevcellStats),frame));
    if C<45 %threshold on the minimum distance
       if cellStats(idz).Area<0.37*prevcellStats(idm).Area
       newcellMask(find(prevcellMask==idm))=idm;
       else newcellMask(find(cellMask==idz))=idm;
       end
       rev(idm)=1;
       rec(idz)=1;
    end
end;
%Record cell number in previous image that not match in the current image,
%copy the cell (with its number and segmentation pixels) to the current image.
for ii=1:length(prevcellStats)
    if rev(ii)==0;
        newcellMask(find(prevcellMask==ii))=ii;
    end
end
%Record cell number in current image that not match in the previous image,
%assign a new number, identify as a new cell.
addcell=length(prevcellStats);
for jj=1:length(cellStats)
    if rec(jj)==0;
        newcellMask(find(cellMask==jj))=addcell+1;
        addcell=addcell+1;
    end
end

newcolonyDB(frame).newcellMask=newcellMask;
end;
track=d;
end