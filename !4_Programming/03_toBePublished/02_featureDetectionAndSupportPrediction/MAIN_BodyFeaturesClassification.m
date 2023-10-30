close all; clear all; clc
tic 

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('datasetBasicShapes\')); % add whole dataset to searchpath
addpath(genpath('testBodies')); 

load('datasetBasicShapes.mat')
load('Body_08_res_1.mat')

%% 01 WHOLE BODY SYMETRY CHECK

G_size = size(bodyData.G);
CutX_all = squeeze(bodyData.G(round(G_size(1)/2),:,:));
CutY_all = squeeze(bodyData.G(:,round(G_size(2)/2),:));
 

bodyData.symetry.symX = immse( CutX_all, flip(CutX_all,1));
bodyData.symetry.symY = immse( CutY_all, flip(CutY_all,1));

%% 02 FEATURE SHAPE 

bodyData = featureShape(bodyData,dataset);


%% 03 FEATURE DIMENSION PROPERTIES - measured in mm

bodyData = featureDimension(bodyData);

%% 04 FEATURES EXCENTRICITY CHECK

for iFeature = 1:numel(bodyData.propsFeatures)
    
    
    projection = not(bodyData.propsFeatures(iFeature).CutZ.Cut);

    iProps = regionprops(projection,"Eccentricity");
    bodyData.propsFeatures(iFeature).dimensions.eccentricity = iProps.Eccentricity;
end


%% 05 FEATURE SURROUNDINGS ANALYSIS

bodyData = featureSurroundings(bodyData);


%% 06 FEATURE SUPPORT ANALYSIS

for iFeature = 1:numel(bodyData.propsFeatures)
    supportBottomPoints = bodyData.propsFeatures(iFeature).featurePoints.supportBtm(:,3);  
 
    bodyData.propsFeatures(iFeature).supportStandOnBaseRatio = numel(find(supportBottomPoints == 1)) / numel(supportBottomPoints);   % 1- if all supports stand on base build plate; 0 - if all supports stand on other feature overhang

end


toc