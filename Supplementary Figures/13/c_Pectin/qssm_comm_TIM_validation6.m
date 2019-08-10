function dy=qssm_comm_TIM_validation(t,y,deltat,FS,FV,V_colon,hmo_in_y)
global  spc 
global SxZ_tot kmax KM ke alpha beta subs_cn biom_inx  met_udf met_udf_co n_carbon met_udf_co_new
global Y_BM Y_SUB maxEnzyme kl rct obsv V_obsv t_obsv    F5    kd  C_Kd   GLU_in     GLU_obsv   HMO_obsv
global lg_8tank  f_back   n_rct      km   km_w   Pn   rho  mol_mass
global HMO_in spc_hyd  kmax_hmo  KM_hmo  Y_hmo  HMO_const V5  outflow out_time t_open V5_open

out_time=[out_time;t];
ylg=lg_8tank; 
lx=length(met_udf_co);
HMO_inx=hmo_in_y;
hmo_ix=find(strcmp('HMO',met_udf_co));

         V5=y(ylg*9+1);  ????????????????????????????V5
%         if (mod(t,72)-0-0.01)>=0&&(mod(t,72)-2.5-0.01)<=0 %% 25g/L input
        if (mod(t,72)-0-0.001)>=0&&(mod(t,72)-0.1-0.001)<=0
            HMO_in=HMO_const;
%         elseif (mod(t,72)-15-0.01)>=0&&(mod(t,72)-17-0.01)<=0
%             HMO_in=HMO_const;
%         elseif (mod(t,72)-30-0.01)>=0&&(mod(t,72)-32-0.01)<=0
%             HMO_in=HMO_const;
        else
            HMO_in=0;
        end



HMO=y(HMO_inx);

rhyd=[];rhyd_hex_spc=[];
r_hyd_hmo={};r_hyd_hex={};
sub_mdf={};
substrate={};
for k=1:n_rct-1
    
    rhyd(:,k)=kmax_hmo.*HMO(k)./(KM_hmo+HMO(k)).*spc_hyd;    
    r_hyd_hmo{k}=rhyd(:,k);                            

    rhyd_hex_spc(:,k)=Y_hmo.*rhyd(:,k);                      
    r_hyd_hex{k}=rhyd_hex_spc(:,k);                          

end

k=10;  
    r_hyd_hmo{k}=0;
    r_hyd_hex{k}=0;
    
    
    FT0=FV(1);FL0=FV(2);FM0=FV(3);FB0=FV(4); %% three inflow rate 
    f1=f_back(1);f2=f_back(2);f3=f_back(3);f4=f_back(4);
    VL1=V_colon(1);VL2=V_colon(2);VL3=V_colon(3);VL4=V_colon(4);
    VM1=V_colon(5);VM2=V_colon(6);VM3=V_colon(7);VM4=V_colon(8);
    V_rtm=V_colon(9); V_BLD=V_colon(10);    
    rho=0.7*1000;    
    JLT={};
    JL_temp=0;
    Mass_temp=0;   
    for k=1:4
        for i=1:lx
            Mass_temp=Mass_temp+mol_mass(i).*(y(i+(k-1)*ylg));            
            JL_temp=JL_temp+km(i)*mol_mass(i).*(y(i+(k-1)*ylg)-y(i+(k-1+4)*ylg));   
        end
        JLT{k}=JL_temp; 
        WL{k}=rho-Mass_temp; 
        FL_water{k}=km_w{k}*(WL{k}-0.1*WL{k});   %

        Flow_L{k}=(JLT{k}+FL_water{k})*V_colon(k)/rho;   
        JL_temp=0;
        Mass_temp=0;
    end

    JMT={};
    JM_temp=[0];
    Mass_mucosa_temp=0;   
    icr_blood=9*ylg+1+lx;  
    for k=5:8
        for i=1:lx
            Mass_mucosa_temp=Mass_mucosa_temp+mol_mass(i).*(y(i+(k-1)*ylg));    
            JM_temp=JM_temp+Pn(i)*mol_mass(i)*(y(i+(k-1)*ylg)-y(i+icr_blood));
        end
        JMT{k-4}=JM_temp;
        WML{k-4}=rho-Mass_mucosa_temp;

          FM_water{k-4}=Flow_L{k-4}-JMT{k-4}*V_colon(k)/rho;


        Flow_M{k-4}=FM_water{k-4}+JMT{k-4}*V_colon(k)/rho;
        JM_temp=[0];
        Mass_mucosa_temp=0;

    end

    FL1=FL0+f2-Flow_L{1}-f1;
    FL2=FL1-Flow_L{2}+f3-f2;
    FL3=FL2-Flow_L{3}+f4-f3;
    FL4=FL3-Flow_L{4}-f4;
    FM1=FM0+Flow_L{1}-Flow_M{1};
    FM2=FM1+Flow_L{2}-Flow_M{2};
    FM3=FM2+Flow_L{3}-Flow_M{3};
    FM4=FM3+Flow_L{4}-Flow_M{4};
    FL=[FL0;FL1;FL2;FL3;FL4];FM=[FM0;FM1;FM2;FM3;FM4];
    FM(find(FM<0))=0;    

    outflow=[outflow;FL4];
    
 tc=24;   
 T=2/60;  

       if F5==0
            if (V5-V_colon(9))<=0
            else
                  F5=V5./T;
            end
            
       else
            if (V5-0.0001)<=0
                V5=0.0001;
                F5=0;
            end
       end


lx=length(met_udf_co);

for i=1:length(y)
    if y(i)<0,y(i)=eps;end
end
  
    dy=zeros(length(y),1);
    lx=length(met_udf_co);

k=1;    
     icr=(k-1).*ylg;
     icr_pre=(k-2).*ylg;
     icr_next=(k).*ylg; 
     icr_m=(k-1+4)*ylg;
     
    dy(hmo_ix+icr)=dy(hmo_ix+icr)+FL0/V_colon(k).*HMO_in-FL(k+1)/V_colon(k)*y(hmo_ix+icr)+f_back(k+1)/V_colon(k).*y(hmo_ix+icr_next)-km(hmo_ix)*(y(hmo_ix+icr)-y(hmo_ix+icr_m))-r_hyd_hmo{k};   %%????????????????????????????hmo??????????????????????????????hmo??????????????????g/L??????????????????????????????????????????????????????
     dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)-FL(k+1)/V_colon(k)*y(hmo_ix+1+icr:lx+icr)+f_back(k+1)/V_colon(k).*y(hmo_ix+1+icr_next:lx+icr_next)-km(2:end).*(y(hmo_ix+1+icr:lx+icr)-y(hmo_ix+1+icr_m:lx+icr_m))+r_hyd_hex{k};   %%????????????????????????????hexose????????????????????????????????????????????????????????????????????????????????????????????????????????????????????%%
     
   for k=2:3
     icr=(k-1).*ylg;
     icr_pre=(k-2).*ylg;
     icr_next=(k).*ylg;  
     icr_m=(k-1+4)*ylg;
     
      dy(hmo_ix+icr)=dy(hmo_ix+icr)+FL(k)/V_colon(k).*y(hmo_ix+icr_pre)-FL(k+1)/V_colon(k)*y(hmo_ix+icr)-f_back(k)/V_colon(k).*y(hmo_ix+icr)+f_back(k+1)/V_colon(k).*y(hmo_ix+icr_next)-km(1)*(y(hmo_ix+icr)-y(hmo_ix+icr_m))-r_hyd_hmo{k};
      dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)+FL(k)/V_colon(k)*y(hmo_ix+1+icr_pre:lx+icr_pre)-FL(k+1)/V_colon(k)*y(hmo_ix+1+icr:lx+icr)-f_back(k)/V_colon(k).*y(hmo_ix+1+icr:lx+icr)...
                              +f_back(k+1)/V_colon(k).*y(hmo_ix+1+icr_next:lx+icr_next)-km(hmo_ix+1:end).*(y(hmo_ix+1+icr:lx+icr)-y(hmo_ix+1+icr_m:lx+icr_m))+r_hyd_hex{k};
   end
k=4;    
   icr=(k-1).*ylg;
     icr_pre=(k-2).*ylg;
     icr_next=(k).*ylg;  
     icr_m=(k-1+4)*ylg;
     dy(1+icr:lx+icr)=dy(1+icr:lx+icr)+FL(k)/V_colon(k)*y(1+icr_pre:lx+icr_pre)-FL(k+1)/V_colon(k)*y(1+icr:lx+icr)-f_back(k)/V_colon(k).*y(1+icr:lx+icr)...
                              -km.*(y(1+icr:lx+icr)-y(1+icr_m:lx+icr_m));
     
     dy(hmo_ix+icr)=dy(hmo_ix+icr)+FL(k)/V_colon(k).*y(hmo_ix+icr_pre)-FL(k+1)/V_colon(k)*y(hmo_ix+icr)-f_back(k)/V_colon(k).*y(hmo_ix+icr)-km(1)*(y(hmo_ix+icr)-y(hmo_ix+icr_m))-r_hyd_hmo{k};
     dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)+FL(k)/V_colon(k)*y(hmo_ix+1+icr_pre:lx+icr_pre)-FL(k+1)/V_colon(k)*y(hmo_ix+1+icr:lx+icr)-f_back(k)/V_colon(k).*y(hmo_ix+1+icr:lx+icr)...
                              -km(2:end).*(y(hmo_ix+1+icr:lx+icr)-y(hmo_ix+1+icr_m:lx+icr_m))+r_hyd_hex{k};
     

 k=5;   
 icr=(k-1).*ylg;
 icr_pre=(k-2).*ylg;
 icr_next=(k).*ylg; 
 icr_lm=(k-1-4).*ylg;
 icr_bld=9*ylg+1+lx;

 dy(hmo_ix+icr)=dy(hmo_ix+icr)+FM(k-4)/V_colon(k).*HMO_in-FM(k-4+1)/V_colon(k)*y(hmo_ix+icr)+V_colon(k-4)/V_colon(k).*km(1)*(y(hmo_ix+icr_lm)-y(hmo_ix+icr))-Pn(1)*(y(hmo_ix+icr)-y(hmo_ix+icr_bld))-r_hyd_hmo{k};   %%????????????????????????????hmo??????????????????????????????hmo??????????????????g/L??????????????????????????????????????????????????????
 dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)-FM(k-4+1)/V_colon(k)*y(hmo_ix+1+icr:lx+icr)+V_colon(k-4)/V_colon(k).*km(2:end).*(y(hmo_ix+1+icr_lm:lx+icr_lm)-y(hmo_ix+1+icr:lx+icr))-Pn(2:end).*(y(hmo_ix+1+icr:lx+icr)-y(2+icr_bld:lx+icr_bld))+r_hyd_hex{k};
 
 
 
 for k=6:8   
    icr=(k-1).*ylg;
    icr_pre=(k-2).*ylg;
    icr_next=(k).*ylg;
    icr_lm=(k-1-4).*ylg;
    icr_bld=9*ylg+1+lx;
 
    dy(hmo_ix+icr)=dy(hmo_ix+icr)+FM(k-4)/V_colon(k).*y(hmo_ix+icr_pre)-FM(k-4+1)/V_colon(k)*y(hmo_ix+icr)+V_colon(k-4)/V_colon(k).*km(1)*(y(hmo_ix+icr_lm)-y(hmo_ix+icr))-Pn(1)*(y(hmo_ix+icr)-y(hmo_ix+icr_bld))-r_hyd_hmo{k};   %%????????????????????????????hmo??????????????????????????????hmo??????????????????g/L??????????????????????????????????????????????????????
    dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)+FM(k-4)/V_colon(k).*y(hmo_ix+1+icr_pre:lx+icr_pre)-FM(k-4+1)/V_colon(k)*y(hmo_ix+1+icr:lx+icr)+V_colon(k-4)/V_colon(k).*km(2:end).*(y(hmo_ix+1+icr_lm:lx+icr_lm)-y(hmo_ix+1+icr:lx+icr))-Pn(2:end).*(y(hmo_ix+1+icr:lx+icr)-y(2+icr_bld:lx+icr_bld))+r_hyd_hex{k};
    
    
    
 end
 
 k=9;    
     icr=(k-1).*ylg;
     icr_pre=(k-1-1).*ylg;    %% VM4
     icr_lm=(k-1-1-4).*ylg; %% VL4
     icr_next=(k).*ylg;


               
               
               dSP_dt_V5_temp=dy(hmo_ix+icr:lx+icr); %% d metabolite concentrations/dt
               dy(hmo_ix+icr)=dy(hmo_ix+icr)+FM(k-4)/V5.*(y(hmo_ix+icr_pre)-y(hmo_ix+icr))+FL(k-4)/V5*(y(hmo_ix+icr_lm)-y(hmo_ix+icr))-r_hyd_hmo{k};
               dy(hmo_ix+1+icr:lx+icr)=dy(hmo_ix+1+icr:lx+icr)+FM(k-4)/V5*(y(hmo_ix+1+icr_pre:lx+icr_pre)-y(hmo_ix+1+icr:lx+icr))+FL(k-4)/V5*(y(hmo_ix+1+icr_lm:lx+icr_lm)-y(hmo_ix+1+icr:lx+icr))+r_hyd_hex{k};
               
               
               dy(icr+ylg+1)=FL(k-4)+FM(k-4)-F5; 
               dSP_dt_V5_temp(1)=dSP_dt_V5_temp(1)-r_hyd_hmo{k};  %% d V*mets /dt
               dSP_dt_V5_temp(2:end)=dSP_dt_V5_temp(2:end)+r_hyd_hex{k};
               dy(icr+ylg+1+1:icr+ylg+1+lx)=V5*dSP_dt_V5_temp+FL(k-4)*y(1+icr_lm:lx+icr_lm)+FM(k-4)*y(1+icr_pre:lx+icr_pre)-F5*y(1+icr:lx+icr);        %% d(HexoseV5-H2V5)/dt
            
               
               
            

k=10;  
icr=(k-1).*ylg;
icr_M1=(k-4-1-1).*ylg;
icr_M2=(k-4-1-1+1).*ylg;
icr_M3=(k-4-1-1+2).*ylg;
icr_M4=(k-4-1-1+3).*ylg;
lx_bld=icr+1+lx;   
CB0=0.5.*ones(lx,1);   
CB0(1)=0.1;   
dy(lx_bld+1:lx_bld+lx)=FB0/V_colon(k).*(CB0-y(lx_bld+1:lx_bld+lx))+VM1/V_BLD.*Pn.*(y(1+icr_M1:lx+icr_M1)-y(lx_bld+1:lx_bld+lx))+VM2/V_BLD.*Pn.*(y(1+icr_M2:lx+icr_M2)-y(lx_bld+1:lx_bld+lx))...
                                                                        +VM3/V_BLD.*Pn.*(y(1+icr_M3:lx+icr_M3)-y(lx_bld+1:lx_bld+lx))+VM4/V_BLD.*Pn.*(y(1+icr_M4:lx+icr_M4)-y(lx_bld+1:lx_bld+lx));


