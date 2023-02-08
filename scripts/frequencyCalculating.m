clear;
clc;

%% Settings
addpath('data')
report = struct();
namek = {'All','NAODAO','swowWebsite'};

for k = 1:length(namek)
    
    %% Inputs
    load("SWOW-ZH_R55.mat"); % [raw]
    raw = table2cell(raw); 

    idxNAODAO = find(strcmp(raw(:,11),'NAODAO'));
    idxWebsite = find(~strcmp(raw(:,11),'NAODAO'));
    
    if length(namek{1,k}) == 3 % All
        raw = raw;
    elseif length(namek{1,k}) == 6 % NAODAO
        raw = raw(idxNAODAO,:);
    elseif length(namek{1,k}) == 11 % swowWebsite
        raw = raw(idxWebsite,:);
    end
    
    part = unique(raw(:,3)); % [part]
    for i = 1:length(part) % Abstract participants information, it took a while
        idx = find(strcmp(raw(:,3),part{i,1}));
        part{i,2} = raw{idx(1,1),5}; % Age
        part{i,3} = raw{idx(1,1),6}; % Native language
        part{i,4} = raw{idx(1,1),7}; % Gender
        part{i,5} = raw{idx(1,1),8}; % Education
        part{i,6} = raw{idx(1,1),9}; % City
        part{i,7} = raw{idx(1,1),10}; % Country
    end
    cue = unique(raw(:,12)); % [cue]
    for i = 1:length(cue) % Abstract participants information, it took a while
        idx = find(strcmp(raw(:,12),cue{i,1}));
        cue{i,2} = raw(idx,16); % R1
        cue{i,3} = raw(idx,17); % R2
        cue{i,4} = raw(idx,18); % R3
    end
    
    %% Discription statistics
    data = sort(raw(:,4)); % Collection period
    report.startdate = data{1,1}; % Start date
    report.enddate = data{length(data),1}; % End date
    report.Ncuewords = length(unique(raw(:,12))); % The number of cue words
    report.Nsheets = length(raw); % The number of sheets
    report.Nparticipants = length(unique(raw(:,3))); % The number of participants
    
    %% Demography
    data = str2num(char(part(:,2))); % Descriptive statistics of age
    report.demography.age.all = data;
    report.demography.age.mean = mean(data);
    report.demography.age.median = median(data);
    report.demography.age.var = var(data);
    report.demography.age.std = std(data);
    report.demography.age.min = min(data);
    report.demography.age.max = max(data);
    report.demography.age.range = range(data);
    report.demography.age.freq = tabulate(data);
    report.demography.age.histogram = histogram(report.demography.age.all);
    report.demography.age.DiscriptionTable = struct2table(report.demography.age,"AsArray",true);
    
    data = char(part(:,3)); % Descriptive statistics of native language
    report.demography.nativeLanguage.all = data;
    report.demography.nativeLanguage.freq = tabulate(data);
    report.demography.nativeLanguage.pie = ...
        pie(cell2mat(report.demography.nativeLanguage.freq(:,2)),...
        report.demography.nativeLanguage.freq(:,1));
    
    data = char(part(:,4)); % Descriptive statistics of gender
    report.demography.gender.all = data;
    report.demography.gender.freq = tabulate(data);
    report.demography.gender.pie = ...
        pie(cell2mat(report.demography.gender.freq(:,2)),...
        report.demography.gender.freq(:,1));
    
    data = char(part(:,5)); % Descriptive statistics of education
    report.demography.education.all = data;
    report.demography.education.freq = tabulate(data);
    report.demography.education.pie = ...
        pie(cell2mat(report.demography.education.freq(:,2)),...
        report.demography.education.freq(:,1)); % 1 = None, 2 = Elementary school,
    % 3 = High School, 4 = College or University Bachelor, 5 = College or University Master
    
    data = char(part(:,6)); % Descriptive statistics of city
    report.demography.city.all = data;
    report.demography.city.freq = tabulate(data);
    report.demography.city.pie = ...
        pie(cell2mat(report.demography.city.freq(:,2)),...
        report.demography.city.freq(:,1));
    
    data = char(part(:,7)); % Descriptive statistics of country
    report.demography.country.all = data;
    report.demography.country.freq = tabulate(data);
    report.demography.country.pie = ...
        pie(cell2mat(report.demography.country.freq(:,2)),...
        report.demography.country.freq(:,1));
    
    %% Types and tokens
    report.typestokens.Ntypes_R1 = length(unique(raw(:,16))); % R1 Types
    report.typestokens.Ntypes_R123 = length(unique(raw(:,16:18)))-1; % R123 Types (minus 1 for #Missing)
    report.typestokens.Ntokens_R1 = length(raw(:,16))-length(find(strcmp(raw(:,16),'#Missing')))...
        -length(find(strcmp(raw(:,16),'#Unknown'))); % R1 Tokens, #Unknown = 0, #Missing = 0
    report.typestokens.Ntokens_R123 = length(raw(:,16))*3-length(find(strcmp(raw(:,16:18),'#Missing')))...
        -length(find(strcmp(raw(:,16:18),'#Unknown'))); % R123 Tokens, #Unknown = 0, #Missing = 147,716
    
    %% Hapax legomena ratio
    data = tabulate(raw(:,16)); % R1 hapax legomena
    idx = find(cell2mat(data(:,2))==1);
    report.hapax.Nhapax_R1 = length(idx);
    report.hapax.Rhapax_types_R1 = report.hapax.Nhapax_R1/report.typestokens.Ntypes_R1;
    report.hapax.Rhapax_tokens_R1 = report.hapax.Nhapax_R1/report.typestokens.Ntokens_R1;
    data = tabulate([raw(:,16);raw(:,17);raw(:,18)]); % R123 hapax legomena
    idx = find(cell2mat(data(:,2))==1);
    report.hapax.Nhapax_R123 = length(idx);
    report.hapax.Rhapax_types_R123 = report.hapax.Nhapax_R123/report.typestokens.Ntypes_R123;
    report.hapax.Rhapax_tokens_R123 = report.hapax.Nhapax_R123/report.typestokens.Ntokens_R123;
    report.hapax.DiscriptionTable = struct2table(report.hapax,"AsArray",true);
    
    %% Missing and unknown ratio
    data = []; % Descriptive statistics of #Unknown ratio
    for i = 1:length(cue)
        idxunk = find(strcmp(cue{i,2},'#Unknown'));
        data(i,1) = length(idxunk)/length(cue{i,2});
    end
    report.missunk.Runknown.mean_sheets = length(find(strcmp(raw(:,16),'#Unknown')))/length(raw);
    report.missunk.Runknown.all = data;
    report.missunk.Runknown.mean_cues = mean(data);
    report.missunk.Runknown.median = median(data);
    report.missunk.Runknown.var = var(data);
    report.missunk.Runknown.std = std(data);
    report.missunk.Runknown.min = min(data);
    report.missunk.Runknown.max = max(data);
    report.missunk.Runknown.range = range(data);
    report.missunk.Runknown.freq = tabulate(data);
    report.missunk.Runknown.histogram = histogram(report.missunk.Runknown.all);
    report.missunk.Runknown.DiscriptionTable = struct2table(report.missunk.Runknown,"AsArray",true);
    report.missunk.Runknown.DiscriptionTable.Properties.RowNames = string('Runknown');
    
    data = []; % Descriptive statistics of #Missing ratio in R1
    for i = 1:length(cue)
        idxmiss = find(strcmp(cue{i,2},'#Missing'));
        data(i,1) = length(idxmiss)/length(cue{i,2});
    end
    report.missunk.Rmissing_R1.mean_sheets = length(find(strcmp(raw(:,16),'#Missing')))/length(raw);
    report.missunk.Rmissing_R1.all = data;
    report.missunk.Rmissing_R1.mean_cues = mean(data);
    report.missunk.Rmissing_R1.median = median(data);
    report.missunk.Rmissing_R1.var = var(data);
    report.missunk.Rmissing_R1.std = std(data);
    report.missunk.Rmissing_R1.min = min(data);
    report.missunk.Rmissing_R1.max = max(data);
    report.missunk.Rmissing_R1.range = range(data);
    report.missunk.Rmissing_R1.freq = tabulate(data);
    report.missunk.Rmissing_R1.histogram = histogram(report.missunk.Rmissing_R1.all);
    report.missunk.Rmissing_R1.DiscriptionTable = struct2table(report.missunk.Rmissing_R1,"AsArray",true);
    report.missunk.Rmissing_R1.DiscriptionTable.Properties.RowNames = string('Rmissing_R1');
    
    data = []; % Descriptive statistics of #Missing ratio in R2
    for i = 1:length(cue)
        idxmiss = find(strcmp(cue{i,3},'#Missing'));
        data(i,1) = length(idxmiss)/length(cue{i,3});
    end
    report.missunk.Rmissing_R2.mean_sheets = length(find(strcmp(raw(:,17),'#Missing')))/length(raw);
    report.missunk.Rmissing_R2.all = data;
    report.missunk.Rmissing_R2.mean_cues = mean(data);
    report.missunk.Rmissing_R2.median = median(data);
    report.missunk.Rmissing_R2.var = var(data);
    report.missunk.Rmissing_R2.std = std(data);
    report.missunk.Rmissing_R2.min = min(data);
    report.missunk.Rmissing_R2.max = max(data);
    report.missunk.Rmissing_R2.range = range(data);
    report.missunk.Rmissing_R2.freq = tabulate(data);
    report.missunk.Rmissing_R2.histogram = histogram(report.missunk.Rmissing_R2.all);
    report.missunk.Rmissing_R2.DiscriptionTable = struct2table(report.missunk.Rmissing_R2,"AsArray",true);
    report.missunk.Rmissing_R2.DiscriptionTable.Properties.RowNames = string('Rmissing_R2');
    
    data = []; % Descriptive statistics of #Missing ratio in R3
    for i = 1:length(cue)
        idxmiss = find(strcmp(cue{i,4},'#Missing'));
        data(i,1) = length(idxmiss)/length(cue{i,4});
    end
    report.missunk.Rmissing_R3.mean_sheets = length(find(strcmp(raw(:,18),'#Missing')))/length(raw);
    report.missunk.Rmissing_R3.all = data;
    report.missunk.Rmissing_R3.mean_cues = mean(data);
    report.missunk.Rmissing_R3.median = median(data);
    report.missunk.Rmissing_R3.var = var(data);
    report.missunk.Rmissing_R3.std = std(data);
    report.missunk.Rmissing_R3.min = min(data);
    report.missunk.Rmissing_R3.max = max(data);
    report.missunk.Rmissing_R3.range = range(data);
    report.missunk.Rmissing_R3.freq = tabulate(data);
    report.missunk.Rmissing_R3.histogram = histogram(report.missunk.Rmissing_R3.all);
    report.missunk.Rmissing_R3.DiscriptionTable = struct2table(report.missunk.Rmissing_R3,"AsArray",true);
    report.missunk.Rmissing_R3.DiscriptionTable.Properties.RowNames = string('Rmissing_R3');
    
    report.missunk.DiscriptionTable = table();
    namei = fieldnames(report.missunk);
    for i = 1:(size(namei,1)-1)
        eval(['report.missunk.DiscriptionTable = [report.missunk.DiscriptionTable; report.missunk.',namei{i},'.DiscriptionTable];']);
    end
    
    eval([namek{1,k},' = report;']);
end

%% Type-token Curve (R scripts)

%% Cue Entropy Curve (R scripts)

%% Response Chaining (R scripts)

%% Outputs
report = struct();
report.All = All;
report.NAODAO = NAODAO;
report.swowWebsite = swowWebsite;

save("output/reports/frequencyCalculating",'report')