clc; clear all; 

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath

load dataset\dataset_AllBodies.mat


lib = struct;



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

bodyCategory = string;
bodyGroupCategory = string;

for bodyIdx = 1:numel(dataset)
    for featureIdx = 1:numel(dataset(bodyIdx).Features)

        bodyID = dataset(bodyIdx).name;
        bodyID(strfind(bodyID,'.STL'):end) = [];
        bodyGroupID = bodyID(1:(strfind(bodyID,'_')-1));
        bodyID(strfind(bodyID,'_')) = [];
        
        
        Features = dataset(bodyIdx).Features(featureIdx);
        
        CutX_Cut(end+1,:)           = f_InvMoments(Features.CutXImage.Cut);
        CutX_CutExt(end+1,:)        = f_InvMoments(Features.CutXImage.CutExt);
        CutX_CutTight(end+1,:)      = f_InvMoments(Features.CutXImage.CutTight);
        CutX_CutTightExt(end+1,:)   = f_InvMoments(Features.CutXImage.CutTightExt);

        CutY_Cut(end+1,:)           = f_InvMoments(Features.CutYImage.Cut);
        CutY_CutExt(end+1,:)        = f_InvMoments(Features.CutYImage.CutExt);
        CutY_CutTight(end+1,:)      = f_InvMoments(Features.CutYImage.CutTight);
        CutY_CutTightExt(end+1,:)   = f_InvMoments(Features.CutYImage.CutTightExt);

        CutZ_Cut(end+1,:)           = f_InvMoments(Features.CutZImage.Cut);
        CutZ_CutExt(end+1,:)        = f_InvMoments(Features.CutZImage.CutExt);


        bodyCategory(end+1,:) = bodyID;
        bodyGroupCategory(end+1,:) = bodyGroupID;
    end
end

bodyCategory(1) = [];
bodyGroupCategory(1) = [];

bodyCategory = categorical(bodyCategory);


IM_trainingDataset = table(bodyGroupCategory,bodyCategory,...
                            CutX_Cut,CutX_CutExt,CutX_CutTight,CutX_CutTightExt, ...
                            CutY_Cut,CutY_CutExt,CutY_CutTight,CutY_CutTightExt, ...
                            CutZ_Cut,CutZ_CutExt);


%% SVM classifier training

[trainedClassifier, validationAccuracy] = trainClassifier_fineGaussSVM(IM_trainingDataset);

