clear;
clc;

%% Settings
addpath('data')
addpath('data/dictionaries')
report = struct();

%% Inputs
load('SWOW-GPT_raw.mat');
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
    raw{i,5} = raw{i,2};
    raw{i,6} = raw{i,3};
    raw{i,7} = raw{i,4};
end

report.inputDiscription.participants = length(unique(raw(:,3)));
report.inputDiscription.cues = length(unique(raw(:,1)));
report.inputDiscription.types = length(unique(raw(:,5:7)));
report.inputDiscription.sheets = length(raw);
report.inputDiscription = struct2table(report.inputDiscription);

%% Responses cleaning: Empty (tag: #Missing)
count = 0;
for i = 1:length(raw)
    if isempty(raw{i,2}) == 1
        raw{i,5} = '#Missing';
        count = count + 1;
    end
    if isempty(raw{i,3}) == 1
        raw{i,6} = '#Missing';
        count = count + 1;
    end
    if isempty(raw{i,4}) == 1
        raw{i,7} = '#Missing';
        count = count + 1;
    end
end
report.sheetsChange.Empty = count;

%% Responses cleaning: resWLsymbol (tag: #Symbol)
rSymbol = {}; count = 0;
for i = 1:length(resWLsymbol) % R1Raw
    idx = find(strcmp(raw(:,5),resWLsymbol{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {resWLsymbol{i,2},raw{idx(j),6},raw{idx(j),7}};
            count = count + 1;
            rSymbol{count,1} = idx(j);
            rSymbol(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(resWLsymbol) % R2Raw
    idx = find(strcmp(raw(:,6),resWLsymbol{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},resWLsymbol{i,2},raw{idx(j),7}};
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
for i = 1:length(resWLsymbol) % R3Raw
    idx = find(strcmp(raw(:,7),resWLsymbol{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},raw{idx(j),6},resWLsymbol{i,2}};
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
    raw(idx,5:7) = rSymbol(i,2:4);
end

report.sheetsChange.Symbol = length(rSymbol);

%% Responses cleaning: resWLsplit
rSplit = {}; count = 0;
for i = 1:length(resWLsplit) % R1Raw
    idx = find(strcmp(raw(:,5),resWLsplit{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = [resWLsplit{i,2},{raw{idx(j),6}},{raw{idx(j),7}}];
            line(cellfun(@isempty,line)) = [];
            count = count + 1;
            rSplit{count,1} = idx(j);
            rSplit(count,2:4) = line(1,1:3); % Remain first three responses
        end
    end
end
for i = 1:length(resWLsplit) % R2Raw
    idx = find(strcmp(raw(:,6),resWLsplit{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            if isempty(rSplit) == 0
                idxin = find(cell2mat(rSplit(:,1))==idx(j));
                if isempty(idxin) == 1 % If R1Raw not in [rSplit]
                    line = [raw{idx(j),5},resWLsplit{i,2},raw{idx(j),7}];
                    line(cellfun(@isempty,line)) = [];
                    count = count + 1;
                    rSplit{count,1} = idx(j);
                    rSplit(count,2:4) = line(1,1:3); % Remain first three responses
                else
                    line = [rSplit{idxin,2:4},resWLsplit{i,2},raw{idx(j),7}];
                    line(cellfun(@isempty,line)) = [];
                    rSplit{idxin,1} = idx(j);
                    rSplit(idxin,2:4) = line(1,1:3);
                end
            else
                line = [raw{idx(j),5},resWLsplit{i,2},raw{idx(j),7}];
                line(cellfun(@isempty,line)) = [];
                count = count + 1;
                rSplit{count,1} = idx(j);
                rSplit(count,2:4) = line(1,1:3); % Remain first three responses
            end
        end
    end
end
for i = 1:length(resWLsplit) % R3Raw
    idx = find(strcmp(raw(:,7),resWLsplit{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            idxin = find(cell2mat(rSplit(:,1))==idx(j));
            if isempty(idxin) == 1 % If R1Raw and R2Raw not in [rSplit]
                line = [raw{idx(j),5},raw{idx(j),6},resWLsplit{i,2}];
                line(cellfun(@isempty,line)) = [];
                count = count + 1;
                rSplit{count,1} = idx(j);
                rSplit(count,2:4) = line(1,1:3); % Remain first three responses
            else
                line = [rSplit{idxin,2:4},resWLsplit{i,2}];
                line(cellfun(@isempty,line)) = [];
                rSplit{idxin,1} = idx(j);
                rSplit(idxin,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:length(rSplit)
    idx = rSplit{i,1};
    raw(idx,5:7) = rSplit(i,2:4);
end

report.sheetsChange.Split = length(rSplit);

%% Responses cleaning: resWLlong (tag: #Long)
rLong = {}; count = 0;
for i = 1:length(resWLlong) % R1Raw
    idx = find(strcmp(raw(:,5),resWLlong{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {resWLlong{i,2},raw{idx(j),6},raw{idx(j),7}};
            count = count + 1;
            rLong{count,1} = idx(j);
            rLong(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(resWLlong) % R2Raw
    idx = find(strcmp(raw(:,6),resWLlong{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},resWLlong{i,2},raw{idx(j),7}};
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
for i = 1:length(resWLlong) % R3Raw
    idx = find(strcmp(raw(:,7),resWLlong{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},raw{idx(j),6},resWLlong{i,2}};
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
    raw(idx,5:7) = rLong(i,2:4);
end

report.sheetsChange.Long = length(rLong);

%% Responses cleaning: resWLen
rEn = {}; count = 0;
for i = 1:length(resWLen) % R1Raw
    idx = find(strcmp(raw(:,5),resWLen{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {resWLen{i,2},raw{idx(j),6},raw{idx(j),7}};
            count = count + 1;
            rEn{count,1} = idx(j);
            rEn(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(resWLen) % R2Raw
    idx = find(strcmp(raw(:,6),resWLen{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},resWLen{i,2},raw{idx(j),7}};
            if isempty(rEn) == 0
                idxin = find(cell2mat(rEn(:,1))==idx(j));
                if  isempty(idxin) == 1 % If R1Raw not in [rEn]
                    count = count + 1;
                    rEn{count,1} = idx(j);
                    rEn(count,2:4) = line(1,1:3);
                else
                    rEn{idxin,1} = idx(j);
                    rEn(idxin,3:4) = line(1,2:3);
                end
            else
                count = count + 1;
                rEn{count,1} = idx(j);
                rEn(count,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:length(resWLen) % R3Raw
    idx = find(strcmp(raw(:,7),resWLen{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},raw{idx(j),6},resWLen{i,2}};
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
    raw(idx,5:7) = rEn(i,2:4);
end

report.sheetsChange.En = length(rEn);

%% Cue words & responses cleaning: Traditional Chinses
cTrad = {}; count = 0; % Cue words
for i = 1:length(cueWLtrad)
    idx = find(strcmp(raw(:,1),cueWLtrad{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            count = count + 1;
            cTrad{count,1} = idx(j);
            cTrad{count,2}= cueWLtrad{i,2};
        end
    end
end
for i = 1:length(cTrad)
    idx = cTrad{i,1};
    raw(idx,1) = cTrad(i,2);
end

report.sheetsChange.Tradcues = length(cTrad);

rTrad = {}; count = 0;
for i = 1:length(resWLtrad) % R1Raw
    idx = find(strcmp(raw(:,5),resWLtrad{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {resWLtrad{i,2},raw{idx(j),6},raw{idx(j),7}};
            count = count + 1;
            rTrad{count,1} = idx(j);
            rTrad(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:length(resWLtrad) % R2Raw
    idx = find(strcmp(raw(:,6),resWLtrad{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},resWLtrad{i,2},raw{idx(j),7}};
            if isempty(rTrad) == 0
                idxin = find(cell2mat(rTrad(:,1))==idx(j));
                if isempty(idxin) == 1 % If R1Raw not in [rTrad]
                    count = count + 1;
                    rTrad{count,1} = idx(j);
                    rTrad(count,2:4) = line(1,1:3);
                else
                    for k = 1:length(idxin)
                        rTrad{idxin(k),1} = idx(j);
                        rTrad(idxin(k),3:4) = line(1,2:3);
                    end
                end
            else
                count = count + 1;
                rTrad{count,1} = idx(j);
                rTrad(count,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:length(resWLtrad) % R3Raw
    idx = find(strcmp(raw(:,7),resWLtrad{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},raw{idx(j),6},resWLtrad{i,2}};
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
    raw(idx,5:7) = rTrad(i,2:4);
end

report.sheetsChange.Tradres = length(rTrad);

%% Responses cleaning: resWLer
rEr = {}; count = 0;
for i = 1:size(resWLer,1) % R1Raw
    idx = find(strcmp(raw(:,5),resWLer{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {resWLer{i,2},raw{idx(j),6},raw{idx(j),7}};
            count = count + 1;
            rEr{count,1} = idx(j);
            rEr(count,2:4) = line(1,1:3);
        end
    end
end
for i = 1:size(resWLer,1) % R2Raw
    idx = find(strcmp(raw(:,6),resWLer{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},resWLer{i,2},raw{idx(j),7}};
            if isempty(rEr) == 0
                idxin = find(cell2mat(rEr(:,1))==idx(j));
            end
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
for i = 1:size(resWLer,1) % R3Raw
    idx = find(strcmp(raw(:,7),resWLer{i,1}));
    if isempty(idx) == 0
        for j = 1:length(idx)
            line = {raw{idx(j),5},raw{idx(j),6},resWLer{i,2}};
            if isempty(rEr) == 0
                idxin = find(cell2mat(rEr(:,1))==idx(j));
                if  isempty(idxin) == 1 % If R1Raw and R2Raw not in [rEr]
                    count = count + 1;
                    rEr{count,1} = idx(j);
                    rEr(count,2:4) = line(1,1:3);
                else
                    rEr{idxin,1} = idx(j);
                    rEr(idxin,4) = line(1,3);
                end
            else
                count = count + 1;
                rEr{count,1} = idx(j);
                rEr(count,2:4) = line(1,1:3);
            end
        end
    end
end
for i = 1:size(rEr,1)
    idx = rEr{i,1};
    raw(idx,5:7) = rEr(i,2:4);
end

report.sheetsChange.Er = length(rEr);

%% Responses cleaning: resWLrepeat (tag: #Repeat)
for i = 1:length(raw)
    idxm = find(strcmp(raw(i,5:7),'#Missing'));
    idxu = find(strcmp(raw(i,5:7),'Unknown word'));
    idxb = find(strcmp(raw(i,5:7),'不认识'));
    idxs = find(strcmp(raw(i,5:7),'#Symbol'));
    idxl = find(strcmp(raw(i,5:7),'#Long'));
    idx = [idxm,idxu,idxb,idxs,idxl];
    idx = setdiff([1:3],idx);
    line = raw(i,5:7);
    line = line(1,idx);
    if length(line) - length(unique(line)) ~= 0
        line = tabulate(line);
        idx = find(cell2mat(line(:,2))~=1);
        repeat = line{idx,1};
        idx = find(strcmp(raw(i,5:7),repeat));
        idx = idx(2:length(idx))+4;
        for j = 1:length(idx)
            raw{i,idx(j)} = '#Repeat';
        end
    end
end

idx1 = find(strcmp(raw(:,5),'#Repeat'));
idx2 = find(strcmp(raw(:,6),'#Repeat'));
idx3 = find(strcmp(raw(:,7),'#Repeat'));
idx = unique([idx1;idx2;idx3]); idx = unique(idx);

report.sheetsChange.Repeat = length(idx);
report.sheetsChange = struct2table(report.sheetsChange);

report.mark.Repeat_sameSheet = length(find(strcmp(raw(:,5:7),'#Repeat')));
report.mark.Symbol = length(find(strcmp(raw(:,5:7),'#Symbol')));
report.mark.Long = length(find(strcmp(raw(:,5:7),'#Long')));

%% Transform other tags to #Missing
report.mark.Repeat_sameSheet = length(find(strcmp(raw(:,5:7),'#Repeat')));
report.mark.Symbol = length(find(strcmp(raw(:,5:7),'#Symbol')));
report.mark.Long = length(find(strcmp(raw(:,5:7),'#Long')));

tags = {'#Symbol','#Long','#Repeat'};
for i = 1:length(raw)
    line = raw(i,5:7);
    idx = [];
    idx = find(strcmp(line,'#Symbol'));
    idx = [idx,find(strcmp(line,'#Long'))];
    idx = [idx,find(strcmp(line,'#Repeat'))];
    if isempty(idx) == 0
        for j = 1:length(idx)
            line{1,idx(j)} = '#Missing';
        end
    end
    raw(i,5:7) = line;
end

report.mark.R1Missing = length(find(strcmp(raw(:,5),'#Missing')));
report.mark.R2Missing = length(find(strcmp(raw(:,6),'#Missing')));
report.mark.R3Missing = length(find(strcmp(raw(:,7),'#Missing')));
report.mark.Unknown = length(find(strcmp(raw(:,5:7),'#Unknown')));
report.ratio.R1Missing = report.mark.R1Missing/length(raw);
report.ratio.R2Missing = report.mark.R2Missing/length(raw);
report.ratio.R3Missing = report.mark.R3Missing/length(raw);
report.ratio.Unknown = report.mark.Unknown/(length(raw)*3);
report.ratio.NaN = (report.mark.R1Missing + report.mark.R2Missing + report.mark.R3Missing + report.mark.Unknown)/(length(raw)*3);

report.mark = struct2table(report.mark);
report.ratio = struct2table(report.ratio);

%% Outputs
report.outputDiscription.participants = length(unique(raw(:,3)));
report.outputDiscription.cues = length(unique(raw(:,1)));
report.outputDiscription.types = length(unique(raw(:,5:7)));
report.outputDiscription.sheets = length(raw);
report.outputDiscription = struct2table(report.outputDiscription);
save('reports/wordCleaning','report');

save("data/SWOW-GPT_wordcleaning","raw");
writetable(cell2table(raw),'data/SWOW-GPT_wordcleaning.csv');