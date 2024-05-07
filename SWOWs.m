clear;
clc;

%% Settings
addpath('data')
addpath('data/SWOWs')
SWOWs = {'en','nl','rp'};

for x = 1:length(SWOWs)
    
    %% Inputs
    if isempty(find(strcmp(SWOWs(x),'en'))) == 0 % SWOW-EN
        raw = readtable('SWOW-EN.R100.csv');
        raw = table2cell(raw(:,10:13));
    elseif isempty(find(strcmp(SWOWs(x),'nl'))) == 0 % SWOW-NL
        load('DutchWordAssociations_April2012');
        raw(:,1) = data.cue;
        raw(:,2) = data.response1;
        raw(:,3) = data.response2;
        raw(:,4) = data.response3;
        clear data summary pp
    elseif isempty(find(strcmp(SWOWs(x),'rp'))) == 0  % SWOW-RP
        raw = readtable('SWOWRP.R70.20220426.csv');
        raw = table2cell(raw(:,10:13));
    end
    
    %% Generate network
    % Generate adjacency matrix
    cue = unique(raw(:,1)); % [cue]
    for i = 1:length(cue) % Abstract participants information, it took a while
        idx = find(strcmp(raw(:,1),cue{i,1}));
        cue{i,2} = raw(idx,2); % R1
        cue{i,3} = raw(idx,3); % R2
        cue{i,4} = raw(idx,4); % R3
        cue{i,5} = raw(idx,2:4); % R123
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
    % Remain strong connected components
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
    end
    
    %% Outputs
    if isempty(find(strcmp(SWOWs(x),'en'))) == 0 % SWOW-EN
        save('data/SWOWs/SWOW-EN_network','net','-v7.3'); % It's larger than 2GB, takes a while to save......
    elseif isempty(find(strcmp(SWOWs(x),'nl'))) == 0 % SWOW-NL
        save('data/SWOWs/SWOW-NL_network','net','-v7.3');
    elseif isempty(find(strcmp(SWOWs(x),'rp'))) == 0  % SWOW-RP
        save('data/SWOWs/SWOW-RP_network','net','-v7.3');
    end
    
    %% Centrality Calculating
    % Indegree
    node = {};
    for k = 1:length(val)
        eval(['G = net.Gnrm_',val{1,k},';']);
        node = table2cell(G.Nodes);
        node(:,2) = num2cell(indegree(G)); % indegree_unw
        centr = cell2table(node,"VariableNames",["words" "indegree_unw"]);
        eval(['report.centrality_',val{1,k},' = centr;']);
    end
    
    %% Outputs
    if isempty(find(strcmp(SWOWs(x),'en'))) == 0 % SWOW-EN
        save('data/SWOWs/centralityCalculating_EN','report');
        writetable(report.centrality_R1,'data/SWOWs/centrality_R1_EN.csv');
        writetable(report.centrality_R123,'data/SWOWs/centrality_R123_EN.csv');
    elseif isempty(find(strcmp(SWOWs(x),'nl'))) == 0 % SWOW-NL
        save('data/SWOWs/centralityCalculating_NL','report');
        writetable(report.centrality_R1,'data/SWOWs/centrality_R1_NL.csv');
        writetable(report.centrality_R123,'data/SWOWs/centrality_R123_NL.csv');
    elseif isempty(find(strcmp(SWOWs(x),'rp'))) == 0  % SWOW-RP
        save('data/SWOWs/centralityCalculating_RP','report');
        writetable(report.centrality_R1,'data/SWOWs/centrality_R1_RP.csv');
        writetable(report.centrality_R123,'data/SWOWs/centrality_R123_RP.csv');
    end
    
    clear report net
    
end