

for iFeature = 1:numel(bodyData.propsFeatures)
    supportBottomPoints = bodyData.propsFeatures(iFeature).featurePoints.supportBtm(:,3);  
 
    bodyData.propsFeatures(iFeature).supportStandOnBaseRatio = numel(find(supportBottomPoints == 1)) / numel(supportBottomPoints);   % 1- if all supports stand on base build plate; 0 - if all supports stand on other feature overhang

end