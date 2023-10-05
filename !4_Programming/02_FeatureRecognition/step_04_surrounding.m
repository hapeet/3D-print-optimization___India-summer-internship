clc; close all




for iFeature = 1:numel(bodyData.propsFeatures)

% CUT X 

% bodyData.propsFeatures(iFeature).CutX.negSurroundings = bodyData.propsFeatures(iFeature).CutX.CutTightMaxWidth(1,1:bodyData.params.maxCutOffsetPx-4,:);
% bodyData.propsFeatures(iFeature).CutX.posSurroundings = bodyData.propsFeatures(iFeature).CutX.CutTightMaxWidth(1,(size(bodyData.propsFeatures(iFeature).CutX.CutTightMaxWidth,2)-bodyData.params.maxCutOffsetPx+5):end,:);

bodyData.propsFeatures(iFeature).CutX.negSurroundings = bodyData.propsFeatures(iFeature).CutX.CutMaxWidth(1,1:bodyData.params.maxCutOffsetPx-4,:);
bodyData.propsFeatures(iFeature).CutX.posSurroundings = bodyData.propsFeatures(iFeature).CutX.CutMaxWidth(1,(size(bodyData.propsFeatures(iFeature).CutX.CutTightMaxWidth,2)-bodyData.params.maxCutOffsetPx+5):end,:);

bodyData.propsFeatures(iFeature).CutX.negSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutX.negSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutX.negSurroundings);
bodyData.propsFeatures(iFeature).CutX.posSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutX.posSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutX.posSurroundings);


% figure
% subplot(2,2,[1,3])
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutX.CutMaxWidth)) 
% axis on
% 
% subplot(2,2,2)
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutX.negSurroundings))
% axis on
% 
% subplot(2,2,4)
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutX.posSurroundings))
% axis on
% 
% close all

% CUT Y 

bodyData.propsFeatures(iFeature).CutY.negSurroundings = bodyData.propsFeatures(iFeature).CutY.CutMaxWidth(1:bodyData.params.maxCutOffsetPx-4,1,:);
bodyData.propsFeatures(iFeature).CutY.posSurroundings = bodyData.propsFeatures(iFeature).CutY.CutMaxWidth((size(bodyData.propsFeatures(iFeature).CutY.CutTightMaxWidth,1)-bodyData.params.maxCutOffsetPx+5):end,1,:);

bodyData.propsFeatures(iFeature).CutY.negSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutY.negSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutY.negSurroundings);
bodyData.propsFeatures(iFeature).CutY.posSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutY.posSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutY.posSurroundings);

% figure
% subplot(2,2,[1,3])
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutY.CutMaxWidth)) 
% axis on
% 
% subplot(2,2,2)
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutY.negSurroundings))
% axis on
% 
% subplot(2,2,4)
% imshow(squeeze(bodyData.propsFeatures(iFeature).CutY.posSurroundings))
% axis on
% 
% close all

end