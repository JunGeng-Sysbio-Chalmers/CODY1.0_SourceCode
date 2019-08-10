function main_pure_batch
addpath('./export_fig-master')
addpath('./data');

clc
clear
close all
set(0,'defaultfigurecolor',[1 1 1])

% close all
currentDepth = 1; % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));% get current path
cd(currPath);
load('8SPC_0405.mat');
fileNum=size(SPC,2);
for i=1:fileNum
    name{i}=SPC{i}.id;
    met{i}=SPC{i}.met_udf;
end
i=5;
    [Tmodel,Ymodel,Texp,Yexp,miu]=common_pure_simulation_biom(SPC{i},i);
        
% Supp Figure8 5)
figure5 = figure;

% Create axes
axes1 = axes('Parent',figure5,'YTick',[0 30 60 90 120 150 200]);
hold(axes1,'on');

% Activate the left side of the axes
set(gcf,'unit','centimeters','position',[13 17 25 11]);

yyaxis(axes1,'left');
% Create multiple lines using matrix input to plot
plot1 = plot(Tmodel,Ymodel(:,2:end),'linestyle','-','Marker','none','LineWidth',6.5,'Parent',axes1);
set(plot1(1),...
    'Color',[0.905882352941176 0.529411764705882 0.219607843137255]);
set(plot1(2),...
    'Color',[0.886274509803922 0.725490196078431 0.541176470588235]);
set(plot1(3),...
    'Color',[0.956862745098039 0.631372549019608 0.647058823529412]);
set(plot1(4),...
    'Color',[0.588235294117647 0.674509803921569 0.819607843137255]);
set(plot1(5),...
    'Color',[0.419607843137255 0.588235294117647 0.658823529411765]);

% Create multiple lines using matrix input to plot
plot2 = plot(Texp,Yexp(:,2:end),'MarkerSize',18,'Marker','>','LineStyle','none',...
    'Parent',axes1);
set(plot2(1),...
    'MarkerFaceColor',[0.905882352941176 0.529411764705882 0.219607843137255],...
    'MarkerEdgeColor',[0.905882352941176 0.529411764705882 0.219607843137255]);
set(plot2(2),...
    'MarkerFaceColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'MarkerEdgeColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
    'Marker','v');
set(plot2(3),...
    'MarkerFaceColor',[0.956862745098039 0.631372549019608 0.647058823529412],...
    'MarkerEdgeColor',[0.956862745098039 0.631372549019608 0.647058823529412],...
    'Marker','^');
set(plot2(4),...
    'MarkerFaceColor',[0.588235294117647 0.674509803921569 0.819607843137255],...
    'MarkerEdgeColor',[0.588235294117647 0.674509803921569 0.819607843137255]);
set(plot2(5),...
    'MarkerEdgeColor',[0.419607843137255 0.588235294117647 0.658823529411765],...
    'LineWidth',4);

% Create ylabel
ylabel('[mM]','FontSize',20,'FontName','arial');

% Set the remaining axes properties
set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 30 60 90 120 150]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-10 152]);
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
    'YTick',[0 25]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-2 25]);
% Create xlabel
xlabel('Time [h]','FontSize',24);

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 50]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'LineStyleOrderIndex',3,'XTick',[0 10 20 30 40 50]);
% Create textbox
annotation(figure5,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Bifidobacterium adolescentis'},...
    'LineStyle','none',...
    'FontSize',22,...
    'FontAngle','italic',...
    'FitBoxToText','off');

T_index=cell2mat(arrayfun(@(x) find(abs(Tmodel-x)<=0.01,1), Texp, 'un',0));
Ymodel_cmp=Ymodel(T_index,:);

y1=reshape(Yexp(:,1:end),[],1);     %% true value
f1=reshape(Ymodel_cmp(:,1:end),[],1);     %% model prediction
[r1,rmse1]=rsquare(y1,f1);

str=strcat({'R^2'},{' = '},num2str(r1));

annotation(figure5,'textbox',...
    [0.145254237288136 0.816307692307692 0.0812146892655367 0.0737179487179487],...
    'LineStyle','none',...
    'FontSize',18,...
    'String',str,...
    'FitBoxToText','off',...
    'FontName', 'Helvetica');

export_fig SippFig5_5_legend_0530.pdf -q101
end




