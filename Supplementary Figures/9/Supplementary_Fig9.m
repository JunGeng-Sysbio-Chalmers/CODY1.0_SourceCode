function main_TIM_empty_validation
%% give a pulse function, validate how it transport in the system
clear
clc

addpath('../');
addpath('../export_fig-master');


global food n_species Aim  lg_standard
global store_flag
global SPC e_ini  e_ini_X spc SxZ kmax e_rel ke alpha beta Y_BM maxmue maxEnzyme e0 met_udf_co met_length met_co_hmo
global RA_data Km_lumen Pn_mucosa  Mass
global ini_4m_x0  ini_4m_met ini_4m_enz
global x10 x20 x30 x40 x50 XB10 XB20 XB30 XB40

n_rct=10;

V_colon_t=0.12;   %% TIM-2 model settings  

V_colon=[0.03 0.03 0.03 0.03 0.006 0.006 0.006 0.006 0.03 0.1]';  %% TIM-2 model volume: 120mL

GLU_in=100;     

F0=[0.004  0.004  0  0.01]';  %% TIM-2 model, inflow rate: 4mL/h

f=[0  0.0004  0.0004  0.0004]';   %% recycle fluid,f4=0;


sim_time=600;              %% simulation time; unit: day

% 
HMO=80;   

hmo_para=[HMO];

met_udf_co={'hexose'};
x10=0;
x20=0;
x30=0;
x40=0;
XB10=0;
XB20=0;
XB30=0;
XB40=0;
x50=0;

ini_stat_Lumen1=[x10];
ini_stat_Lumen2=[x20];
ini_stat_Lumen3=[x30];
ini_stat_Lumen4=[x40];
ini_stat_Mucosa1=[XB10];
ini_stat_Mucosa2=[XB20];
ini_stat_Mucosa3=[XB30];
ini_stat_Mucosa4=[XB40];
ini_stat_V5=[x50;V_colon(9);x50.*V_colon(9)];  %% rectum
ini_stat_Blood=[0];
ini_stat=[ini_stat_Lumen1;ini_stat_Lumen2;ini_stat_Lumen3;ini_stat_Lumen4;ini_stat_Mucosa1;ini_stat_Mucosa2;ini_stat_Mucosa3;ini_stat_Mucosa4;ini_stat_V5;ini_stat_Blood;];


lg_standard=length(ini_stat_Lumen1);  
%%
Km_lumen=0.03;
Pn_mucosa=power(10,-7);
Pn=Pn_mucosa.*3600/100; %% unit transfer to dm/h
    Pn=Pn.*10;
    av=1/0.05;
    Pn_mucosa=Pn.*av;
Km_water={1/20 1/60 1/300 1/400};


density=0.7*1000;
Mass=[180];


[T,Y,Y_model,Y_mets]=dynamic_simulation_TIM_validation2(SPC,n_species,n_rct,GLU_in,F0,f,V_colon,ini_stat,sim_time,lg_standard,Km_lumen,Pn_mucosa,Km_water,density,Mass,hmo_para);

end
