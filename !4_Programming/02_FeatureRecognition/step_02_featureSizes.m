clc; close all;


% resolution = 0.25;  % pixelsize in mm

%% dimensional properties of feature - measured in mm

for iFeature = 1:numel(propsFeatures)
    F = propsFeatures(iFeature);

    pointsFeature = F.featurePoints.down * resolution;
    pointsOverhangTop = F.featurePoints.overhangTop * resolution;
    pointsSupportBtm = F.featurePoints.supportBtm * resolution;


    % Feature down facing points

    featureXmax = max(pointsFeature(:,1));
    featureXmin = min(pointsFeature(:,1));

    featureYmax = max(pointsFeature(:,2));
    featureYmin = min(pointsFeature(:,2));



    % Supports height
    supportHeight = pointsFeature(:,3) - pointsSupportBtm(:,3);
    
    % overhang height
    overhangHeight = pointsOverhangTop(:,3)-pointsFeature(:,3);


    D = struct;

    D.area =  F.Area*resolution^2;
    D.xWidth = (featureXmax-featureXmin+1);
    D.yWidth = (featureYmax-featureYmin+1);     

    D.featureHeight.min =  min(pointsFeature(:,3));
    D.featureHeight.max = max(pointsFeature(:,3));
    D.featureHeight.avg = mean(pointsFeature(:,3));
    
    % supports measured from bottom of supports untill feature surface
    D.supportHeight.min = min(supportHeight);
    D.supportHeight.max = max(supportHeight);
    D.supportHeight.avg = mean(supportHeight);
    
    
    % overhang - mearured from top of feature
    D.overhangHeight.min = min(overhangHeight);
    D.overhangHeight.max = max(overhangHeight);
    D.overhangHeight.avg = mean(overhangHeight);


    propsFeatures(iFeature).dimensions = D;
end