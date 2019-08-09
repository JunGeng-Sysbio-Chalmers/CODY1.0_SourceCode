function main_pure_batch_mulsub
clc
clear
close all
addpath('./export_fig-master')

set(0,'defaultfigurecolor',[1 1 1])

currentDepth = 1; % 
currPath = fileparts(mfilename('fullpath'));% 
cd(currPath);

CurrentPath=pwd;

id2={'Bifido_ado_3sub_0822_starch_1002'};
SPC_EM=[14;6;6];
load('SPC_Co_Bad.mat');
[Tmodel,Ymodel,Texp,Yexp,metname]=common_pure_sim_mulsub(SPC_Co_Bad,SPC_EM,1);   


Coculture_Data=importdata('Bad_data_with_sd.txt');    
Exp_Bad_data=Coculture_Data.data;
Exp_Bad_data_mets=Coculture_Data.textdata;
Time_Bad_data=Exp_Bad_data(:,1);
Met_Bad_data=Exp_Bad_data(:,2:2:end);
Met_Bad_data_error=Exp_Bad_data(:,3:2:end);

met_udf=Exp_Bad_data_mets(2:2:15);


figure11 = figure;
% Create axes
axes1 = axes('Parent',figure11,'YTick',[0 2 4]);
hold(axes1,'on');

% Activate the left side of the axes
yyaxis(axes1,'left');
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[17 26 25 8]);
plot1 = plot(Tmodel,Ymodel(:,2:4),'Linestyle','-','LineWidth',6.5,'Parent',axes1);
set(plot1(1),...
    'Color',[0.7137    0.4431    0.5569]);
set(plot1(2),...
    'Color',[0.9686    0.5333    0.5529]);
set(plot1(3),...
    'Color',[0.6314    0.2392    0.2314]);

% Create multiple lines using matrix input to plot
% plot2 = plot(Texp,Yexp(:,2:4),'MarkerSize',18,'LineStyle','none','Parent',axes1);
% set(plot2(1),...
%     'MarkerFaceColor',[0.7137    0.4431    0.5569],...
%     'MarkerEdgeColor',[0.7137    0.4431    0.5569],...
%     'Marker','>','linewidth',4);
% set(plot2(2),...
%     'MarkerFaceColor',[0.9686    0.5333    0.5529],...
%     'MarkerEdgeColor',[0.9686    0.5333    0.5529],...
%     'Marker','^','linewidth',4);
% set(plot2(3),...
%     'MarkerFaceColor',[0.6314    0.2392    0.2314],...
%     'MarkerEdgeColor',[0.6314    0.2392    0.2314],...
%     'Marker','v','linewidth',4);


plot2= errorbar(Texp,Met_Bad_data(:,2),Met_Bad_data_error(:,2),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.7137    0.4431    0.5569],...
    'MarkerFaceColor',[0.7137    0.4431    0.5569],...
    'Marker','>','linewidth',2,...
    'color','k');

plot3= errorbar(Texp,Met_Bad_data(:,3),Met_Bad_data_error(:,3),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.9686    0.5333    0.5529],...
    'MarkerFaceColor',[0.9686    0.5333    0.5529],...
    'Marker','^','linewidth',2,...
    'color','k');

plot4= errorbar(Texp,Met_Bad_data(:,4),Met_Bad_data_error(:,4),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.6314    0.2392    0.2314],...
    'MarkerFaceColor',[0.6314    0.2392    0.2314],...
    'Marker','v','linewidth',2,...
    'color','k');


% % color: 
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
% green,
% [171,206,199]./255 



% Create ylabel
ylabel('Biomass(g/L)','FontSize',20,'FontName','arial');

% Set the remaining axes properties
set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 2 4],'xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.5 4.6]);
% Activate the right side of the axes
yyaxis(axes1,'right');
set(gcf,'unit','centimeters','position',[17 26 25 8]);
% Create plot
plot(Tmodel,Ymodel(:,1),'LineWidth',6.5,...
    'Color',[0.3569    0.5020    0.5843]);

% Create plot
% plot(Texp,Yexp(:,1),...
%     'MarkerEdgeColor',[0.3569    0.5020    0.5843],...
%     'MarkerSize',18,...
%     'Marker','^',...
%     'LineWidth',4,...
%     'LineStyle','none');

errorbar(Texp,Met_Bad_data(:,1),Met_Bad_data_error(:,1),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0.3569    0.5020    0.5843],...
    'MarkerFaceColor',[0.3569    0.5020    0.5843],...
    'Marker','^','linewidth',2,...
    'Color','k');

 bms=legend([met_udf(1:4) met_udf(1:4)],'linewidth',1.5,'fontsize',18,'fontname','Helvetica');
        set(bms,'Box','off','Location','best')
% Create ylabel

% Set the remaining axes properties
set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 1 2 3],'YScale','linear','xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-0.5 3.5]);
% Create xlabel
xlabel('Time [h]','FontSize',24,'FontName','Helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 27]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[0 5 10 15 20 25],'xcolor','k');
% Create textbox
annotation(figure11,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'B.adolescentis-Substrates'},...
    'LineStyle','none',...
    'FontSize',17,...
    'FontAngle','normal',...
    'FitBoxToText','off');

% export_fig Supp_Fig9a1.pdf -q101
export_fig Supp_Fig6a1_legend.pdf -q101


T_index=cell2mat(arrayfun(@(x) find(abs(Tmodel-x)<=0.011,1), Texp, 'un',0));
Ymodel_cmp=Ymodel(T_index,:);

y1=reshape(Met_Bad_data(1:4),[],1);     %% true value
f1=reshape(Ymodel_cmp(1:4),[],1);     %% model prediction
[r1,rmse1]=rsquare(y1,f1);



figure12 = figure;

% Create axes
axes1 = axes('Parent',figure12,'YTick',[0 20 40]);
hold(axes1,'on');

% Activate the left side of the axes
% Create multiple lines using matrix input to plot
set(gcf,'unit','centimeters','position',[17 17 25 8]);
plot1 = plot(Tmodel,Ymodel(:,5:end),'Linestyle','-','LineWidth',6.5,'Parent',axes1);
set(plot1(1),...
    'Color',[ 0.0706    0.4196    0.6196]);
set(plot1(2),...
    'Color',[ 0.9569    0.6784    0.6863]);
set(plot1(3),...
    'Color',[0    0.5294    0.3216]);

% Create multiple lines using matrix input to plot
% plot2 = plot(Texp,Yexp(:,5:end),'MarkerSize',18,'LineStyle','none','Parent',axes1);
% set(plot2(1),...
%     'MarkerFaceColor',[ 0.0706    0.4196    0.6196],...
%     'MarkerEdgeColor',[ 0.0706    0.4196    0.6196],...
%     'Marker','<','linewidth',4);
% set(plot2(2),...
%     'MarkerFaceColor',[ 0.9569    0.6784    0.6863],...
%     'MarkerEdgeColor',[ 0.9569    0.6784    0.6863],...
%     'Marker','^','linewidth',4);
% set(plot2(3),...
%     'MarkerFaceColor',[0    0.5294    0.3216],...
%     'MarkerEdgeColor',[0    0.5294    0.3216],...
%     'Marker','v','linewidth',4);

plot2= errorbar(Texp,Met_Bad_data(:,5),Met_Bad_data_error(:,5),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[ 0.0706    0.4196    0.6196],...
    'MarkerFaceColor',[ 0.0706    0.4196    0.6196],...
    'Marker','>','linewidth',2,...
    'Color','k');

plot3= errorbar(Texp,Met_Bad_data(:,6),Met_Bad_data_error(:,6),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[ 0.9569    0.6784    0.6863],...
    'MarkerFaceColor',[ 0.9569    0.6784    0.6863],...
    'Marker','^','linewidth',2,...
    'Color','k');

plot4= errorbar(Texp,Met_Bad_data(:,7),Met_Bad_data_error(:,7),...
    'LineStyle','none','MarkerSize',18,...
        'MarkerEdgeColor',[0    0.5294    0.3216],...
    'MarkerFaceColor',[0    0.5294    0.3216],...
    'Marker','v','linewidth',2,...
    'Color','k');

bms=legend([met_udf(5:end) met_udf(5:end)],'linewidth',1.5,'fontsize',18,'fontname','Helvetica');
        set(bms,'Box','off','Location','best')

% Create ylabel
ylabel('Conc (mM)','FontSize',20,'FontName','arial');

% Set the remaining axes properties
set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 25 50 75 100],'xcolor','k');
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-12 112]);

% Set the remaining axes properties
% set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 1 2 3],'scale','linear');
% Uncomment the following line to preserve the Y-limits of the axes
% Create xlabel
xlabel('Time [h]','FontSize',24,'FontName','Helvetica');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[-2 27]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[0 5 10 15 20 25],'xcolor','k');
% Create textbox
annotation(figure12,'textbox',...
    [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
    'String',{'B.adolescentis-Products'},...
    'LineStyle','none',...
    'FontSize',17,...
    'FontAngle','normal',...
    'FitBoxToText','off');

% export_fig Supp_Fig9a2.pdf -q101
export_fig Supp_Fig6a2_legend.pdf -q101


y2=reshape(Met_Bad_data(5:end),[],1);     %% true value
f2=reshape(Ymodel_cmp(5:end),[],1);     %% model prediction
[r2,rmse2]=rsquare(y2,f2);



RMSE=0;
T_index=cell2mat(arrayfun(@(x) find(abs(Tmodel-x)<=0.011,1), Texp, 'un',0));
Ymodel_cmp=Ymodel(T_index,:);
[m,n]=size(Yexp);


err=0;
        for j=1:n-1
            maxYexp=max(abs(Yexp(:,j)));
            maxYmodel=max(abs(Ymodel_cmp(:,j)));
            minmaxY=min(maxYexp,maxYmodel);
            if minmaxY<eps; minmaxY=maxYexp;end
%             if strcmp(paraopt_objfcn,'MSRE')
                for i=1:m
                    err_sq=((Ymodel_cmp(i,j)-Yexp(i,j))/minmaxY)^2;
                    err=err+err_sq;
                end
%             elseif strcmp(paraopt_objfcn,'MSE')
%                 for i=1:m
%                     err_sq=(Ymodel_cmp(i,j)-Yexp(i,j))^2;
%                     err=err+err_sq;
%                 end
%             end
        end
        err=err/(n*m);
% RMSE=err;

%         RMSE = sqrt(mean((Ymodel_cmp - Yexp).^2));  % Root Mean Squared Error

