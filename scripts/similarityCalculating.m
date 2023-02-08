clear;
clc;

%% Settings
addpath('data')
report = struct();
alpha = 0.75;
val = {'R1','R123'}; % R2 and R3 could be added in [val] if you need.

%% Inputs
load("SWOW-ZH_network.mat"); % [net]
for k = 1:length(val)
    eval(['report.label_',val{1,k},' = table2cell(net.Gconncomp_',val{1,k},'.Nodes);']);
end

%% Anonymous functions
% Normalize the rows of a sparse matrix A
rowNormal = @(A) spdiags(1./sum (A,2), 0, size(A,1), size(A,1)) * A;

% Calculate PPMI for a row-normalized sparse matrix A
ppmi = @(A) max(0,spfun('log2',A/spdiags((sum(A,1)./size(A,1))',0,size(A,2),size(A,2))));

% Katz paths
katzWalk = @(A,alpha) (eye(size(A,1))-alpha*A) \ eye(size(A,1)); 

% L2 norm for calculating cosine similarity
L2Norm = @(A) spdiags(1./sum(abs(A).^2,2).^0.5,0,size(A,1),size(A,1)) * A; 

%% Cosine similarity (associative strength in SWOW-EN)
for k = 1:length(val)
    eval(['AM = net.AMnrm_',val{1,k},';']);
    AM = full(L2Norm(AM) * L2Norm(AM)');
    eval(['report.cosineS_',val{1,k},' = AM;']);
end

%% PPMI
for k = 1:length(val)
    eval(['AM = net.AMnrm_',val{1,k},';']);
    AM = ppmi(AM);
    AM = rowNormal(AM);
    AM = full(L2Norm(AM) * L2Norm(AM)');
    eval(['report.ppmiS_',val{1,k},' = AM;']);
end

%% Random walk
for k = 1:length(val)
    eval(['AM = net.AMnrm_',val{1,k},';']);
    AM = ppmi(AM);
    AM = rowNormal(AM);
    AM = katzWalk(AM,alpha);
    AM = rowNormal(AM);
    AM = ppmi(AM);
    AM = rowNormal(AM);
    AM = full(L2Norm(AM) * L2Norm(AM)');
    eval(['report.rwS_',val{1,k},' = AM;']);
end

%% Random walk & Embedding (scripts from SWOW-RP)
for j = 1:length(val)
    eval(['AM = net.AMnrm_',val{1,j},';']);
    AM = ppmi(AM);
    AM = rowNormal(AM);
    D       = spdiags(ones(size(AM,1),1),0,size(AM,1),size(AM,2));
    S_1     = D + AM + AM'; % undirected paths of length 1
    S_2     = S_1 * S_1; % undirected (mediated) paths of length 2
    S_2     = rowNormal(S_2 + S_1);
    % Create semantic spaces
    ks = 300;
    for i = 1:numel(ks)
        fprintf('.');
        k = ks(i);
        [U,S,V] = svds(S_2,k);
        col = ['k' int2str(k)];
        emb.(col) = U*S; % this seems to be key, but is not indicated as such in Steyvers
    end
    eval(['report.emb_',val{1,j},' = emb.k',num2str(ks),';']);
    eval(['AM = emb.k',num2str(ks),';']);
    AM = full(L2Norm(AM) * L2Norm(AM)');
    eval(['report.embS_',val{1,j},' = AM;']);
end

%% Outputs
save('output/reports/similarityCalculating','report','-v7.3');