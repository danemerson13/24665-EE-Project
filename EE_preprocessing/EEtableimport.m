% Updated: 4/11/21
% this function generates a useable table from the unusual structure and
% datatypes used for the raw data (multiple values held in a single string,
% non-uniform sampling rate, inconsistent sample order, etc.).

function tbl = EEtableimport(fname)

%% define table import options
% need to explicitly define a few of the variable types for matlab to play
% nice
opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines     = [2, Inf];
opts.Delimiter     = ",";
opts.MissingRule = 'fill';
opts.VariableNames = ["VarName1", "DeviceID", "Time", "PersonID", "Scenario",...
    "Activity", "Placement", "AccX", "AccY", "AccZ", "ZephyrHR", "ZephyrBR",...
    "ZephyrST", "ZephyrRR", "BodyNBT", "BodyST", "BodyGSR", "BodyCal",...
    "BodyMET", "COSMED", "Android"];
opts.VariableTypes = ["double", "categorical", "datetime", "categorical",...
    "categorical", "categorical", "categorical", "double", "double",...
    "double", "double", "double", "double", "double", "double", "double",...
    "double", "double", "double", "double", "char"];

opts = setvaropts(opts, "Time", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");

%% import table
tbl = readtable(fname, opts);