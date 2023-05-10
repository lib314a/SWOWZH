clear;
clc;

%% Settings
addpath('data')
addpath('data/dictionaries')
report = struct();

%% Inputs
load("SWOW-ZH_wordcleaning.mat"); % [raw]
vNames = raw.Properties.VariableNames;
raw = table2cell(raw); 

load("englishRes.mat")
load('SWOWZHwordlist.mat')

report.inputDiscription.participants = length(unique(raw(:,3)));
report.inputDiscription.cues = length(unique(raw(:,12)));
report.inputDiscription.types = length(unique(raw(:,16:18)));
report.inputDiscription.sheets = length(raw);
report.inputDiscription = struct2table(report.inputDiscription);

%% Reorganize SWOW-ZH according to participants index
partdic = str2num(char(unique(raw(:,3))));
dic = str2num(char(raw(:,3)));
part = {};
for i = 1:length(partdic)
    idx = find(dic==partdic(i,1));
    part{i,1} = raw{idx(1,1),3};
    part{i,2} = raw(idx,12:18);
    part{i,3} = [raw(idx,16);raw(idx,17);raw(idx,18)];
end

%% Too many non-words responses (> 40%)
pNonword = {}; count = 0;
[ch,~,~] = intersect(raw(:,16:18),ch);
for i = 1:length(part)
    idxm = find(strcmp(part{i,3},'没有了'));
    idxu = find(strcmp(part{i,3},'Unknown word'));
    idxb = find(strcmp(part{i,3},'不认识'));
    idxs = find(strcmp(part{i,3},'#Symbol'));
    idxl = find(strcmp(part{i,3},'#Long'));
    idxrr = find(strcmp(part{i,3},'#Repeat'));
    idxtag = [idxm;idxu;idxb;idxs;idxl;idxrr];
    idxword = setdiff([1:length(part{i,3})],idxtag);
    ins = intersect(part{i,3}(idxword,1),ch);
    if isempty(ins) == 0
        if length(ins)/length(part{i,3}(idxword,1)) < 0.6
            count = count + 1;
            pNonword(count,1:3) = part(i,1:3);
        end
    else
        count = count + 1;
        pNonword(count,1:3) = part(i,1:3);
    end
end

report.participantsDelete.Nonword = length(pNonword);

%% Too many long-string responses (> 30%)
pLong = {}; count = 0;
for i = 1:length(part)
    idx = find(strcmp(part{i,3},'#Long'));
    if isempty(idx) == 0
        if length(idx)/length(part{i,3}) > 0.3
            count = count + 1;
            pLong(count,1:3) = part(i,1:3);
        end
    end
end

report.participantsDelete.Long = length(pLong);

%% Too many symbol responses (> 40%)
pSymbol = {}; count = 0;
for i = 1:length(part)
    idx = find(strcmp(part{i,3},'#Symbol'));
    if isempty(idx) == 0
        if length(idx)/length(part{i,3}) > 0.4
            count = count + 1;
            pSymbol(count,1:3) = part(i,1:3);
        end
    end
end

report.participantsDelete.Symbol = length(pSymbol);

%% Too many English responses (> 40%)
pEnglish = {}; count = 0;
for i = 1:length(part)
    idx = [];
    for j = 1:length(englishRes)
        idx = [idx;find(strcmp(part{i,3},englishRes{j,1}))];
    end
    if isempty(idx) == 0
        if length(idx)/length(part{i,3}) > 0.4
            count = count + 1;
            pEnglish(count,1:3) = part(i,1:3);
        end
    end
end

report.participantsDelete.English = length(pEnglish);

%% Too many repeated responses (> 20%)
%% Too many "Unknown Word" and "Missing" responses (> 60%)
pEmpty = {}; countE = 0;
pRepeat = {}; countR = 0;
for i = 1:length(part)
    idxm = find(strcmp(part{i,3},'没有了'));
    idxu = find(strcmp(part{i,3},'Unknown word'));
    idxb = find(strcmp(part{i,3},'不认识'));
    idx = [idxm;idxu;idxb];
    if isempty(idx) == 0
        if length(idx)/length(part{i,3}) > 0.6
            countE = countE + 1;
            pEmpty(countE,1:3) = part(i,1:3);
        end
    end
    idxs = find(strcmp(part{i,3},'#Symbol'));
    idxl = find(strcmp(part{i,3},'#Long'));
    idxrr = find(strcmp(part{i,3},'#Repeat'));
    idx = [idx;idxs;idxl;idxrr];
    idxr = setdiff([1:length(part{i,3})],idx);
    repeatnum = length(part{i,3}(idxr,1)) - length(unique(part{i,3}(idxr,1)));
    if (repeatnum+length(idxrr))/length(part{i,3}) > 0.2
        countR = countR + 1;
        pRepeat(countR,1:3) = part(i,1:3);
    end
end

report.participantsDelete.Repeat = length(pRepeat);
report.participantsDelete.Empty = length(pEmpty);

%% Cantonese paricipants
idxcan = find(strcmp(raw(:,6),"SOUTH"));
pCantonese = unique(raw(idxcan,3));
[~,~,idx] = intersect(pCantonese,part(:,1));
pCantonese = part(idx,1:3);

report.participantsDelete.Cantonese = length(pCantonese);
report.participantsDelete = struct2table(report.participantsDelete);

%% Remove participants
dic = [pNonword(:,1);pLong(:,1);pSymbol(:,1);pEnglish(:,1);pRepeat(:,1);pEmpty(:,1);pCantonese(:,1)];
dic = unique(dic);

report.participantsDeleteActually = length(dic);

idx = [];
for i = 1:length(dic)
    idx = [idx;find(strcmp(raw(:,3),dic{i,1}))];
end
raw(idx,:) = [];

%% Transform "不认识" "没有了" "Unknown word" to #Missing or #Unknown
for i = 1:length(raw)
    line = raw(i,16:18);
    idx = find(strcmp(line,'不认识'));
    if length(idx) == 3
        raw(i,16:18) = {'#Unknown','#Unknown','#Unknown'};
    end
    idx = find(strcmp(line,'Unknown word'));
    if length(idx) == 3
        raw(i,16:18) = {'#Unknown','#Unknown','#Unknown'};
    end
    idx = find(strcmp(line,'没有了'));
    if length(idx) == 3
        raw(i,16:18) = {'#Missing','#Missing','#Missing'};
    end
    if (length(idx) == 2) && (all(idx == [2,3]))
        raw(i,17:18) = {'#Missing','#Missing'};
    end
    if idx == 3
        raw(i,18) = {'#Missing'};
    end
end

%% Transform other tags to #Missing
report.mark.Repeat_sameSheet = length(find(strcmp(raw(:,16:18),'#Repeat')));
report.mark.Symbol = length(find(strcmp(raw(:,16:18),'#Symbol')));
report.mark.Long = length(find(strcmp(raw(:,16:18),'#Long')));

tags = {'#Symbol','#Long','#Repeat'};
for i = 1:length(raw)
    line = raw(i,16:18);
    idx = [];
    idx = find(strcmp(line,'#Symbol'));
    idx = [idx,find(strcmp(line,'#Long'))];
    idx = [idx,find(strcmp(line,'#Repeat'))];
    if isempty(idx) == 0
        for j = 1:length(idx)
            line{1,idx(j)} = '#Missing';
        end
    end
    raw(i,16:18) = line;
end

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
save('output/reports/participantCleaning','report');

raw = cell2table(raw);
raw.Properties.VariableNames = vNames;
save("data/SWOW-ZH_partcleaning","raw");
writetable(raw,'data/SWOW-ZH_partcleaning.csv');