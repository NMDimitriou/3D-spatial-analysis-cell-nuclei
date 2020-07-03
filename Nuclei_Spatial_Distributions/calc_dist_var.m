function varargout = calc_dist_var(INDist,KNDist,name1,name2)
%% Computes variation between distributions using the Kullback-Leibler divergence
% Input: 
%   INDist: Inter-Nuclei distances
%   KNDist: Nearest-Neighbour distances
%   name1, name2: the names for the output files
% Output: the files with the KL divergence of the distributions
% Author: Nikolaos M. Dimitriou, 
% McGill University, 2020

KLdiv_IN = [];
KLdiv_NN = [];
INDist=struct2cell(INDist);
KNDist=struct2cell(KNDist);

% Inter-Nuclei distance
for i = 1:length(INDist)-1
    for j = i+1:length(INDist)

    INDist1 = INDist{i};
    INDist2 = INDist{j};

    maxINDist = max(max(INDist1),max(INDist2));
    LstCount = maxINDist/100;
    
    pts = 0:LstCount:maxINDist;
    
    [f1,x1] = ksdensity(INDist1, pts);
    [f2,x2] = ksdensity(INDist2, pts);

    kl_dist = mean((f1-f2).^2);
    KLdiv_IN = [KLdiv_IN;i,j,kl_dist];
    
    end
end

% Nuclei Nearest Neighbor distance
for i = 1:length(KNDist)-1
    for j = i+1:length(KNDist)

    NNDist1 = KNDist{i};
    NNDist2 = KNDist{j};

    maxNNDist = max(max(NNDist1),max(NNDist2));
    LstCount = maxNNDist/100;
    
    pts = 0:LstCount:maxNNDist;
    
    [f1,x1] = ksdensity(NNDist1, pts);
    [f2,x2] = ksdensity(NNDist2, pts);

    kl_dist = mean((f1-f2).^2);
    KLdiv_NN = [KLdiv_NN;i,j,kl_dist];
    
    end
end

writematrix(KLdiv_IN,name1);
writematrix(KLdiv_NN,name2);

