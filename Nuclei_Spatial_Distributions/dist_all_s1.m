%% Plot distances and number of nuclei for all time points, in each sample
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020
clear; clc; close all;

% the parent directory that contains the subdirectories of the time-points
file1  = 'res_coord_scaled/';

% the list of the time-point subdirectories that contain the data
tp     = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
time   = [0 2 5 7 9 12 14];

% the name of the data files for the coordinates
group1 = {'A*C*.txt','A*E*.txt','B*E*.txt','B*N*.txt','B*W*.txt','F*W*.txt'};
gname1 = {'Sample_1', 'Sample_2', 'Sample_3', 'Sample_4', 'Sample_5', 'Sample_6' };

nsamp  = length(group1);
ntp    = length(tp);

run plotopt.m

%% Import coordinates
disp('1. Importing coordinates...')
% Series 1

for i=1:nsamp
   
    for j=1:ntp
       
        samp1{i,j}=dir([file1 tp{j} '/' group1{i}]); %
        coord.(gname1{i}).(tp{j})=readmatrix([samp1{i,j}.folder '/' samp1{i,j}.name]);
        count.(gname1{i}).(tp{j})=length(coord.(gname1{i}).(tp{j})(:,1));

    end
end
disp('Finished importing coordinates...')

%% Calculate distances and save them
disp('2. Calculating and saving distances...')

%parpool(nsamp);
for i=1:nsamp
    for k=1:ntp
   
        calc_ind_knd(coord.(gname1{i}).(tp{k}),samp1{i,k}.name)
    
    end
end
disp('Finished calculating and saving distances!')
%delete(gcp('nocreate'))


%% Import distance distributions
disp('3. Importing distance distributions...')

for i=1:nsamp
    for k=1:ntp
    
    sampIND{i,k}=dir(['Distances/Distributions/' 'IND_' samp1{i,k}.name]);
    sampKND{i,k}=dir(['Distances/Distributions/' 'KND_' samp1{i,k}.name]);
           
    IND.(gname1{i}).(tp{k})=readmatrix(['Distances/Distributions/' sampIND{i,k}.name]);
    KND.(gname1{i}).(tp{k})=readmatrix(['Distances/Distributions/' sampKND{i,k}.name]);
       
    end
end
disp('Finished importing distance distributions!')
clear sampIND sampKND

%% Plot inter-nucleic, and nearest neighbor distance
disp('4. Plotting IN-, NN- distances...')

for i=1:nsamp
    h=figure('Name',['IND_KND_' gname1{i}],'Position', [200, 200, 1200, 900]);
    alphaval=0.8;
    cmap=winter(7);
    for k=1:ntp
        subplot(1,2,1);
        
        hax=gca;
        hold on
        xi1=IND.(gname1{i}).(tp{k})(2,:);
        f1 =IND.(gname1{i}).(tp{k})(1,:);
        h1=plot(xi1./1000,f1,'LineWidth',4,'Color',cmap(k,:));
        h1.Color(4) = alphaval; 
        xlabel('IN Distances $(mm)$')
        ylabel('PDF') 
             
        subplot(1,2,2);
        hbx=gca;
        hold on
        xi2=KND.(gname1{i}).(tp{k})(2,:);
        f2 =KND.(gname1{i}).(tp{k})(1,:); 
        h2=plot(xi2./1000,f2,'LineWidth',4,'Color',cmap(k,:));
        h2.Color(4) = alphaval; 
        xlabel('NN Distances $(mm)$') 
        colormap(cmap)
        caxis([0 14])
        colorbar(hbx,'Ticks',[0,14],'TickLabels',{'D0' 'D14'},'TickLabelInterpreter','latex'); %
    end
    hold off
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['test_IN_NN_' gname1{i} '.png'],'-dpng','-r350')
end
disp('Finished plotting IN-, NN- distances!')

%% Estimate variations between distributions
% import distances
disp('5. Importing distances...')
for i=1:nsamp
    for k=1:ntp
    
    sampINDist{i,k}=dir(['Distances/INDist/' 'INDist_' samp1{i,k}.name '.bin' ]);
    sampKNDist{i,k}=dir(['Distances/KNDist/' 'KNDist_' samp1{i,k}.name '.bin']);
         
    fileID=fopen([sampINDist{i,k}.folder '/' sampINDist{i,k}.name],'r');
    INDist.(gname1{i}).(tp{k})=fread(fileID,'double');
    fclose(fileID);
        
    fileID=fopen([sampKNDist{i,k}.folder '/' sampKNDist{i,k}.name],'r');
    KNDist.(gname1{i}).(tp{k})=fread(fileID,'double');
    fclose(fileID);
      
    end
end
disp('Finished importing distances!')
clear sampINDist sampKNDist 

%% calculate the cosine similarity between distributions
disp('6. Estimating similarity...')
%parpool(length(group));
for i=1:nsamp
   
    calc_dist_var(INDist.(gname1{i}),KNDist.(gname1{i}),gname1{i});
    
end
%delete(gcp('nocreate'))
disp('Finished estimating similarity!')

%% Import variations between distributions 
disp('7. Importing variations between distributions...')

for i=1:nsamp
    
    varIND.(gname1{i})=readmatrix(['Distances/Variability/' 'Var_INDist_' gname1{i} '.txt']);
    varKND.(gname1{i})=readmatrix(['Distances/Variability/' 'Var_KNDist_' gname1{i} '.txt']);
%{
    matIND.(gname{i})=zeros(7,7);
    matKND.(gname{i})=zeros(7,7);
    for j=1:length(varIND.(gname{i}))
        matIND.(gname{i})(varIND.(gname{i})(j,1),varIND.(gname{i})(j,2))=varIND.(gname{i})(j,3);
        matKND.(gname{i})(varKND.(gname{i})(j,1),varKND.(gname{i})(j,2))=varKND.(gname{i})(j,3);
    end
%}
end

varINDt=struct2array(varIND);
varINDt=vertcat(varINDt(:,1:3),varINDt(:,4:6),varINDt(:,7:9),varINDt(:,10:12),varINDt(:,13:15),varINDt(:,16:18));

varKNDt=struct2array(varKND);
varKNDt=vertcat(varKNDt(:,1:3),varKNDt(:,4:6),varKNDt(:,7:9),varKNDt(:,10:12),varKNDt(:,13:15),varKNDt(:,16:18));

varINDmean  = mean(varINDt(:,3)); 
varKNDmean  = mean(varKNDt(:,3));

varINDstd  = std(varINDt(:,3));
varKNDstd  = std(varKNDt(:,3));

disp('Finished importing variations between distributions!')
%% Plot similarity for different time-points
disp('8. Plotting similarity...')

vIND_dt = [];
vKND_dt = [];
dt  = [];

for i=1:nsamp
    
    %i-tp difference
    subin{i}=find(abs(varINDt(:,1)-varINDt(:,2))==i);
    subkn{i}=find(abs(varKNDt(:,1)-varKNDt(:,2))==i);
    len = length(subkn{i});

    vIND_dt=[vIND_dt;    varINDt(subin{i},3)]; 
    vKND_dt=[vKND_dt;    varKNDt(subkn{i},3)];
    dt     =[dt; i*ones(len,1)]; 
    
end

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
print(h,'test_violin_IN_s1.png','-dpng','-r350')

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
print(h,'test_violin_NN_s1.png','-dpng','-r350')

disp('Finished plotting similarity!')

%% Plot all the samples together
disp('9. Plotting all distance samples...')
% IND
h=figure('Name','IND','Position', [100, 100, 1200, 900]);
for i=1:ntp
    
    subplot(3,3,i);
    %subaxis(3,3,i, 'Spacing', 0.08, 'Padding', 0.015, 'Margin', 0.08);
    hax=gca;
    hold on
    for j=1:nsamp
        xi1=IND.(gname1{j}).(tp{i})(2,:);
        f1 =IND.(gname1{j}).(tp{i})(1,:);
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
hL=legend(gname1,'Interpreter','latex','FontSize',24,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.15 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
print(h,['test_IND_group1.png'],'-dpng','-r350')
%title(hh.ah,'Inter-Nucleic distance')

% KND
h=figure('Name','KND','Position', [100, 100, 1200, 900]);
for i=1:ntp
    
    subplot(3,3,i);
    %subaxis(3,3,i, 'Spacing', 0.08, 'Padding', 0.015, 'Margin', 0.08);
    hax=gca;
    hold on
    for j=1:nsamp
        xi1=KND.(gname1{j}).(tp{i})(2,:);
        f1 =KND.(gname1{j}).(tp{i})(1,:);
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
hL=legend(gname1,'Interpreter','latex','FontSize',24,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.15 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
print(h,['test_KND_group1.png'],'-dpng','-r350')
disp('Finished plotting all distance samples...')
%--------------------------------------------------------------------------

