clear;
clc;

%% Settings
addpath('data')
addpath('reports')
addpath('functions')
report = struct();
namenum = [20:5:120];

%% Inputs
absraw = importdata('similarity.abstract.zh.csv');
abs.words = absraw.textdata;
abs.scores = absraw.data;

conraw = importdata('similarity.concrete.zh.csv');
con.words = conraw.textdata;
con.scores = conraw.data; 

load("SWOW-ZH_partcleaning.mat"); % [raw]
raw = table2cell(raw); 

absraw = readtable('C:\Users\Ziyi Ding\Desktop\GPT-SWOW\data\behavioralData\similarity.abstract.zh.csv','Format','auto');
conraw = readtable('C:\Users\Ziyi Ding\Desktop\GPT-SWOW\data\behavioralData\similarity.concrete.zh.csv','Format','auto');
abscon = [absraw.Var1;conraw.Var1];
idx = [];
for i = 1:length(abscon)
    idx = [idx;find(strcmp(raw(:,12),abscon{i}))];
end
raw(idx,:) = [];
swow = raw;

load("SWOW-CH_wordcleaning"); % [raw]
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

cue164 = [abs.words;con.words];
idx = [];
for i = 1:length(raw)
    if isempty(find(strcmp(cue164,raw{i,12}))) == 0
        idx(end+1) = i;
    end
end
rawP = raw(idx,:);

load("SWOW-CH_network")
AMfull.AM_R1 = net.AMnrm_R1;
AMfull.AM_R123 = net.AMnrm_R123;
AMfull.label_R1 = table2cell(net.Gconncomp_R1.Nodes);
AMfull.label_R123 = table2cell(net.Gconncomp_R123.Nodes);

clear net raw

for k = 1:length(namenum)
    num = namenum(k);
    
    % Data balance
    eval(['report.rawB.R',num2str(num),' = f_dataBalance(rawP,num);']);

    % Connection vecters
    eval(['report.CV.R',num2str(num),' = f_networkGeneration(report.rawB.R',num2str(num),',AMfull);']);
    
    % Similarty calculating
    alpha = 0.75;
    eval(['report.s.R',num2str(num),' = f_similarityCalculating(report.CV.R',num2str(num),',alpha);']);
    
end

%% Predict relatedness judgments task
for k = 1:length(namenum)
    num = namenum(k);
    % Shared word-pairs
    eval(['s = report.s.R',num2str(num),';']);
    simonabs = struct(); % Simon2020_abstract
    pool = intersect(abs.words,s.labelRJT_R1);
    pool = intersect(pool,s.labelRJT_R123);
    [~,~,idxb] = intersect(pool,abs.words);
    [~,~,idxswowR1] = intersect(pool,s.labelRJT_R1);
    [~,~,idxswowR123] = intersect(pool,s.labelRJT_R123);
    count = 0;
    for i = 1:length(pool)
        for j = i+1:length(pool)
            count = count + 1;
            simonabs.sharedwords1{count,1} = pool{i};
            simonabs.sharedwords2{count,1} = pool{j};
            simonabs.RJT{count,1} = abs.scores(idxb(i),idxb(j)); % Behavioral data
            simonabs.cosineS_R1{count,1} = s.cosineS_R1(idxswowR1(i),idxswowR1(j)); % R1
            simonabs.ppmiS_R1{count,1} = s.ppmiS_R1(idxswowR1(i),idxswowR1(j));
            simonabs.rwS_R1{count,1} = s.rwS_R1(idxswowR1(i),idxswowR1(j));
            simonabs.embS_R1{count,1} = s.embS_R1(idxswowR1(i),idxswowR1(j));
            simonabs.cosineS_R123{count,1} = s.cosineS_R123(idxswowR123(i),idxswowR123(j)); % R123
            simonabs.ppmiS_R123{count,1} = s.ppmiS_R123(idxswowR123(i),idxswowR123(j));
            simonabs.rwS_R123{count,1} = s.rwS_R123(idxswowR123(i),idxswowR123(j));
            simonabs.embS_R123{count,1} = s.embS_R123(idxswowR123(i),idxswowR123(j));
        end
    end
    simonabs = struct2table(simonabs);
    
    eval(['s = report.s.R',num2str(num),';']);
    simoncon = struct(); % Simon2020_concrete
    pool = intersect(con.words,s.labelRJT_R1);
    pool = intersect(pool,s.labelRJT_R123);
    [~,~,idxb] = intersect(pool,con.words);
    [~,~,idxswowR1] = intersect(pool,s.labelRJT_R1);
    [~,~,idxswowR123] = intersect(pool,s.labelRJT_R123);
    count = 0;
    for i = 1:length(pool)
        for j = i+1:length(pool)
            count = count + 1;
            simoncon.sharedwords1{count,1} = pool{i};
            simoncon.sharedwords2{count,1} = pool{j};
            simoncon.RJT{count,1} = con.scores(idxb(i),idxb(j)); % Behavioral data
            simoncon.cosineS_R1{count,1} = s.cosineS_R1(idxswowR1(i),idxswowR1(j)); % R1
            simoncon.ppmiS_R1{count,1} = s.ppmiS_R1(idxswowR1(i),idxswowR1(j));
            simoncon.rwS_R1{count,1} = s.rwS_R1(idxswowR1(i),idxswowR1(j));
            simoncon.embS_R1{count,1} = s.embS_R1(idxswowR1(i),idxswowR1(j));
            simoncon.cosineS_R123{count,1} = s.cosineS_R123(idxswowR123(i),idxswowR123(j)); % R123
            simoncon.ppmiS_R123{count,1} = s.ppmiS_R123(idxswowR123(i),idxswowR123(j));
            simoncon.rwS_R123{count,1} = s.rwS_R123(idxswowR123(i),idxswowR123(j));
            simoncon.embS_R123{count,1} = s.embS_R123(idxswowR123(i),idxswowR123(j));
        end
    end
    simoncon = struct2table(simoncon);
    
    %% Correlations
    rowname = {'simonabs','simoncon'};
    idxname = simonabs.Properties.VariableNames(1,3:end);
    for i = 2:length(idxname)
        colname{1,i-1} = strcat(idxname{1},'-',idxname{i});
    end
    r = []; p = []; N = []; RL = []; RH = [];
    for i = 1:length(rowname)
        eval(['RJT = cell2mat(',rowname{i},'.',idxname{1},');']);
        for j = 2:length(idxname)
            eval(['sim = cell2mat(',rowname{i},'.',idxname{j},');']);
            idx = find(sim > 0);
            N(i,j-1) = length(idx);
            [xr,xp,xRL,xRH] = corrcoef(RJT(idx),sim(idx));
            r(i,j-1) = xr(1,2);
            p(i,j-1) = xp(1,2);
            RL(i,j-1) = xRL(1,2);
            RH(i,j-1) = xRH(1,2);
        end
    end
    eval(['report.simonabsData.R',num2str(num),' = simonabs;']);
    eval(['report.simonconData.R',num2str(num),' = simoncon;']);
    eval(['report.Correlation_R.R',num2str(num),' = array2table(r,''VariableNames'',cellstr(colname),''RowNames'',cellstr(rowname));']);
    eval(['report.Correlation_p.R',num2str(num),' = array2table(p,''VariableNames'',cellstr(colname),''RowNames'',cellstr(rowname));']);
    eval(['report.Correlation_N.R',num2str(num),' = array2table(N,''VariableNames'',cellstr(colname),''RowNames'',cellstr(rowname));']);
    eval(['report.Correlation_RL.R',num2str(num),' = array2table(RL,''VariableNames'',cellstr(colname),''RowNames'',cellstr(rowname));']);
    eval(['report.Correlation_RH.R',num2str(num),' = array2table(RH,''VariableNames'',cellstr(colname),''RowNames'',cellstr(rowname));']);
end

%% Outputs
save('reports/gradientValidation','report','-v7.3');
x.Correlation_R = report.Correlation_R;
x.Correlation_p = report.Correlation_p;
x.Correlation_RL = report.Correlation_RL;
x.Correlation_RH = report.Correlation_RH;
x.Correlation_N = report.Correlation_N;
save('reports/gradientValidation_correlationTable','x');