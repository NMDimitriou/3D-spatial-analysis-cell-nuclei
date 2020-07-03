%% Plot distances and number of nuclei for all time points, in each sample
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020
clear; clc; close all;

tp    = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
group = {'A*C*.txt','A*E*.txt','B*E*.txt','B*N*.txt','B*W*.txt','F*W*.txt'};
gname = {'AC','AE','BE','BN','BW','FW'};
time  = [0 2 5 7 9 12 14];

run plotopt.m

%% Import coordinates
disp('Importing coordinates...')
for i=1:length(group)
   
    for j=1:length(tp)
       
        samp{i,j}=dir(['res_coord_scaled/' tp{j} '/' group{i}]);
        coord.(gname{i}).(tp{j})=readmatrix([samp{i,j}.folder '/' samp{i,j}.name]);
        count.(gname{i}).(tp{j})=length(coord.(gname{i}).(tp{j})(:,1));

    end
end

%% Calculate distances and save them
disp('Calculating and saving distances...')
%parpool(length(group));
for i=1:length(group)
    for k=1:length(tp)
   
        calc_ind_knd(coord.(gname{i}).(tp{k}),samp{i,k}.name)
    
    end
end
disp('Finished')
%delete(gcp('nocreate'))
%% Import distance distributions
disp('Importing distance distributions...')
for i=1:length(group)
    
    sampIND{i}=dir(['Distances/Distributions/' 'IND_' group{i}]);
    sampKND{i}=dir(['Distances/Distributions/' 'KND_' group{i}]);
    namesIND     = {sampIND{i}.name};
    namesIND     = natsort(namesIND);
    namesKND     = {sampKND{i}.name};
    namesKND     = natsort(namesKND);
    for j=1:length(tp)
           
        IND.(gname{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesIND{j}]);
        KND.(gname{i}).(tp{j})=readmatrix(['Distances/Distributions/' namesKND{j}]);
       
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

%% Estimate variations between distributions
% import distances
disp('Importing distances...')
for i=1:length(group)
    
    sampINDist{i}=dir(['Distances/INDist/' 'INDist_' group{i} '.bin']);
    sampKNDist{i}=dir(['Distances/KNDist/' 'KNDist_' group{i} '.bin']);
    namesINDist  = {sampINDist{i}.name};
    namesINDist  = natsort(namesINDist);
    namesKNDist  = {sampKNDist{i}.name};
    namesKNDist  = natsort(namesKNDist);
    
    for j=1:length(tp)
       
        fileID=fopen(['Distances/INDist/' namesINDist{j}],'r');
        INDist.(gname{i}).(tp{j})=fread(fileID,'double');
        fclose(fileID);
        
        fileID=fopen(['Distances/KNDist/' namesKNDist{j}],'r');
        KNDist.(gname{i}).(tp{j})=fread(fileID,'double');
        fclose(fileID);
        
    end
end
disp('Finished')
%clear sampINDist sampKNDist names*

% calculate the Kullback Leibler divergence between distributions
disp('Estimating divergence...')
%parpool(length(group));
for i=1:length(group)
   
    calc_dist_var(INDist.(gname{i}),KNDist.(gname{i}),...
        ['Distances/Variability/Var_INDist_' gname{i}],...
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

varINDmean = mean(varINDt(:,3));
varKNDmean = mean(varKNDt(:,3));

varINDstd  = std(varINDt(:,3));
varKNDstd  = std(varKNDt(:,3));

%% Plot inter-nuclei, and nearest neighbor distance
disp('Plotting IN-, NN- distances...')
for i=1:length(group)
    h=figure('Name',['IND_KND_' gname{i}],'Position', [200, 200, 1200, 600]);
    alphaval=0.8;
    cmap=winter(7);
    for k=1:length(tp)
        subplot(1,2,1);
        hax=gca;
        hold on
        xi1=IND.(gname{i}).(tp{k})(2,:);
        f1 =IND.(gname{i}).(tp{k})(1,:);
        h1=plot(xi1,f1,'LineWidth',4,'Color',cmap(k,:));
        h1.Color(4) = alphaval; 
        xlabel('Inter-Nuclei Distance $(\mu m)$')
        ylabel('PDF') 
        
        
        subplot(1,2,2);
        hbx=gca;
        hold on
        xi2=KND.(gname{i}).(tp{k})(2,:);
        f2 =KND.(gname{i}).(tp{k})(1,:); 
        h2=plot(xi2,f2,'LineWidth',4,'Color',cmap(k,:));
        h2.Color(4) = alphaval; 
        xlabel('Nearest-Neighbor Distance $(\mu m)$') 
        colormap(cmap)
        caxis([0 14])
        colorbar(hbx,'Ticks',[0,14],'TickLabels',{'D0' 'D14'},'TickLabelInterpreter','latex'); %
    end
    hold off
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['Figures/IN_NN_' gname{i} '.png'],'-dpng','-r0')
end

%% Plot all the samples together
% IND
h=figure('Name','IND','Position', [200, 200, 1200, 900]);
for i=1:length(tp)
    
    subplot(3,3,i);
    hold on
    for j=1:length(group)
        xi1=IND.(gname{j}).(tp{i})(2,:);
        f1 =IND.(gname{j}).(tp{i})(1,:);
        h1=plot(xi1,f1,'LineWidth',4);
    end
    title(tp{i})
    axis([-inf inf 0 8.5e-04])
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$');
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'PDF');
set(ylh, 'Visible', 'On');
hL=legend(gname,'Interpreter','latex','FontSize',16,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.2 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
%title(hh.ah,'Inter-Nuclei distance')

%% KND
h=figure('Name','KND','Position', [200, 200, 1200, 900]);
for i=1:length(tp)
    
    subplot(3,3,i);
    hold on
    for j=1:length(group)
        xi1=KND.(gname{j}).(tp{i})(2,:);
        f1 =KND.(gname{j}).(tp{i})(1,:);
        h1=plot(xi1,f1,'LineWidth',4);
    end
    title(tp{i})
    axis([-inf 200 0 0.08])
    hold off
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$');
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'PDF');
set(ylh, 'Visible', 'On');
hL=legend(gname,'Interpreter','latex','FontSize',16,...
      'Location','southeastoutside','NumColumns',2);
newPosition = [0.4 0.2 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
%title(hh.ah,'Nearest-Neighbor distance')

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
