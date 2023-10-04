function propsFeatures = cutFeatures(numberOfFeatures, G, propsFeatures, maxCutOffsetpx, cutOffsetPercent)

f3 = figure;
f3.Units = "normalized";
f3.Position = [0.5 0 0.5 1.5];
n = ceil(sqrt(numberOfFeatures));

[height, dG] = supportHeight(G);  % support height calculation

for featureID = 1:numberOfFeatures
    BoundingBox = propsFeatures(featureID).BoundingBox;     % bounding box of top view projection
    

    if ~isfield(propsFeatures(featureID),'FeatureHeight') ||...
        isempty(propsFeatures(featureID).FeatureHeight)  % overhang features has already filled and this method would not work

        H = zeros(1,length(propsFeatures(featureID).PixelList));
    
        for u = 1:length(propsFeatures(featureID).PixelList)
           H(1,u) = height(propsFeatures(featureID).PixelList(u,1),propsFeatures(featureID).PixelList(u,2));
        end
    
        propsFeatures(featureID).FeatureHeight.All = H;
        minH = min(H);              % feature min height
        maxH = max(H);              % feature max height
        propsFeatures(featureID).FeatureHeight.Max = maxH;
        propsFeatures(featureID).FeatureHeight.Min = minH;
        
        featureHeight = maxH - minH;
    else
        minH = propsFeatures(featureID).FeatureHeight.Min;
        maxH = propsFeatures(featureID).FeatureHeight.Max;

        featureHeight = maxH - minH;
    end



    cutXOffset = min(maxCutOffsetpx,ceil(cutOffsetPercent/100 * BoundingBox(4)));
    cutYOffset = min(maxCutOffsetpx,ceil(cutOffsetPercent/100 * BoundingBox(3)));
    
    cutZOffsetUpLim  = min(size(G,3), maxH + ceil(cutOffsetPercent/100 * featureHeight));
    cutZOffsetBotLim = max(1        , minH - ceil(cutOffsetPercent/100 * featureHeight));

    % CUT X

    propsFeatures(featureID).CutX.CutLine          =  round(propsFeatures(featureID).Centroid(1));    % x coordinate of cut
    propsFeatures(featureID).CutX.CutBoundaries    = [ceil(BoundingBox(2)), floor(BoundingBox(2)+BoundingBox(4))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.CutBoundariesExt = [max(1,ceil(BoundingBox(2))-cutXOffset), min(size(G,2), floor(BoundingBox(2)+BoundingBox(4))+cutXOffset)];   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.Cut              = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundaries(1):propsFeatures(featureID).CutX.CutBoundaries(2)],:);
    propsFeatures(featureID).CutX.CutExt           = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundariesExt(1):propsFeatures(featureID).CutX.CutBoundariesExt(2)],:);
    propsFeatures(featureID).CutX.CutTight         = propsFeatures(featureID).CutX.Cut(:,:,minH:maxH);
    propsFeatures(featureID).CutX.CutTightExt      = propsFeatures(featureID).CutX.CutExt(:,:,[cutZOffsetBotLim:cutZOffsetUpLim]);

    % CUT Y

    propsFeatures(featureID).CutY.CutLine          = round(propsFeatures(featureID).Centroid(2));     % x coordinate of cut
    propsFeatures(featureID).CutY.CutBoundaries    = [ceil(BoundingBox(1)), floor(BoundingBox(1)+BoundingBox(3))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.CutBoundariesExt = [max(1,ceil(BoundingBox(1))-cutYOffset), min(size(G,1),floor(BoundingBox(1)+BoundingBox(3))+cutYOffset)];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.Cut              = G([propsFeatures(featureID).CutY.CutBoundaries(1):propsFeatures(featureID).CutY.CutBoundaries(2)],propsFeatures(featureID).CutY.CutLine,:);
    propsFeatures(featureID).CutY.CutExt           = G([propsFeatures(featureID).CutY.CutBoundariesExt(1):propsFeatures(featureID).CutY.CutBoundariesExt(2)],propsFeatures(featureID).CutY.CutLine,:);
    propsFeatures(featureID).CutY.CutTight         = propsFeatures(featureID).CutY.Cut(:,:,minH:maxH);
    propsFeatures(featureID).CutY.CutTightExt      = propsFeatures(featureID).CutY.CutExt(:,:,[cutZOffsetBotLim:cutZOffsetUpLim]);

    
    % CUT Z

    propsFeatures(featureID).CutZ.CutLine          = round(mean([minH,maxH]));
    propsFeatures(featureID).CutZ.CutBoundaries    = [propsFeatures(featureID).CutY.CutBoundaries;      propsFeatures(featureID).CutX.CutBoundaries];
    propsFeatures(featureID).CutZ.CutBoundariesExt = [propsFeatures(featureID).CutY.CutBoundariesExt;   propsFeatures(featureID).CutX.CutBoundariesExt];
    propsFeatures(featureID).CutZ.Cut              = G(propsFeatures(featureID).CutZ.CutBoundaries(1,1):propsFeatures(featureID).CutZ.CutBoundaries(1,2),...
                                                       propsFeatures(featureID).CutZ.CutBoundaries(2,1):propsFeatures(featureID).CutZ.CutBoundaries(2,2),...
                                                       propsFeatures(featureID).CutZ.CutLine);
    propsFeatures(featureID).CutZ.CutExt           = G(propsFeatures(featureID).CutZ.CutBoundariesExt(1,1):propsFeatures(featureID).CutZ.CutBoundariesExt(1,2),...
                                                       propsFeatures(featureID).CutZ.CutBoundariesExt(2,1):propsFeatures(featureID).CutZ.CutBoundariesExt(2,2),...
                                                       propsFeatures(featureID).CutZ.CutLine);  

    subplot(n,2*n,featureID)
    showCutSectionsIn3D(propsFeatures, featureID,n)
end


end