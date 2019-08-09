function [Tmodel, Ymodel, Time, Data, rg]=common_pure_simulation(species_info,spc_id)

 
spc=species_info;
name=spc.id; 
 if ismember('expdata',fields(spc))
      Expdata=spc.expdata;
 else 
     disp('no available experimental data for this species!');
     x_ini=spc.x_ini;
     Time=spc.Time;
 end
 
 SxZ=spc.S;
 kmax=spc.kmax;
 K_MM=spc.KM;
 ke=spc.ke;
 alpha=spc.alpha;
 beta=spc.beta;
 ke=spc.ke;
 met_udf=spc.met_udf;
 e_rel=spc.e_rel;
 subs_cn=spc.subs_cn;
 biom_coef=spc.biom_coef;
 
 n_carbon=spc.n_carbon;  
 [cr,cl]=size(n_carbon); 
 if (cr>1)&&(cl>1)
%      disp('this species use more than one cl species');
 end
 biom_inx=strmatch('BIOM',met_udf);
 
 if ismember('expdata',fields(spc))
     Time=Expdata(:,1);    
     Data=Expdata(:,2:end);
     Data(any(isnan(Data)'),:) = [];  
     Time(find(isnan(Time)),:) = [];
     [rexp cexp]=size(Data);
     Biomass=Data(:,biom_inx);    
     Data(:,biom_inx)=Data(:,biom_inx).*biom_coef;
     Substrate=Data(:,subs_cn); 
     x_ini=Data(1,:);
 else
 end

[sr,sl]=size(SxZ);
n_ezm=sl;
kl=length(kmax);
KM=[];
for i=1:length(subs_cn)
    KM(:,i)=K_MM(i).*ones(kl,1);  
end
alpha=alpha.*ones(kl,1);   
beta=beta.*ones(kl,1);
ke=ke.*ones(kl,1); 
e_rel=e_rel.*ones(kl,1); 

Y_BM=SxZ(1,:)';
Y_SUB=SxZ(subs_cn,:)';     
maxmue=kmax.*Y_BM;
maxEnzyme=(ke+alpha)./(beta+maxmue); 
e0=e_rel.*maxEnzyme;      
para=kmax;
options_ode = odeset('maxstep',0.001);
Y0=[x_ini e0'];
Tspan=0:0.02:24;
[T,Y]=ode15s(@diff,Tspan,Y0,options_ode,para,spc);

u=[];v=[];rg=[];
    for i=1:length(T)
       [ui,vi,rgi]=calcu_uv(Y(i,:),spc);
       u=[u;ui'];
       v=[v;vi'];
       rg=[rg;rgi'];
    end
Tmodel=T;
Ymodel=Y(:,1:length(x_ini));  
[ys,yl]=size(Ymodel);

if yl==cexp
    bmflag=1;  
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

biom_flag=1;

co = [0,0,1;...
    0,0.5,0;...
    1,0,0;...
    0.25,0.5,0.75;...
    0.75,0,0.75;...
    0.75,0.75,0;...
    0.25,0.25,0.25;...
    1,1,0;...
    1,0,1;...
    0,1,1;...
    0.32,0.19,0.19;
    0,0,0];


    
function dy=diff(t,y,para,spc) 
% global kmax KM Y_BM Y_SUB x_ini
% global ke alpha beta 
% global maxEnzyme
% global SxZ subs_cn n_ezm kl n_carbon biom_inx met_udf

name=spc.id; 
 if ismember('expdata',fields(spc))
      Expdata=spc.expdata;
 else 
     disp('no available experimental data for this species!');
     x_ini=spc.x_ini;
     Time=spc.Time;
 end
 
 SxZ=spc.S;
 kmax=spc.kmax;
 K_MM=spc.KM;
 ke=spc.ke;
 alpha=spc.alpha;
 beta=spc.beta;
 ke=spc.ke;
 met_udf=spc.met_udf;
 e_rel=spc.e_rel;
 subs_cn=spc.subs_cn;
 biom_coef=spc.biom_coef;
 biom_inx=strmatch('BIOM',met_udf);

  
 if ismember('expdata',fields(spc))
     Time=Expdata(:,1);   
     Data=Expdata(:,2:end);
     Data(any(isnan(Data)'),:) = [];  
     Time(find(isnan(Time)),:) = [];
     [rexp cexp]=size(Data);
     Biomass=Data(:,biom_inx);    
     Data(:,biom_inx)=Data(:,biom_inx).*biom_coef;
     Substrate=Data(:,subs_cn); 
     x_ini=Data(1,:);
 else
 end
 
 n_carbon=spc.n_carbon;  
 [cr,cl]=size(n_carbon); 
 biom_inx=strmatch('BIOM',met_udf);
[sr,sl]=size(SxZ);
n_ezm=sl;
kl=length(kmax);
KM=[];
for i=1:length(subs_cn)
    KM(:,i)=K_MM(i).*ones(kl,1);  
end
alpha=alpha.*ones(kl,1);   
beta=beta.*ones(kl,1);
ke=ke.*ones(kl,1); 
e_rel=e_rel.*ones(kl,1); 

Y_BM=SxZ(1,:)';
Y_SUB=SxZ(subs_cn,:)';     
maxmue=kmax.*Y_BM;
maxEnzyme=(ke+alpha)./(beta+maxmue); 
e0=e_rel.*maxEnzyme;      

for i=1:length(y)
    if y(i)<0
        y(i)=eps;
    end
end

BIOM=y(biom_inx);
sub=y(subs_cn);
for i=1:length(sub)   
    S(:,i)=sub(i).*ones(kl,1);  
end
e=y(length(x_ini)+1:end); 
e_rel=e./maxEnzyme;
es=size(e);
rkin=kmax;
re=ke;
for i=1:length(sub)  
    rkin=rkin.* S(:,i) ./(KM(:,i) + S(:,i));   
    re=re.*S(:,i) ./(KM(:,i) + S(:,i));
end
    
    r=rkin.*e_rel;
    rc=n_carbon;
    rc=-rc.*Y_SUB;
    rc=sum(rc,2);
    r_c=r.*rc;
    roi=e_rel.*rkin;
            roi=rc.*roi;

    roi=max(roi,zeros(kl,1));
    pu=max(roi,zeros(kl,1)); pv=max(roi,zeros(kl,1));
    sumpu=sum(pu); maxpv=max(pv);
    if sumpu>0, u=pu/sumpu; else u=zeros(kl,1); end
    if maxpv>0, v=pv/maxpv; else v=zeros(kl,1); end
    rM=v.*e_rel.*rkin;
    rg=sum(Y_BM.*v.*r);
    diagV=diag(v);
    dxdt=SxZ*diagV*r*BIOM;
    dy=zeros(length(y),1);
    dy(1:length(x_ini))=dxdt(1:length(x_ini));
    dy(length(x_ini)+1:end)=alpha+re.*u-(beta+rg).*e;

function [u,v,rg]=calcu_uv(y,spc)
% global lxini spc 
% global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx met_udf  n_carbon
% global Y_BM Y_SUB maxEnzyme kl met_udf

name=spc.id; 
 if ismember('expdata',fields(spc))
      Expdata=spc.expdata;
 else 
     disp('no available experimental data for this species!');
     x_ini=spc.x_ini;
     Time=spc.Time;
 end
 
 SxZ=spc.S;
 kmax=spc.kmax;
 K_MM=spc.KM;
 ke=spc.ke;
 alpha=spc.alpha;
 beta=spc.beta;
 ke=spc.ke;
 met_udf=spc.met_udf;
 e_rel=spc.e_rel;
 subs_cn=spc.subs_cn;
 biom_coef=spc.biom_coef;
 biom_inx=strmatch('BIOM',met_udf);

  
 if ismember('expdata',fields(spc))
     Time=Expdata(:,1);    
     Data=Expdata(:,2:end);
     Data(any(isnan(Data)'),:) = [];  
     Time(find(isnan(Time)),:) = [];
     [rexp cexp]=size(Data);
     Biomass=Data(:,biom_inx);    
     Data(:,biom_inx)=Data(:,biom_inx).*biom_coef;
     Substrate=Data(:,subs_cn); 
     x_ini=Data(1,:);
 else
 end
 
 n_carbon=spc.n_carbon;  
 [cr,cl]=size(n_carbon);
 biom_inx=strmatch('BIOM',met_udf);
[sr,sl]=size(SxZ);
n_ezm=sl;
kl=length(kmax);
%%%%% create KM matrix %%%%%
KM=[];
for i=1:length(subs_cn)
    KM(:,i)=K_MM(i).*ones(kl,1);  
end
alpha=alpha.*ones(kl,1);   
beta=beta.*ones(kl,1);
ke=ke.*ones(kl,1); 
e_rel=e_rel.*ones(kl,1); 

Y_BM=SxZ(1,:)';
Y_SUB=SxZ(subs_cn,:)';     
maxmue=kmax.*Y_BM;
maxEnzyme=(ke+alpha)./(beta+maxmue); 
e0=e_rel.*maxEnzyme;  

if nargin<3
    ns=1;
end
n=ns;
y=y';
    for j=1:length(subs_cn)
       sub_inx(j)=strmatch(met_udf(subs_cn(j)),met_udf);
    end
       substrate=y(sub_inx);
lx=length(met_udf);

    et=y(lx+1:lx+length(kmax));


    if length(subs_cn>1)
        [rkm,ckm]=size(KM);
        if ckm==1
            for j=1:length(subs_cn)
                KM(:,j)=KM(:,1);
            end
        end
    end
for i=1:length(substrate)  
    S(:,i)=substrate(i).*ones(kl,1);  
end
e=et; 
e_rel=e./maxEnzyme;
es=size(e);
rkin=kmax;
re=ke;
for i=1:length(substrate)  
    rkin=rkin.* S(:,i) ./(KM(:,i) + S(:,i));
    re=re.*S(:,i) ./(KM(:,i) + S(:,i));
end
    
    r=rkin.*e_rel;
    rc=n_carbon;
    rc=-rc.*Y_SUB;
    rc=sum(rc,2);
    r_c=r.*rc;
    roi=e_rel.*rkin;
            roi=rc.*roi;

    roi=max(roi,zeros(kl,1));
    pu=max(roi,zeros(kl,1)); pv=max(roi,zeros(kl,1));
    sumpu=sum(pu); maxpv=max(pv);
    if sumpu>0, u=pu/sumpu; else u=zeros(kl,1); end
    if maxpv>0, v=pv/maxpv; else v=zeros(kl,1); end
    rg=sum(Y_BM.*v.*r);



function K=set_K(nz,x_ode,x_kin_all,K_all,nx_kin_all)
nx=length(x_ode);
K=zeros(nz,nx);

nx_kin_sum=zeros(nz,1);
sum=0; 
for i=2:nz
    sum=sum+nx_kin_all(i-1);
    nx_kin_sum(i)=sum;
end

for i=1:nz
    
	x_kin=x_kin_all(nx_kin_sum(i)+1:nx_kin_sum(i)+nx_kin_all(i));

    nx_kin=length(x_kin);
    for j=1:nx_kin
        ix_kin(j)=strmatch(x_kin(j),x_ode,'exact');
        K(i,ix_kin(j))=K_all(nx_kin_sum(i)+j);
    end
end

