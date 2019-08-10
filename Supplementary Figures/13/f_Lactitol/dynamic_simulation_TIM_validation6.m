function [Tmodel,Y,Ymodel,Ymodel_met,met_udf_co]=dynamic_simulation_TIM_validation(community,n_spc,num_rct,FSG,Feed,flow_back,V,ini_stat,time,length_each_tank,km_lumen,Pn_mucosa,km_water,density,Met_Mass,hmo_para,vld,uv)

global lxini spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx met_udf met_udf_co n_carbon met_udf_co_new
global Y_BM Y_SUB maxEnzyme kl rct obsv V_obsv t_obsv F5 length_additional kd C_Kd GLU_in GLU_obsv HMO_obsv
global lg_8tank  f_back   n_rct  km   km_w   Pn   rho mol_mass
global flag_meal1 flag_meal2 flag_meal3 flag_fece 
global HMO_in spc_hyd kmax_hmo KM_hmo Y_hmo HMO_const F5_obsv outflow out_time t_open V5_open V_colon

addpath('export_fig-master/')


n_rct=num_rct;
rct=n_rct;
if nargin<19
    uv=false;
end
 
if nargin<18
    vld=false;
end 

f_back=flow_back;
n_s=n_spc;
kl={};
km=km_lumen;
km_w=km_water;
Pn=Pn_mucosa;
rho=density;
mol_mass=Met_Mass./1000;



HMO_const=hmo_para(1);
spc_hyd=hmo_para(2);
kmax_hmo=hmo_para(3);
KM_hmo=hmo_para(4);
Y_hmo=hmo_para(5:end);

    hmo_ix=find(strcmp('HMO',met_udf_co));
for k=1:n_rct-1
    HMO_index(k)=hmo_ix+(k-1).*length_each_tank;  
end
k=n_rct;  
    HMO_index(k)=(k-1).*length_each_tank+length(met_udf_co)+1+hmo_ix;
    

 

lxini=length(met_udf_co);

V_rct=0.00001;  
y0=ini_stat;
lg_8tank=length_each_tank;
y0(9*lg_8tank+1)=V_rct;
tspan=[0:0.01:time];
options_ode=odeset('maxstep',0.01);
obsv=1;   
V_obsv=V_rct;
t_obsv=0;
F5=0; 
GLU_in=0;
HMO_in=0;  
GLU_obsv=[];HMO_obsv=[];F5_obsv=F5;

tspan=[0;72;0.01];
outflow=[];  
out_time=[];
t_open=[];V5_open=[];
[T Y]=my_runge_kutta4_TIM6(@qssm_comm_TIM_validation6,y0,tspan,FSG,Feed,V,HMO_index);  


ylg=lg_8tank;   

Tmodel=T;
[ys,yl]=size(Y);
Y(Y<0)=eps;
for k=1:rct-2
    Ymodel{k}=Y(:,1+(k-1).*ylg:ylg+(k-1).*ylg); 
    Ymodel_met{k}=Y(:,1+(k-1).*ylg:lxini+(k-1).*ylg); 
end
k=9;
Ymodel{k}=Y(:,1+(k-1).*ylg:ylg+1+lxini+(k-1).*ylg);
Ymodel_met{k}=Y(:,1+(k-1).*ylg:lxini+(k-1).*ylg);
V5_rctm=Y(:,(k-1)*ylg+ylg+1); 
Ymodel_mass_rctm=Y(:,(k-1)*ylg+ylg+1+1:(k-1).*ylg+ylg+1+lxini);   


k=10;
Ymodel{k}=Y(:,(k-1).*ylg+1+lxini+1:(k-1).*ylg+1+lxini+lxini);   

leglbl_bm=[];
    tank{1}=hex2rgb('1B9E77');
    tank{2}=hex2rgb('D95F02');
    tank{3}=hex2rgb('7570B3');
    tank{4}=hex2rgb('E7298A');
    tank{5}=hex2rgb('66A61E');
    tank{6}=hex2rgb('E6AB02');
    tank{7}=hex2rgb('80B1D3');
    tank{8}=hex2rgb('BC80BD');


for i=1:10
   switch i
    case 1
        color{i}=[0.15  0  0];
%         color{i-n_s}=[0.905  0.192  0.199];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 2
%         color{i-n_s}=[0.5  0.5  0.5];
        color{i}=[1.0  0.548  0.1];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 3
%         color{i-n_s}=[1  0.8  0];
        color{i}=[0.972  0.555  0.774];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 4
        color{i}=[1  0  1];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 5
        color{i}=[0.8  0.8  0.8];
        color{i}=[0.865 0.811 0.433];

%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 6
%         color{i-n_s}=[0.3  0.3  0.6];
        color{i}=[0.294  0.545  0.749];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 7
%         color{i-n_s}=[0.1  0.8  0.3];
        color{i}=[0.372  0.718  0.361];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 8
        color{i}=[0.2  0.8  0.2];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 9
        color{i}=[0.5  1  0.5];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 10
        color{i}=[1   1  0.2];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    end
end

lumen_legend={'Ascending Lumen' 'Transverse Lumen' 'Descending Lumen' 'Sigmoid Lumen'};
Mucus_legend={'Ascending Mucus' 'Transverse Mucus' 'Descending Mucus' 'Sigmoid Mucus'};

title_name=[lumen_legend Mucus_legend];

met_udf_co{1}='Lactitol';

pred_set='Validation5';
Vad1_lumen=figure(1);
first_pos=0.76;
for k=1:8
    if k<5
    hAxis(k) =subplot(4,2,2*k-1)
       for i=1:lxini
           plot(Tmodel,Ymodel_met{k}(:,i),'color',tank{i}./255,'linewidth',2);
           ylabel('Conc. [mmol/L]','fontsize',18,'fontname','Helvetica');
           title(title_name{k},'fontsize',18,'fontname','Helvetica','FontWeight','normal','FontAngle','normal');
           hold on
       end
       hold off
%         title(['One-time Pulse Tracor in' num2str(1) '^t^h Lumen'],'fontsize',17,'fontname','Helvetica');
        if k==1
           bms=legend(met_udf_co(1:lxini),'linewidth',1.5,'fontsize',15,'fontname','Helvetica','FontWeight','normal','FontAngle','normal');
           set(bms,'Box','off','Location','NorthEast');
        end
      pos = get( hAxis(k), 'Position');      %% first two: left top point, second two: width*height
      pos(1) = 0.175;                         % Shift down. control the invervals between two subplot
      pos(2) = first_pos-0.22*(k-1) ;                         % Shift down. control the invervals between two subplot
      pos(3) = 0.3 ;                         % Increase height.
      pos(4) = 0.17 ;                         % Increase height.

      set( hAxis(k), 'Position', pos);
        
    else
      hAxis(k) =subplot(4,2,2*(k-4))
       for i=1:lxini
           plot(Tmodel,Ymodel_met{k}(:,i),'color',tank{i}./255,'linewidth',2);
           title(title_name{k},'fontsize',18,'fontname','Helvetica','FontWeight','normal','FontAngle','normal');
           ylabel('Conc. [mmol/L]','fontsize',18,'fontname','Helvetica');
           hold on
       end
       hold off
    pos = get( hAxis(k), 'Position');
    pos(1) = 0.53;                         % Shift down. control the invervals between two subplot
    pos(2) = first_pos-0.22*(k-5) ;                         % Shift down. control the invervals between two subplot
    pos(3) = 0.3 ;                         % Increase height.
    pos(4) = 0.17 ;      
    set( hAxis(k), 'Position', pos);
        
    end
    if k==1
           bms=legend(met_udf_co(1:lxini),'linewidth',1.5,'fontsize',15,'fontname','Helvetica','FontWeight','normal','FontAngle','normal');
           set(bms,'Box','off','Location','NorthEast');
    end
    if k==4 || k==8
        xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); 
    end
    
end
set(gca, 'DataAspectRatioMode', 'auto')  %<== Need this to prevent unpredictable behavior, BUT you loose the aspect ratio of the original image!

% set(gca, 'units', 'normalized'); %Just making sure it's normalized
% Tight = get(gca, 'TightInset');  %Gives you the bording spacing between plot box and any axis labels
%                                  %[Left Bottom Right Top] spacing
% NewPos = [Tight(1) Tight(2) 1-Tight(1)-Tight(3) 1-Tight(2)-Tight(4)]; %New plot position [X Y W H]
%  set(gcf, 'Position', NewPos);


%     set(gcf,'position',[120 120 1000 700]);
set(gcf,'OuterPosition',[120 120 1000 800]);
pos = get(gcf,'paperposition');
set(gcf,'paperposition',[pos(1),pos(2), 10, 7.5]);
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 4 2];
%         print(gcf, '-dtiff',[pred_set '_lumen_mets.tiff'],'-r300');
%         print('-dtiff',[pred_set '_lumen_mets'],'-r300');
%        print -dtiff -r600 [pred_set 'lumen_mets.tiff']
% saveas(gcf, 'test.png');
export_fig Validation6_lumen_mucus_mets.pdf -q101
% print -dpdf Validation1_lumen_mets.pdf

% 
% Vad1_mucosa=figure(2);
% 
% for k=5:8
%     plot(Tmodel,Ymodel_met{k},'color',tank{k}./255,'linewidth',2);
%     ylim();
%     hold on
% end
% hold off
% %         title(['Mucus Response'],'fontsize',16,'fontname','Helvetica');
%         bms=legend(Mucus_legend,'linewidth',1.5,'fontsize',16,'fontname','Helvetica');
%         set(bms,'Box','off','Location','NorthEast')
%    
%     set(gca,'fontsize',16); set(gca,'linewidth',1.5);
%     set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
%     xlabel('Time [h]','fontsize',16,'fontname','Helvetica');
%     ylabel(['Hexose ' '[mM]'],'fontsize',16,'fontname','Helvetica');
%     set(gcf,'position',[120 250 700 300])
% export_fig Validation5_mucus_mets.pdf -q101


k=9;
V_rectum=figure(2);
% subplot(3,2,1)     %% ??????9??????????????rectum?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
%    for i=1:n_s
%        plot(Tmodel,Ymodel_met{k}(:,i),line{i},'linewidth',2);
%        hold on
%    end
%    hold off
%         title(['Species in Rectum '],'fontsize',15,'fontname','arial');
%         bms=legend(met_udf_co(1:n_s),'linewidth',1.5,'fontsize',7);
%         set(bms,'Box','off','Location','NorthWest')
%    
%     set(gca,'fontsize',10); set(gca,'linewidth',1.5);
%     set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
%     xlabel('Time [h]','fontsize',15,'fontname','arial'); ylabel(['Biomass' '[g/L]'],'fontsize',15,'fontname','arial');
%     
%    subplot(3,2,2)   %% ??????9??????????????rectum???????????????????????????????????????????????
%    for i=1:length(met_udf_co)-n_s
%        plot(Tmodel,Ymodel_met{k}(:,i+n_s),'color',color{i},'linewidth',2);
%        hold on
%    end
%    
%        title('Metabolites in Rectum','fontsize',15,'fontname','arial');
%        mts=legend(met_udf_co(n_s+1:end),'linewidth',1.5,'fontsize',7);
%        set(mts,'Box','off','Location','NorthWest')
%   
%     set(gca,'fontsize',10); set(gca,'linewidth',1.5);
%     set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
%     xlabel('Time [h]','fontsize',15,'fontname','arial'); ylabel(['Metabolites' '[mM]'],'fontsize',15,'fontname','arial');
%     hold off
    
    subplot(2,1,1)  %% ????????????????????????????????????????????????????????????blood??????????????????4????????????????????

    for i=1:lxini
       plot(Tmodel,Ymodel_mass_rctm(:,i),'color',tank{i}./255,'linewidth',2);
       hold on
    end
    hold off
%         title(['Feces Metabolites'],'fontsize',10,'fontname','Helvetica');
%         bms=legend(met_udf_co(1:n_s),'linewidth',1.5,'fontsize',7);
%         set(bms,'Box','off')
   
    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
            set(gca,'YTick',[0 0.5]);
%     xlabel('Time [h]','fontsize',16,'fontname','helvetica'); 
    ylabel(['SCFA' ' ' '[mmol]'],'fontsize',21,'fontname','helvetica');

    ylim([0,0.5])
%     subplot(3,2,4)   %% ??????9??????????????rectum?????????????????????????????????????????????????????????????
    subplot(2,1,2)   %% ??????9??????????????rectum?????????????????????????????????????????????????????????????
% 
%     for i=1:length(met_udf_co)-n_s
%        plot(Tmodel,Ymodel_mass_rctm(:,i+n_s),'color',color{i},'linewidth',2);
%        hold on
%    end
%    
%        title('Feces Metabolites Excretion','fontsize',15,'fontname','arial');
% %        mts=legend(met_udf_co(n_s+1:end),'linewidth',1.5,'fontsize',7);
% %        set(mts,'Box','off')
%     set(gca,'fontsize',10); set(gca,'linewidth',1.5);
%     set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
%     xlabel('Time [h]','fontsize',15,'fontname','arial'); ylabel(['Metabolites in Feces' '[mmol]'],'fontsize',15,'fontname','arial');
%     hold off
%        
% %     subplot(3,2,[5,6])  %% ??????feces?????????????????????????????9???????????????????????????????
%     subplot(2,2,3)  %% ??????feces?????????????????????????????9???????????????????????????????
    plot(Tmodel,V5_rctm,'k-','linewidth',2);
%     title('Feces Volume','fontsize',10,'fontname','Helvetica'); 
            set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); ylabel(['Volume' ' ' '[L]'],'fontsize',21,'fontname','Helvetica');

    set(gcf,'position',[300 120 700 300])
%     set(gca,'YTick',[0 0.1]);
%         ylim([0,0.1])

%     export_fig 'Validation1_feces_mets.tiff'
export_fig Validation6_feces_mets.pdf -q101

    
k=10;
V_BLD=figure(3)    %% blood??????????????????????????????????????
%     subplot(2,2,4)  %% ??????blood??????????????4????????????????????
    for i=1:length(met_udf_co)
       plot(Tmodel,Ymodel{k}(:,i),'color',tank{i}./255,'linewidth',2);
       hold on
    end
   set(gcf,'position',[300 250 700 300])
   
%        title('Blood SCFA','fontsize',16,'fontname','Helvetica');
%        mts=legend(met_udf_co(1:lxini),'linewidth',1.5,'fontsize',16,'fontname','helvetica');
%        set(mts,'Box','off','Location','NorthEast')
    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); ylabel(['Concentration' ' ' '[mM]'],'fontsize',21,'fontname','Helvetica');
    hold off
% export_fig 'Validation1_Blood_mets.tiff'
export_fig Validation6_Blood_mets.pdf -q101


In_and_out_flow=figure(4)
    
    inflow=0.004*ones(length(Tmodel),1);
        plot(Tmodel,inflow,'color',color{6},'linewidth',2);

    hold on
        plot(out_time,outflow,'color',color{5},'linewidth',2);

    hold off
    mts=legend({'Feeding rate' 'Outflow rate'},'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
       set(mts,'Box','off','Location','NorthEast')
    ylim([0,0.006]);
       set(gca,'fontsize',16); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica');
    ylabel(['Flow Rate' '[L/h]'],'fontsize',21,'fontname','Helvetica');
 
    set(gcf,'position',[300 500 700 300])

% export_fig 'Validation1_Inflow_Outflow.tiff'
export_fig Validation6_Inflow_Outflow.pdf -q101

%     print(gcf,'foo.png','-dpng','-r300'); 
%     print(gcf, '-dtiff', 'myfigure.tiff');


Feeding=figure(5)
HMO_feeding=[];
a=0;
HMO_g=0.25;
for i=1:length(Tmodel)
    
      if (mod(Tmodel(i),72)-0-0.001)>=0&&(mod(Tmodel(i),72)-0.1-0.001)<=0
            a=HMO_g;
%        elseif (mod(Tmodel(i),72)-15-0.01)>=0&&(mod(Tmodel(i),72)-17-0.01)<=0
%             a=1000;
%         elseif (mod(Tmodel(i),72)-30-0.01)>=0&&(mod(Tmodel(i),72)-32-0.01)<=0
%             a=1000;
        else
            a=0;
      end
        HMO_feeding=[HMO_feeding;a];
end
   plot(Tmodel,HMO_feeding,'color',tank{2}./255,'linewidth',2);

    
    mts=legend({'Feeding Lactitol'},'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
       set(mts,'Box','off','Location','NorthEast')
    ylim([0,HMO_g*2]);
        set(gca,'fontsize',21,'YTick',[0,0.25,0.5]); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',16,'fontname','Helvetica');
    ylabel(['Feeding Carbs' ' ' '[g]'],'fontsize',21,'fontname','Helvetica');

    set(gcf,'position',[300 500 700 300])

export_fig Validation6_Feeding_hexose.pdf -q101


%% calculate the total SCFA production in all tanks
SCFA_tt=[];
ac=[];
prop=[];
but=[];
for k=1:rct-2
    ac(:,k)=Ymodel{k}(:,2).*V_colon(k);
    prop(:,k)=Ymodel{k}(:,3).*V_colon(k);
    but(:,k)=Ymodel{k}(:,4).*V_colon(k);
end
k=9;
   ac(:,k)=Ymodel_mass_rctm(:,2);
   prop(:,k)=Ymodel_mass_rctm(:,3);
   but(:,k)=Ymodel_mass_rctm(:,4);
    
k=10;
%    ac(:,k)=trapz(Tmodel,Ymodel{k}(:,2));
%    prop(:,k)=trapz(Tmodel,Ymodel{k}(:,3));
%    but(:,k)=trapz(Tmodel,Ymodel{k}(:,4));
   ac(:,k)=Ymodel{k}(:,2).*V_colon(k);
   prop(:,k)=Ymodel{k}(:,3).*V_colon(k);
   but(:,k)=Ymodel{k}(:,4).*V_colon(k);


ac_tt=sum(ac,2);
prop_tt=sum(prop,2);
but_tt=sum(but,2);
SCFA_tt=[ac_tt prop_tt but_tt];

plt_index=find(Tmodel>=10);
plt_index=[1:plt_index(1)]';
SCFA_t=sum(SCFA_tt,2);


   addpath('Datassource');
   Pectin_Data=readtable('Lactitol.csv');
   Pectin_Data.Properties.VariableNames={'Time_h' 'SCFA_mmol'};
   Pectin_Data.Time_h=Pectin_Data.Time_h./60;

exp_color=hex2rgb('67000d');
lengend_tt=[met_udf_co(2:4) {'SCFA Prediction' 'SCFA Experiment'}];

SCFA=figure(6)   
for i=1:3
   plot(Tmodel(plt_index),SCFA_tt(plt_index,i),'color',tank{i+1}./255,'linewidth',2);
   hold on
end
   plot(Tmodel(plt_index),SCFA_t(plt_index),'color',exp_color./255,'linewidth',2);
   hold on

   % load experimental data from literature: "A computer-controlled system to simulate conditions of the large intestine with peristaltic mixing, water absorption and absorption of fermentation products"
   
   
   plot(Pectin_Data.Time_h,Pectin_Data.SCFA_mmol,'MarkerSize',18,'LineStyle','none',...
       'MarkerFaceColor',exp_color./255,...
       'MarkerEdgeColor',exp_color./255,...
       'Marker','>');

%    plot(Tmodel,SCFA_tt(:,i),'color',tank{i+1}./255,'linewidth',2);
    hold off
    title('SCFA production by Lactitol');
    mts=legend(lengend_tt,'linewidth',1.5,'fontsize',22,'fontname','Helvetica');
       set(mts,'Box','off','Location','NorthEast')
    ylim([0,3]);
        set(gca,'fontsize',24,'YTick',[0,1.5,3]); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',24,'fontname','Helvetica');
    ylabel(['SCFA Amount' ' ' '[mmol]'],'fontsize',24,'fontname','Helvetica');
    title('SCFA production by Lactulose','fontsize',24,'FontWeight','normal','FontAngle','normal');

    set(gcf,'position',[300 500 700 420])

export_fig Validation6_SCFA_production.pdf -q101


final_index=plt_index(length(plt_index));
SCFA_final_Lactitol=SCFA_tt(final_index,:);
final_Ratio=SCFA_final_Lactitol./sum(SCFA_final_Lactitol);
title_SCFA={'Acetate' 'Propionate' 'Butyrate'};
output=cell2table(num2cell(final_Ratio),'VariableNames',title_SCFA);
output.Carbs='Lactitol';
output = output(:,[end 1:end-1]);

writetable(output,'Lactitol_SCFA.csv');
% plots=get(gca, 'Children');
%  legend(plots(2, 1), {'Second line', 'First line'});

