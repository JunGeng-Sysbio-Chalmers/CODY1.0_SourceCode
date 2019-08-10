function main_pure_batch
clear 
clc
close all

load('8SPC_0405.mat');
fileNum=size(SPC,2);
n_species=length(spc_id);
for i=1:length(fileNum)
    idi=spc_id{i};
    SPC{i}=importSpecies(idi);
    name{i}=SPC{i}.id;
    met{i}=SPC{i}.met_udf;
end
tf = isequaln(SPC,SPC_imp);

    SPC=Models{i};
    met=SPC.met_udf;
    name=SPC.id;
    maxmiu{i}=max(miu{i});
    figure('Name',name,'NumberTitle','off');
i=6;
    plot_pure_simulation_multiple(Tmodel{i},Ymodel{i},Texp{i},Yexp{i},met{i},name{i});


for i=1:length(fileNum)
% i=1
    SPC=Models{i};
    met=SPC.met_udf;
    name=SPC.id;
    [Tmodel{i},Ymodel,Texp,Yexp,miu{i}]=common_pure_simulation(SPC,i);
    maxmiu{i}=max(miu{i})
    figure('Name',name,'NumberTitle','off');
    plot_pure_simulation_multiple(Tmodel{i},Ymodel,Texp,Yexp,met,name);
end


for i=1:length(fileNum)
    i=8;
    name=Models{i}.id;
    SPC=Models{i};
    met=SPC.met_udf;
    [Tmodel{i},Ymodel,Texp,Yexp,miu{i}]=common_pure_simulation(SPC,i);
    figure('Name',name,'NumberTitle','off');
    plot_pure_simulation(Tmodel{i},Ymodel,Texp,Yexp,met,name);
end
figure()
clr={'r--' 'r' 'k' 'k--' 'b--' 'b' 'g' 'm' };
% clr={[]
%      []
%      []
%      []
%      []
%      []
%      []
%      []};
for i=1:length(spc_id)
    plot(Tmodel{i},miu{i},clr{i},'linewidth',1.5);
    hold on
end
% hold off
legend(spc_id);
legend boxoff
title('Specific Growth Rate','fontsize',15)
ylabel('Specific Growth Rate (/h)','fontsize',15)
xlabel('Time (h)','fontsize',15)
