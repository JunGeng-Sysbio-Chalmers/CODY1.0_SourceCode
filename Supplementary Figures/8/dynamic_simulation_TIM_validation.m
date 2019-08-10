function [Tmodel,Y,Ymodel,Ymodel_met,met_udf_co]=dynamic_simulation_TIM_validation(community,n_spc,num_rct,FSG,Feed,flow_back,V,ini_stat,time,length_each_tank,km_lumen,Pn_mucosa,km_water,density,Met_Mass,hmo_para,vld,uv)

global lxini spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx met_udf met_udf_co n_carbon met_udf_co_new
global Y_BM Y_SUB maxEnzyme kl rct obsv V_obsv t_obsv F5 length_additional kd C_Kd GLU_in GLU_obsv HMO_obsv
global lg_8tank  f_back   n_rct  km   km_w   Pn   rho mol_mass
global flag_meal1 flag_meal2 flag_meal3 flag_fece 
global HMO_in spc_hyd kmax_hmo KM_hmo Y_hmo HMO_const F5_obsv outflow out_time t_open V5_open

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
HMO_const=FSG;



 

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

tspan=[0;72;0.005];
outflow=[];  
out_time=[];
t_open=[];V5_open=[];
[T Y]=my_runge_kutta4_TIM(@qssm_comm_TIM_validation,y0,tspan,FSG,Feed,V);  




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

set(0,'defaultfigurecolor',[1 1 1])

pred_set='Validation1';
Vad1_lumen=figure(1);
for k=1:4
    plot(Tmodel,Ymodel_met{k},'color',tank{k}./255,'linewidth',4);
%     ylim();
    hold on
end
hold off

        bms=legend(lumen_legend,'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
        set(bms,'Box','off','Location','NorthEast')
   
    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); 
    ylabel(['Hexose ' '[mM]'],'fontsize',21,'fontname','Helvetica');
    set(gcf,'position',[120 120 700 300]);
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 4 2];
%         print(gcf, '-dtiff',[pred_set '_lumen_mets.tiff'],'-r300');
%         print('-dtiff',[pred_set '_lumen_mets'],'-r300');
%        print -dtiff -r600 [pred_set 'lumen_mets.tiff']
% saveas(gcf, 'test.png');
% export_fig 'Validation1_lumen_mets.tiff'
export_fig Validation1_lumen_mets.pdf -q101
% print -dpdf Validation1_lumen_mets.pdf


Vad1_mucosa=figure(2);

for k=5:8
    plot(Tmodel,Ymodel_met{k},'color',tank{k}./255,'linewidth',4);
    ylim();
    hold on
end
hold off
%         title(['Mucus Response'],'fontsize',16,'fontname','Helvetica');
        bms=legend(Mucus_legend,'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
        set(bms,'Box','off','Location','NorthEast')
   
    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica');
    ylabel(['Hexose ' '[mM]'],'fontsize',21,'fontname','Helvetica');
    set(gcf,'position',[120 250 700 300])
% export_fig 'Validation1_mucus_mets.tiff'
export_fig Validation1_mucus_mets.pdf -q101


k=9;
V_rectum=figure(3);

    subplot(2,1,1)  

       plot(Tmodel,Ymodel_mass_rctm,'color',color{3},'linewidth',2);
%         title(['Feces'],'fontsize',10,'fontname','Helvetica');
%         bms=legend(met_udf_co(1:n_s),'linewidth',1.5,'fontsize',7);
%         set(bms,'Box','off')
   
    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
            set(gca,'YTick',[0 0.03]);

%     xlabel('Time [h]','fontsize',16,'fontname','helvetica'); 
%     ylabel(['Fecal Mets' '[mmol]'],'fontsize',22,'fontname','helvetica');
    ylabel(['Mets[mmol]'],'fontsize',21,'fontname','helvetica');

    ylim([0,0.03])
%     subplot(3,2,4)   
    subplot(2,1,2)   
 
    plot(Tmodel,V5_rctm,'k-','linewidth',2);
        set(gca,'fontsize',21); set(gca,'linewidth',1.5,'YTick',[0 0.1]);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);

%     title('Feces Volume [L]','fontsize',22,'fontname','Helvetica'); 
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); 
%     ylabel(['Volume' '[L]'],'fontsize',22,'fontname','Helvetica');
    ylabel(['Volume [L]'],'fontsize',21,'fontname','Helvetica');

    set(gcf,'position',[300 120 700 300])
        ylim([0,0.1])

    export_fig 'Validation1_feces_mets.tiff'

    
k=10;
V_BLD=figure(4)    
%     subplot(2,2,4)  
    for i=1:length(met_udf_co)
       plot(Tmodel,Ymodel{k}(:,i),'color',color{7},'linewidth',3);
       hold on
    end
   set(gcf,'position',[300 250 700 300])
   

    set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica'); 
    ylabel(['Blood Metabolites' '[mM]'],'fontsize',21,'fontname','Helvetica');
    hold off
export_fig 'Validation1_Blood_mets.tiff'


V_BLD=figure(5)    
    
    inflow=0.004*ones(length(Tmodel),1);
%     In_and_out_flow=figure(5)
        plot(Tmodel,inflow,'color',color{6},'linewidth',2);

    hold on
        plot(out_time,outflow,'color',color{5},'linewidth',2);

    hold off
    mts=legend({'Feeding rate' 'Outflow rate'},'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
       set(mts,'Box','off','Location','NorthEast')
    ylim([0,0.006]);
      set(gca,'fontsize',21); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);
    xlabel('Time [h]','fontsize',21,'fontname','Helvetica');
    ylabel(['Flow Rate' '[L/h]'],'fontsize',21,'fontname','Helvetica');
  
    set(gcf,'position',[300 500 700 300])

export_fig 'Validation1_Inflow_Outflow.tiff'



Feeding=figure(6)
HMO_feeding=[];
a=0;
for i=1:length(Tmodel)
    
      if (mod(Tmodel(i),72)-0-0.01)>=0&&(mod(Tmodel(i),72)-0.1-0.01)<=0
            a=FSG;
%         elseif (mod(t,72)-10-0.01)>=0&&(mod(t,72)-10.1-0.01)<=0
%             HMO_in=HMO_const;
%         elseif (mod(t,72)-20-0.01)>=0&&(mod(t,72)-20.1-0.01)<=0
%             HMO_in=HMO_const;
        else
            a=0;
      end
        HMO_feeding=[HMO_feeding;a];
end
   plot(Tmodel,HMO_feeding/1000*180,'color',color{2},'linewidth',3);

    
    mts=legend({'Feeding hexose'},'linewidth',1.5,'fontsize',19,'fontname','Helvetica');
       set(mts,'Box','off','Location','NorthEast')
    ylim([0,30]);
        set(gca,'fontsize',21,'YTick',[0,15,30]); set(gca,'linewidth',1.5);
    set(findobj(get(gca,'Children'),'LineWidth',1.5),'LineWidth',2);

    xlabel('Time [h]','fontsize',21,'fontname','Helvetica');
    ylabel(['Feeding hexose' '[g/L]'],'fontsize',21,'fontname','Helvetica');
    set(gcf,'position',[300 500 700 300])

export_fig Validation1_Feeding_hexose.pdf -q101

