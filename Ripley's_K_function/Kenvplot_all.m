%% Plots all the summary functions for three-dimensional point patterns.
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020

clear; clc; close all;

tp    = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
group = {'*A*C*.csv','*A*E*.csv','*B*E*.csv','*B*N*.csv','*B*W*.csv','*F*W*.csv'};
gname = {'AC','AE','BE','BN','BW','FW'};

run plotopt.m

%% Import the results from point pattern analysis

for i=1:length(group)
   
    samp{i}=dir(['resEnv_K_original/' group{i}]);
    names     = {samp{i}.name};
    names     = natsort(names);
    for j=1:length(tp)
        Kenv.(tp{j}).(gname{i})=readtable(['resEnv_K_original/' names{j}]);
    end
end

%% Plot
c=1;
for i=1:length(group)
    h=figure('Name',gname{i},'Position', [100, 100, 1200, 900]);
    ah = gobjects(7, 1);
    for j=1:length(tp)
       
        subplot(3,3,c);
        Kenvplot(Kenv.(tp{j}).(gname{i}));
        title(tp{j},'Interpreter','latex');
        c=c+1;
    end
    hh = mtit(' ');
    xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$');
    set(xlh, 'Visible', 'On');
    ylh=ylabel(hh.ah,'$K(r)-\frac{4}{3}\pi r^3$');
    set(ylh, 'Visible', 'On');
    hL=legend({'Observed','Random','CSR envelope'},'Interpreter','latex','FontSize',16,...
        'Location','southeastoutside','NumColumns',1);
    newPosition = [0.4 0.2 0.2 0.1];
    newUnits = 'normalized';
    set(hL,'Position', newPosition,'Units', newUnits);
    c=1;  
    
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(h,['Figures/K_' gname{i} '.png'],'-dpng','-r0')
end
%% Envelope from all distributions
h=figure('Name','Average K','Position', [100, 100, 1200, 900]);
c=1;
for i=1:length(tp)
   
    env{i}=struct2cell(Kenv.(tp{i}));
    subplot(3,3,c);
    envelope(env{i});
    title(tp{i},'Interpreter','latex');
    c=c+1;
    
end
hh = mtit(' ');
xlh=xlabel(hh.ah,'Neighborhood radius $r$ $(\mu m)$'); 
set(xlh, 'Visible', 'On');
ylh=ylabel(hh.ah,'$\langle K(r) \rangle - \frac{4}{3}\pi r^3$');
set(ylh, 'Visible', 'On');
hL=legend({'Observed','Observed SEM','Random','CSR envelope'},'Interpreter','latex','FontSize',16,...
        'Location','southeastoutside','NumColumns',1);
newPosition = [0.4 0.2 0.2 0.1];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(h,['Figures/K_average.png'],'-dpng','-r0')
