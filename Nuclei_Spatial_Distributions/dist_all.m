%% Plot distances and number of nuclei for all time points, in each sample
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020
clear; clc; close all;

tp    = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
time  = [0 2 5 7 9 12 14];
% Series 1
group1 = {'A*C*.txt','A*E*.txt','B*E*.txt','B*N*.txt','B*W*.txt','F*W*.txt'};
gname1 = {'Control_s1_AC','Control_s1_AE','Control_s1_BE','Control_s1_BN','Control_s1_BW','Control_s1_FW'};
file1  = 'res_coord_scaled/';
gname = gname1;
lname = {'Sample 1', 'Sample 2', 'Sample 3', 'Sample 4', 'Sample 5', 'Sample 6' };

datgroup = {'Control'};
nsamp=6;

% Series 2
%{
group2 = {'A*C*.txt','A*N*.txt','A*S*.txt','A*W*.txt','A*E*.txt',...
         'B*C*.txt','B*N*.txt','B*S*.txt','B*W*.txt','B*E*.txt',...
         'C*C*.txt','C*N*.txt','C*S*.txt','C*W*.txt','C*E*.txt',...
         'DD*C*.txt','DD*N*.txt','DD*S*.txt','DD*W*.txt','DD*E*.txt',...
                    'E*N*.txt','E*S*.txt','E*W*.txt'           ,...
                    'F*N*.txt',           'F*W*.txt','F*E*.txt'};
gname2 = {'Pac_0p5_AC','Pac_0p5_AN','Pac_0p5_AS','Pac_0p5_AW','Pac_0p5_AE',...
          'Pac_0p05_BC','Pac_0p05_BN','Pac_0p05_BS','Pac_0p05_BW','Pac_0p05_BE',...
         'Pac_0p005_CC','Pac_0p005_CN','Pac_0p005_CS','Pac_0p005_CW','Pac_0p005_CE',...
         'Pac_0p0005_DC','Pac_0p0005_DN','Pac_0p0005_DS','Pac_0p0005_DW','Pac_0p0005_DE',...
              'Control_s2_EN','Control_s2_ES','Control_s2_EW'     ,...
              'Control_s2_FN',     'Control_s2_FW','Control_s2_FE'};
file2  = 'res_coord_series_2_scaled/';

% names of all datasets
gname = [gname2, gname1];

% names for legends to avoid confusion
lname = {'Pac0.5 R1','Pac0.5 R2','Pac0.5 R3','Pac0.5 R4','Pac0.5 R5', ...
         'Pac0.05 R1','Pac0.05 R2','Pac0.05 R3','Pac0.05 R4','Pac0.05 R5', ...
         'Pac0.005 R1','Pac0.005 R2','Pac0.005 R3','Pac0.005 R4','Pac0.005 R5', ...
         'Pac0.0005 R1','Pac0.0005 R2','Pac0.0005 R3','Pac0.0005 R4','Pac0.0005 R5', ...
         'Control R1','Control R2','Control R3','Control R4','Control R5','Control R6',...
         'Control R7','Control R8','Control R9','Control R10','Control R11','Control R12'};
%}
%datgroup = {'Pac 0.5','Pac 0.05','Pac 0.005','Pac 0.0005','Control'};
%nsamp    = [5        , 5        , 5         , 5          , 12 ];


run plotopt.m

%% Import coordinates
disp('Importing coordinates...')
%{
% Series 2
for i=1:length(group2)
   
    for j=1:length(tp)
       
        samp2{i,j}=dir([file2 tp{j} '/' group2{i}]);
        coord.(gname2{i}).(tp{j})=readmatrix([samp2{i,j}.folder '/' samp2{i,j}.name]);
        count.(gname2{i}).(tp{j})=length(coord.(gname2{i}).(tp{j})(:,1));

    end
end
clear samp2
%}
% Series 1
for i=1:length(group1)
   
    for j=1:length(tp)
       
        samp1{i,j}=dir([file1 tp{j} '/' group1{i}]);
        coord.(gname1{i}).(tp{j})=readmatrix([samp1{i,j}.folder '/' samp1{i,j}.name]);
        count.(gname1{i}).(tp{j})=length(coord.(gname1{i}).(tp{j})(:,1));

    end
end
clear samp1

%% Plot histogram of cells across z
%{
gc=struct2array(coord);
gc=struct2table(gc);
gc=table2array(gc);

gc_control = gc(21:32, :);
gc_pac_0p5 = gc(1:5,:);
gc_pac_0p05 = gc(6:10,:);
gc_pac_0p005 = gc(11:15,:);
gc_pac_0p0005 = gc(16:20,:);

[l1,d1]=size(gc_control);
[l2,d2]=size(gc_pac_0p5);
[l3,d3]=size(gc_pac_0p05);
[l4,d4]=size(gc_pac_0p005);
[l5,d5]=size(gc_pac_0p0005);

for i=1:length(tp)
    
    gc_cont_z=[];
    gc_pac_0p5_z=[];
    gc_pac_0p05_z=[];
    gc_pac_0p005_z=[];
    gc_pac_0p0005_z=[];
    
    for j=1:l1       
        gc_cont_z = [gc_cont_z; gc_control{j,i}];      
    end
    
    for j=1:l2
        gc_pac_0p5_z = [gc_pac_0p5_z; gc_pac_0p5{j,i}];
    end
    
    for j=1:l3
        gc_pac_0p05_z = [gc_pac_0p05_z; gc_pac_0p05{j,i}];
    end
    
    for j=1:l4
        gc_pac_0p005_z = [gc_pac_0p005_z; gc_pac_0p005{j,i}];
    end
    
    for j=1:l5
        gc_pac_0p0005_z = [gc_pac_0p0005_z; gc_pac_0p0005{j,i}];
    end
    
    f1=figure('Position', [100, 100, 1400, 1200],'Visible','off');
    hold on
    histogram(gc_pac_0p5_z(:,3),50,'FaceAlpha',0.5,'DisplayName','$0.5\ \mu$M','Normalization','probability')
    histogram(gc_cont_z(:,3),50,'FaceAlpha',0.5,'DisplayName','Control','Normalization','probability')
    legend
    title(tp(i))
    xlabel('z ($\mu m$)')
    axis([0 900 0 inf])
    hold off
    set(f1,'Units','Inches');
    pos = get(f1,'Position');
    set(f1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    disp('Saving...')
    print(f1,['hist_z_pac_0p5_' tp{i} '.png'],'-r350','-dpng')
    
    f2=figure('Position', [100, 100, 1400, 1200],'Visible','off');
    hold on
    histogram(gc_pac_0p05_z(:,3),50,'FaceAlpha',0.5,'DisplayName','$0.05\ \mu$M','Normalization','probability')
    histogram(gc_cont_z(:,3),50,'FaceAlpha',0.5,'DisplayName','Control','Normalization','probability')
    legend
    title(tp(i))
    xlabel('z ($\mu m$)')
    axis([0 900 0 inf])
    hold off
    set(f2,'Units','Inches');
    pos = get(f2,'Position');
    set(f2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    disp('Saving...')
    print(f2,['hist_z_pac_0p05_' tp{i} '.png'],'-r350','-dpng')
    
    f3=figure('Position', [100, 100, 1400, 1200],'Visible','off');
    hold on
    histogram(gc_pac_0p005_z(:,3),50,'FaceAlpha',0.5,'DisplayName','$0.005\ \mu$M','Normalization','probability')
    histogram(gc_cont_z(:,3),50,'FaceAlpha',0.5,'DisplayName','Control','Normalization','probability')
    legend
    title(tp(i))
    xlabel('z ($\mu m$)')
    axis([0 900 0 inf])
    hold off
    set(f3,'Units','Inches');
    pos = get(f3,'Position');
    set(f3,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    disp('Saving...')
    print(f3,['hist_z_pac_0p005_' tp{i} '.png'],'-r350','-dpng')
    
    f4=figure('Position', [100, 100, 1400, 1200],'Visible','off');
    hold on
    histogram(gc_pac_0p0005_z(:,3),50,'FaceAlpha',0.5,'DisplayName','$0.0005\ \mu$M','Normalization','probability')
    histogram(gc_cont_z(:,3),50,'FaceAlpha',0.5,'DisplayName','Control','Normalization','probability')
    legend
    title(tp(i))
    xlabel('z ($\mu m$)')
    axis([0 900 0 inf])
    hold off
    set(f4,'Units','Inches');
    pos = get(f4,'Position');
    set(f4,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    disp('Saving...')
    print(f4,['hist_z_pac_0p0005_' tp{i} '.png'],'-r350','-dpng')
end
%}

%% Calculate distances and save them
%{
disp('Calculating and saving distances...')
%parpool(length(group));
for i=1:length(group)
    for k=1:length(tp)
   
        calc_ind_knd(coord1.(gname{i}).(tp{k}),samp1{i,k}.name)
    
    end
end
disp('Finished')
%delete(gcp('nocreate'))
%}

%% Import distance distributions
%{
disp('Importing distance distributions...')
group11 = {'Control_s1_A*C*.txt','Control_s1_A*E*.txt','Control_s1_B*E*.txt',...
    'Control_s1_B*N*.txt','Control_s1_B*W*.txt','Control_s1_F*W*.txt'};
%{
group22 = {'Pac_*_A*C*.txt','Pac_*_A*N*.txt','Pac_*_A*S*.txt','Pac_*_A*W*.txt','Pac_*_A*E*.txt',...
         'Pac_*_B*C*.txt','Pac_*_B*N*.txt','Pac_*_B*S*.txt','Pac_*_B*W*.txt','Pac_*_B*E*.txt',...
         'Pac_*_C*C*.txt','Pac_*_C*N*.txt','Pac_*_C*S*.txt','Pac_*_C*W*.txt','Pac_*_C*E*.txt',...
         'Pac_*_DD*C*.txt','Pac_*_DD*N*.txt','Pac_*_DD*S*.txt','Pac_*_DD*W*.txt','Pac_*_DD*E*.txt',...
                    'Control_s2_E*N*.txt','Control_s2_E*S*.txt','Control_s2_E*W*.txt'           ,...
                    'Control_s2_F*N*.txt',           'Control_s2_F*W*.txt','Control_s2_F*E*.txt'};
                

for i=1:length(group22)
    
    sampIND{i}=dir(['Distances/Distributions/' 'IND_' group22{i}]);
    sampKND{i}=dir(['Distances/Distributions/' 'KND_' group22{i}]);
    namesIND     = {sampIND{i}.name};
    namesIND     = natsort(namesIND);
    namesKND     = {sampKND{i}.name};
    namesKND     = natsort(namesKND);
    for j=1:length(tp)
           
        IND.(gname2{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesIND{j}]);
        KND.(gname2{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesKND{j}]);
       
    end
end
clear sampIND sampKND
%}
for i=1:length(group11)
    
    sampIND{i}=dir(['Distances/Distributions/' 'IND_' group11{i}]);
    sampKND{i}=dir(['Distances/Distributions/' 'KND_' group11{i}]);
    namesIND     = {sampIND{i}.name};
    namesIND     = natsort(namesIND);
    namesKND     = {sampKND{i}.name};
    namesKND     = natsort(namesKND);
    for j=1:length(tp)
           
        IND.(gname1{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesIND{j}]);
        KND.(gname1{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesKND{j}]);
       
    end
end
clear sampIND sampKND

%{
%% Plot nearest neighbor distance
for i=1:length(group)
    figure('Name',['KND_' gname{i}]);
    alphaval=0.8;
    cmap=winter(7);
    colormap(cmap)
    caxis([0 14])
    c=colorbar('Ticks',[0,14],'TickLabels',{'D0' 'D14'});
    for k=1:length(tp)
        hax=gca;
        hax.FontSize=16;
        hold on
        xi2=KND.(tp{k}).(gname{i})(2,:);
        f2=KND.(tp{k}).(gname{i})(1,:);
        h=plot(xi2,f2,'LineWidth',4,'Color',cmap(k,:));
        h.Color(4) = alphaval; 
        xlabel('Nearest-Neighbor Distance $(\mu m)$','Interpreter','latex') 
        ylabel('PDF','Interpreter','latex')
    end
    hold off
end
%}

%}
%% Estimate variations between distributions
% import distances
group11 = {'Control_s1_A*C*.txt','Control_s1_A*E*.txt','Control_s1_B*E*.txt',...
    'Control_s1_B*N*.txt','Control_s1_B*W*.txt','Control_s1_F*W*.txt'};
group=group11;
disp('Importing distances...')
for i=1:length(group)
    
   % sampINDist{i}=dir(['Distances/Distributions/IND_' group{i} ]);
    sampKNDist{i}=dir(['Distances/KNDist/' 'KNDist_' group{i} '.bin']);
    %namesINDist  = {sampINDist{i}.name};
    %namesINDist  = natsort(namesINDist);
    namesKNDist  = {sampKNDist{i}.name};
    namesKNDist  = natsort(namesKNDist);
    
    for j=1:length(tp)
       
     %   fileID=fopen(['Distances/Distributions/' namesINDist{j}],'r');
     %   INDist.(gname{i}).(tp{j})=fread(fileID,'double');
     %   fclose(fileID);
        
        fileID=fopen(['Distances/KNDist/' namesKNDist{j}],'r');
        KNDist.(gname{i}).(tp{j})=fread(fileID,'double');
        fclose(fileID);
        
    end
end
disp('Finished')
%clear sampINDist sampKNDist names*
%
% calculate the cosine similarity between distributions
disp('Estimating similarity...')
%parpool(length(group));
for i=1:length(gname)
   
    calc_dist_var(0,KNDist.(gname{i}),...
        ['Distances/to_delete_' gname{i}],...
        ['Distances/Variability/Var_KNDist_' gname{i}]);
    
end
%delete(gcp('nocreate'))
%% Import variations between distributions 

disp('Importing variations between distributions...')
for i=1:length(gname)
    
    varIND.(gname{i})=readmatrix(['Distances/Variability/' 'Var_INDist_' gname{i} '.txt']);
    varKND.(gname{i})=readmatrix(['Distances/Variability/' 'Var_KNDist_' gname{i} '.txt']);
    matIND.(gname{i})=zeros(7,7);
    matKND.(gname{i})=zeros(7,7);
    for j=1:length(varIND.(gname{i}))
        matIND.(gname{i})(varIND.(gname{i})(j,1),varIND.(gname{i})(j,2))=varIND.(gname{i})(j,3);
        matKND.(gname{i})(varKND.(gname{i})(j,1),varKND.(gname{i})(j,2))=varKND.(gname{i})(j,3);
    end
end



varINDt=struct2array(varIND);
varINDt=vertcat(varINDt(:,1:3),varINDt(:,4:6),varINDt(:,7:9),varINDt(:,10:12),varINDt(:,13:15),varINDt(:,16:18));

varKNDt=struct2array(varKND);
varKNDt=vertcat(varKNDt(:,1:3),varKNDt(:,4:6),varKNDt(:,7:9),varKNDt(:,10:12),varKNDt(:,13:15),varKNDt(:,16:18));

varINDmean  = mean(varINDt(:,3));
%ShanINDmean = mean(varINDt(:,4)); 
varKNDmean  = mean(varKNDt(:,3));

varINDstd  = std(varINDt(:,3));
%ShanINDstd = std(varINDt(:,4)); 
varKNDstd  = std(varKNDt(:,3));

%% Plot similarity for different time-points

vIND_dt = [];
vKND_dt = [];
dtp_cat = [];
dt  = [];


for i=1:6
    
    %i-tp difference
    subin{i}=find(abs(varINDt(:,1)-varINDt(:,2))==i);
    subkn{i}=find(abs(varKNDt(:,1)-varKNDt(:,2))==i);
    len = length(subin{i});

    vIND_dt=[vIND_dt;    varINDt(subin{i},3)]; 
    vKND_dt=[vKND_dt;    varKNDt(subkn{i},3)];
    dtp_cat=[dtp_cat;    repmat(dtp{i},len,1)];
    dt     =[dt; i*ones(len,1)]; 
    
end
    
%%
run plotopt.m
h=figure('Name','Variations','Position', [100, 100, 1200, 900]);   
hold on
violinplot(vIND_dt,dt,'ShowMean',true,'ViolinAlpha',0.5);
xlabel('$\Delta t_{i,j}$')
ylabel('cosine similarity')
%axis([-inf inf 0.9 1])
hold off
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(h,'violin_IN_s1.png','-dpng','-r350')

%
h=figure('Name','Variations','Position', [100, 100, 1200, 900]);   
hold on
violinplot(vKND_dt,dt,'ShowMean',true,'ViolinAlpha',0.5);
xlabel('$\Delta t_{i,j}$')
ylabel('cosine similarity')
%axis([-inf inf 0.9 1])
hold off
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(h,'violin_NN_s1.png','-dpng','-r350')

%% Plot inter-nuclei, and nearest neighbor distance
%{
run plotopt.m
disp('Plotting IN-, NN- distances...')
for i=1:length(group1)
    h=figure('Name',['IND_KND_' gname{i}],'Position', [200, 200, 1200, 900]);
    alphaval=0.8;
    cmap=winter(7);
    for k=1:length(tp)
        subplot(1,2,1);
        hax=gca;
        hold on
        xi1=IND.(gname{i}).(tp{k})(2,:);
        f1 =IND.(gname{i}).(tp{k})(1,:);
        h1=plot(xi1./1000,f1,'LineWidth',4,'Color',cmap(k,:));
        h1.Color(4) = alphaval; 
        xlabel('IN Distances $(mm)$','FontSize',30)
        ylabel('PDF','FontSize',30) 
        
        
        subplot(1,2,2);
        hbx=gca;
        hold on
        xi2=KND.(gname{i}).(tp{k})(2,:);
        f2 =KND.(gname{i}).(tp{k})(1,:); 
        h2=plot(xi2./1000,f2,'LineWidth',4,'Color',cmap(k,:));
        h2.Color(4) = alphaval; 
        xlabel('NN Distances $(mm)$','FontSize',30) 
        colormap(cmap)
        caxis([0 14])
        colorbar(hbx,'Ticks',[0,14],'TickLabels',{'D0' 'D14'},'TickLabelInterpreter','latex'); %
    end
    hold off
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['IN_NN_' gname{i} '.png'],'-dpng','-r350')
end
%}

%% Plot all the samples together
%{
% IND
overlap = 0.4;
mn = linspace(0,1,length(gname));
cmap=winter(length(datgroup));

h=figure('Name','IND','Position', [200, 200, 1200, 800]);
hold on
for i=1:length(tp)
    
    subplot(2,4,i);
   
    for j=1:length(gname)
        xi1(:,j)=IND.(gname{j}).(tp{i})(2,:);
        f1(:,j) =IND.(gname{j}).(tp{i})(1,:);
    end
    f = cumsum(max(f1,[],1))*(1-overlap);
    
    hold on
    for ii=length(datgroup):-1:1
        m=nsamp(ii)+1;
        for j=1:nsamp(ii)
            patch([xi1(:,ii+m)',-min(xi1(:,ii+m))],[f1(:,ii+m)+f(ii);f(ii)],mn(ii),...
                 'EdgeColor','none','FaceAlpha',0.05,'FaceColor',cmap(ii,:));

            plot(xi1(:,ii+m),f1(:,ii+m)+f(ii),'Color',cmap(ii,:),'LineWidth',2) 
            m=m-1;
        end
    end
    title(tp{i})
    axis([0 3000 0 inf])
    yticks(f)
    yticklabels({' '})
    %if(i==1 || i==5)
    %    yticklabels({'Pac 0.5','Pac 0.05','Pac 0.005','Pac 0.0005','Control'});
    %else
    %    yticklabels({' '})
    %end
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$');
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'Inter-Nuclei Distances');
set(ylh, 'Visible', 'On')
colormap(cmap)
c=colorbar('Ticks',[0:0.1290/4:0.1290],'TickLabels',...
    {'Pac 0.5$\mu M$','Pac 0.05$\mu M$','Pac 0.005$\mu M$','Pac 0.0005$\mu M$','Control'},...
    'TickLabelInterpreter','latex',...
    'Position',[0.5422+1.3*0.1566  0.11  0.01  0.12+1.35*0.1566]);
%hL=legend(gname,'Interpreter','latex','FontSize',16,...
%      'Location','southeastoutside','NumColumns',2);
%newPosition = [0.4 0.2 0.2 0.1];
%newUnits = 'normalized';
%set(hL,'Position', newPosition,'Units', newUnits);
hold off
%title(hh.ah,'Inter-Nuclei distance')
print(h,['Figures/IN_all_group1.png'],'-dpng','-r350')

%% KND
overlap = 0.4;
mn = linspace(0,1,length(gname));
cmap=winter(length(datgroup));

h=figure('Name','IND','Position', [200, 200, 1200, 800]);
hold on
for i=1:length(tp)
    
    subplot(2,4,i);
   
    for j=1:length(gname)
        xi1(:,j)=KND.(gname{j}).(tp{i})(2,:);
        f1(:,j) =KND.(gname{j}).(tp{i})(1,:);
    end
    f = cumsum(max(f1,[],1))*(1-overlap);
    
    hold on
    for ii=length(datgroup):-1:1
        m=nsamp(ii)+1;
        for j=1:nsamp(ii)
            patch([xi1(:,ii+m)',-min(xi1(:,ii+m))],[f1(:,ii+m)+f(ii);f(ii)],mn(ii),...
                 'EdgeColor','none','FaceAlpha',0.05,'FaceColor',cmap(ii,:));

            plot(xi1(:,ii+m),f1(:,ii+m)+f(ii),'Color',cmap(ii,:),'LineWidth',2) 
            m=m-1;
        end
    end
    title(tp{i})
    axis([0 149 0 inf])
    yticks(f)
    yticklabels({' '})
    %if(i==1 || i==5)
    %    yticklabels({'Pac 0.5','Pac 0.05','Pac 0.005','Pac 0.0005','Control'});
    %else
    %    yticklabels({' '})
    %end
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$');
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'Nearest-Neighbour Nuclei Distances');
set(ylh, 'Visible', 'On')
colormap(cmap)
c=colorbar('Ticks',[0:0.1290/4:0.1290],'TickLabels',...
    {'Pac 0.5$\mu M$','Pac 0.05$\mu M$','Pac 0.005$\mu M$','Pac 0.0005$\mu M$','Control'},...
    'TickLabelInterpreter','latex',...
    'Position',[0.5422+1.3*0.1566  0.11  0.01  0.12+1.35*0.1566]);
%hL=legend(gname,'Interpreter','latex','FontSize',16,...
%      'Location','southeastoutside','NumColumns',2);
%newPosition = [0.4 0.2 0.2 0.1];
%newUnits = 'normalized';
%set(hL,'Position', newPosition,'Units', newUnits);
hold off
%title(hh.ah,'Inter-Nuclei distance')
print(h,['Figures/KN_all.png'],'-dpng','-r350')
%}

%% Plot all the samples together temporary
%{
% IND
run plotopt.m
h=figure('Name','IND','Position', [100, 100, 1200, 900]);
for i=1:length(tp)
    
    %subplot(3,3,i);
    subaxis(3,3,i, 'Spacing', 0.08, 'Padding', 0.015, 'Margin', 0.08);
    hax=gca;
    hold on
    for j=1:length(group1)
        xi1=IND.(gname{j}).(tp{i})(2,:);
        f1 =IND.(gname{j}).(tp{i})(1,:);
        h1=plot(xi1./1000,f1,'LineWidth',4);
        box off
    end
    title(tp{i})
    axis([-inf inf 0 10e-04])
    hax.FontSize=24;
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(mm)$','FontSize',30);
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'PDF','FontSize',30);
set(ylh, 'Visible', 'On');
hL=legend(lname,'Interpreter','latex','FontSize',24,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.15 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
print(h,['IND_group1.png'],'-dpng','-r350')
%title(hh.ah,'Inter-Nuclei distance')

%% KND
h=figure('Name','KND','Position', [100, 100, 1200, 900]);
for i=1:length(tp)
    
    subaxis(3,3,i, 'Spacing', 0.08, 'Padding', 0.015, 'Margin', 0.08);
    hax=gca;
    hold on
    for j=1:length(group1)
        xi1=KND.(gname{j}).(tp{i})(2,:);
        f1 =KND.(gname{j}).(tp{i})(1,:);
        h1=plot(xi1./1000,f1,'LineWidth',4);
        hax.FontSize=24;
    end
    title(tp{i})
    axis([-inf 200/1000 0 0.1])
    box off
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(mm)$','FontSize',30);
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'PDF','FontSize',30);
set(ylh, 'Visible', 'On');
hL=legend(lname,'Interpreter','latex','FontSize',24,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.15 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
print(h,['KND_group1.png'],'-dpng','-r350')
%}

%% Violin plots of IN- and NN-distance distributions for each dataset
%{
disp('Plotting violins of IN- and NN-distance distributions for each dataset...')
% Inter-Nuclei distance
parpool(length(group));
parfor i=1:length(group)
   
    dirINDist.(gname{i}) = dir(['Distances/INDist/' 'INDist_' group{i} '.bin']);
    names{i}=natsort({dirINDist.(gname{i}).name});
    INall.(gname{i})=[];
    Call.(gname{i}) =[];
    for j=1:length(tp)
        fileid = fopen(['Distances/INDist/' names{i}{j}],'r');
        INDist.(gname{i}).(tp{j}) = fread(fileid,'double');
        fclose(fileid);
        C.(gname{i}).(tp{j})=cell(length(INDist.(gname{i}).(tp{j})),1);
        C.(gname{i}).(tp{j})(:)={tp{j}};
        
        INall.(gname{i}) = [INall.(gname{i}) ; INDist.(gname{i}).(tp{j})];
        Call.(gname{i})  = [Call.(gname{i}) ; C.(gname{i}).(tp{j})];
    end
    
    h=figure('Name',gname{i},'Position', [200, 200, 1200, 600]);
    hold on
    violinplot(INall.(gname{i}),Call.(gname{i}),'GroupOrder',tp)
    xlabel('Times $(days)$')
    ylabel('Inter-Nuclei Distance $(\mu m)$')
    hold off
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['Figures/Violin_IND_' gname{i} '.png'],'-dpng','-r0')
end
delete(gcp('nocreate'))

% Nearest-Neighbor distance
for i=1:length(group)
   
    dirKNDist.(gname{i}) = dir(['Distances/KNDist/' 'KNDist_' group{i} '.bin']);
    names{i}=natsort({dirKNDist.(gname{i}).name});
    KNall.(gname{i})=[];
    Call.(gname{i}) =[];
    for j=1:length(tp)
        fileid = fopen(['Distances/KNDist/' names{i}{j}],'r');
        KNDist.(gname{i}).(tp{j}) = fread(fileid,'double');
        fclose(fileid);
        C.(gname{i}).(tp{j})=cell(length(KNDist.(gname{i}).(tp{j})),1);
        C.(gname{i}).(tp{j})(:)={tp{j}};
        
        KNall.(gname{i}) = [KNall.(gname{i}) ; KNDist.(gname{i}).(tp{j})];
        Call.(gname{i})  = [Call.(gname{i}) ; C.(gname{i}).(tp{j})];
    end
    
    h=figure('Name',gname{i},'Position', [200, 200, 1200, 600]);
    hold on
    violinplot(KNall.(gname{i}),Call.(gname{i}),'GroupOrder',tp)
    xlabel('Times $(days)$')
    ylabel('Nearest-Neighbor Distance $(\mu m)$')
    hold off
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['Figures/Violin_NND_' gname{i} '.png'],'-dpng','-r0')
end
%}

%% Plot variations over time
%{
disp('Plotting variations over time...')
for i=1:length(group)
    h=figure('Name',['Var_' gname{i}],'Position', [200, 200, 1600, 800]);    
    subplot(1,2,1);
    hold on
    title('Divergence of IND Distributions')
    im1=imagesc(matIND.(gname{i}));
    colormap(flipud(gray(10))); %)
    set(gca, 'XTick', (1:7));
    set(gca, 'YTick', (1:7));
    set(gca, 'XTickLabel', tp, 'XTickLabelRotation', 0);
    set(gca, 'YTickLabel', tp, 'XTickLabelRotation', 0);
    c1 = colorbar('eastoutside','TickLabelInterpreter','latex');
    axis tight
    hold off
    
    subplot(1,2,2);
    hold on
    title('Divergence of NND Distributions')
    im2=imagesc(matKND.(gname{i}));
    colormap(flipud(gray(10)));
    set(gca, 'XTick', (1:7));
    set(gca, 'YTick', (1:7));
    set(gca, 'XTickLabel', tp, 'XTickLabelRotation', 0);
    set(gca, 'YTickLabel', tp, 'XTickLabelRotation', 0);
    c2 = colorbar('eastoutside','TickLabelInterpreter','latex');
    axis tight
    hold off
    
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['Figures/Variations_' gname{i} '.pdf'],'-dpdf','-r0')
end
%}