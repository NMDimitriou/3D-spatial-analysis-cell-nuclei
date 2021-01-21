function varargout = calc_ind_knd(coord,name)
%% Plots the inter-nucleic distances and the nearest-neighbor distances.
% input: the coordinates of the nuclei centroids, and the name of the output file
% output: two files that contain the distances
%         two files with the corresponding distributions
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020

INDist = pdist(coord, 'euclidean'); % Inter nucleic distance 
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


