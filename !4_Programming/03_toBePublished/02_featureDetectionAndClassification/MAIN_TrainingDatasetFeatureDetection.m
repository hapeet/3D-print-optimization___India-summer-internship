

%% INIT
clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('datasetBasicShapes\')); % add whole dataset to searchpath

STLfiles = dir('dataset\**\*.STL');


% addpath(genpath('testBodies'))
% STLfiles = dir('testBodies\testBody_8\*.STL');

%% process bodies

dataset = struct;
for fileIdx = 1:numel(STLfiles)
    body = STLfiles(fileIdx).name;
    body(strfind(body,'.STL'):end) = [];
    propsFeatures = func_MAIN_12_DatasetLabelling(body);
    close all

    for f = 1:numel(propsFeatures)
        dataset(end+1,1).name = STLfiles(fileIdx).name;
        dataset(end,1).Features = propsFeatures(f);
    end
    
    
    





    disp(sprintf('%d / %d ...... %s', fileIdx, numel(STLfiles), body))
end

dataset(1) = [];
%% squeeze Cuts

for bodyIdx = 1:numel(dataset)
    for featureIdx = 1:numel(dataset(bodyIdx).Features)
    
    dataset(bodyIdx).Features(featureIdx).CutXImage.Cut          = squeeze(dataset(bodyIdx).Features(featureIdx).CutX.Cut);
    dataset(bodyIdx).Features(featureIdx).CutXImage.CutExt       = squeeze(dataset(bodyIdx).Features(featureIdx).CutX.CutExt);
    dataset(bodyIdx).Features(featureIdx).CutXImage.CutTight     = squeeze(dataset(bodyIdx).Features(featureIdx).CutX.CutTight);
    dataset(bodyIdx).Features(featureIdx).CutXImage.CutTightHigh = squeeze(dataset(bodyIdx).Features(featureIdx).CutX.CutTightHigh);
    dataset(bodyIdx).Features(featureIdx).CutXImage.CutTightExt  = squeeze(dataset(bodyIdx).Features(featureIdx).CutX.CutTightExt);

    dataset(bodyIdx).Features(featureIdx).CutYImage.Cut          = squeeze(dataset(bodyIdx).Features(featureIdx).CutY.Cut);
    dataset(bodyIdx).Features(featureIdx).CutYImage.CutExt       = squeeze(dataset(bodyIdx).Features(featureIdx).CutY.CutExt);
    dataset(bodyIdx).Features(featureIdx).CutYImage.CutTight     = squeeze(dataset(bodyIdx).Features(featureIdx).CutY.CutTight);
    dataset(bodyIdx).Features(featureIdx).CutYImage.CutTightHigh = squeeze(dataset(bodyIdx).Features(featureIdx).CutY.CutTight);
    dataset(bodyIdx).Features(featureIdx).CutYImage.CutTightExt  = squeeze(dataset(bodyIdx).Features(featureIdx).CutY.CutTightExt);

    dataset(bodyIdx).Features(featureIdx).CutZImage.Cut          = squeeze(dataset(bodyIdx).Features(featureIdx).CutZ.Cut);
    dataset(bodyIdx).Features(featureIdx).CutZImage.CutExt       = squeeze(dataset(bodyIdx).Features(featureIdx).CutZ.CutExt);    

    end
end



save dataset\datasetBasicShapes.mat dataset -mat