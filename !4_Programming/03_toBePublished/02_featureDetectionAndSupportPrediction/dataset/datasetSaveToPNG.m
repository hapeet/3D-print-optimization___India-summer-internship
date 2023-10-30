% clc; clear all; close all


% load('dataset_AllBodies.mat')



%% 






    %%

for iFeatures = 1:numel(propsFeatures)
% for iDataset = 1:numel(dataset)
%     disp(iDataset)
%     filename = dataset(iDataset).name;
    % class = filename(1:strfind(filename,"_")-1);
    % subClass = filename(strfind(filename,"_")+1:strfind(filename,".")-1);
    % CutX = dataset(iDataset).Features.CutXImage;
    % CutY = dataset(iDataset).Features.CutYImage;
    % CutZ = dataset(iDataset).Features.CutZImage;

    % imwrite(CutX.Cut,strcat('datasetPNG\',class,'_',subClass,'_CutX_Cut.png'));
    % imwrite(CutX.CutExt,strcat('datasetPNG\',class,'_',subClass,'_CutX_CutExt.png'));
    % imwrite(CutX.CutTight,strcat('datasetPNG\',class,'_',subClass,'_CutX_CutTight.png'));
    % imwrite(CutX.CutTightHigh,strcat('datasetPNG\',class,'_',subClass,'_CutX_CutTightHigh.png'));
    % imwrite(CutX.CutTightExt,strcat('datasetPNG\',class,'_',subClass,'_CutX_CutTightExt.png'));
    % 
    % imwrite(CutY.Cut,strcat('datasetPNG\',class,'_',subClass,'_CutY_Cut.png'));
    % imwrite(CutY.CutExt,strcat('datasetPNG\',class,'_',subClass,'_CutY_CutExt.png'));
    % imwrite(CutY.CutTight,strcat('datasetPNG\',class,'_',subClass,'_CutY_CutTight.png'));
    % imwrite(CutY.CutTightHigh,strcat('datasetPNG\',class,'_',subClass,'_CutY_CutTightHigh.png'));
    % imwrite(CutY.CutTightExt,strcat('datasetPNG\',class,'_',subClass,'_CutY_CutTightExt.png'));
    % 
    % imwrite(CutZ.Cut,strcat('datasetPNG\',class,'_',subClass,'_CutZ_Cut.png'));
    % imwrite(CutZ.CutExt,strcat('datasetPNG\',class,'_',subClass,'_CutZ_CutExt.png'));


    CutX = propsFeatures(iFeatures).CutXImage;
    CutY = propsFeatures(iFeatures).CutYImage;
    CutZ = propsFeatures(iFeatures).CutZImage;

    

    imwrite(CutX.Cut,strcat('feature_',num2str(iFeatures),'_CutX_Cut.png'));
    imwrite(CutX.CutExt,strcat('feature_',num2str(iFeatures),'_CutX_CutExt.png'));
    imwrite(CutX.CutTight,strcat('feature_',num2str(iFeatures),'_CutX_CutTight.png'));
    imwrite(CutX.CutTightHigh,strcat('feature_',num2str(iFeatures),'_CutX_CutTightHigh.png'));
    imwrite(CutX.CutTightExt,strcat('feature_',num2str(iFeatures),'_CutX_CutTightExt.png'));

    imwrite(CutY.Cut,strcat('feature_',num2str(iFeatures),'_CutY_Cut.png'));
    imwrite(CutY.CutExt,strcat('feature_',num2str(iFeatures),'_CutY_CutExt.png'));
    imwrite(CutY.CutTight,strcat('feature_',num2str(iFeatures),'_CutY_CutTight.png'));
    imwrite(CutY.CutTightHigh,strcat('feature_',num2str(iFeatures),'_CutY_CutTightHigh.png'));
    imwrite(CutY.CutTightExt,strcat('feature_',num2str(iFeatures),'_CutY_CutTightExt.png'));

    imwrite(CutZ.Cut,strcat('feature_',num2str(iFeatures),'_CutZ_Cut.png'));
    imwrite(CutZ.CutExt,strcat('feature_',num2str(iFeatures),'_CutZ_CutExt.png'));

end

%%

for featureIdx = 1:numel(propsFeatures)
    
    propsFeatures(featureIdx).CutXImage.Cut          = squeeze(propsFeatures(featureIdx).CutX.Cut);
    propsFeatures(featureIdx).CutXImage.CutExt       = squeeze(propsFeatures(featureIdx).CutX.CutExt);
    propsFeatures(featureIdx).CutXImage.CutTight     = squeeze(propsFeatures(featureIdx).CutX.CutTight);
    propsFeatures(featureIdx).CutXImage.CutTightHigh = squeeze(propsFeatures(featureIdx).CutX.CutTightHigh);
    propsFeatures(featureIdx).CutXImage.CutTightExt  = squeeze(propsFeatures(featureIdx).CutX.CutTightWide);

    propsFeatures(featureIdx).CutYImage.Cut          = squeeze(propsFeatures(featureIdx).CutY.Cut);
    propsFeatures(featureIdx).CutYImage.CutExt       = squeeze(propsFeatures(featureIdx).CutY.CutExt);
    propsFeatures(featureIdx).CutYImage.CutTight     = squeeze(propsFeatures(featureIdx).CutY.CutTight);
    propsFeatures(featureIdx).CutYImage.CutTightHigh = squeeze(propsFeatures(featureIdx).CutY.CutTight);
    propsFeatures(featureIdx).CutYImage.CutTightExt  = squeeze(propsFeatures(featureIdx).CutY.CutTightWide);

    propsFeatures(featureIdx).CutZImage.Cut          = squeeze(propsFeatures(featureIdx).CutZ.Cut);
    propsFeatures(featureIdx).CutZImage.CutExt       = squeeze(propsFeatures(featureIdx).CutZ.CutExt);    

end



