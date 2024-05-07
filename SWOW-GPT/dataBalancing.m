clear;
clc;

%% Settings
addpath('data')
report = struct();

%% Inputs
load("SWOW-ZH_partcleaning.mat"); % [raw]
vNames = raw.Properties.VariableNames;
raw = table2cell(raw); 

abscon = importdata('164words.txt');
idx = [];
for i = 1:length(abscon)
    idx = [idx;find(strcmp(raw(:,12),abscon{i}))];
end
raw(idx,:) = [];
swow = raw;

load("SWOW-GPT_wordcleaning"); % [raw]
st = length(swow);
for i = (st+1):(st+length(raw))
    swow{i,12} = raw{(i-st),1};
    swow{i,13} = raw{(i-st),2};
    swow{i,14} = raw{(i-st),3};
    swow{i,15} = raw{(i-st),4};
    swow{i,16} = raw{(i-st),5};
    swow{i,17} = raw{(i-st),6};
    swow{i,18} = raw{(i-st),7};
    swow{i,6} = 'PUTON';
end

raw = swow;

report.inputDiscription.participants = length(unique(raw(:,3)));
report.inputDiscription.cues = length(unique(raw(:,12)));
report.inputDiscription.types = length(unique(raw(:,16:18)));
report.inputDiscription.sheets = length(raw);
report.inputDiscription = struct2table(report.inputDiscription);

%% Rate sheets according to priority
%%   3 for three responses, 2 for two responses, 1 for one respones, 0 for zero responses
%%   +0.5 if sheets are from PUTON
mark = {'#Unknown','#Missing'};
for i = 1:length(raw)
    count = 0;
    if isempty(find(strcmp(mark,raw{i,16}))) == 0
        count = count + 1;
    end
    if isempty(find(strcmp(mark,raw{i,17}))) == 0
        count = count + 1;
    end
    if isempty(find(strcmp(mark,raw{i,18}))) == 0
        count = count + 1;
    end
    raw{i,19} = 3 - count;
end

idx = find(strcmp(raw(:,6),"PUTON"));
for i = 1:length(idx)
    raw{idx(i),19} = raw{idx(i),19} + 0.5;
end

%% Remain 55 participants for each cue word
cue = unique(raw(:,12)); % Cue words
for i = 1:length(cue)
    idx = find(strcmp(raw(:,12),cue{i,1}));
    rate = cell2mat(raw(idx,19));
    sheets = raw(idx,:);
    [rateSorted,seq] = sort(rate,'descend');
    sheets = sheets(seq,:);
    cue{i,2} = sheets;
end
for i = 1:length(cue)
    cue{i,3} = cue{i,2};
end
for i = 1:length(cue)
    if size(cue{i,3},1) >= 55 % Remain 55 cue words per cue
        cue{i,4} = cue{i,3}(1:55,:);
        cue{i,5} = 0;
    else
        cue{i,4} = cue{i,3};
        cue{i,5} = 55 - size(cue{i,3},1);
    end
end
raw = {};
badcue = {};
for i = 1:length(cue)
    if cue{i,5} == 0
        raw = [raw;cue{i,4}];
    else
        dic = {cue{i,1},cue{i,2}{1,11},cue{i,5}};
        badcue = [badcue;dic];
    end
end
[~,seq] = sort(cell2mat(badcue(:,3)),'descend');
badcue = badcue(seq,:);
report.badcues = badcue;
report.badsets = tabulate(badcue(:,2));

report.mark.R1Missing = length(find(strcmp(raw(:,16),'#Missing')));
report.mark.R2Missing = length(find(strcmp(raw(:,17),'#Missing')));
report.mark.R3Missing = length(find(strcmp(raw(:,18),'#Missing')));
report.mark.Unknown = length(find(strcmp(raw(:,16:18),'#Unknown')));
report.ratio.R1Missing = report.mark.R1Missing/length(raw);
report.ratio.R2Missing = report.mark.R2Missing/length(raw);
report.ratio.R3Missing = report.mark.R3Missing/length(raw);
report.ratio.Unknown = report.mark.Unknown/(length(raw)*3);
report.ratio.NaN = (report.mark.R1Missing + report.mark.R2Missing + report.mark.R3Missing + report.mark.Unknown)/(length(raw)*3);

report.mark = struct2table(report.mark);
report.ratio = struct2table(report.ratio);

%% Outputs
report.outputDiscription.participants = length(unique(raw(:,3)));
report.outputDiscription.cues = length(unique(raw(:,12)));
report.outputDiscription.types = length(unique(raw(:,16:18)));
report.outputDiscription.sheets = length(raw);
report.outputDiscription = struct2table(report.outputDiscription);
save('reports/dataBalancing','report');

save("data/SWOW-GPT_R55","raw");
writetable(cell2table(raw),'data/SWOW-GPT_R55.csv');