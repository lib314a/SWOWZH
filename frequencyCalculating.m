clear;
clc;

%% Settings
addpath('data')
val = {'R1','R123'};
report = struct();

%% Inputs
load("SWOW-ZH_R55.mat"); % [raw]
raw = table2cell(raw); 

load("SWOW-ZH_network.mat"); % [net]

%% Cue statistics
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
        node{i,5} = node{i,3}/node{i,4}; % coverage
        if size(pool{1,1},2) == 1 % R1
            node{i,6} = length(find(strcmp(pool{idx,1},'#Unknown')))/55; % unknown
            node{i,7} = length(find(strcmp(pool{idx,1},'#Missing')))/55; % R1missing
        else % R123
            node{i,6} = length(find(strcmp(pool{idx,1}(:,1),'#Unknown')))/55; % unknown
            node{i,7} = length(find(strcmp(pool{idx,1}(:,1),'#Missing')))/55; % R1missing
            node{i,8} = length(find(strcmp(pool{idx,1}(:,2),'#Missing')))/55; % R2missing
            node{i,9} = length(find(strcmp(pool{idx,1}(:,3),'#Missing')))/55; % R3missing
        end
    end
    eval(['report.pool_',val{1,k},' = pool;']);
    eval(['report.node_',val{1,k},'.all = node;']);
end

for k = 1:length(val) % Descriptive statistics of coverage
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

%% Response statistics
res = unique(raw(:,16:18),'stable');
res = setdiff(res,{'#Missing';'#Unknown';'#Long';'#Repeat';'#Symbol'},'stable');

for k = 1:length(val)
    eval(['G = net.G_',val{1,k},';']);
    eval(['pool = net.',val{1,k},';']);
    cue = table2cell(G.Nodes);
    for i = 1:length(res)
        res{i,3*k-1} = 0;
        res{i,3*k} = 0;
        res{i,3*k+1} = 0;
        for j = 1:length(cue)
            idx = find(strcmp(label,cue{j,1}));
            if isempty(find(strcmp(pool{idx,1},res{i,1}))) == 0
                res{i,3*k-1} = res{i,3*k-1} + 1; % types
                res{i,3*k} = res{i,3*k} + length(find(strcmp(pool{idx,1},res{i,1}))); % tokens
                if length(find(strcmp(pool{idx,1},res{i,1}))) == 1
                res{i,3*k+1} = res{i,3*k+1} + 1; % hapax
                end
            end
        end
    end
end

report.res = res;

%% Outputs
resStats = cell2table(res);
resStats.Properties.VariableNames = {'Responses','Types_R1','Tokens_R1','Hapax_R1',...
    'Types_R123','Tokens_R123','Hapax_R123'};
writetable(resStats,'output/resStats.csv');
save('output/resStats','resStats');

cueStats_R1 = cell2table(report.node_R1.all);
cueStats_R1(:,2:4) = [];
cueStats_R1.Properties.VariableNames = {'Cues','Coverage','Unknown','R1missing'};
writetable(cueStats_R1,'output/cueStats_R1.csv');
save('output/cueStats_R1','cueStats_R1');

cueStats_R123 = cell2table(report.node_R123.all);
cueStats_R123(:,2:4) = [];
cueStats_R123.Properties.VariableNames = {'Cues','Coverage','Unknown','R1missing',...
    'R2missing','R3missing'};
writetable(cueStats_R123,'output/cueStats_R123.csv');
save('output/cueStats_R123','cueStats_R123');

save("output/reports/frequencyCalculating",'report')