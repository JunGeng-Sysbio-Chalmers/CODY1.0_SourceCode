function [Tmodel Ymodel]=common_com_sim_nouv(community,n_spc,SPC_EM,x_ini0)
global lxini spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx met_udf met_udf_co n_carbon
global Y_BM Y_SUB maxEnzyme kl
n_s=n_spc;
kl={};
kmax={};
KM={};
ke={};
alpha={};
beta={};
subs_cn={};
biom_coef={};
n_carbon={};
e_rel={};
met_udf={};
biom_inx={};
Y_BM={};
Y_SUB={};
maxEnzyme={};
spc={};
 for s=1:n_s
     spc{s}=community{s};
     if ismember('expdata',fields(spc{s}))
         Expdata{s}=spc{s}.expdata;
     else 
         disp('no available experimental data for "''i"th species!');
         x_ini{s}=spc{s}.x_ini;
         Time{s}=spc{s}.Time;
     end
     name{s}=spc{s}.id;
     SxZ{s}=spc{s}.S;
     kmax{s}=spc{s}.kmax;
     
         
     
     K_MM{s}=spc{s}.KM;
     ke{s}=spc{s}.ke;
     alpha{s}=spc{s}.alpha;
     beta{s}=spc{s}.beta;
     ke{s}=spc{s}.ke;
     met_udf{s}=spc{s}.met_udf;
     e_rel{s}=spc{s}.e_rel;
     subs_cn{s}=spc{s}.subs_cn;
     biom_coef{s}=spc{s}.biom_coef;
     n_carbon{s}=spc{s}.n_carbon;  %%
     [cr,cl]=size(n_carbon{s}); %%
     if (cr>1)&&(cl>1)
        disp('this species use more than one cl species');
     end
     biom_inx{s}=strmatch('BIOM',met_udf{s});
 
    if ismember('expdata',fields(spc{s}))
        Time{s}=Expdata{s}(:,1);    %% 
        Data{s}=Expdata{s}(:,2:end);
        [rexp cexp]=size(Data{s});
        Biomass{s}=Data{s}(:,biom_inx{s});    
        Data{s}(:,biom_inx{s})=Data{s}(:,biom_inx{s}).*biom_coef{s};
        Substrate{s}=Data{s}(:,subs_cn{s}); %%
        temp_ini=Data{s}(1,:);
        x_ini{s}=temp_ini';
    else
    end
    Tspan{s}=Time{s};
    [sr,sl]=size(SxZ{s});
    n_ezm=sl;

for i=1:size(SPC_EM,2)
    if i==1
        stat_inx=1;
        end_inx=SPC_EM(s,i);
    else
        stat_inx=end_inx+1;
        end_inx=end_inx+SPC_EM(s,i-1);
    end
    kl{s}(i)=SPC_EM(s,i);
end

    Y_BM{s}=SxZ{s}(1,:)';
    Y_SUB{s}=SxZ{s}(subs_cn{s},:)';     
    maxmue{s}=kmax{s}.*Y_BM{s};
    maxEnzyme{s}=(ke{s}+alpha{s})./(beta{s}+maxmue{s}); 
    e0{s}=e_rel{s}.*maxEnzyme{s};     
    para{s}=kmax{s};
    options_ode=[];
 end
  KM=K_MM;
for s=1:n_s
    met_udf{s}{1}=[met_udf{s}{1} '_' name{s}];
end

met_udf_co={};
bm_co={};
for s=1:n_s
        met_udf_co=union(met_udf_co,met_udf{s},'stable');
        bm_co=union(bm_co,met_udf{s}(1),'stable');
end
clear_index=[];
for i=1:length(met_udf_co)   
    if ~isempty(strmatch('BIOMASS',met_udf_co{i}))
        clear_index=[clear_index;i];
    end
end
met_udf_co(clear_index)=[]; %%%%%
met_udf_co=union(bm_co,met_udf_co,'stable'); %%


cm_met={};
for i=1:n_s
    for j=1:length(met_udf_co)
        temp=strmatch(met_udf_co{j},met_udf{i},'exact');
        if (isempty(temp))   
            cm_met{i}{j}=1;   
        end
    end                   
end
row_index={};
for i=1:n_s
    temp=[];
    for j=1:length(cm_met{i})
        if find(cm_met{i}{j})            
            temp=[temp;j];  %%%%%
        end
    end
    row_index{i}=temp;  %%% 
end
SxZ_tot={};
for i=1:n_s    
    temp_S=SxZ{i};
    temp_xini=x_ini{i};
    for j=1:length(row_index{i})  
        [rlos,clos]=size(temp_S);
        if row_index{i}(j)<=rlos    %%
%             for jj=j:rlos          %%%%%%%
                ij=row_index{i}(j);  %%%%%%%%%
                temp_S=[temp_S(1:ij-1,:);zeros(1,length(temp_S(1,:)));temp_S(ij:end,:)];   %%%
                temp_xini=[temp_xini(1:ij-1);0;temp_xini(ij:end)];
        elseif row_index{i}(j)>rlos
            ij=row_index{i}(j);  %%%%%%%
            temp_S=[temp_S(1:ij-1,:);zeros(1,length(temp_S(1,:)))];
            temp_xini=[temp_xini(1:ij-1);0];
        end
    end
    SxZ_tot{i}=temp_S;
    x_ini{i}=temp_xini; %%%
end

x_ini_co=zeros(length(x_ini{1}),1);
for s=1:n_s
    x_ini_co=x_ini_co+x_ini{s}; %%
end
x_ini_co=x_ini0;
lxini=length(x_ini_co);
e_ini=[];
for s=1:n_s
    e_ini=[e_ini;e0{s}];
end

y0=[x_ini_co; e_ini];

time=[];
for s=1:n_s
    time(s)=Time{s}(end);
end

tspan=[0:0.01:30];
options_ode=[];
[T Y]=ode15s(@qssm,tspan,y0,options_ode,kmax,n_s);
ut={};  
vt={};  

Tmodel=T;
Ymodel=Y(:,1:length(x_ini_co));


for ij=1:2
    Ymodel(:,ij)=Ymodel(:,ij)./biom_coef{ij};
end
%%

[ys,yl]=size(Ymodel);
if yl==cexp
    bmflag=1;  %%%%% plot biom
else
    bmflag=0;
end

for p=1:ys
    for q=1:yl
        if Ymodel(p,q)<0
            Ymodel(p,q)=0;
        end
    end
end

leglbl_bm=[];
for i=1:n_s
   switch i
    case 1
        line{i}='k-';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 2
        line{i}='k--';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 3
        line{i}='r-';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 4
        line{i}='r--';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 5
        line{i}='b-';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 6
        line{i}='b--';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 7
        line{i}='g-';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 8
        line{i}='g--';
%         leglbl_bm=[leglbl_bm;met_udf_co{i}];
    case 9
        line{i}='m-';
    case 10
        line{i}='m--.';
    end
end
    

leglbl_prd=[];
for i=n_s+1:length(met_udf_co)
   switch i-n_s
    case 1
        color{i-n_s}=[0.15  0  0];
%         color{i-n_s}=[0.905  0.192  0.199];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 2
%         color{i-n_s}=[0.5  0.5  0.5];
        color{i-n_s}=[1.0  0.548  0.1];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 3
%         color{i-n_s}=[1  0.8  0];
        color{i-n_s}=[0.972  0.555  0.774];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 4
        color{i-n_s}=[1  0  1];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 5
        color{i-n_s}=[0.8  0.8  0.8];
        color{i-n_s}=[0.865 0.811 0.433];

%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 6
%         color{i-n_s}=[0.3  0.3  0.6];
        color{i-n_s}=[0.294  0.545  0.749];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 7
%         color{i-n_s}=[0.1  0.8  0.3];
        color{i-n_s}=[0.372  0.718  0.361];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 8
        color{i-n_s}=[0.2  0.8  0.2];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 9
        color{i-n_s}=[0.5  1  0.5];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    case 10
        color{i-n_s}=[1   1  0.2];
%         leglbl_prd=[leglbl_prd;met_udf_co{i}];
    end
end


    
end
 
function dy=qssm(t,y,para,ns)
global lxini spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx  met_udf met_udf_co n_carbon
global Y_BM Y_SUB maxEnzyme kl


for i=1:length(y)
    if y(i)<0,y(i)=eps;end
end

Sub=[];
for i=1:ns
    for j=1:length(subs_cn{i})
       sub_inx(j)=strmatch(met_udf{i}(subs_cn{i}(j)),met_udf_co);%% strmatch cannot identify two strings at one time
    end
       Sub_tt=y(sub_inx);
       for j=1:length(Sub_tt)   %%% number of substrate
          S{j}=Sub_tt(j).*ones(kl{i}(j),1);  
          Sub=[Sub;S{j}];
       end
       substrate{i}=Sub;
       sub_inx=[];
       Sub=[];
end

lx=length(met_udf_co);
for i=1:ns
    e{i}=y(lx+1:lx+length(kmax{i}));
    lx=lx+length(kmax{i});
end


u_co={};
v_co={};
rg_co={};
dxdt={};
re_co={};
for s=1:ns
    e_rel=e{s}./maxEnzyme{s};
    rkin=kmax{s};
    re_s=ke{s};
    sub=substrate{s};
    KS=KM{s};
    BIOM=y(s); 
    SxZ=SxZ_tot{s};
    klz=length(kmax{s});
S=[];

    S=sub;
 
        rkin=rkin.* S ./(KS + S);  
        re_s=re_s.*S ./(KS + S);
    r=rkin.*e_rel;
    rc=n_carbon{s};
     for i=1:length(kl{s})
        rc(:,i)=-Y_SUB{s}(:,i).*n_carbon{s};
    end
    rc=sum(rc,2);  
    r_c=r.*rc;
    roi=e_rel.*rkin;
            roi=rc.*roi;

    roi=max(roi,zeros(klz,1));
    pu=max(roi,zeros(klz,1)); pv=max(roi,zeros(klz,1));
    sumpu=sum(pu); maxpv=max(pv);
    if sumpu>0, u=pu/sumpu; else u=zeros(klz,1); end
    if maxpv>0, v=pv/maxpv; else v=zeros(klz,1); end
    u_co{s}=u;
    v_co{s}=v;
    rM=v.*e_rel.*rkin;
    rg_co{s}=sum(Y_BM{s}.*v.*r);
    re_co{s}=re_s;
    diagV=diag(v);
    dxdt{s}=SxZ*diagV*r*BIOM;
end
    dy=zeros(length(y),1);
    lx=length(met_udf_co);
    for s=1:ns        
        dy(1:lx)=dy(1:lx)+dxdt{s}(1:lx);
    end

    for s=1:ns        
        dy(lx+1:lx+length(kmax{s}))=alpha{s}+re_co{s}.*u_co{s}-(beta{s}+rg_co{s}).*e{s};
        lx=lx+length(kmax{s});
    end
 
end
%     
function [u,v]=plot_uv(ns,y)
global lxini spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx met_udf met_udf_co n_carbon
global Y_BM Y_SUB maxEnzyme kl

n=ns;
y=y';
    for j=1:length(subs_cn{n})
       sub_inx(j)=strmatch(met_udf{n}(subs_cn{n}(j)),met_udf_co);
    end
       substrate=y(sub_inx);
lx=length(met_udf_co);
for i=1:ns
    et{i}=y(lx+1:lx+length(kmax{i}));
    lx=lx+length(kmax{i});
end

    if length(subs_cn{n}>1)
        [rkm,ckm]=size(KM{n});
        if ckm==1
            for j=1:length(subs_cn{n})
                KM{n}(:,j)=KM{n}(:,1);
            end
        end
    end
for i=1:length(substrate)  
    S(:,i)=substrate(i).*ones(kl{n},1);  
end
e=et{n}; 
e_rel=e./maxEnzyme{n};
es=size(e);
rkin=kmax{n};
re=ke{n};
for i=1:length(substrate)  
    rkin=rkin.* S(:,i) ./(KM{n}(:,i) + S(:,i)); 
    re=re.*S(:,i) ./(KM{n}(:,i) + S(:,i));
end
    
    r=rkin.*e_rel;
    rc=n_carbon{n};
    rc=-rc.*Y_SUB{n};
    rc=sum(rc,2);
    r_c=r.*rc;
    roi=e_rel.*rkin;
            roi=rc.*roi;

    roi=max(roi,zeros(kl{n},1));
    pu=max(roi,zeros(kl{n},1)); pv=max(roi,zeros(kl{n},1));
    sumpu=sum(pu); maxpv=max(pv);
    if sumpu>0, u=pu/sumpu; else u=zeros(kl{n},1); end
    if maxpv>0, v=pv/maxpv; else v=zeros(kl{n},1); end


end
function old 
global maxEnzyme_bth maxEnzyme_bif ke_bth ke_bif kl1 kl2 kl KM_bth KM_bif KM_eha Y_BM_bth Y_BM_bif
global maxmue_bif maxmue_bth maxmue_eha
global kmax_bth kmax_bif kmax_eha
global SxZ_bth SxZ_bif  SxZ_tot
global alpha_bth beta_bth alpha_bif beta_bif alpha_eha beta_eha
%%%%%%%%%%%%%%%%%%%%%%%%
species={'bth';'bif';'eha'};
M_FRU=180.16;
M_SUCC=118.09;
M_AC=59.04;
alpha=0.004;   
beta=0.05;
ke=1;
e_rel=0.2;
KM=10;
KM_Bif=10;
KM_Eha=30;
kmax_bth=[1.0444
   14.6232
   12.8317
   11.6884];
kl1=length(kmax_bth);
KM_bth=KM.*ones(kl1,1);  
alpha_bth=alpha.*ones(kl1,1);  
beta_bth=beta.*ones(kl1,1);
ke_bth=ones(kl1,1); 
e_rel_bth=e_rel.*ones(kl1,1);


kmax_bif=[0.7530
   43.9466
   45.0031
    0.1010
   38.9481
  587.0111
  807.2576];
kmax_eha=1.0e+03 *[

    0.0002
    0.0974
    0.0000
    0.0017
    0.1172
    0.5734
    0.0000
    1.9351];
kmax=[kmax_bth
    kmax_bif
    kmax_eha];
kl2=length(kmax_bif);
KM_bif=KM.*ones(kl2,1);  
alpha_bif=alpha.*ones(kl2,1);  
beta_bif=beta.*ones(kl2,1);
ke_bif=ones(kl2,1); 
e_rel_bif=e_rel.*ones(kl2,1);
e_rel_bif=0.1.*ones(kl2,1);

kl3=length(kmax_eha);
KM_eha=KM_Eha.*ones(kl3,1);  
alpha_eha=alpha.*ones(kl3,1);  
beta_eha=beta.*ones(kl3,1);
ke_eha=ones(kl3,1); 
e_rel_eha=e_rel.*ones(kl3,1);
EMs=importdata('EMforBth_fructose.txt'); 
exmetname_bth=EMs.textdata;
Smatrix_bth=EMs.data;
exmetname=char(exmetname_bth);
met_udf_bth={'BIOMASS_BTH' 'FRUCTOSE' 'SUCCINATE' 'ACETATE'};

SxZ_bth=Smatrix_bth([10 12 7 4],:); 
                             
Y_BM_bth=SxZ_bth(1,:)';  

[Tspan,ExpValue]=readdata('Fig1a_aftertreat1_BM.txt');  
Yexp_bth=ExpValue;
Texp_bth=Tspan;
[rexp cexp]=size(ExpValue);
Exp_BIOM_org=ExpValue(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Exp_BIOM=Exp_BIOM_org;
Exp_BIOM(2:end)=Exp_BIOM_org(2:end).*0.27;
Exp_BIOM_bth=Exp_BIOM;
Exp_Fru_bth=ExpValue(:,1);
Exp_Succ_bth=ExpValue(:,3);
Exp_AC_bth=ExpValue(:,4);
x_ini_bth=[Exp_BIOM_bth(1) 0 0 Exp_Fru_bth(1) Exp_Succ_bth(1) Exp_AC_bth(1) 0 0 0 0]';

Yexp_bth=[Exp_BIOM_bth Exp_Fru_bth Exp_Succ_bth Exp_AC_bth];
maxmue_bth=kmax_bth.*Y_BM_bth;
maxEnzyme_bth=(ke_bth+alpha_bth)./(beta_bth+maxmue_bth); 
e_bth=e_rel_bth.*maxEnzyme_bth;      

Smatrix_bif=[0         0         0         0         0         0         0         0         0         0
         0         0         0         0         0         0         0         0         0         0
    2.0000    1.6667    1.5091    1.1881         0         0    0.6609    1.0000         0         0
         0         0         0         0         0         0    0.6563    1.0000    2.1324    3.0000
    2.0000    0.6667    1.4934    0.4074   -0.0592         0   -0.0787         0   -0.0668         0
         0         0         0         0    1.4876    2.0000         0         0         0         0
         0         0         0         0         0         0         0         0         0         0
         0         0   -0.4103   -0.4660   -0.4162         0   -0.5534         0   -0.4698         0
         0    2.0000         0    1.5257    0.0865         0    1.4368    2.0000    0.0977         0
         0         0    0.0365    0.0414    0.0370         0    0.0492         0    0.0418         0
         0         0         0         0         0         0         0         0         0         0
   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000   -1.0000];

exmetname=char(exmetname);
met_udf_bif={'BIOMASS_BIF' 'FRUCTOSE' 'ACETATE' 'LACTATE' 'FORMATE' 'ETHANOL'};
SxZ=Smatrix_bif([10 12 4 6 9 3],:);
                            
SxZ_bif=SxZ(:,[1 3 5:8 10]);
Y_BM_bif=SxZ_bif(1,:)';  

[Tspan,ExpValue]=readdata('Fig3a_mM_BM_aug20_1.txt'); 
Yexp_bif=ExpValue;
Texp_bif=Tspan;
ExpValue = ExpValue;
[rexp cexp]=size(ExpValue);
Exp_Time = Tspan;
Tspan=Exp_Time;
Texp=Exp_Time;
Exp_FRU_bif   = ExpValue(:,1);    
Exp_BIOM   = ExpValue(:,2).*0.42;
Exp_BIOM_bif=Exp_BIOM;
Exp_AC_bif   = ExpValue(:,3);
Exp_LAC_bif   = ExpValue(:,4);
Exp_FOR_bif   = ExpValue(:,5);
Exp_ETH_bif   = ExpValue(:,6);

x_ini_bif=[0 Exp_BIOM_bif(1) 0 Exp_FRU_bif(1) 0 Exp_AC_bif(1) Exp_LAC_bif(1) Exp_FOR_bif(1) Exp_ETH_bif(1) 0]';

Yexp_bif=[Exp_BIOM_bif Exp_FRU_bif Exp_AC_bif Exp_LAC_bif Exp_FOR_bif Exp_ETH_bif];


maxmue_bif=kmax_bif.*Y_BM_bif;
maxEnzyme_bif=(ke_bif+alpha_bif)./(beta_bif+maxmue_bif); 
e_bif=e_rel_bif.*maxEnzyme_bif;      

EMs=importdata('EM_Ehallii_withmet_0922.txt'); 
exmetname=EMs.textdata;
Smatrix_eha=EMs.data; 

exmetname=char(exmetname);
met_udf_eha={'BIOMASS_EHA' 'ACETATE' 'LACTATE' 'BUTYRATE'};

SxZ_eha=Smatrix_eha([9 3 5 11],:); 


Y_BM_eha=SxZ_eha(1,:)';

ExpData=importdata('rawdatacombine and computation_1.txt');  
ExpName = ExpData.textdata;
ExpValue = ExpData.data;
[rexp cexp]=size(ExpValue(:,2:end));

Exp_Time = ExpValue(:,1);
Tspan_eha=Exp_Time;
Texp_eha=Exp_Time;
Exp_BIOM_eha   = ExpValue(:,2).*0.35;
Exp_AC_eha   = ExpValue(:,4);
Exp_LAC_eha   = ExpValue(:,3);
Exp_BUT_eha   = ExpValue(:,5);  

x_ini_eha=[0 0 Exp_BIOM_eha(1) 0 0 Exp_AC_eha(1) Exp_LAC_eha(1) 0 0 Exp_BUT_eha(1)]';

Yexp_eha=[Exp_BIOM_eha Exp_AC_eha Exp_LAC_eha Exp_BUT_eha];
[mYexp nYexp]=size(Yexp_eha);

maxmue_eha=kmax_eha.*Y_BM_eha;
maxEnzyme_eha=(ke_eha+alpha_eha)./(beta_eha+maxmue_eha); 
e_rel_eha=0.2.*ones(kl3,1);
e_eha=e_rel_eha.*maxEnzyme_eha;

SxZ_tot={SxZ_bth SxZ_bif SxZ_eha};
met_udf_co=union(union(met_udf_bth,met_udf_bif,'stable'),met_udf_eha,'stable');
clear_index=[];
for i=1:length(met_udf_co)   
    if ~isempty(strmatch('BIOMASS',met_udf_co{i}))
        clear_index=[clear_index;i];
    end
end
met_udf_co(clear_index)=[];
met_udf{1}=met_udf_bth;
met_udf{2}=met_udf_bif;
met_udf{3}=met_udf_eha;
cm_met={};
for i=1:length(species)
    for j=1:length(met_udf_co)
        temp=strmatch(met_udf_co{j},met_udf{i},'exact');
        if (isempty(temp))&&(isempty(strmatch('BIOMASS',met_udf_co{j})))   
           cm_met{i}{j}=1;   
        end
    end                   
end
row_index={};
for i=1:length(species)
    temp=[];
    for j=1:length(cm_met{i})
        if find(cm_met{i}{j})            
            temp=[temp;j+1];  
        end
    end
    row_index{i}=temp;  
end
for i=1:length(species)    
    temp_S=SxZ_tot{i};
    for j=1:length(row_index{i})  
        [rlos,clos]=size(temp_S);
        if row_index{i}(j)<=rlos    
%             for jj=j:rlos          
                ij=row_index{i}(j);  
                temp_S=[temp_S(1:ij-1,:);zeros(1,length(temp_S(1,:)));temp_S(ij:end,:)];   
        elseif row_index{i}(j)>rlos
            ij=row_index{i}(j); 
            temp_S=[temp_S(1:ij-1,:);zeros(1,length(temp_S(1,:)))];
        end
    end
    SxZ_tot{i}=temp_S;
end
x_ini_co=x_ini_bth+x_ini_bif+x_ini_eha;
kl=length(x_ini_co);
y0=[x_ini_co; e_bth; e_bif; e_eha];

tspan=[0 50];
% tspan=Texp_bif;
options_ode=[];
[T Y]=ode15s(@qssm,tspan,y0,options_ode,kmax);



end
function dy=old_qssm(t,y,para)

global alpha beta e_max ke K_S kl  KM_bth KM_bif KM_eha Y_BM_bth Y_BM_bif Y_BM_eha
global Y_BM SxZ 
global maxEnzyme_bth maxEnzyme_bif maxEnzyme_eha ke_bth ke_bif ke_eha kl1 kl2 kl3
global maxmue_bif maxmue_bth maxmue_eha
global kmax_bth kmax_bif kmax_eha
global SxZ_bth SxZ_bif SxZ_tot
global alpha_bth beta_bth alpha_bif beta_bif alpha_eha beta_eha

% i_strain=mysys.i_strain;
kmax1=para(1:kl1);
kmax2=para(kl1+1:kl1+kl2);
kmax3=para(kl1+kl2+1:end);
% K_S=para(5:8);   
% K_E=para(3);

for i=1:length(y)
    if y(i)<0,y(i)=eps;end
end

BIOM_bth=y(1);BIOM_bif=y(2);BIOM_eha=y(3);
Fru=y(4);    
Succ=y(5);
Ac=y(6);
Lac=y(7);
Formate=y(8);
Eth=y(9);
But=y(10);
e1=y(11:11+kl1-1);
e2=y(11+kl1:11+kl1+kl2-1);
e3=y(11+kl1+kl2:end);

[r1,c1]=size(SxZ_tot{1});
[r2,c2]=size(SxZ_tot{2});
[r3,c3]=size(SxZ_tot{3});

S1=Fru.*ones(c1,1);
S2=Fru.*ones(c2,1);

        e_rel1=e1./maxEnzyme_bth;     
        el1=size(e1);
        r1 = kmax1 .* S1 ./(KM_bth + S1) .* e_rel1; 
        rc1=6.*ones(c1,1);
        r_c1=r1.*rc1;
        if sum(r_c1)==0
            u1(1:el1)=0;
        else
            u1=r_c1./sum(r_c1);
        end
        
        if max(r_c1)==0
           v1(1:c1)=0;
        else
           v1=r_c1./max(r_c1);
        end
        
        e_rel2=e2./maxEnzyme_bif;
        el2=size(e2);
        r2 = kmax2 .* S2 ./(KM_bif + S2) .* e_rel2; 
        rc2=6.*ones(c2,1);
        r_c2=r2.*rc2;
        if sum(r_c2)==0
            u2(1:el2)=0;
        else
            u2=r_c2./sum(r_c2);
        end
        
        if max(r_c2)==0
           v2(1:c2)=0;
        else
           v2=r_c2./max(r_c2);
        end
        
        S3_lac=Lac.*ones(c3,1);
        S3_ac=Ac.*ones(c3,1);
        e_rel3=e3./maxEnzyme_eha;
        el3=size(e3);
        r3 = kmax3 .* S3_lac ./(KM_eha + S3_lac) .* S3_ac ./(KM_eha + S3_ac) .* e_rel3; 
        rc3=(-SxZ_tot{3}(4,:).*2-SxZ_tot{3}(5,:).*3 )'; 
        r_c3=r3.*rc3;
        if sum(r_c3)==0
            u2(1:el3)=0;
            u3=u3';
        else
            u3=r_c3./sum(r_c3);
        end
        
        if max(r_c3)==0
           v3(1:c3)=0;
           v3=v3';
        else
           v3=r_c3./max(r_c3);
        end
        
        re1=ke_bth.*S1./(KM_bth+S1);    
        rg1=sum(Y_BM_bth.*v1.*r1);
        
        diagV1=diag(v1);
        dxdt1=SxZ_tot{1}*diagV1*r1*BIOM_bth;    
        
        re2=ke_bif.*S2./(KM_bif+S2);    
        rg2=sum(Y_BM_bif.*v2.*r2);
        
        diagV2=diag(v2);
        dxdt2=SxZ_tot{2}*diagV2*r2*BIOM_bif; 
        
        re3=ke_eha.*S3_lac ./(KM_eha + S3_lac) .* S3_ac ./(KM_eha + S3_ac);    
        rg3=sum(Y_BM_eha.*v3.*r3);
        
        diagV3=diag(v3);
        dxdt3=SxZ_tot{3}*diagV3*r3*BIOM_eha;  
        
        dy=zeros(length(y),1);
        dy(1)=dxdt1(1);  
        dy(2)=dxdt2(1); 
        dy(3)=dxdt3(1); 
        dy(4:10)=dxdt1(2:8)+dxdt2(2:8)+dxdt3(2:8);
        dy(11:11+kl1-1)=alpha_bth+re1.*u1-(beta_bth+rg1).*e1;
        dy(11+kl1:11+kl1+kl2-1)=alpha_bif+re2.*u2-(beta_bif+rg2).*e2;
        dy(11+kl1+kl2:end)=alpha_eha+re3.*u3-(beta_eha+rg3).*e3;
end