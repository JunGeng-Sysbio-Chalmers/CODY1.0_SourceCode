function main_CM_diet

data=load('20190319_CM_diet_intervention.mat');
data=data.ReferenceStates;
%% Rectum/Feces time-series RA calculation:
% Res_12m=Result_SF;
Tmodel=data.SimulationTime;
Y=data.SimulationResult;      %% vector
% Ymet_12m=data.SimulationMetabolites;%% 
% Ymodel_12m=data.Result_cell;  
% met_co_12m=data.met_udf_co;
ylg=data.ylg;
n_species=data.SpeciesNumber;
met_udf_co=data.met_udf_co;
lxini=length(met_udf_co);
n_rct=data.RectorNumber;

for k=1:n_rct-2
    Ymodel{k}=Y(:,1+(k-1).*ylg:ylg+(k-1).*ylg); %% 
    Ymodel_met{k}=Y(:,1+(k-1).*ylg:lxini+(k-1).*ylg); %% 
end
k=9;
Ymodel{k}=Y(:,1+(k-1).*ylg:ylg+1+lxini+(k-1).*ylg);
Ymodel_met{k}=Y(:,1+(k-1).*ylg:lxini+(k-1).*ylg);
V5_rctm=Y(:,(k-1)*ylg+ylg+1);  %%
Ymodel_mass_rctm=Y(:,(k-1)*ylg+ylg+1+1:(k-1).*ylg+ylg+1+lxini);  


defecation_Time=[36];
Time_index(1)=find((Tmodel-36)>0 & (Tmodel-36)<0.001);
i=1;
while i<25
    i=i+1;
    defecation_Time=[defecation_Time;defecation_Time(i-1)+24];
    time_pt=defecation_Time(i);
    Time_index(i)=find(abs(Tmodel-time_pt)<0.01);
end
Time_index(1)=Time_index(1)-2;
Y_rectum=Ymodel_mass_rctm(Time_index,1:n_species);
Y_rectum_7spc_tt=sum(Y_rectum,2)+eps;
Y_rectum_RA=Y_rectum./Y_rectum_7spc_tt.*0.0928;  


%% extraction of the baseline condition prediction from baseline mat file:
data_bsl=load('20190312_CM_diet_baseline.mat');
data_bsl=data_bsl.ReferenceStates;
Tmodel_bsl=data_bsl.SimulationTime;
Y_bsl=data_bsl.SimulationResult;      
for k=1:n_rct-2
    Ymodel_bsl{k}=Y_bsl(:,1+(k-1).*ylg:ylg+(k-1).*ylg); 
    Ymodel_met_bsl{k}=Y_bsl(:,1+(k-1).*ylg:lxini+(k-1).*ylg); 
end
k=9;
Ymodel_bsl{k}=Y_bsl(:,1+(k-1).*ylg:ylg+1+lxini+(k-1).*ylg);
Ymodel_met_bsl{k}=Y_bsl(:,1+(k-1).*ylg:lxini+(k-1).*ylg);
V5_rctm_bsl=Y_bsl(:,(k-1)*ylg+ylg+1);  
Ymodel_mass_rctm_bsl=Y_bsl(:,(k-1)*ylg+ylg+1+1:(k-1).*ylg+ylg+1+lxini);  


Y_rectum_bsl=Ymodel_mass_rctm_bsl(end,1:n_species);
Y_rectum_RA_bsl=Y_rectum_bsl./sum(Y_rectum_bsl).*0.1351; 

Y_rectum_RA=[Y_rectum_RA_bsl;Y_rectum_RA];
Time_index=[1 Time_index];

colorset={[220,240,206]
          [200,242,234]
          [244,235,206]
          [255,228,226]
          [200,240,250]
          [237,232,254]
          [255,223,246]};
      
%% Experimental data extraction
RA_file='Mean_RA_species.txt';
RA_data=readtable(RA_file);
% RA_data=importdata(RA_file);
Fpr_dup=find(contains(RA_data.Var1,'Faecalibacterium'));
Fpr_dup_data=RA_data(Fpr_dup,:);
Fpr_RA=sum(Fpr_dup_data{:,2:end},1);
RA_data(Fpr_dup,:)=[];
Fpr_new=RA_data(Fpr_dup(1),:);
Fpr_new.Var1='Faecalibacterium prausnitzii';
Fpr_new(1,2:end)=num2cell(Fpr_RA);
RA_data=[RA_data;Fpr_new];
RA_data= [RA_data(:,1) RA_data(:,end) RA_data(:,2:end-1)];
header=table2cell(RA_data(1,2:end));
header=cellfun(@string,header,'un',0);
header=cellfun(@char,header,'un',0);
header=strcat('day_',header);
RA_data.Properties.VariableNames=['Species' header];
RA_data(1,:)=[];
species={'Bacteroides fragilis','Bifidobacterium longum','Bifidobacterium breve', 'Bifidobacterium adolescentis' 'Eubacterium hallii' 'Faecalibacterium prausnitzii' 'Roseburia intestinalis'}';
index=[];
for i=1:length(species)
    index(i)=find(contains(RA_data.Species,species(i)));
end
RA_data=RA_data(index,:);
RA_data_exp=RA_data(:,[1 3:6 2]);
RA_data_exp_data=RA_data_exp{:,2:end};
RA_data_exp_data=RA_data_exp_data'; 
RA_data_time=[0,1,3,7,14].*24;
% RA_7spc=figure(11);
%     for i=1:n_species
%        subplot(n_species,1,i)  
%           plot(Tmodel(Time_index).*0.56,Y_rectum_RA(:,i),'color',colorset{i}./255,'linewidth',3);
%        hold on
%           plot(RA_data_time,RA_data_exp_data(:,i),'MarkerSize',10,'LineStyle','none',...
%               'MarkerFaceColor','black',...
%               'MarkerEdgeColor','black',...
%               'Marker','o');
%        hold on
%     end
%     
% 
%     
%    set(gcf,'position',[120 120 456 786]);
%    
%        title('Feces Microbial RA','fontsize',15,'fontname','arial');
% %        mts=legend(met_udf_co(1:n_species),'linewidth',1.5,'fontsize',7);
% %        set(mts,'Box','off','Location','NorthWest')
%     set(gca,'fontsize',10); set(gca,'linewidth',1.5);
%     set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
%     xlabel('Time [h]','fontsize',15,'fontname','arial'); ylabel(['Blood Concentration' '[mM]'],'fontsize',15,'fontname','arial');
%     hold off
    
Time_series_RA=[Tmodel(Time_index).*0.56 Y_rectum_RA]; 
header={'Time' 'Bfr' 'Blg' 'Bbr' 'Bad' 'Ehal' 'Fpr' 'Rint'};
RA_timeSeries=array2table(Time_series_RA,'VariableNames',header);
% writetable(RA_timeSeries,'RA_prediction_TimeSeries.csv');
%%


