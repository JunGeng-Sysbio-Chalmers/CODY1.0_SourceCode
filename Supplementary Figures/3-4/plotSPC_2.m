function plotSPC_2(Tmodel,Ymodel,Texp,Yexp,name,id,colname)
addpath('/Users/gejun/Desktop/Projects/Dynamic_Infant_Microbiome/SourceCode/Figure2/export_fig-master')

set(0,'defaultfigurecolor',[1 1 1])

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YTick',[0 30 60 90 120]);
hold(axes1,'on');

% Activate the left side of the axes
yyaxis(axes1,'left');
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[13 17 25 11]);

plot1 = plot(Tmodel,Ymodel(:,2:end),'Linestyle','-','LineWidth',6.5,'Parent',axes1);
set(plot1(1),...
    'Color',[0.905882352941176 0.529411764705882 0.219607843137255]);
set(plot1(2),...
    'Color',[0.607843137254902 0.607843137254902 0.776470588235294]);
set(plot1(3),...
    'Color',[0.886274509803922 0.725490196078431 0.541176470588235]);
set(plot1(4),...
    'Color',[0.627450980392157 0.796078431372549 0.776470588235294]);

% Create multiple lines using matrix input to plot
plot2 = plot(Texp,Yexp(:,2:4),'MarkerSize',18,'LineStyle','none','Parent',axes1);
set(plot2(1),...
    'MarkerFaceColor',[0.905882352941176 0.529411764705882 0.219607843137255],...
    'MarkerEdgeColor',[0.905882352941176 0.529411764705882 0.219607843137255],...
    'Marker','>');
set(plot2(2),...
    'MarkerFaceColor',[0.607843137254902 0.607843137254902 0.776470588235294],...
    'MarkerEdgeColor',[0.607843137254902 0.607843137254902 0.776470588235294],...
    'Marker','^');
set(plot2(3),...
    'MarkerFaceColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'MarkerEdgeColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'Marker','v');

% Create ylabel
ylabel('[mM]','FontSize',20,'FontName','arial');

% Set the remaining axes properties
set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 30 60 90 120]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-15 120]);
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
    'LineWidth',3.5,...
    'LineStyle','none');

% Create ylabel
ylabel('[logCFU/mL]','FontSize',24,'FontName','Helvetica','Rotation',270);

% Set the remaining axes properties
set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 10 20 30 40]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-5 50]);
% Create xlabel
xlabel('Time [h]','FontSize',24,'FontName','Helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 50]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[0 10 20 30 40 50]);
% Create textbox
annotation(figure1,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Bacteroides fragilis'},...
    'LineStyle','none',...
    'FontSize',22,...
    'FontAngle','italic',...
    'FitBoxToText','off');

dir='Sensitivity_analysis_figures/';
name=strrep(name,' ','_');
str=strcat(dir,name,'_',colname,'_sensitiviey','_0530.pdf');
export_fig(figure1,sprintf('%s',str),'-pdf')