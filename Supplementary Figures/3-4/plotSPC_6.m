function plotSPC_2(Tmodel,Ymodel,Texp,Yexp,name,id,colname)
addpath('/Users/gejun/Desktop/Projects/Dynamic_Infant_Microbiome/SourceCode/Figure2/export_fig-master')

set(0,'defaultfigurecolor',[1 1 1])

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YTick',[0 30 60 90 120 150 200]);
hold(axes1,'on');

% Activate the left side of the axes
set(gcf,'unit','centimeters','position',[13 17 25 11]);

yyaxis(axes1,'left');
% Create multiple lines using matrix input to plot
plot1 = plot(Tmodel,Ymodel(:,2:end),'linestyle','-','Marker','none','LineWidth',6.5,'Parent',axes1);
set(plot1(1),...
    'Color',[0.886274509803922 0.725490196078431 0.541176470588235]);
set(plot1(2),...
    'Color',[0.956862745098039 0.631372549019608 0.647058823529412]);
set(plot1(3),...
    'Color',[0.419607843137255 0.709803921568627 0.705882352941177]);

% Create multiple lines using matrix input to plot
plot2 = plot(Texp,Yexp(:,2:end),'MarkerSize',18,'Marker','>','LineStyle','none',...
    'Parent',axes1);
set(plot2(1),...
    'MarkerFaceColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'MarkerEdgeColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'Marker','v');
set(plot2(2),...
    'MarkerFaceColor',[0.956862745098039 0.631372549019608 0.647058823529412],...
    'MarkerEdgeColor',[0.956862745098039 0.631372549019608 0.647058823529412],...
    'Marker','^');
set(plot2(3),...
    'MarkerFaceColor',[0.419607843137255 0.709803921568627 0.705882352941177],...
    'MarkerEdgeColor',[0.419607843137255 0.709803921568627 0.705882352941177],...
    'Marker','>',...
    'LineWidth',4);

% Create ylabel
ylabel('[mM]','FontSize',20,'FontName','arial');

% Set the remaining axes properties
set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 15 30 45 60]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-5 63]);
% Activate the right side of the axes
yyaxis(axes1,'right');
set(gcf,'unit','centimeters','position',[13 17 25 11]);

% Create plot
plot(Tmodel,Ymodel(:,1),'LineWidth',6.5,...
    'Color',[0.964705882352941 0.349019607843137 0.270588235294118]);

% Create plot
plot(Texp,Yexp(:,1),...
    'MarkerEdgeColor',[0.964705882352941 0.349019607843137 0.270588235294118],...
    'MarkerSize',18,...
    'Marker','^',...
    'LineWidth',4,...
    'LineStyle','none');

% Create ylabel
ylabel('[logCFU/mL]','FontSize',24,'Rotation',270);

% Set the remaining axes properties
set(axes1,'YColor',[0.85 0.325 0.098],'YMinorTick','off','YScale','linear',...
    'YTick',[0 0.5 1 1.5 2]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.1 2.1]);
% Create xlabel
xlabel('Time [h]','FontSize',24);

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[2 23]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'LineStyleOrderIndex',3,'XTick',[5 10 15 20]);
% Create textbox
annotation(figure1,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Eubacterium hallii'},...
    'LineStyle','none',...
    'FontSize',22,...
    'FontAngle','italic',...
    'FitBoxToText','off');

dir='Sensitivity_analysis_figures/';
name=strrep(name,' ','_');
str=strcat(dir,name,'_',colname,'_sensitiviey','_0530.pdf');
export_fig(sprintf('%s',str),'-pdf')