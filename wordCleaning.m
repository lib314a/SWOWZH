clear;
clc;

%% Settings
addpath('data')
addpath('data/dictionaries')
report = struct();

%% Inputs
load('SWOW-ZH_raw.mat'); 
vNames = respart.Properties.VariableNames;
raw = table2cell(respart); 
clear respart

load("tradCues.mat")
load("tradRes.mat")
load("englishRes.mat")
load("erRes.mat")
load("longRes.mat")
load("unsplitedRes.mat")
load("symbolRes.mat")

for i = 1:length(raw)
    raw{i,16} = raw{i,13};
    raw{i,17} = raw{i,14};
    raw{i,18} = raw{i,15};
end

report.inputDiscription.participants = length(unique(raw(:,3)));
report.inputDiscription.cues = length(unique(raw(:,12)));
report.inputDiscription.types = length(unique(raw(:,16:18)));
report.inputDiscription.sheets = length(raw);
report.inputDiscription = struct2table(report.inputDiscription);

%% Responses cleaning: symbolRes (tag: #Symbol)
rSymbol = {}; count = 0;
for i = 1:length(symbolRes) % R1Raw
    idx = find(strcmp(raw(:,16),symbolRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {symbolRes{i,2},raw{idx(j),17},raw{idx(j),18}};
            count = count + 1;
            rSymbol{count,1} = idx(j);
            rSymbol(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(symbolRes) % R2Raw
    idx = find(strcmp(raw(:,17),symbolRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},symbolRes{i,2},raw{idx(j),18}};
            idxin = find(cell2mat(rSymbol(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw not in [rSymbol]
                count = count + 1;
                rSymbol{count,1} = idx(j);
                rSymbol(count,2:4) = line(1,1:3);
            else
                rSymbol{idxin,1} = idx(j);
                rSymbol(idxin,3:4) = line(1,2:3);
            end
        end
    end
end
for i = 1:length(symbolRes) % R3Raw
    idx = find(strcmp(raw(:,18),symbolRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},raw{idx(j),17},symbolRes{i,2}};
            idxin = find(cell2mat(rSymbol(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rSymbol]
                count = count + 1;
                rSymbol{count,1} = idx(j);
                rSymbol(count,2:4) = line(1,1:3);
            else
                rSymbol{idxin,1} = idx(j);
                rSymbol(idxin,4) = line(1,3);
            end
        end
    end
end
for i = 1:length(rSymbol)
    idx = rSymbol{i,1};
    raw(idx,16:18) = rSymbol(i,2:4);
end

report.sheetsChange.Symbol = length(rSymbol);

%% Responses cleaning: unsplitedRes
rSplit = {}; count = 0;
for i = 1:length(unsplitedRes) % R1Raw
    idx = find(strcmp(raw(:,16),unsplitedRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = [unsplitedRes{i,2},raw{idx(j),17},raw{idx(j),18}];
            line(cellfun(@isempty,line)) = [];
            count = count + 1;
            rSplit{count,1} = idx(j);
            rSplit(count,2:4) = line(1,1:3); % Remain first three responses
        end
    end
end
for i = 1:length(unsplitedRes) % R2Raw
    idx = find(strcmp(raw(:,17),unsplitedRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            idxin = find(cell2mat(rSplit(:,1))==idx(j));
            if isempty(idxin) == 1 % If R1Raw not in [rSplit]
                line = [raw{idx(j),16},unsplitedRes{i,2},raw{idx(j),18}];
                line(cellfun(@isempty,line)) = [];
                count = count + 1;
                rSplit{count,1} = idx(j);
                rSplit(count,2:4) = line(1,1:3); % Remain first three responses
            else
                line = [rSplit{idxin,2:4},unsplitedRes{i,2},raw{idx(j),18}];
                line(cellfun(@isempty,line)) = [];
                rSplit{idxin,1} = idx(j);
                rSplit(idxin,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:length(unsplitedRes) % R3Raw
    idx = find(strcmp(raw(:,18),unsplitedRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            idxin = find(cell2mat(rSplit(:,1))==idx(j));
            if isempty(idxin) == 1 % If R1Raw and R2Raw not in [rSplit]
                line = [raw{idx(j),16},raw{idx(j),17},unsplitedRes{i,2}];
                line(cellfun(@isempty,line)) = [];
                count = count + 1;
                rSplit{count,1} = idx(j);
                rSplit(count,2:4) = line(1,1:3); % Remain first three responses
            else
                line = [rSplit{idxin,2:4},unsplitedRes{i,2}];
                line(cellfun(@isempty,line)) = [];
                rSplit{idxin,1} = idx(j);
                rSplit(idxin,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:length(rSplit)
    idx = rSplit{i,1};
    raw(idx,16:18) = rSplit(i,2:4);
end

report.sheetsChange.Unplited = length(rSplit);

%% Responses cleaning: longRes (tag: #Long)
rLong = {}; count = 0;
for i = 1:length(longRes) % R1Raw
    idx = find(strcmp(raw(:,16),longRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {longRes{i,2},raw{idx(j),17},raw{idx(j),18}};
            count = count + 1;
            rLong{count,1} = idx(j);
            rLong(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(longRes) % R2Raw
    idx = find(strcmp(raw(:,17),longRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},longRes{i,2},raw{idx(j),18}};
            idxin = find(cell2mat(rLong(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw not in [rLong]
                count = count + 1;
                rLong{count,1} = idx(j);
                rLong(count,2:4) = line(1,1:3);
            else
                rLong{idxin,1} = idx(j);
                rLong(idxin,3:4) = line(1,2:3);
            end
        end
    end
end
for i = 1:length(longRes) % R3Raw
    idx = find(strcmp(raw(:,18),longRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},raw{idx(j),17},longRes{i,2}};
            idxin = find(cell2mat(rLong(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rLong]
                count = count + 1;
                rLong{count,1} = idx(j);
                rLong(count,2:4) = line(1,1:3);
            else
                rLong{idxin,1} = idx(j);
                rLong(idxin,4) = line(1,3);
            end
        end
    end
end
for i = 1:length(rLong)
    idx = rLong{i,1};
    raw(idx,16:18) = rLong(i,2:4);
end

report.sheetsChange.Long = length(rLong);

%% Responses cleaning: englishRes
rEn = {}; count = 0;
for i = 1:length(englishRes) % R1Raw
    idx = find(strcmp(raw(:,16),englishRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {englishRes{i,2},raw{idx(j),17},raw{idx(j),18}};
            count = count + 1;
            rEn{count,1} = idx(j);
            rEn(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(englishRes) % R2Raw
    idx = find(strcmp(raw(:,17),englishRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},englishRes{i,2},raw{idx(j),18}};
            idxin = find(cell2mat(rEn(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw not in [rEn]
                count = count + 1;
                rEn{count,1} = idx(j);
                rEn(count,2:4) = line(1,1:3);
            else
                rEn{idxin,1} = idx(j);
                rEn(idxin,3:4) = line(1,2:3);
            end
        end
    end
end
for i = 1:length(englishRes) % R3Raw
    idx = find(strcmp(raw(:,18),englishRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},raw{idx(j),17},englishRes{i,2}};
            idxin = find(cell2mat(rEn(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rEn]
                count = count + 1;
                rEn{count,1} = idx(j);
                rEn(count,2:4) = line(1,1:3);
            else
                rEn{idxin,1} = idx(j);
                rEn(idxin,4) = line(1,3);
            end
        end
    end
end
for i = 1:length(rEn)
    idx = rEn{i,1};
    raw(idx,16:18) = rEn(i,2:4);
end

report.sheetsChange.English = length(rEn);

%% Cue words & responses cleaning: Traditional Chinses
cTrad = {}; count = 0; % Cue words
for i = 1:length(tradCues)
    idx = find(strcmp(raw(:,12),tradCues{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            count = count + 1;
            cTrad{count,1} = idx(j);
            cTrad{count,2}= tradCues{i,2};
        end
    end
end
for i = 1:length(cTrad)
    idx = cTrad{i,1};
    raw(idx,12) = cTrad(i,2);
end

report.sheetsChange.Tradcues = length(cTrad);

rTrad = {}; count = 0;
for i = 1:length(tradRes) % R1Raw
    idx = find(strcmp(raw(:,16),tradRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {tradRes{i,2},raw{idx(j),17},raw{idx(j),18}};
            count = count + 1;
            rTrad{count,1} = idx(j);
            rTrad(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(tradRes) % R2Raw
    idx = find(strcmp(raw(:,17),tradRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},tradRes{i,2},raw{idx(j),18}};
            idxin = find(cell2mat(rTrad(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw not in [rTrad]
                count = count + 1;
                rTrad{count,1} = idx(j);
                rTrad(count,2:4) = line(1,1:3);
            else
                rTrad{idxin,1} = idx(j);
                rTrad(idxin,3:4) = line(1,2:3);
            end
        end
    end
end
for i = 1:length(tradRes) % R3Raw
    idx = find(strcmp(raw(:,18),tradRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},raw{idx(j),17},tradRes{i,2}};
            idxin = find(cell2mat(rTrad(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rTrad]
                count = count + 1;
                rTrad{count,1} = idx(j);
                rTrad(count,2:4) = line(1,1:3);
            else
                rTrad{idxin,1} = idx(j);
                rTrad(idxin,4) = line(1,3);
            end
        end
    end
end
for i = 1:size(rTrad,1)
    idx = rTrad{i,1};
    raw(idx,16:18) = rTrad(i,2:4);
end

report.sheetsChange.Tradres = length(rTrad);

%% Responses cleaning: erRes
rEr = {}; count = 0;
for i = 1:length(erRes) % R1Raw
    idx = find(strcmp(raw(:,16),erRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {erRes{i,2},raw{idx(j),17},raw{idx(j),18}};
            count = count + 1;
            rEr{count,1} = idx(j);
            rEr(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(erRes) % R2Raw
    idx = find(strcmp(raw(:,17),erRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},erRes{i,2},raw{idx(j),18}};
            idxin = find(cell2mat(rEr(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw not in [rEr]
                count = count + 1;
                rEr{count,1} = idx(j);
                rEr(count,2:4) = line(1,1:3);
            else
                rEr{idxin,1} = idx(j);
                rEr(idxin,3:4) = line(1,2:3);
            end
        end
    end
end
for i = 1:length(erRes) % R3Raw
    idx = find(strcmp(raw(:,18),erRes{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),16},raw{idx(j),17},erRes{i,2}};
            idxin = find(cell2mat(rEr(:,1))==idx(j));
            if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rEr]
                count = count + 1;
                rEr{count,1} = idx(j);
                rEr(count,2:4) = line(1,1:3);
            else
                rEr{idxin,1} = idx(j);
                rEr(idxin,4) = line(1,3);
            end
        end
    end
end
for i = 1:length(rEr)
    idx = rEr{i,1};
    raw(idx,16:18) = rEr(i,2:4);
end

report.sheetsChange.Er = length(rEr);

%% Responses cleaning: repeatRes (tag: #Repeat)
for i = 1:length(raw)
    idxm = find(strcmp(raw(i,16:18),'没有了'));
    idxu = find(strcmp(raw(i,16:18),'Unknown word'));
    idxb = find(strcmp(raw(i,16:18),'不认识'));
    idxs = find(strcmp(raw(i,16:18),'#Symbol'));
    idxl = find(strcmp(raw(i,16:18),'#Long'));
    idx = [idxm,idxu,idxb,idxs,idxl];
    idx = setdiff([1:3],idx);
    line = raw(i,16:18);
    line = line(1,idx);
    if length(line) - length(unique(line)) ~= 0
        line = tabulate(line);
        idx = find(cell2mat(line(:,2))~=1);
        repeat = line{idx,1};
        idx = find(strcmp(raw(i,16:18),repeat));
        idx = idx(2:length(idx))+15;
        for j = 1:length(idx)
            raw{i,idx(j)} = '#Repeat';
        end
    end
end

idx1 = find(strcmp(raw(:,16),'#Repeat'));
idx2 = find(strcmp(raw(:,17),'#Repeat'));
idx3 = find(strcmp(raw(:,18),'#Repeat'));
idx = unique([idx1;idx2;idx3]); idx = unique(idx);

report.sheetsChange.Repeat = length(idx);
report.sheetsChange = struct2table(report.sheetsChange);

report.mark.Repeat_sameSheet = length(find(strcmp(raw(:,16:18),'#Repeat')));
report.mark.Symbol = length(find(strcmp(raw(:,16:18),'#Symbol')));
report.mark.Long = length(find(strcmp(raw(:,16:18),'#Long')));
report.mark = struct2table(report.mark);

%% Outputs
report.outputDiscription.participants = length(unique(raw(:,3)));
report.outputDiscription.cues = length(unique(raw(:,12)));
report.outputDiscription.types = length(unique(raw(:,16:18)));
report.outputDiscription.sheets = length(raw);
report.outputDiscription = struct2table(report.outputDiscription);
save('output/reports/wordCleaning','report');

vNames = [vNames,{'R1','R2','R3'}];
raw = cell2table(raw);
raw.Properties.VariableNames = vNames;
save("data/SWOW-ZH_wordcleaning","raw");
writetable(raw,'data/SWOW-ZH_wordcleaning.csv');