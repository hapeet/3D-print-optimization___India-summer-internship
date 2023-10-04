function propsConnected = connectedFeatures(propsFeatures,originalImage)

if size(propsFeatures,1)>1
    C = nchoosek(1:size(propsFeatures,1),2);
    
    for i = 1:size(propsFeatures,1)
        propsFeatures(i).ConnectedFeature = [];
    end
    
    for i = 1:size(C,1)

        bboxA = propsFeatures(C(i,1)).BoundingBox;
        bboxB = propsFeatures(C(i,2)).BoundingBox;
    
        bboxA(1:2) = floor(bboxA(1:2));
        bboxA(3:4) = ceil(bboxA(3:4)) +1;
    
        bboxB(1:2) = floor(bboxB(1:2));
        bboxB(3:4) = ceil(bboxB(3:4)) +1;
    
        overlapRatio = bboxOverlapRatio(bboxA,bboxB,'Min');
    
        if overlapRatio ~= 0
            if isempty(propsFeatures(C(i,1)).ConnectedFeature)
                propsFeatures(C(i,1)).ConnectedFeature = C(i,2);
            else
                propsFeatures(C(i,1)).ConnectedFeature(end+1) = C(i,2);
            end
            
            if isempty(propsFeatures(C(i,2)).ConnectedFeature)
                propsFeatures(C(i,2)).ConnectedFeature = C(i,1);
            else
                propsFeatures(C(i,2)).ConnectedFeature(end+1) = C(i,1);
            end
        end
    end

    %% connecting

    propsConnected = propsFeatures;
    propsConnected(:) = [];
    propsConnected = rmfield(propsConnected, 'ConnectedFeature');


    for i = 1:(size(propsFeatures,1) - numel([propsFeatures.ConnectedFeature])/2)
        if isempty(propsFeatures(i).ConnectedFeature)
            propsConnected(end+1) = rmfield(propsFeatures(i), 'ConnectedFeature');
        else
            n1 = i;
            n2 = propsFeatures(i).ConnectedFeature;
            X = zeros(size(originalImage));
            X(propsFeatures(n1).PixelIdxList) = 1;
            X(propsFeatures(n2).PixelIdxList) = 1;
            propsX = regionprops(X,originalImage, 'all');
            propsConnected(end+1) = propsX;
            propsFeatures(n2) = [];
        end
    end
else 
    propsConnected = propsFeatures;
end

end
