function bodyData = featureSurroundings(bodyData)

for iFeature = 1:numel(bodyData.propsFeatures)
 % For each cut surroundings analysed to determine percentual fill of left
 % and right side of feature


% CUT X 

bodyData.propsFeatures(iFeature).CutX.negSurroundings = bodyData.propsFeatures(iFeature).CutX.CutMaxWidth(1,1:bodyData.params.maxCutOffsetPx-4,:);
bodyData.propsFeatures(iFeature).CutX.posSurroundings = bodyData.propsFeatures(iFeature).CutX.CutMaxWidth(1,(size(bodyData.propsFeatures(iFeature).CutX.CutTightMaxWidth,2)-bodyData.params.maxCutOffsetPx+5):end,:);

bodyData.propsFeatures(iFeature).CutX.negSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutX.negSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutX.negSurroundings);
bodyData.propsFeatures(iFeature).CutX.posSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutX.posSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutX.posSurroundings);

% CUT X show images
f = figure
f.Color = [1 1 1];
f.Position = [0 300 1400 550];
subplot(2,4,1:2)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutX.CutMaxWidth)))
axis on
title(sprintf('Feature %i, Extended cut I_x',iFeature))
xlabel('Y [px]')
ylabel('Z [px]')


subplot(2,4,5)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutX.negSurroundings)))
axis on
title(sprintf('Negative direction surroundings\n density %0.1f %%',bodyData.propsFeatures(iFeature).CutX.negSurroundingsRatio*100))
xlabel('Y [px]')
ylabel('Z [px]')

subplot(2,4,6)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutX.posSurroundings)))
axis on
title(sprintf('Positive direction surroundings\n density %0.1f %%',bodyData.propsFeatures(iFeature).CutX.posSurroundingsRatio*100))
xlabel('Y [px]')
ylabel('Z [px]')

% CUT Y 

bodyData.propsFeatures(iFeature).CutY.negSurroundings = bodyData.propsFeatures(iFeature).CutY.CutMaxWidth(1:bodyData.params.maxCutOffsetPx-4,1,:);
bodyData.propsFeatures(iFeature).CutY.posSurroundings = bodyData.propsFeatures(iFeature).CutY.CutMaxWidth((size(bodyData.propsFeatures(iFeature).CutY.CutTightMaxWidth,1)-bodyData.params.maxCutOffsetPx+5):end,1,:);

bodyData.propsFeatures(iFeature).CutY.negSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutY.negSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutY.negSurroundings);
bodyData.propsFeatures(iFeature).CutY.posSurroundingsRatio = numel(find(bodyData.propsFeatures(iFeature).CutY.posSurroundings)) / numel(bodyData.propsFeatures(iFeature).CutY.posSurroundings);

% CUT Y show images
subplot(2,4,3:4)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutY.CutMaxWidth)))
axis on
title(sprintf('Feature %i, Extended cut I_y',iFeature))
xlabel('X [px]')
ylabel('Z [px]')


subplot(2,4,7)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutY.negSurroundings)))
axis on
title(sprintf('Negative direction surroundings\n density %0.1f %%',bodyData.propsFeatures(iFeature).CutY.negSurroundingsRatio*100))
xlabel('X [px]')
ylabel('Z [px]')

subplot(2,4,8)
imshow(rot90(squeeze(bodyData.propsFeatures(iFeature).CutY.posSurroundings)))
axis on
title(sprintf('Positive direction surroundings\n density %0.1f %%',bodyData.propsFeatures(iFeature).CutY.posSurroundingsRatio*100))
xlabel('X [px]')
ylabel('Z [px]')

saveas(f,sprintf('feature_%i_surroundings.png',iFeature))
% close all

end