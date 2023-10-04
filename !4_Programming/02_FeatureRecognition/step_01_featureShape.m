close all
clear all
clc

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('testBodies')); 

%% 

% load('dataset_NoSymetricalBodies.mat')
load('datasetBasicShapes.mat')


load('Body_08_propsFeatures.mat')
% load('Body_08_propsFeaturesHighRes.mat');

for iFeature = 1:numel(propsFeatures)

    I_x = squeeze(propsFeatures(iFeature).CutX.CutTight);
    I_y = squeeze(propsFeatures(iFeature).CutY.CutTight);

    for iDataset = 1:numel(dataset)
 
        CutX = dataset(iDataset).Features.CutXImage.CutTight;
        CutY = dataset(iDataset).Features.CutYImage.CutTight;
        
        CorrXXExt(iDataset,1) = corr2(I_x,imresize(CutX,size(I_x)));
        CorrXYExt(iDataset,1) = corr2(I_x,imresize(CutY,size(I_x)));
        
        CorrYYExt(iDataset,1) = corr2(I_y,imresize(CutY,size(I_y)));
        CorrYXExt(iDataset,1) = corr2(I_y,imresize(CutX,size(I_y)));

    end

    propsFeatures(iFeature).corr.tbl = table(CorrXXExt,CorrXYExt,CorrYYExt,CorrYXExt);
    [propsFeatures(iFeature).corr.MaxVal...
     propsFeatures(iFeature).corr.MaxIdx] = max(propsFeatures(iFeature).corr.tbl);
    

    [MAX(1), IDX(1)] = max(propsFeatures(iFeature).corr.tbl.CorrXXExt + propsFeatures(iFeature).corr.tbl.CorrYYExt);
    [MAX(2), IDX(2)] = max(propsFeatures(iFeature).corr.tbl.CorrXYExt + propsFeatures(iFeature).corr.tbl.CorrYXExt);

    [~ ,I] = max(MAX);

    Idx = IDX(I);


    % figure
    % title(sprintf('Feature: %i',iDataset))
    % subplot(2,2,1)
    % imshow(I_x);axis xy
    % title 'Feature cut I_x'
    % subplot(2,2,2)
    % imshow(I_y);axis xy
    % title 'Feature cut I_y'
    % 
    % 
    % subplot(2,2,3)
    % imshow(dataset(Idx).Features.CutXImage.CutTight);axis xy
    % title 'Dataset cut I_x'
    % subplot(2,2,4)
    % imshow(dataset(Idx).Features.CutYImage.CutTight);axis xy
    % title 'Dataset cut I_y'
    % shg

    identifiedBody = dataset(Idx).name;
    identifiedBody(strfind(identifiedBody,'.STL'):end) = [];
    propsFeatures(iFeature).basicShape = identifiedBody;

    disp(sprintf('Feature: %i, Identified as: %s',iFeature,identifiedBody));

end