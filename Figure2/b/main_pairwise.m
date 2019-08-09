function main_pairwise

addpath('./software/apache-poi');
addpath('./data');
addpath('./software/xlwrite/poi_library');

blank_inx=0;

spc_id={'Bacteroides theta' 'Bacteroides fragilis' 'Bifido longum' 'Bifido breve' 'Bifido adolescentis'  'Eubacterium hallii' 'Faecalibacterium prausnitzii' 'Roseburia intestinalis'};

biom_inx=2;

load 8SPC_0405
for i=1:length(spc_id)
    subs_cn{i}=SPC{i}.subs_cn;
    Expdata{i}=SPC{i}.expdata;
    met{i}=SPC{i}.met_udf;
    Substrate{i}=Expdata{i}(1,subs_cn{i}+1);  
    name=SPC{i}.id;
      if i<=5  
        Sug_org=SPC{i}.expdata(1,3);            
        SPC{i}.expdata(1,3)=80;

      elseif i==6   
            SPC{i}.expdata(1,3)=60;   
      else
            SPC{i}.expdata(1,3)=80;   
            SPC{i}.expdata(1,4)=60;   
      end
      

      
      SPC{i}.expdata(:,2)=SPC{i}.expdata(:,2).*SPC{i}.biom_coef;
      SPC{i}.expdata(1,2)=0.01./SPC{i}.biom_coef;   


    end
% end

Result_pure=[];
Biomass_pure=[];
Pure_miu=[];
Pure_id=[];

for i=1:length(spc_id)    
    [Tmodel,Ymodel,Texp,Yexp,miu]=common_pure_simulation_for_pairwise(SPC{i},i);
    Result_pure=[Result_pure Ymodel];   
    Biomass_pure=[Biomass_pure Ymodel(:,1)];
    Pure_id=[Pure_id {SPC{i}.id}];
    Pure_miu=[Pure_miu miu];
end
% save Result_pure Result_pure
Tspan=0:0.02:24;
Biomass_pure=[Tspan' Biomass_pure];
% save Biomass_pure Biomass_pure
% % save Pure_miu Pure_miu
% save Pure_id Pure_id
save Result_pure Result_pure
save Biomass_pure Biomass_pure
save Pure_miu Pure_miu
save Pure_id Pure_id

clear all   
clc
% load Result_pure
% load Pure_miu
% load Pure_id
% load Biomass_pure
load Result_pure
load Pure_miu
load Pure_id
load Biomass_pure

load 8SPC_0405


Result_file_pairwise='./data/pairwise_growth.xlsx';

spc_id={'Bacteroides theta' 'Bacteroides fragilis' 'Bifido longum' 'Bifido breve' 'Bifido adolescentis'  'Eubacterium hallii' 'Faecalibacterium prausnitzii' 'Roseburia intestinalis'};

write_flag=0;
output_title=[];
output_title1=[];
output_layout=[];

output=[];
miu=[];
output_miu=[];
TSpan=0:0.02:24;
for i=1:length(spc_id)
    subs_cn{i}=SPC{i}.subs_cn;
    Expdata{i}=SPC{i}.expdata;
    met{i}=SPC{i}.met_udf;
      if i<=5  
        Sug_org=SPC{i}.expdata(1,3);
        SPC{i}.expdata(1,3)=80;
      elseif i==6   
            SPC{i}.expdata(1,3)=60;  
      else
            SPC{i}.expdata(1,3)=80;   
            SPC{i}.expdata(1,4)=60;    
      end
      SPC{i}.expdata(1,2)=0.01/SPC{i}.biom_coef;

end


for i=1:length(spc_id)
%     [pathstr,name,ext]=fileparts(fileList(i).name);
%     SPC1=importSpecies(spc_id{i});
    SPC1=SPC{i};
    met1=SPC1.met_udf;
    for j=i:length(spc_id)
%         [pathstr,name,ext]=fileparts(fileList(j).name);
%         SPC2=importSpecies(spc_id{j});
        SPC2=SPC{j};
        met2=SPC2.met_udf;
%         SPC{1}=SPC1;
%         SPC{2}=SPC2;

        [Com_ij,miu_comm]=common_com_pairwise_Interaction({SPC1,SPC2},2);
        output_title_ij={SPC1.id,SPC2.id};
        output_title=[output_title output_title_ij];
        output_title1=[output_title1;output_title_ij];
        output=[output Com_ij];


        Com_ij_layout=reshape(Com_ij,[],1);
        output_layout=[output_layout;Com_ij_layout'];
        output_miu=[output_miu miu_comm];
    end
end

[spcr,spcn]=size(output);   
flag=0;
for i=1:length(spc_id)   
    for j=i:length(spc_id)
        pair_fc(:,2*(j-i+1)-1+flag)=log2(output(end,2*(j-i+1)-1+flag)./Biomass_pure(end,i));  
        pair_fc(:,2*(j-i+1)+flag)=log2(output(end,2*(j-i+1)+flag)./Biomass_pure(end,j));  
        pair_miu_fc(:,2*(j-i+1)-1+flag)=log2(max(output_miu(:,2*(j-i+1)-1+flag))./max(Pure_miu(:,i)));   
        pair_miu_fc(:,2*(j-i+1)+flag)=log2(max(output_miu(:,2*(j-i+1)+flag))./max(Pure_miu(:,j)));    
    end
    flag=flag+(8-i+1)*2;
end
 

writetable(cell2table([output_title1 num2cell(output_layout)]),'Biomass_tab.txt','WriteVariableNames',0);    


xlwrite_Jun(Result_file_pairwise,['Time';num2cell(TSpan')],'Time'); 
xlwrite_Jun(Result_file_pairwise,[output_title;num2cell(output)],'Biomass');
xlwrite_Jun(Result_file_pairwise,[output_title1 num2cell(output_layout)],'Biomass_format');     


xlwrite_Jun(Result_file_pairwise,[output_title;num2cell(output_miu)],'Growth_rate'); 
xlwrite_Jun(Result_file_pairwise,[output_title;num2cell(pair_miu_fc)],'MaxMiu_log2_FC'); 
Pure_title=['Time' Pure_id];
xlwrite_Jun(Result_file_pairwise,[Pure_title;num2cell(Biomass_pure)],'Pure_Culture');   




function unify_Initconc(SPClist)
  for i=1:length(SPClist)
    SPC{i}=SPClist{i};
    spc_name{i}=SPC{i}.id; 
    met{i}=SPC{i}.met_udf;
    subs_cn{i}=SPC{i}.subs_cn;
    biom_coef{i}=SPC{i}.biom_coef;
    biom_inx=strmatch('BIOM',met{i});
      if ismember('expdata',fields(SPC{i}))
         Expdata=SPC{i}.expdata;
         Time=Expdata(:,1);    
         Data=Expdata(:,2:end);
         Data(any(isnan(Data)'),:) = [];  
         Time(find(isnan(Time)),:) = [];
         [rexp cexp]=size(Data);
         Biomass{i}=Data(:,biom_inx);    
         Substrate{i}=Data(:,subs_cn{i}); 
         conc_ini{i}=Data(1,:);
     end
  end
  met_co={};
  for s=1:length(SPClist)
        met_co=union(met_co,met{s},'stable');
  end
  if (subs_cn{1}(1)==2)&&(subs_cn{2}(1)==2)
      SPC{1}.expdata(1,biom_inx+1)=SPC{1}.expdata(1,biom_inx+1).* Substrate{1}(1,1)./max(Substrate{1}(1,1),Substrate{2}(1,1));   
      SPC{2}.expdata(1,biom_inx+1)=SPC{2}.expdata(1,biom_inx+1).* Substrate{2}(1,1)./max(Substrate{1}(1,1),Substrate{2}(1,1));
  end
  
