%% this code is to simulate community culture of user-defined species in batch condition %%
function main_pureCulture_sensitivity_analysis
clear 
clc
close all
currentDepth = 1; % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));% get current path
cd(currPath);
addpath('./data');
addpath('./export_fig-master/');

load('8SPC_0405.mat');
fileNum=size(SPC,2);

Sensitivity_org={};   %% sensitivity analysis results for 8 species
Sensitivity_95={};   %% sensitivity analysis results for 8 species
Sensitivity_105={};   %% sensitivity analysis results for 8 species


for i=1:fileNum
Tmodel={};
Ymodel={};
miu={};
rsq_org={};
rmse_org={};
    name{i}=SPC{i}.id;
    met{i}=SPC{i}.met_udf;
    para=SPC{i}.kmax;

%% org parameters, rmse
    [Tmodel,Ymodel,Texp,Yexp,miu,rsq_org,rmse_org]=common_pure_sensitivity_simulation(SPC{i},i);
    Tmodel_org{i}=Tmodel;
    Ymodel_org{i}=Ymodel;
    miu_org{i}=miu;

    %% 95% parameters, rmse
    para_sensi_95={};
Tmodel={};
Ymodel={};
miu={};
rsq={};
rmse={};
    for j=1:length(para)
        para_95=para;
        para_95(j)=para_95(j).*0.95;
        para_sensi_95{j}=para_95;
        SPC{i}.kmax=para_95;
        [Tmodel,Ymodel,Texp,Yexp,miu,rsq,rmse]=common_pure_sensitivity_simulation(SPC{i},i);
           Tmodel_95{j}=Tmodel;
           Ymodel_95{j}=Ymodel;
           miu_95{j}=miu;
           rsq_95{j}=rsq;
           rmse_95{j}=rmse;
           colname_lb=strcat('kmax',num2str(j),'_lb');
           plotSPC(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
    end

%% 105% parameters, rmse   
    para_sensi_105={};
Tmodel={};
Ymodel={};
miu={};
rsq={};
rmse={};
    for j=1:length(para)
        para_105=para;
        para_105(j)=para(j).*1.05;
        para_sensi_105{j}=para_105;
        SPC{i}.kmax=para_105;
        [Tmodel,Ymodel,Texp,Yexp,miu,rsq,rmse]=common_pure_sensitivity_simulation(SPC{i},i);
        Tmodel_105{j}=Tmodel;
        Ymodel_105{j}=Ymodel;
        miu_105{j}=miu;
        rsq_105{j}=rsq;
        rmse_105{j}=rmse;
        colname_ub=strcat('kmax',num2str(j),'_ub');
        plotSPC(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);

    end
%     colname_lb=strcat('kmax',num2str(j),'_lb');
    SPC{i}.id=strrep(SPC{i}.id,' ','_');
    output_name=strcat('./data/',SPC{i}.id,'RMSE_sensitivity_analysis.txt');

    header={};
    for j=1:length(para)
        header=[header, strcat('kmax',num2str(j),'_95')];
    end
    header=[header,'para_org'];
    for j=1:length(para)
        header=[header, strcat('kmax',num2str(j),'_105')];
    end
    output{i}=[rmse_95 {rmse_org} rmse_105];
    writetable(cell2table(output{i},'VariableNames',header),output_name);
end
end



    function [Tmodel,Ymodel,Texp,Yexp,miu,rmse]=sensitivity_analysis(SPC,id)
        spc_id=strrep(SPC.id,' ','_');
        lth_para=length(SPC.kmax);
        for jj=1:lth_para
            [Tmodel{jj},Ymodel{jj},Texp{jj},Yexp{jj},miu{jj},rmse{jj}]=common_pure_sensitivity_simulation(SPC,jj);
        end
    end
        


    function plotSPC(Tmodel,Ymodel,Texp,Yexp,name,ii,IC)
         id=ii;
         switch id
            case id==1
                 plotSPC_1(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==2
                 plotSPC_2(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==3
                 plotSPC_3(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==4
                 plotSPC_4(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==5
                 plotSPC_5(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==6
                 plotSPC_6(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==7
                 plotSPC_7(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
            case id==8
                 plotSPC_8(Tmodel,Ymodel,Texp,Yexp,name,id,IC);
        end
    end







% 
% 
% for i=1:length(fileNum)
% %     SPC{i}=importSpecies(idi);
%     name{i}=SPC{i}.id;
%     met{i}=SPC{i}.met_udf;
% %     met=SPC.met_udf;
% %     [Tmodel{i},Ymodel,Texp,Yexp,miu{i}]=common_pure_simulation(SPC,i);
%     [Tmodel,Ymodel,Texp,Yexp,miu]=common_pure_simulation_biom(SPC{i},i);
% end
% 
% % Supp Figure8 1)
% i=1;
% % para_sens_table=cell2table({});
% % para_sens=cell2table({});
% for i=1:fileNum
% %     para0=common_pure_paraopt(SPC{i});
% %     para0=common_pure_paraopt_10fold(SPC{i});
%     para_sens.spc=SPC{i}.id;
%     met{i}=SPC{i}.met_udf;
%     para=SPC{i}.kmax;
%     para_lb=para.*0.95;
%     para_ub=para.*1.05;
%     [Tmodel,Ymodel,Texp,Yexp,miu,rmse_org]=common_pure_sensitivity_simulation(SPC{i},i);
%     for j=1:length(para)
%         colname_lb=strcat('kmax',num2str(j),'_lb');
%         colname_ub=strcat('kmax',num2str(j),'_ub');
%         para(j)=para_lb(j);
%         SPC{i}.kmax=para;
%         [Tmodel,Ymodel,Texp,Yexp,miu,rmse_lb]=common_pure_sensitivity_simulation(SPC{i},i);
%         switch i
%             case i==1
%                  plotSPC_1(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==2
%                  plotSPC_2(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==3
%                  plotSPC_3(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==4
%                  plotSPC_4(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==5
%                  plotSPC_5(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==6
%                  plotSPC_6(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==7
%                  plotSPC_7(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%             case i==8
%                  plotSPC_8(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_lb);
%         end
% %         filename=strcat(SPC{i}.id,colname_lb,'.png');
% %         saveas(gcf,filename);
% 
%         para(j)=para_ub(j);
%         SPC{i}.kmax=para;
%         [Tmodel,Ymodel,Texp,Yexp,miu,rmse_ub]=common_pure_sensitivity_simulation(SPC{i},i);
%         para_sens.(genvarname(colname_lb))=(f_lb-f_org)./f_org;
%         para_sens.(genvarname(colname_ub))=(f_lb-f_org)./f_org;
%         switch i
%             case i==1
%                  plotSPC_1(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==2
%                  plotSPC_2(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==3
%                  plotSPC_3(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==4
%                  plotSPC_4(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==5
%                  plotSPC_5(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==6
%                  plotSPC_6(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==7
%                  plotSPC_7(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%             case i==8
%                  plotSPC_8(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);
%         end
% %         filename=strcat(SPC{i}.id,colname_ub,'.png');
% %         saveas(gcf,filename);
%         
%     end
%     para_sens_table{i}=para_sens;
% end
%         
% 
% figure1 = figure;
% 
% % Create axes
% axes1 = axes('Parent',figure1,'YTick',[0 30 60 90 120]);
% hold(axes1,'on');
% 
% % Activate the left side of the axes
% yyaxis(axes1,'left');
% % Create multiple lines using matrix input to plot
% set(gcf,'unit','centimeters','position',[13 17 25 11]);
% 
% plot1 = plot(Tmodel,Ymodel(:,2:end),'Linestyle','-','LineWidth',6.5,'Parent',axes1);
% set(plot1(1),...
%     'Color',[0.905882352941176 0.529411764705882 0.219607843137255]);
% set(plot1(2),...
%     'Color',[0.607843137254902 0.607843137254902 0.776470588235294]);
% set(plot1(3),...
%     'Color',[0.886274509803922 0.725490196078431 0.541176470588235]);
% set(plot1(4),...
%     'Color',[0.627450980392157 0.796078431372549 0.776470588235294]);
% 
% % Create multiple lines using matrix input to plot
% plot2 = plot(Texp,Yexp(:,2:4),'MarkerSize',18,'LineStyle','none','Parent',axes1);
% set(plot2(1),...
%     'MarkerFaceColor',[0.905882352941176 0.529411764705882 0.219607843137255],...
%     'MarkerEdgeColor',[0.905882352941176 0.529411764705882 0.219607843137255],...
%     'Marker','>');
% set(plot2(2),...
%     'MarkerFaceColor',[0.607843137254902 0.607843137254902 0.776470588235294],...
%     'MarkerEdgeColor',[0.607843137254902 0.607843137254902 0.776470588235294],...
%     'Marker','^');
% set(plot2(3),...
%     'MarkerFaceColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
%     'MarkerEdgeColor',[0.886274509803922 0.725490196078431 0.541176470588235],...
%     'Marker','v');
% 
% % Create ylabel
% ylabel('[mM]','FontSize',20,'FontName','arial');
% 
% % Set the remaining axes properties
% set(axes1,'YColor',[0 0.447 0.741],'YTick',[0 30 60 90 120]);
% % Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-15 145]);
% % Activate the right side of the axes
% yyaxis(axes1,'right');
% set(gcf,'unit','centimeters','position',[13 17 25 11]);
% % Create plot
% plot(Tmodel,Ymodel(:,1),'LineWidth',6.5,...
%     'Color',[0.964705882352941 0.349019607843137 0.270588235294118]);
% 
% % Create plot
% plot(Texp,Yexp(:,1),...
%     'MarkerEdgeColor',[0.964705882352941 0.349019607843137 0.270588235294118],...
%     'MarkerSize',18,...
%     'Marker','^',...
%     'LineWidth',3.5,...
%     'LineStyle','none');
% 
% % Create ylabel
% ylabel('[logCFU/mL]','FontSize',24,'FontName','Helvetica','Rotation',270);
% 
% % Set the remaining axes properties
% set(axes1,'YColor',[0.85 0.325 0.098],'YTick',[0 10 20 30 40]);
% % Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-2 43]);
% % Create xlabel
% xlabel('Time [h]','FontSize',24,'FontName','Helvetica');
% 
% % Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[-2 50]);
% box(axes1,'on');
% % Set the remaining axes properties
% set(axes1,'XTick',[0 10 20 30 40 50]);
% % Create textbox
% annotation(figure1,'textbox',...
%     [0.566824644549765 0.806522123893805 0.329383886255924 0.0862831858407079],...
%     'String',{'Bacteroides thetaiotaomicron'},...
%     'LineStyle','none',...
%     'FontSize',22,...
%     'FontAngle','italic',...
%     'FitBoxToText','off');
% 
% % plot_pure_simulation_multiple(Tmodel{i},Ymodel{i},Texp{i},Yexp{i},met{i},name{i});
% end



