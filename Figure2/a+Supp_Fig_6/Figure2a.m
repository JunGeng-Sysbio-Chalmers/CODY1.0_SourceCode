function main_comm_batch
addpath('./export_fig-master')
clc
clear
close all
set(0,'defaultfigurecolor',[1 1 1])

currentDepth = 1; 
currPath = fileparts(mfilename('fullpath'));
cd(currPath);

load('SPC_Co_Bth.mat');
load('SPC_Co_Bad.mat');
SPC{1}=SPC_Co_Bth;
SPC{2}=SPC_Co_Bad;
n_species=size(SPC,2);

SPC_EM=[8 8 8;
        14 6 6];
Coculture_Data=importdata('BB_COCULTURE_data.txt');    
Exp_co_data=Coculture_Data.data;
Exp_co_mets=Coculture_Data.textdata;

biom_ini=[0.04 0.02];
Time=Exp_co_data(:,1);
Data=Exp_co_data(:,2:end);
x0=Exp_co_data(1,3:end);
x0=[biom_ini x0]';
[T Y]=common_com_sim_3sub_unit(SPC,n_species,SPC_EM,x0);
Ymodel=Y(:,1:10);
Y_model_co=Y(:,1:10);
Ymodel(:,2)=Ymodel(:,1)+Ymodel(:,2);
Ymodel=Ymodel(:,2:10);
for mn=2:4
    Ymodel(:,mn)=Ymodel(:,mn)./Ymodel(1,mn).*2;   
    Data(:,mn)=Data(:,mn)./Data(1,mn).*2;
end
bmflag=1;
met_udf=Exp_co_mets(2:10);
Tmodel=T;
Texp=Time;
Yexp=Data;


Coculture_Data=importdata('Co_data_with_sd.txt');    
Exp_Co_data=Coculture_Data.data;
Exp_Co_data_mets=Coculture_Data.textdata;
Time_Co_data=Exp_Co_data(:,1);
Met_Co_Data=Exp_Co_data(:,2:2:end);
Met_Co_error=Exp_Co_data(:,3:2:end);

figure13 = figure;
% Create axes
axes1 = axes('Parent',figure13,'YTick',[0 2 4]);
hold(axes1,'on');

% Activate the left side of the axes
yyaxis(axes1,'left');
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[17 27 21 7.5]);
plot1 = plot(Tmodel,Ymodel(:,2:4),'Linestyle','-','LineWidth',3.5,'Parent',axes1);
set(plot1(1),...
    'Color',[0.7137    0.4431    0.5569]);
set(plot1(2),...
    'Color',[0.9686    0.5333    0.5529]);
set(plot1(3),...
    'Color',[0.6314    0.2392    0.2314]);

% Create multiple lines using matrix input to plot
% plot2 = plot(Texp,Yexp(:,2:4),'MarkerSize',16,'LineStyle','none','Parent',axes1);
% set(plot2(1),...
%     'MarkerFaceColor',[0.7137    0.4431    0.5569],...
%     'MarkerEdgeColor',[0.7137    0.4431    0.5569],...
%     'Marker','>','linewidth',3);
% set(plot2(2),...
%     'MarkerFaceColor',[0.9686    0.5333    0.5529],...
%     'MarkerEdgeColor',[0.9686    0.5333    0.5529],...
%     'Marker','^','linewidth',3);
% set(plot2(3),...
%     'MarkerFaceColor',[0.6314    0.2392    0.2314],...
%     'MarkerEdgeColor',[0.6314    0.2392    0.2314],...
%     'Marker','v','linewidth',3);

% plot2 = errorbar(Texp,Met_Co_Data(:,2),'MarkerSize',16,'LineStyle','none','Parent',axes1);

plot2= errorbar(Texp,Met_Co_Data(:,2),Met_Co_error(:,2),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.7137    0.4431    0.5569],...
    'MarkerFaceColor',[0.7137    0.4431    0.5569],...
    'Marker','>','linewidth',2,...
    'color','k');

plot3= errorbar(Texp,Met_Co_Data(:,3),Met_Co_error(:,3),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.9686    0.5333    0.5529],...
    'MarkerFaceColor',[0.9686    0.5333    0.5529],...
    'Marker','^','linewidth',2,...
    'color','k');

plot4= errorbar(Texp,Met_Co_Data(:,4),Met_Co_error(:,4),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.6314    0.2392    0.2314],...
    'MarkerFaceColor',[0.6314    0.2392    0.2314],...
    'Marker','v','linewidth',2,...
    'color','k');


% color: 
% biomass:
% [91,128,149]./255
% hexose:
% [182,113,142]./255
% maltose:
% [247,136,141]./255
% starch:
% [161,61,59]./255
% acetate:
% [18,107,158]./255
% formate:
% [0 135 82]./255
% lactate:
% [244,173,175]./255
% succinate:
% [220,142,181]./255
% yellow: propionate
% [248,205,151]./255 
% green
% [171,206,199]./255 

% % bad, growth
% [236,187,83]./255
% % bth, growth
% [87,155,201]./255

       
% Create ylabel
ylabel('Biomass(g/L)','FontSize',20,'FontName','helvetica');

% Set the remaining axes properties
set(axes1,'YColor','black','YTick',[0 2 4],'xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.5 4.6]);
% Activate the right side of the axes
yyaxis(axes1,'right');
set(gcf,'unit','centimeters','position',[17 27 21 7.5]);
% Create plot
plot(Tmodel,Ymodel(:,1),'LineWidth',3.5,...
    'Color',[0.3569    0.5020    0.5843]);

% Create plot
% plot(Texp,Yexp(:,1),...
%     'MarkerEdgeColor',[0.3569    0.5020    0.5843],...
%     'MarkerSize',16,...
%     'Marker','^',...
%     'LineWidth',3,...
%     'LineStyle','none');
errorbar(Texp,Met_Co_Data(:,1),Met_Co_error(:,1),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.3569    0.5020    0.5843],...
    'MarkerFaceColor',[0.3569    0.5020    0.5843],...
    'Marker','^','linewidth',2,...
    'Color','k');
 bms=legend([met_udf(2:4) met_udf(1) met_udf(2:4) met_udf(1)],'linewidth',1.5,'fontsize',18,'fontname','Helvetica');
        set(bms,'Box','off','Location','best')
% Create ylabel

% Set the remaining axes properties
set(axes1,'YColor','black','YTick',[0 1 2 3],'YScale','linear','xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.5 3.5]);
% Create xlabel
% xlabel('Time [h]','FontSize',24,'FontName','Helvetica');
ylabel('Substrate (g/L)','FontSize',20,'FontName','helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 27]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18,'XTick',[0 5 10 15 20 25],'LineWidth',1,'xcolor','k');
% Create textbox
annotation(figure13,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Coculture-Substrates'},...
    'LineStyle','none',...
    'FontSize',16,...
    'FontAngle','normal',...
    'FitBoxToText','off');

% export_fig Fig2a1.pdf -q101
export_fig Fig2a1_legend.pdf -q101

%% Figure a1 R squared calculation
T_index=cell2mat(arrayfun(@(x) find(abs(Tmodel-x)<=0.011,1), Texp, 'un',0));
Ymodel_cmp=Ymodel(T_index,:);

y1=reshape(Met_Co_Data(1:4),[],1);     %% true value
f1=reshape(Ymodel_cmp(1:4),[],1);     %% model prediction
[r1,rmse1]=rsquare(y1,f1)




figure14 = figure;

% Create axes
axes1 = axes('Parent',figure14,'YTick',[0 20 40]);
hold(axes1,'on');

% Activate the left side of the axes
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[17 18 21 7.5]);
plot1 = plot(Tmodel,Ymodel(:,5:end),'Linestyle','-','LineWidth',3.5,'Parent',axes1);
set(plot1(1),...
    'Color',[ 0.8627    0.5569    0.7098]);
set(plot1(2),...
    'Color',[0.0706    0.4196    0.6196]);
set(plot1(3),...
    'Color',[0.9725    0.8039    0.5922]);
set(plot1(4),...
    'Color',[0.9569    0.6784    0.6863]);
set(plot1(5),...
    'Color',[0    0.5294    0.3216]);

% Create multiple lines using matrix input to plot
% plot2 = plot(Texp,Yexp(:,5:end),'MarkerSize',18,'LineStyle','none','Parent',axes1);
% set(plot2(1),...
%     'MarkerFaceColor',[ 0.8627    0.5569    0.7098],...
%     'MarkerEdgeColor',[ 0.8627    0.5569    0.7098],...
%     'Marker','>','linewidth',3);
% set(plot2(2),...
%     'MarkerFaceColor',[0.0706    0.4196    0.6196],...
%     'MarkerEdgeColor',[0.0706    0.4196    0.6196],...
%     'Marker','^','linewidth',3);
% set(plot2(3),...
%     'MarkerFaceColor',[0.9725    0.8039    0.5922],...
%     'MarkerEdgeColor',[0.9725    0.8039    0.5922],...
%     'Marker','v','linewidth',3);
% set(plot2(4),...
%     'MarkerFaceColor',[0.9569    0.6784    0.6863],...
%     'MarkerEdgeColor',[0.9569    0.6784    0.6863],...
%     'Marker','v','linewidth',3);
% set(plot2(5),...
%     'MarkerFaceColor',[0    0.5294    0.3216],...
%     'MarkerEdgeColor',[0    0.5294    0.3216],...
%     'Marker','v','linewidth',3);

plot2= errorbar(Texp,Met_Co_Data(:,5),Met_Co_error(:,5),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[ 0.8627    0.5569    0.7098],...
    'MarkerFaceColor',[ 0.8627    0.5569    0.7098],...
    'Marker','>','linewidth',2,...
    'Color','k');

plot3= errorbar(Texp,Met_Co_Data(:,6),Met_Co_error(:,6),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.0706    0.4196    0.6196],...
    'MarkerFaceColor',[0.0706    0.4196    0.6196],...
    'Marker','^','linewidth',2,...
    'Color','k');

plot4= errorbar(Texp,Met_Co_Data(:,7),Met_Co_error(:,7),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.9725    0.8039    0.5922],...
    'MarkerFaceColor',[0.9725    0.8039    0.5922],...
    'Marker','v','linewidth',2,...
    'Color','k');

plot5= errorbar(Texp,Met_Co_Data(:,8),Met_Co_error(:,8),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.9569    0.6784    0.6863],...
    'MarkerFaceColor',[0.9569    0.6784    0.6863],...
    'Marker','v','linewidth',2,...
    'Color','k');

plot6= errorbar(Texp,Met_Co_Data(:,9),Met_Co_error(:,9),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0    0.5294    0.3216],...
    'MarkerFaceColor',[0    0.5294    0.3216],...
    'Marker','v','linewidth',2,...
    'Color','black');

% Create ylabel
ylabel('Conc (mM)','FontSize',20,'FontName','helvetica');

bms=legend([met_udf(5:end) met_udf(5:end)],'linewidth',1.5,'fontsize',18,'fontname','Helvetica');
        set(bms,'Box','off','Location','best')

% Set the remaining axes properties
set(axes1,'YColor','black','YTick',[0 25 50 75],'xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-12 100]);

% Set the remaining axes properties
% set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 1 2 3],'scale','linear');
% Uncomment the following line to preserve the Y-limits of the axes
% Create xlabel
% xlabel('Time [h]','FontSize',24,'FontName','Helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 27]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18,'XTick',[0 5 10 15 20 25],'LineWidth',1,'xcolor','k');
% Create textbox
annotation(figure14,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Coculture-Products'},...
    'LineStyle','none',...
    'FontSize',16,...
    'FontAngle','normal',...
    'FitBoxToText','off');

% export_fig Fig2a2.pdf -q101
export_fig Fig2a2_legend.pdf -q101

y2=reshape(Met_Co_Data(5:9),[],1);     %% true value
f2=reshape(Ymodel_cmp(5:9),[],1);     %% model prediction
[r2,rmse2]=rsquare(y2,f2)



figure15 = figure;
axes1 = axes('Parent',figure15,'YTick',[0 1 2 3]);
hold(axes1,'on');

% Activate the left side of the axes
yyaxis(axes1,'left');


% Activate the left side of the axes
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[17 10 21 7.5]);
plot1 = plot(Tmodel,Y(:,1:2),'Linestyle','-','LineWidth',3.5,'Parent',axes1);

set(plot1(1),...
    'Color',[0.3412    0.6078    0.7882]);
set(plot1(2),...
    'Color',[0.9255    0.7333    0.3255]);
ylabel('Biomass (g/L)','FontSize',20,'FontName','helvetica');


% Set the remaining axes properties
% set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 1 2 3]);
set(axes1,'YColor','k','YTick',[0 1 2 3],'LineWidth',1,'xcolor','k');

% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.25 3]);


% Set the remaining axes properties
% Uncomment the following line to preserve the Y-limits of the axes
% Set the remaining axes properties
% set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 1 2 3],'scale','linear');
% Uncomment the following line to preserve the Y-limits of the axes
% Create xlabel

yyaxis(axes1,'right');
set(gcf,'unit','centimeters','position',[17 27 21 9]);
% Create plot


Coculture_Data=importdata('Bth_and_Bado_Co_qPCR.csv');    
Exp_qPCR=Coculture_Data.data;
Exp_qPCR_mets=Coculture_Data.textdata;
Time_qPCR=Exp_qPCR(:,1);
% met_qPCR=Exp_qPCR(:,2:end)./power(10,8)./1.0518;
met_qPCR=Exp_qPCR(:,2:end)./power(10,8)./0.9;


plot1= errorbar(Time_qPCR,met_qPCR(:,1),met_qPCR(:,2),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[33, 113, 181]./255,...
    'MarkerFaceColor',[33, 113, 181]./255,...
    'Marker','o','linewidth',2,...
    'Color','black');

plot2= errorbar(Time_qPCR,met_qPCR(:,3),met_qPCR(:,4),...
    'LineStyle','none','MarkerSize',18,...
    'MarkerEdgeColor',[178, 128, 19]./255,...
    'MarkerFaceColor',[178, 128, 19]./255,...
    'Marker','o','linewidth',2,...
    'Color','black');

bac_2spc={'B.thetaiotaomicron' 'B.adolescentis'};
bms=legend([bac_2spc bac_2spc],'linewidth',1.5,'fontsize',18,'fontname','Helvetica');
        set(bms,'Box','off','Location','best')

% set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 1 2 3],'YScale','linear');
set(axes1,'YColor','k','YTick',[0 1 2 3],'YScale','linear','xcolor','k');

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-1.5*10^6 1.8*10^8]);
ylim(axes1,[-0.25 3]);

% Create xlabel
ylabel('qPCR / 10^8','FontSize',20,'FontName','Helvetica');


xlabel('Time (hours)','FontSize',24,'FontName','Helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 27]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18,'LineStyleOrderIndex',2,'XTick',[0 5 10 15 20 25],'LineWidth',1,'xcolor','k');

% Create textbox
annotation(figure15,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'Coculture-Growth'},...
    'LineStyle','none',...
    'FontSize',16,...
    'FontAngle','normal',...
    'FitBoxToText','off');

% export_fig Fig2a3.pdf -q101
export_fig Fig2a3_legend.pdf -q101


%% compare qPCR, can not calculate the real r square, instead fit then calculate
BM_cmp=Y(T_index,:);
y2=reshape(Exp_qPCR(:,[2,4]),[],1);     %%
f2=reshape(BM_cmp(:,1:2),[],1);     %%
mdl = fitlm(y2,f2)
mdl.Rsquared.Ordinary
mdl.Rsquared.Adjusted



