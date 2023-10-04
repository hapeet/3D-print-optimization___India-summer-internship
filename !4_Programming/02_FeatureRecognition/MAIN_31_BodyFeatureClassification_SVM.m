%% INIT
% clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('lib\classification')); % add whole library to searchpath
addpath(genpath('testBodies\')); % add whole dataset to searchpath



%% process body 

    body = 'Body_08';

    featuresAll = func_MAIN_12_DatasetLabelling(body);
    % close all

%% squeeze Cuts

    for featureIdx = 1:numel(featuresAll)
    
    featuresAll(featureIdx).CutXImage.Cut          = squeeze(featuresAll(featureIdx).CutX.Cut);
    featuresAll(featureIdx).CutXImage.CutExt       = squeeze(featuresAll(featureIdx).CutX.CutExt);
    featuresAll(featureIdx).CutXImage.CutTight     = squeeze(featuresAll(featureIdx).CutX.CutTight);
    featuresAll(featureIdx).CutXImage.CutTightExt  = squeeze(featuresAll(featureIdx).CutX.CutTightExt);

    featuresAll(featureIdx).CutYImage.Cut          = squeeze(featuresAll(featureIdx).CutY.Cut);
    featuresAll(featureIdx).CutYImage.CutExt       = squeeze(featuresAll(featureIdx).CutY.CutExt);
    featuresAll(featureIdx).CutYImage.CutTight     = squeeze(featuresAll(featureIdx).CutY.CutTight);
    featuresAll(featureIdx).CutYImage.CutTightExt  = squeeze(featuresAll(featureIdx).CutY.CutTightExt);

    featuresAll(featureIdx).CutZImage.Cut          = squeeze(featuresAll(featureIdx).CutZ.Cut);
    featuresAll(featureIdx).CutZImage.CutExt       = squeeze(featuresAll(featureIdx).CutZ.CutExt);    
    
    end


path = strcat('testBodies/',body,'_labeled.mat');
save(path,"featuresAll",'-mat');




%%      Cuts labeling with Image Moments



CutX_Cut = [];
CutX_CutExt = [];
CutX_CutTight = [];
CutX_CutTightExt = [];

CutY_Cut = [];
CutY_CutExt = [];
CutY_CutTight = [];
CutY_CutTightExt = [];

CutZ_Cut = [];
CutZ_CutExt = [];


for featureIdx = 1:numel(featuresAll)

     
        
        
        Feature = featuresAll(featureIdx);
        
        CutX_Cut(end+1,:)           = f_InvMoments(Feature.CutXImage.Cut);
        CutX_CutExt(end+1,:)        = f_InvMoments(Feature.CutXImage.CutExt);
        CutX_CutTight(end+1,:)      = f_InvMoments(Feature.CutXImage.CutTight);
        CutX_CutTightExt(end+1,:)   = f_InvMoments(Feature.CutXImage.CutTightExt);

        CutY_Cut(end+1,:)           = f_InvMoments(Feature.CutYImage.Cut);
        CutY_CutExt(end+1,:)        = f_InvMoments(Feature.CutYImage.CutExt);
        CutY_CutTight(end+1,:)      = f_InvMoments(Feature.CutYImage.CutTight);
        CutY_CutTightExt(end+1,:)   = f_InvMoments(Feature.CutYImage.CutTightExt);

        CutZ_Cut(end+1,:)           = f_InvMoments(Feature.CutZImage.Cut);
        CutZ_CutExt(end+1,:)        = f_InvMoments(Feature.CutZImage.CutExt);


        bodyCategory(end+1,:) = bodyID;
        bodyGroupCategory(end+1,:) = bodyGroupID;
end


IM_BodyDataset = table(CutX_Cut,CutX_CutExt,CutX_CutTight,CutX_CutTightExt, ...
                       CutY_Cut,CutY_CutExt,CutY_CutTight,CutY_CutTightExt, ...
                       CutZ_Cut,CutZ_CutExt);



%% classification


Ytrue = [];

for i = 1:size(IM_BodyDataset,1)
    T = IM_BodyDataset(i,:);
    [Y(i,1),scores(i,:)] = trainedClassifier.predictFcn(T);
   
end