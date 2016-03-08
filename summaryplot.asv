%30min YKL77 data
tz=[0.7:5:840];
t=tz(1:120);
plot(t,gfpsub');
xlabel('Time [min]','FontSize',15);
ylabel('YFP(A.U.)','FontSize',15);
X=gfpsub(1,:);
%X=yfp4;

[WJt1, VJt1, att1] = modwt(X, 'haar', 6, 'circular');
[DJt1, att1] = imodwt_details(WJt1, 'haar');
[SJt, att2] = imodwt_smooth(VJt1, 'haar',6);

[WJt2, VJt2, att2] = modwt(X, 'd4', 6, 'circular');
[DJt2, att2] = imodwt_details(WJt2, 'd4');
[SJt2, att2] = imodwt_smooth(VJt2, 'd4',6);

subplot(5,1,1);
plot(t,X);
title('X');
for i=1:4
    subplot(5,1,i+1);
    plot(t,DJt2(:,i)');
    title(sprintf('D4 wavelet D%d',i));
end

subplot(3,1,1);
plot(t,X);
title('X');
for i=5:6
    subplot(3,1,i-3);
    plot(t,DJt2(:,i)');
    title(sprintf('D4 wavelet D%d',i));
end


figure()
plot(t,X);
title('X');
for i=2:7
    figure()
    plot(t,DJt2(:,i-1)');
    title(sprintf('D4 wavelet D%d',i-1));
end

yosc3=DJt2(:,3);
yosc2=DJt2(:,3);
yosc1=DJt2(:,2);
yosc0=DJt2(:,1);
yosc=yosc2+yosc3;
%yosc10=yosc1+yosc0;
subplot(2,1,1);
plot(t,X);
title('X');
subplot(2,1,2);
plot(t,yosc');
title('Oscillation extraction');
