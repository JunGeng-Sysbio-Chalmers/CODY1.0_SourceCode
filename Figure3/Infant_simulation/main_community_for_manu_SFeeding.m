function main_community_for_manu(T,Y,Ymodel,Ymets,lg,rct_num,met_co,ns)

javaaddpath('poi_library/poi-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('poi_library/xmlbeans-2.3.0.jar');
javaaddpath('poi_library/dom4j-1.6.1.jar');
javaaddpath('poi_library/stax-api-1.0.1.jar');

addpath('./poi_library')

load('20181029_12m_diet_732h.mat')


T=ReferenceStates.SimulationTime;
Y=ReferenceStates.SimulationResult;
Ymodel=ReferenceStates.Result_cell;
Ymets=ReferenceStates.SimulationMetabolites;
lg=ReferenceStates.ylg;
rct_num=ReferenceStates.RectorNumber;
met_co=ReferenceStates.met_udf_co;
ns=ReferenceStates.SpeciesNumber;
lxini=length(met_co);

A=find(T>=0);
B=find(T<=800);
C=intersect(A,B);
Conc_Time=T(C);
Conc_Y=Y(C,:);
for ij=1:9
    Conc_Ymodel{ij}=Ymodel{ij}(C,:);
    Conc_Ymodel_met{ij}=Ymets{ij}(C,:);
end
ij=10;
Conc_Ymodel{ij}=Ymodel{ij}(C,:);

Tn=length(Conc_Time);
nspc=ns;
if nspc==5
    SmpPnt=5;
else          
    SmpPnt=1;
end
type='lumen';
% for i=1:SmpPnt:Tn
    NewTime=Conc_Time(1:SmpPnt:Tn);
    NewY=Conc_Y(1:SmpPnt:Tn,:);
    for ij=1:9
        New_Ymodel{ij}=Conc_Ymodel{ij}(1:SmpPnt:Tn,:);
        New_Ymodel_met{ij}=Conc_Ymodel_met{ij}(1:SmpPnt:Tn,:);
    end
ij=10;
New_Ymodel{ij}=Ymodel{ij}(1:SmpPnt:Tn,:);

% Tanks={'Lumen_1','Lumen_2','Lumen_3','Lumen_4','Mucosa_1','Mucosa_2','Mucosa_3','Mucosa_4','Rectum','Blood','Feces'};
Tanks={'Lumen_1','Lumen_2','Lumen_3','Lumen_4','Mucosa_1','Mucosa_2','Mucosa_3','Mucosa_4','Rectum','Blood','Feces','HMO'};

cd('./Results')
file_out_name='Community_10tanks_output_Feces_12m_68sample_20181029_732h.xlsx';     %% step=0.01


col_header=['Time',met_co'];
met_co1=met_co(ns+1:end);
col_header2=['Time',met_co1'];

for k=1:rct_num-1   %% 
    Community_Result{k}.result=num2cell([NewTime,New_Ymodel_met{k}]);
    output=[col_header;Community_Result{k}.result];
    xlwrite(file_out_name,output,Tanks{k});   %%
end

k=9;
    Ymass_fece=NewY(:,(k-1)*lg+lg+1+1:(k-1).*lg+lg+1+lxini);
    Ymets{k+2}=num2cell([NewTime,Ymass_fece]);
    output=[col_header;Ymets{k+2}];
    xlwrite(file_out_name,output,Tanks{k+2});
    
    V5_rctm=NewY(:,(k-1)*lg+lg+1);  %%
    Volume=num2cell([NewTime,V5_rctm]);
    col_header={'Time','Fece_Vol'};
    output=[col_header;Volume];
    xlwrite(file_out_name,output,'Feces_Volume');
k=10;
    Community_Result{k}.result=num2cell([NewTime,New_Ymodel{k}]);   %%
    output=[col_header2;Community_Result{k}.result];
    xlwrite(file_out_name,output,Tanks{k});  
k=11;

