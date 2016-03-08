function [colonyDB] = ...
  microcolRun(nd2,firstImg,endImg,params,fluorRate,frameSkip)

width = nd2.getSizeX();
height = nd2.getSizeY();

dbSz = endImg - firstImg + 1;


for frame = firstImg:frameSkip:endImg
  index = frame-firstImg+1;
  
  phzImg = getND2img(nd2,'',frame,'phz');
  tic
  [colonyDB(index).colonyMask colonyDB(index).cellMask colonyDB(index).cellStat] = ...
    imgSegmentation(nd2,frame,params);
  time = toc;
  disp(['Frame ',num2str(frame),' took ',...
    num2str(time/60),' minutes to process.']);
  
end
end
