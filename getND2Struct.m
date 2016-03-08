function nd2 = getND2Struct(nd2Name)

nd2 = loci.formats.ChannelFiller();
nd2 = loci.formats.ChannelSeparator(nd2);
nd2.setId(nd2Name);

end
