function img = getND2img(nd2,xyPos,timeInd,phzGFP)

imgPlN = nd2.getSizeC;

if strcmp(phzGFP,'phz')
  imPlane = (timeInd-1)*imgPlN;
elseif strcmp(phzGFP,'gfp')
  imPlane = (timeInd-1)*imgPlN + 1;
elseif strcmp(phzGFP,'rfp')
  imPlane = (timeInd-1)*imgPlN + 2;
else
  error('phzGFP input not valid');
end

if xyPos ~= ''
  nd2.setSeries(xyPos-1);
end

width = nd2.getSizeX();
height = nd2.getSizeY();
pixelType = nd2.getPixelType();
bpp = loci.formats.FormatTools.getBytesPerPixel(pixelType);
fp = loci.formats.FormatTools.isFloatingPoint(pixelType);
little = nd2.isLittleEndian();
plane = nd2.openBytes(imPlane);

pix = loci.common.DataTools.makeDataArray(plane, bpp, fp, little);
shape = [width height];
img = reshape(pix, shape)';