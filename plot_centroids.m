%% 3D plot of centroids
clear; clc;

tp     = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
group1 = {'A*-C.tif_plot3D.fig','A*-E.tif_plot3D.fig','B*-E.tif_plot3D.fig',...
    'B*-N.tif_plot3D.fig','B*-W.tif_plot3D.fig','F*-W.tif_plot3D.fig'};
group2 = {'AD*C.tif.txt','AD*E.tif.txt','BD*E.tif.txt','BD*N.tif.txt','BD*W.tif.txt','FD*W.tif.txt'};
gname  = {'AC','AE','BE','BN','BW','FW'};
time  = [0 2 5 7 9 12 14];

run plotopt.m

for i=1:length(group1)
   
    for j=1:length(tp)
       
        %samp1{i,j}=dir(['res_coord_scaled/' tp{j} '/' group1{i}]);
        samp2{i,j}=dir(['res_coord_scaled/' tp{j} '/' group2{i}]);
        coord.(gname{i}).(tp{j})=readmatrix([samp2{i,j}.folder '/' samp2{i,j}.name]);
        count.(gname{i}).(tp{j})=length(coord.(gname{i}).(tp{j})(:,1));

    end
end

%for i=1:length(group1)
%    for j=1:length(tp)
        
%        A(j)=hgload([samp1{i,j}.folder '/' samp1{i,j}.name]);
        
        
%    end
%end

gc=struct2array(count);
gc=struct2table(gc);
gc=table2array(gc);

gcm   = mean(gc);
gcstd = std(gc);

%%
for i=1:length(group1)
    
    f=figure('Name',gname{i},'Position', [100, 100, 1800, 800]);
    NameArray = {'MarkerSize'};
    ValueArray = {3};
    for j=1:length(tp)
        A=coord.(gname{i}).(tp{j});
        h(j)=subplot(2,4,j);
        hax=gca;
        hax.FontSize=16;
        hold on
        %plot3(A(:,1),A(:,2),A(:,3),'.','MarkerSize',2)
        scatter3(A(:,1),A(:,2),A(:,3),5,A(:,3),'filled');
        colormap(jet);
%        A(j)=copyobj(allchild(get(A(j),'CurrentAxes')),h(j));
        view(20,20)
        %view(2)
%        set(A(j),NameArray,ValueArray)
        xlabel('x $(\mu m)$');
        ylabel('y $(\mu m)$');
        zlabel('z $(\mu m)$');
        title(tp{j},'Interpreter','latex');
        axis([0 2500 0 2500 0 900])
        hold off
        clear A
    end
    subplot(2,4,8);
    hcx=gca;
    hcx.FontSize=16;
    hold on
    plot(time,struct2array(count.(gname{i})),'.-','LineWidth',4,'MarkerSize',30);
    %errorbar(time,gcm,gcstd,'.-','LineWidth',4,'MarkerSize',30)
    xlabel('time $(day)$','Interpreter','latex')
    ylabel('Nuclei count','Interpreter','latex')
    hold off
    set(f,'Units','Inches');
    pos = get(f,'Position');
    set(f,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    disp('Saving...')
    print(f,['centroids_' gname{i} '.png'],'-r300','-dpng')
end