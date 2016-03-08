function newcolonyDB = getcellYFP(newcolonyDB,nd2,firstImg,endImg,frameSkip)
for frame = firstImg:frameSkip:endImg
    index = frame-firstImg+1;
    gfpImg = getND2img(nd2,'',frame,'gfp');
    newcolonyDB(index).gfpBkgnd = mean2(gfpImg(1:50,1:50));
    gfpStats = regionprops(newcolonyDB(index).newcellMask,...
            gfpImg,'PixelValues','Area');
    for idx = 1: length(gfpStats)
        newcolonyDB(index).cellGFPmn(idx,:) = mean(gfpStats(idx).PixelValues);
        newcolonyDB(index).cellGFParea(idx,:)=gfpStats(idx).Area;
        newcolonyDB(index).cellGFPave(idx,:)=sum(gfpStats(idx).PixelValues)/gfpStats(idx).Area;
        newcolonyDB(index).cellGFPsub(idx,:)=mean(gfpStats(idx).PixelValues)-newcolonyDB(index).gfpBkgnd;
    end
    
end