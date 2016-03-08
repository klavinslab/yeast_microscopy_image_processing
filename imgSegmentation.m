% This function input the movie, calls the colSeg.m to return colony
% segmentation, calls cellSeg.m to return cell segmentation results
function [colonyMask cellMask cellStat] = imgSegmentation(nd2,frameNum,params)

maxHalfgap = params(1);
minarea = params(2);
thre = params(3);

%Read phase image for segmentation processing
imPhzin = getND2img(nd2,'',frameNum,'phz');

colonyMask = ...
  colSeg(imPhzin,frameNum);
if any(any(~colonyMask))
  [cellMask cellStat] = cellSeg(imPhzin,colonyMask,maxHalfgap,minarea,thre);
else
  cellMask = false(size(imPhzin));
end

end