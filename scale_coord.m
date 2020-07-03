%% Scale coordinates

clear; clc;

tp    = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
group = {'A*C*.txt','A*E*.txt','B*E*.txt','B*N*.txt','B*W*.txt','F*W*.txt'};
gname = {'AC','AE','BE','BN','BW','FW'};

% import
for i=1:length(group)
   
    for j=1:length(tp)
       
        samp{i,j}=dir(['res_coord_scaled/' tp{j} '/' group{i}]);
        coord.(gname{i}).(tp{j})=readmatrix([samp{i,j}.folder '/' samp{i,j}.name]);

    end
end

% scale
scalexy = 0.4023; %p ixels/microns
scalez  = 0.05;   % slices/microns

for i=1:length(group)
   
    for j=1:length(tp)
       
        coord.(gname{i}).(tp{j})(:,1:2)=coord.(gname{i}).(tp{j})(:,1:2)/scalexy;
        coord.(gname{i}).(tp{j})(:,3  )=coord.(gname{i}).(tp{j})(:,3  )/scalez ;
        writematrix(coord.(gname{i}).(tp{j}),[samp{i,j}.folder '/' samp{i,j}.name]);

    end
end