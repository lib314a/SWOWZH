clear;
clc;

%% Settings
addpath('data')

%% Inputs
load("SWOW-ZH_R55.mat"); % [raw]
raw = table2cell(raw); 

%% Generate adjacency matrix
cue = unique(raw(:,12)); % [cue]
for i = 1:length(cue) % Abstract participants information, it took a while
    idx = find(strcmp(raw(:,12),cue{i,1}));
    cue{i,2} = raw(idx,16); % R1
    cue{i,3} = raw(idx,17); % R2
    cue{i,4} = raw(idx,18); % R3
    cue{i,5} = raw(idx,16:18); % R123
end
net.label = cue(:,1); % [node]
net.R1 = cue(:,2);
net.R2 = cue(:,3);
net.R3 = cue(:,4);
net.R123 = cue(:,5);

val = {'R1','R123'}; % R2 and R3 could be added in [val] if you need.
label = net.label;
for k = 1:length(val)
    eval(['pool = net.',val{1,k},';']);
    AMnum = []; % AMnum(ij): The numbers of response j under cue word i.
    N = []; % N(i): The numbers of all response tokens under cue word i.
    AM = []; % AM: AMnum/N
    for i = 1:length(label)
        N(i,1) = 0;
        for j = 1:length(label)
            idx = find(strcmp(pool{i,1},label{j,1}));
            if (isempty(idx) == 1) && (i==j) % Delete loops
                AMnum(i,j) = 0;
            else
                AMnum(i,j) = length(idx);
                N(i,1) = N(i,1) + length(idx);
            end
        end
    end
    for i = 1:length(label)
        for j = 1:length(label)
            AM(i,j) = AMnum(i,j)/N(i,1);
        end
    end
    AMnum = AMnum - diag(diag(AMnum)); % Delete loops
    AM = AM - diag(diag(AM)); % Delete loops
    eval(['net.AMnum_',val{1,k},' = AMnum;']);
    eval(['net.N_',val{1,k},' = N;']);
    eval(['net.AM_',val{1,k},' = AM;']);
end

%% Remain strong connected components
label = net.label;
for k = 1:length(val)
    eval(['AM = net.AM_',val{1,k},';']);
    G = digraph(AM,label); % Generate graph
    eval(['net.G_',val{1,k},' = G;']);
    [bin,binsize] = conncomp(G); % Remain strong connected components
    idx = binsize(bin) == max(binsize);
    Gconncomp = subgraph(G,idx);
    eval(['net.Gconncomp_',val{1,k},' = Gconncomp;']);
    AMconncomp = adjacency(Gconncomp,'weighted');
    eval(['net. AMconncomp_',val{1,k},' =  AMconncomp;']);
    nodes = table2cell(Gconncomp.Nodes); % Cue words lost
    [~,~,idxsnodeslost] = intersect(label,nodes);
    nodeslost = label(idxsnodeslost); 
    eval(['net.nodeslost_',val{1,k},' = nodeslost;']);
    AMconncomp = full(AMconncomp); % Normalize edge weights for each row (0-1)
    AMnrm = spdiags(1./sum(AMconncomp,2),0,size(AMconncomp,1),size(AMconncomp,1))*AMconncomp; 
    eval(['net.AMnrm_',val{1,k},' = AMnrm;']);
    Gnrm = digraph(AMnrm,table2cell(Gconncomp.Nodes));
    eval(['net.Gnrm_',val{1,k},' = Gnrm;']);
    AMnrm = full(AMnrm); % Transform adjacency matrix to distances matrix
    AMdis = AMnrm;
    for i = 1:length(AMnrm)
        idx = find(AMnrm(:,i)~=0);
        AMdis(idx,i) = 1-AMnrm(idx,i); % 1 - normalized weights = distances
    end
    Gdis = digraph(AMdis,table2cell(Gconncomp.Nodes)); 
    DisM = distances(Gdis); 
    eval(['net.AMdis_',val{1,k},' = AMdis;']);
    eval(['net.DisM_',val{1,k},' = DisM;']);
end

%% Outputs
assocFrequency_R1 = net.G_R1.Edges;
assocFrequency_R123 = net.G_R123.Edges;
save('output/assocFrequency_R1','assocFrequency_R1');
save('output/assocFrequency_R123','assocFrequency_R123');
writetable(assocFrequency_R1,'output/assocFrequency_R1.csv');
writetable(assocFrequency_R123,'output/assocFrequency_R123.csv');

adjacencyMatrix_R1 = array2table(full(net.AMconncomp_R1));
adjacencyMatrix_R1.Properties.VariableNames = net.nodeslost_R1;
adjacencyMatrix_R1.Properties.RowNames = net.nodeslost_R1;
adjacencyMatrix_R123 = array2table(full(net.AMconncomp_R123));
adjacencyMatrix_R123.Properties.VariableNames = net.nodeslost_R123;
adjacencyMatrix_R123.Properties.RowNames = net.nodeslost_R123;
save('output/adjacencyMatrix_R1','adjacencyMatrix_R1');
save('output/adjacencyMatrix_R123','adjacencyMatrix_R123');
writetable(adjacencyMatrix_R1,'output/adjacencyMatrix_R1.csv');
writetable(adjacencyMatrix_R123,'output/adjacencyMatrix_R123.csv');

lostNodes_R1 = setdiff(net.label,net.nodeslost_R1);
lostNodes_R123 = setdiff(net.label,net.nodeslost_R123);
save('output/lostNodes_R1','lostNodes_R1');
save('output/lostNodes_R123','lostNodes_R123');
writecell(lostNodes_R1,'output/lostNodes_R1.csv');
writecell(lostNodes_R123,'output/lostNodes_R123.csv');

save('data/SWOW-ZH_network','net','-v7.3'); % It's larger than 2GB, takes a while to save......