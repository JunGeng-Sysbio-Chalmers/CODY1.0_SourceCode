
function main_pureCulture_sensitivity_analysis
clear 
clc
close all
currentDepth = 1; 
currPath = fileparts(mfilename('fullpath'));
cd(currPath);
addpath('./data');
addpath('./export_fig-master/');

load('8SPC_0405.mat');
fileNum=size(SPC,2);

Sensitivity_org={};  
Sensitivity_95={};   
Sensitivity_105={};   


for i=[1:3 5:6]
Tmodel={};
Ymodel={};
miu={};
rsq_org={};
rmse_org={};
    name{i}=SPC{i}.id;
    met{i}=SPC{i}.met_udf;
    para=SPC{i}.KM;

%% org parameters, rmse
    [Tmodel,Ymodel,Texp,Yexp,miu,rsq_org,rmse_org]=common_pure_sensitivity_simulation(SPC{i},i);
    Tmodel_org{i}=Tmodel;
    Ymodel_org{i}=Ymodel;
    miu_org{i}=miu;

    %% 95% parameters, rmse
    para_sensi_95={};
% Tmodel={};
% Ymodel={};
% miu={};
% rsq={};
% rmse={};

Tmodel_95={};
Ymodel_95={};
miu_95={};
rsq_95={};
rmse_95={};

    for j=1:length(para)
        para_95=para;
        para_95(j)=para_95(j).*0.95;
        para_sensi_95{j}=para_95;
        SPC{i}.KM=para_95;
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
% Tmodel={};
% Ymodel={};
% miu={};
% rsq={};
% rmse={};
Tmodel_105={};
Ymodel_105={};
miu_105={};
rsq_105={};
rmse_105={};
    for j=1:length(para)
        para_105=para;
        para_105(j)=para(j).*1.05;
        para_sensi_105{j}=para_105;
        SPC{i}.KM=para_105;
        [Tmodel,Ymodel,Texp,Yexp,miu,rsq,rmse]=common_pure_sensitivity_simulation(SPC{i},i);
        Tmodel_105{j}=Tmodel;
        Ymodel_105{j}=Ymodel;
        miu_105{j}=miu;
        rsq_105{j}=rsq;
        rmse_105{j}=rmse;
        colname_ub=strcat('kmax',num2str(j),'_ub');
        plotSPC(Tmodel,Ymodel,Texp,Yexp,name{i},i,colname_ub);

    end
% %     colname_lb=strcat('kmax',num2str(j),'_lb');
%     SPC{i}.id=strrep(SPC{i}.id,' ','_');
%     output_name=strcat('./data/',SPC{i}.id,'RMSE_sensitivity_analysis.txt');
% 
%     header={};
%     for j=1:length(para)
%         header=[header, strcat('kmax',num2str(j),'_95')];
%     end
%     header=[header,'para_org'];
%     for j=1:length(para)
%         header=[header, strcat('kmax',num2str(j),'_105')];
%     end
%     output{i}=[rmse_95 {rmse_org} rmse_105];
%     writetable(cell2table(output{i},'VariableNames',header),output_name);
    
    
    %     colname_lb=strcat('kmax',num2str(j),'_lb');
    SPC{i}.id=strrep(SPC{i}.id,' ','_');
    output_name=strcat(SPC{i}.id,'_KM_RMSE_sensitivity_analysis.txt');

    header={};
    for j=1:length(para)
        header=[header, strcat('KM',num2str(j))];
    end
    header=[header,'para_org'];
    for j=1:length(para)
        header=[header, strcat('KM',num2str(j),'_105')];
    end
    output{i}=num2cell([cell2mat(rmse_95); rmse_org.*ones(1,length(para)); cell2mat(rmse_105)]);
    writetable(cell2table(output{i},'VariableNames',header(1:length(para))),output_name);
    
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



