function createFit30mincell1(t,yosc)
%CREATEFIT Create plot of data sets and fits
%   CREATEFIT(T,YOSC)
%   Creates a plot, similar to the plot in the main Curve Fitting Tool,
%   using the data that you provide as input.  You can
%   use this function with the same data you used with CFTOOL
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%   
%   Number of data sets:  1
%   Number of fits:  1
 
% Data from data set "yosc vs. t":
%     X = t:
%     Y = yosc:
%     Unweighted

% Auto-generated by MATLAB on 29-Jun-2012 00:26:54

% Set up figure to receive data sets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[551 179 688 485]);
% Line handles and text for the legend.
legh_ = [];
legt_ = {};
% Limits of the x-axis.
xlim_ = [Inf -Inf];
% Axes for the plot.
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_);
hold on;
 
% --- Plot data that was originally in data set "yosc vs. t"
t = t(:);
yosc = yosc(:);
h_ = line(t,yosc,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(t));
xlim_(2) = max(xlim_(2),max(t));
legh_(end+1) = h_;
legt_{end+1} = 'yosc vs. t';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[-5.25, 601.65000000000009]);
end
 
% --- Create fit "fit 1"
 
% Apply exclusion rule "ex1"
if length(t)~=120
error( 'GenerateMFile:IncompatibleExclusionRule',...
    'Exclusion rule ''%s'' is incompatible with ''%s''.',...
    'ex1', 't' );
end
ex_ = false(length(t),1);
ex_([]) = 1;
ex_ = ex_ | (t <= 50 | t >= 500);
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[-Inf    0 -Inf],'Upper',[Inf Inf   0]);
ok_ = isfinite(t) & isfinite(yosc);
if ~all( ok_ )
warning( 'GenerateMFile:IgnoringNansAndInfs',...
    'Ignoring NaNs and Infs in data.' );
end
st_ = [22.051476702557821 0.1129561403537903 -3 ];
set(fo_,'Startpoint',st_);
set(fo_,'Exclude',ex_(ok_));
ft_ = fittype('sin1');
 
% Fit this model using new data
if sum(~ex_(ok_))<2
% Too many points excluded.
error( 'GenerateMFile:NotEnoughDataAfterExclusionRule',...
    'Not enough data left to fit ''%s'' after applying exclusion rule ''%s''.',...
    'fit 1', 'ex1' );
else
   cf_ = fit(t(ok_),yosc(ok_),ft_,fo_);
end
% Alternatively uncomment the following lines to use coefficients from the
% original fit. You can use this choice to plot the original fit against new
% data.
%    cv_ = { 35.118617955747638, 0.10588589668513446, -2.0371315285860576};
%    cf_ = cfit(ft_,cv_{:});

% Plot this fit
h_ = plot(cf_,'fit',0.95);
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
% Turn off legend created by plot method.
legend off;
% Store line handle and fit name for legend.
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

% --- Finished fitting and plotting data. Clean up.
hold off;
% Display legend
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'}; 
h_ = legend(ax_,legh_,legt_,leginfo_{:});
set(h_,'Interpreter','none');
% Remove labels from x- and y-axes.
xlabel(ax_,'');
ylabel(ax_,'');
