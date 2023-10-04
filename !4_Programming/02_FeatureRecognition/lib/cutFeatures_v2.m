function propsFeatures = cutFeatures_v2(G, propsFeatures, maxCutOffsetpx, cutOffsetPercent)

numOfFeatures = numel(propsFeatures);

f3 = figure;
f3.Units = "normalized";
f3.Position = [0.5 0 0.5 1.5];
n = ceil(sqrt(numOfFeatures));

% [height, dG] = supportHeight(G);  % support height calculation

for featureID = 1:numOfFeatures
    BB = propsFeatures(featureID).BoundingBox;     % bounding box of top view projection 

    cutXOffset       = min(maxCutOffsetpx,  ceil(cutOffsetPercent/100 * (BB(2,2)-BB(2,1))));
    cutYOffset       = min(maxCutOffsetpx,  ceil(cutOffsetPercent/100 * (BB(1,2)-BB(1,1))));
    
    cutZOffsetUpLim  = ceil(min(size(G,3), BB(3,2) + ceil(cutOffsetPercent/100 * (BB(3,2)-BB(3,1)))));
    cutZOffsetBotLim = floor(max(1        , BB(3,1) - ceil(cutOffsetPercent/100 * (BB(3,2)-BB(3,1)))));

    % CUT X

    propsFeatures(featureID).CutX.CutLine          =  round(propsFeatures(featureID).Centroid(1));                      % x coordinate of cut
    propsFeatures(featureID).CutX.CutBoundaries    = [ceil(BB(2,1)), floor(BB(2,2))];                                   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.CutBoundariesExt = [max(1,ceil(BB(2,1))-cutXOffset), min(size(G,2), floor(BB(2,2)+cutXOffset))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.Cut              = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundaries(1):propsFeatures(featureID).CutX.CutBoundaries(2)],:);
    propsFeatures(featureID).CutX.CutExt           = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundariesExt(1):propsFeatures(featureID).CutX.CutBoundariesExt(2)],:);
    propsFeatures(featureID).CutX.CutTight         = propsFeatures(featureID).CutX.Cut(:,:,BB(3,1):BB(3,2));
    propsFeatures(featureID).CutX.CutTightExt      = propsFeatures(featureID).CutX.CutExt(:,:,[cutZOffsetBotLim:cutZOffsetUpLim]);

    % CUT Y

    propsFeatures(featureID).CutY.CutLine          = round(propsFeatures(featureID).Centroid(2));     % x coordinate of cut
    propsFeatures(featureID).CutY.CutBoundaries    = [ceil(BB(1,1)), floor(BB(1,2))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.CutBoundariesExt = [max(1,ceil(BB(1,1))-cutYOffset), min(size(G,1),floor(BB(1,2)+cutYOffset))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.Cut              = G([propsFeatures(featureID).CutY.CutBoundaries(1):propsFeatures(featureID).CutY.CutBoundaries(2)],propsFeatures(featureID).CutY.CutLine,:);
    propsFeatures(featureID).CutY.CutExt           = G([propsFeatures(featureID).CutY.CutBoundariesExt(1):propsFeatures(featureID).CutY.CutBoundariesExt(2)],propsFeatures(featureID).CutY.CutLine,:);
    propsFeatures(featureID).CutY.CutTight         = propsFeatures(featureID).CutY.Cut(:,:,BB(3,1):BB(3,2));
    propsFeatures(featureID).CutY.CutTightExt      = propsFeatures(featureID).CutY.CutExt(:,:,[cutZOffsetBotLim:cutZOffsetUpLim]);

    
    % CUT Z

    propsFeatures(featureID).CutZ.CutLine          = round(mean(propsFeatures(featureID).featurePoints.down(:,3)));
    propsFeatures(featureID).CutZ.CutBoundaries    = [propsFeatures(featureID).CutY.CutBoundaries;      propsFeatures(featureID).CutX.CutBoundaries];
    propsFeatures(featureID).CutZ.CutBoundariesExt = [propsFeatures(featureID).CutY.CutBoundariesExt;   propsFeatures(featureID).CutX.CutBoundariesExt];
    propsFeatures(featureID).CutZ.Cut              = G(propsFeatures(featureID).CutZ.CutBoundaries(1,1):propsFeatures(featureID).CutZ.CutBoundaries(1,2),...
                                                       propsFeatures(featureID).CutZ.CutBoundaries(2,1):propsFeatures(featureID).CutZ.CutBoundaries(2,2),...
                                                       propsFeatures(featureID).CutZ.CutLine);
    propsFeatures(featureID).CutZ.CutExt           = G(propsFeatures(featureID).CutZ.CutBoundariesExt(1,1):propsFeatures(featureID).CutZ.CutBoundariesExt(1,2),...
                                                       propsFeatures(featureID).CutZ.CutBoundariesExt(2,1):propsFeatures(featureID).CutZ.CutBoundariesExt(2,2),...
                                                       propsFeatures(featureID).CutZ.CutLine);  

    subplot(n,2*n,featureID)
    showCutSectionsIn3D_tight(propsFeatures, featureID,n)
end


end