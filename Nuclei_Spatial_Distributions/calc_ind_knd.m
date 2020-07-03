function varargout = calc_ind_knd(coord,name)
%% Plots the inter-nuclei distances and the nearest-neighbor distances.
% input: the coordinates of the nuclei centroids, and fstr the color of the
% line
% output: the plots
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020

INDist = pdist(coord, 'euclidean'); % Inter nuclei distance 
[f1,xi1] = ksdensity(INDist);
fileID   = fopen(['Distances/INDist/INDist_' name '.bin'],'w');
fwrite(fileID,INDist,'double');
fclose(fileID);
%writematrix(INDist,['Distances/INDist/INDist_' name])
writematrix([f1;xi1],['Distances/Distributions/IND_' name]);



[idx,NNDist] = knnsearch(coord, coord,'K',2); % nearest neighbor search
[f2,xi2]     = ksdensity(NNDist(:,2));
fileID       = fopen(['Distances/KNDist/KNDist_' name '.bin'],'w');
fwrite(fileID,NNDist(:,2),'double');
fclose(fileID);
%writematrix(NNDist(:,2)./scale,['Distances/KNDist/KNDist_' name])
writematrix([f2;xi2],['Distances/Distributions/KND_' name]);


