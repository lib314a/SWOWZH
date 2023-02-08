clear;
clc;

%% Settings
addpath('data')
addpath('functions') % Functions from Brain Connectivity Toolbox (BCT) 
                       % package (http://www.brain-connectivity-toolbox.net)
val = {'R1','R123'};
report = struct();

%% Inputs
load("SWOW-ZH_R55.mat"); % [raw]
raw = table2cell(raw); 

load("SWOW-ZH_network.mat"); % [net]

%% Coverage
label = net.label; % Calculate responses tokens ratio for each cue word in componets
for k = 1:length(val)
    eval(['G = net.Gconncomp_',val{1,k},';']);
    eval(['pool = net.',val{1,k},';']);
    node = table2cell(G.Nodes);
    for i = 1:length(node)
        node{i,2} = successors(G,node{i,1});
    end
    for i = 1:length(node)
        idx = find(strcmp(label,node{i,1}));
        node{i,3} = 0;
        for j = 1:length(node{i,2})
            node{i,3} = node{i,3} + length(find(strcmp(pool{idx,1},node{i,2}{j,1})));
        end
        node{i,4} = size(pool{idx,1},1)*size(pool{idx,1},2)-length(find(strcmp(pool{idx,1},'#Missing')));
        node{i,5} = node{i,3}/node{i,4};
    end
    eval(['report.node_',val{1,k},'.all = node;']);
end

for k = 1:length(val) % Descriptive statistics of Coverage
    eval(['data = cell2mat(report.node_',val{1,k},'.all(:,5));']);
    name = ['report.coverage_',val{1,k},'.'];
    eval([name,'all = data;']);
    eval([name,'mean = mean(data);']);
    eval([name,'median = median(data);']);
    eval([name,'var = var(data);']);
    eval([name,'std = std(data);']);
    eval([name,'min = min(data);']);
    eval([name,'max = max(data);']);
    eval([name,'range = range(data);']);
    eval([name,'freq = tabulate(data);']);
    eval([name,'histogram = histogram(',name,'all);']);
end

%% Network topology (density, diameter, average shortest path length, clustering coefficient)
for k = 1:length(val)
    eval(['G = net.Gnrm_',val{1,k},';']);
    kin = mean(indegree(G)); % mean indegree
    kout = mean(outdegree(G)); % mean outdegree
    eval(['report.topology_',val{1,k},'.kin = kin;']);
    eval(['report.topology_',val{1,k},'.kout = kout;']);
    eval(['DisM = net.DisM_',val{1,k},';']); % diameter and average shortest path length
    [asplMEAN,~,~,~,diameter] = charpath(DisM);
    asplSD = std(DisM(:));
    eval(['report.topology_',val{1,k},'.asplMEAN = asplMEAN;']);
    eval(['report.topology_',val{1,k},'.asplSD = asplSD;']);
    eval(['report.topology_',val{1,k},'.diameter = diameter;']);
    eval(['AMnrm = net.AMnrm_',val{1,k},';']); % clustering coefficient
    ccall = clustering_coef_wd(AMnrm);
    ccMEAN = mean(ccall);
    ccSD = std(ccall);
    eval(['report.topology_',val{1,k},'.ccMEAN = ccMEAN;']);
    eval(['report.topology_',val{1,k},'.ccSD = ccSD;']);
end

%% Centrality (types and tokens, indegree, outdegree, PageRank, centrality, betweenness)
node = {};
for k = 1:length(val)
    eval(['G = net.Gnrm_',val{1,k},';']);
    if val{1,k} == "R1"
        pool = raw(:,16);
    else
        pool = raw(:,16:18);
    end
    node = table2cell(G.Nodes);
    for i = 1:length(node) % type (in fact, it's indegree.)
        node{i,2} = length(predecessors(G,node{i,1}));
    end  
    for i = 1:length(node) % tokens
        node{i,3} = length(find(strcmp(pool,node{i,1})));
    end
    node(:,4) = num2cell(indegree(G)); % indegree_unw
    node(:,5) = num2cell(outdegree(G)); % outdegree_unw
    node(:,6) = num2cell(indegree(G) + outdegree(G)); % degree_unw
    node(:,7) = num2cell(centrality(G,'indegree','Importance',G.Edges.Weight)); % indegree_wei
    node(:,8) = num2cell(centrality(G,'outdegree','Importance',G.Edges.Weight)); % outdegree_wei
    eval(['AMnrm = net.AMnrm_',val{1,k},';']);
    node(:,9) = num2cell(clustering_coef_bd(weight_conversion(AMnrm,'binarize'))); % clustering coefficient_unw
    node(:,10) = num2cell(clustering_coef_wd(AMnrm)); % clustering coefficient_wei
    node(:,11) = num2cell(centrality(G,'pagerank')); % page rank_unw
    node(:,12) = num2cell(centrality(G,'pagerank','Importance',G.Edges.Weight)); % page rank_wei
    node(:,13) = num2cell(centrality(G,'hubs')); % hubs_unw
    node(:,14) = num2cell(centrality(G,'hubs','Importance',G.Edges.Weight)); % hubs_wei
    node(:,15) = num2cell(centrality(G,'authorities')); % authorities_unw
    node(:,16) = num2cell(centrality(G,'authorities','Importance',G.Edges.Weight)); % authorities_wei
    eval(['AMdis = net.AMdis_',val{1,k},';']); % 1 - normalized weights = distances
    Gdis = digraph(AMdis,table2cell(G.Nodes));
    node(:,17) = num2cell(centrality(Gdis,'incloseness')); % incloseness_unw
    node(:,18) = num2cell(centrality(Gdis,'outcloseness'));% outcloseness_unw
    node(:,19) = num2cell(centrality(Gdis,'incloseness','Cost',Gdis.Edges.Weight)); % incloseness_wei
    node(:,20) = num2cell(centrality(Gdis,'outcloseness','Cost',Gdis.Edges.Weight)); % outcloseness_wei
    node(:,21) = num2cell(centrality(Gdis,'betweenness')); % betweenness_unw
    node(:,22) = num2cell(centrality(Gdis,'betweenness','Cost',Gdis.Edges.Weight)); % betweenness_wei
    centr = cell2table(node,"VariableNames",["words" "type" "token" "indegree_unw" ...
        "outdegree_unw" "degree_unw" "indegree_wei" "outdegree_wei" "cc_unw" "cc_wei" ...
        "pageRank_unw" "pageRank_wei" "hubs_unw" "hubs_wei" "authorities_unw" ...
        "authorities_wei" "incloseness_unw" "outcloseness_unw" "incloseness_wei" ...
        "outcloseness_wei" "betweenness_unw" "betweenness_wei"]);
    eval(['report.centrality_',val{1,k},' = centr;']);
end

%% Outputs
save('output/reports/centralityCalculating','report');
writetable(report.centrality_R1,'output/centrality_R1.csv');
writetable(report.centrality_R123,'output/centrality_R123.csv');