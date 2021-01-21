%% Plot distances and number of nuclei for all time points, in each sample
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020
clear; clc; close all;

tp      = {'D0' 'D2' 'D5' 'D7' 'D9' 'D12' 'D14'};
% Series 1
group   = {'A*C*.txt','A*E*.txt','B*E*.txt','B*N*.txt','B*W*.txt','F*W*.txt'};
gname   = {'AC','AE','BE','BN','BW','FW'};
dir_in  = '../res_coord_scaled/';
dir_out = 'Density_double_precision';

if ~exist(dir_out, 'dir')
    mkdir(dir_out)
end

lg    = length(group);
disp(['Number of datasets: ' num2str(lg)]);
time  = [0 2 5 7 9 12 14];
lt    = length(time);

%run plotopt.m

%% For grid points 480x480x176 multiples of 16 (2500x2500x917um space dimensions)
dsxy = 5.208333333333333; % downscale parameter for xy-plane
dsz  = 917/176; % downscale parameter for z-dimension
sz = [2500/dsxy,2500/dsxy,917/dsz];
disp(['Initializing density estmation with dsxy=' num2str(dsxy) ', dz=' num2str(dsz)]);

% Import coordinates
disp('Importing coordinates...')
for i=1:lg
    for j=1:lt
       
        samp{i,j}=dir([dir_in tp{j} '/' group{i}]);
        coord.(gname{i}).(tp{j})=readmatrix([samp{i,j}.folder '/' samp{i,j}.name]);
        count.(gname{i}).(tp{j})=length(coord.(gname{i}).(tp{j})(:,1));
        % Scale them 
        coord.(gname{i}).(tp{j})(:,1:2)=ceil(coord.(gname{i}).(tp{j})(:,1:2)./dsxy);
        coord.(gname{i}).(tp{j})(:,3  )=ceil(coord.(gname{i}).(tp{j})(:,3  )./dsz) ;
        % Shift all coordinates by 1 to remove zeros
        coord.(gname{i}).(tp{j})(:,1:2)=coord.(gname{i}).(tp{j})(:,1:2)+1;

    end
end

%% Convert centroids to density
disp('Converting points to density...')
[X1,X2,X3] = meshgrid(1:sz(1),1:sz(2),1:sz(3));
d          = 3;
grid       = reshape([X1(:),X2(:),X3(:)],sz(1)*sz(2)*sz(3),d);
dens       = struct;
denscell   = {};
%parpool(lg);
for i=1:lg  
    for j=1:lt
	disp(['Calculating density for ' gname{i} ' at day ' tp{j}]);    
	cmt = coord.(gname{i}).(tp{j}); 
        dmt = akde(cmt,grid);
        denscell{i,j} = reshape(dmt,size(X1));
    end    
end
%delete(gcp('nocreate'));

for i=1:lg
	for j=1:lt
          dens.(gname{i}).(tp{j})    =denscell{i,j};	  
	end
end
%save('density.mat','-struct','dens','-v7.3');

%% Save matrices to binary files
disp('Saving...')
for i=1:lg  
    for j=1:lt
        fileid = fopen([dir_out '/' 'dens_' gname{i} '_' tp{j} '.bin'],'w'); 
        fwrite(fileid,dens.(gname{i}).(tp{j}),'double');
        fclose(fileid);
    end
end

disp('Finished!')
%---------------------------------------------------------
