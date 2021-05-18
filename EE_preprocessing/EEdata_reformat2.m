% Updated: 5/10/21
% Accepts raw data in .csv format and produces a parsed, interpolated,
% pre-processed table for classification and/or regression.

% NOTE: The inconsistent structure and content of datasets across different
% subjects make it difficult to generalize a script--several subjects are
% missing sensor data, altogether. Minor alterations to this script may
% therefore be necessary to accomodate these inconsistencies.

%% import table
% importing raw data from csv
tbl = EEtableimport('A:\Data\Chiron\PersonJ.csv');

Fs = 230;                   % sampling rate identical across subjects
t  = (0:size(tbl,1))./Fs;   % time array
t  = t(1:end-1)';

%% parse acc. data
slocs = categories(tbl.Placement)';         % sensor locations
A     = zeros(size(tbl,1),1);

% loop through acc. sensors creating x,y,z variables for each
for i = 2:numel(slocs)
    n = size(tbl,2);
    idx = tbl.Placement==slocs{i};
    tbl = addvars(tbl,A, 'NewVariableNames', strcat(slocs{i},'_accx'));
    tbl = addvars(tbl,A, 'NewVariableNames', strcat(slocs{i},'_accy'));
    tbl = addvars(tbl,A, 'NewVariableNames', strcat(slocs{i},'_accz'));
    tbl{idx,n+1} = tbl.AccX(idx);
    tbl{idx,n+2} = tbl.AccY(idx);
    tbl{idx,n+3} = tbl.AccZ(idx);
end

% clean up
tbl(:,7:10) = [];
clear n idx A i;

%% remove other variables
tbl(:,1) = [];
tbl.Android  = [];
tbl.DeviceID = [];
tbl.Scenario = [];
tbl.Time     = [];
tbl.PersonID = [];

%% fill missing activity data
% replace NaNs (just a few) with the nearest valid entry
tbl.Activity(tbl.Activity=='0') = categorical(NaN);
tbl.Activity = fillmissing(tbl.Activity,'nearest');
Activity = tbl.Activity;

%% interpolate numerical columns
vars = tbl.Properties.VariableNames;                % save var names for later
tbl.Activity = [];
tbl = table2array(tbl);                             % convert to numerical

% loop through vars
for i = 1:size(tbl,2)
    idx = tbl(:,i)~=0;                              % where values exist
    tbl(:,i) = interp1(t(idx),tbl(idx,i),t);
end

% trim NaN at endpoints resulting from interpolation
c   = max(sum(isnan(tbl(1:10000,:)),1));
tbl = tbl(c:(end-1000),:);

%% filter and smooth
% there shouldn't be any missing values now, but just in case
tbl = fillmissing(tbl,'nearest');

% 4th order butterworth lowpass filter (optional)
% improves SNR, but there are massive outliers in the raw data that can trigger
% nasty transients from this (or any) IIR filter
[b,a] = butter(4,4/Fs);
tbl = filtfilt(b,a,tbl);

% loop through vars
for i = 1:size(tbl,2)
    
    % detect outliers via threshold, remove, and replace via interpolation
    tbl(:,i) = filloutliers(tbl(:,i),'center','movmedian', 60*Fs,...
        'ThresholdFactor',0.05);
    tbl(:,i) = tbl(:,i) - min(tbl(:,i));    % subtract offset
    tbl(:,i) = tbl(:,i)./max(tbl(:,i));     % normalize
end

% smooth any jagged edges left over from outlier removal
tbl = smoothdata(tbl,1,'movmean',44*Fs);

% add activities back to the matrix and covert back to table
tbl = horzcat(table(Activity(c:(end-1000))),array2table(tbl));
tbl.Properties.VariableNames = vars;










