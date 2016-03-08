clear all;
close all;

% This file input the cell movie, calls the microcolRun.m to process the 
% movie into gray scale images and calls imgSegmentation.m to return colony 
% segmentation and cell segmentation results recorded in a structure file 
% called colonyDB. In detail, the imgSegmentation.m calls colSeg.m to return 
% colony segmentation results and cellSeg.m to return cell segmentation results.
% After get the cell segmentation results, processCell.m calls trackCells.m 
% to give tracking results which recorded in a structure element called newcolonyDB. 
% Then processCell.m calls getcellYFP.m to return fluorescence time course data for 
% each cell recorded in a matrix called gfpsub.


params = [...
  10 ...%maxHalfgap (cellSeg) used for dilation
  100 ... %minimum cell area in pixels (cellSeg) used for remove non cell are
  70 ... %threshold level (cellSeg) used for finding region maximum
  ];

fluorRate = 2;
frameSkip = 1;

firstImg = 1;
debug = 0;
directory = 'E:\Yaoyu\2011-11-16\Matlab'; %directory where the microscope movies locates
%directory = 'H:\Auxin oscillator movies'; %directory where the microscope movies locates
runName = '20111115 ykl77 30min001_xy4.nd2';%microscope movies file name
%runName ='20111109 ykl77_xy3.nd2';
%runName = '20111115 ykl77 20min_xy5.nd2';
frameNum =120;
nd2 = getND2Struct([directory,'\',runName]);

for dataSet = 1 %[1 2 4 5 7 8 9 10]
    clear colonyDB;
    clear newcolonyDB;
    clear idx idy idt maxcellnum gfpmean gfpsub gfpsub0;
    t1 = tic;
  nd2.setSeries(dataSet-1);
  colonyDB.fluorRate = fluorRate;
  % Segment colony and cells
  colonyDB.segData = microcolRun(nd2,...
    firstImg,firstImg+frameNum-1,params,fluorRate,frameSkip);
  % Save colonyDB data
  t2 = toc(t1);
  disp([runName,', colony ',sprintf('%02i',dataSet),' elapsed time is ', ...
    num2str(floor(t2/3600)), ' hour(s) and ',num2str(mod(t2/60,60)),...
    ' minutes.']);
%track cells, newcolonyDB contains the tracked cell segmentation results
[tr newcolonyDB]=trackCells(colonyDB,firstImg,frameNum,frameSkip);
%get fluorescence  timecourse for each tracked cell
newcolonyDB=getcellYFP(newcolonyDB,nd2,firstImg,firstImg+frameNum-1,frameSkip);

maxcellnum=length(newcolonyDB(firstImg+frameNum-1).cellGFPsub);
gfpsub=nan(maxcellnum,frameNum);

for idy=firstImg:firstImg+frameNum-1
        for idx=1:length(newcolonyDB(idy).cellGFPsub)
        gfpsub(idx,idy)=newcolonyDB(idy).cellGFPsub(idx);
        end
end

cellarea=nan(maxcellnum,frameNum);

for idy=firstImg:firstImg+frameNum-1
        for idx=1:length(newcolonyDB(idy).cellGFParea)
        cellarea(idx,idy)=newcolonyDB(idy).cellGFParea(idx);
        end
end

gfpsub0=gfpsub;
gfpsub0(isnan(gfpsub0))=0;
cellarea0=cellarea;
cellarea0(isnan(cellarea0))=0;
gfpmean=zeros(1,frameNum);
rv=[];
rva=[];
for idt=1:frameNum
    rv=gfpsub0(:,idt);
    rva=cellarea0(:,idt);
    gfpmean(idt)=mean(rv(find(rv~=0)));
    gfpmean1(idt)=sum([rv(find(rv~=0))].*[rva(find(rva~=0))])/sum([rva(find(rva~=0))]);
end

cellstat(dataSet).gfpmean=gfpmean;
cellstat(dataSet).gfpsub=gfpsub;
%%plot fluorescence timecourse for each tracked cell
plot(gfpsub');
%%plot part of fluorescence timecourse for each tracked cell
%plot((gfpsub(:,1:40))');
title('Subtracted fluorescence of cells over time');
xlabel('Time frame');
ylabel('Subtracted fluorescence');
save([runName,'_01-',sprintf('%02i',frameNum),'.mat'],'colonyDB','newcolonyDB','gfpsub','gfpmean','gfpmean1');
end
