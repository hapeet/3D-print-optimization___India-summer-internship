function [propsFeatures,ptsDown,ptsDownNoBtmFiltered, labelsNoBtmFiltered, ptsUp]  = findOverhangs_v2(G,btmOffsetPx,mergeDistance,wireframe, wireframeOffset)
    

    G = cat(3,G,zeros([size(G,[1,2]),1]));  % add cutoff gap
    dG3 = diff(G,1,3);  % difference along z axis -> =1 if overhang starts, =-1 if overhang ends
    
    Xdown = [];
    Ydown = [];
    Zdown = [];

    Xup = [];
    Yup = [];
    Zup = [];

    
    % makes pointcloud from all down and up facing body points
     for ix = 1:size(dG3,1)
         for iy = 1:size(dG3,2)

             coll = dG3(ix,iy,:); % one collumn
             
             down = find(coll>=1); % downfacing points
             up = find(coll<=-1);   % upfacing points
        
             if ~isempty(down) 
                 Xdown = [Xdown; ix*ones(size(down))];
                 Ydown = [Ydown; iy*ones(size(down))];
                 Zdown = [Zdown; down];
             end

             if ~isempty(up)
                 Xup = [Xup; ix*ones(size(up))];
                 Yup = [Yup; iy*ones(size(up))];
                 Zup = [Zup; up];
             end
         end
     end

    XyzDown = [Xdown(:),Ydown(:),Zdown(:)];

    ptsDown = pointCloud(XyzDown);     % whole downfacing body pointcloud


    if max(XyzDown(:,3))>btmOffsetPx  % FILTER FIRST LAYER -> point cloud of downfacing features higher than bottom of body
        ptsDownNoBtm = pointCloud(XyzDown(XyzDown(:,3) > btmOffsetPx,:)); 
    else
        ptsDownNoBtm = pointCloud(XyzDown);     %if there is no features higher than btmOffset
    end


    XyzUp = [Xup(:),Yup(:),Zup(:)];
    ptsUp = pointCloud(XyzUp);             % whole up facing body point cloud

    

    %% FILTER WIREFRAME CLOSE POINTS

    ptsDownNoBtmFiltered = pointLineDistanceFilter(wireframe,ptsDownNoBtm, wireframeOffset);


    
    
    
    %% FEATURE IDENTIFICATION AND PARAMETERS EVALUATION

    [labelsNoBtmFiltered,~] = pcsegdist(ptsDownNoBtmFiltered,mergeDistance);       % clustering features

    propsFeatures = struct;                             
    numFeatures = numel(unique(labelsNoBtmFiltered));
    
    for featureIdx = 1:numFeatures

        featurePoints.down = ptsDownNoBtmFiltered.Location(labelsNoBtmFiltered == featureIdx,:);
        featurePoints.overhangTop = [[],[],[]];
        featurePoints.supportBtm  = [[],[],[]];
        
        for i = 1:size(featurePoints.down,1)
            x = featurePoints.down(i,1);
            y = featurePoints.down(i,2);
            z = featurePoints.down(i,3);

            ups = ptsUp.Location(ptsUp.Location(:,1) == x & ptsUp.Location(:,2) == y,:);    % all upfacing points in collumn given by x and y
            ups = sortrows(ups,3);                                                          

            higherUpIdx = min(find(ups(:,3)>z));    % find index of upfacing point one OVER current overhang point given by z height 
            lowerUpIdx  = max(find(ups(:,3)<z));    % find index of upfacing point one UNDER current overhang point given by z height 

            if ~isempty(higherUpIdx)    % position of overhang top
                featurePoints.overhangTop(end+1,:) = ups(higherUpIdx,:);
            else
                featurePoints.overhangTop(end+1,:) = [x,y,size(G,3)];
            end


            if ~isempty(lowerUpIdx)     % position of support bottom
                featurePoints.supportBtm(end+1,:) = ups(lowerUpIdx,:);
            else
                featurePoints.supportBtm(end+1,:) = [x,y,1];
            end

        end
        

        % Bounding box describing:
        BB = [min(featurePoints.down(:,1)),max(featurePoints.down(:,1));...                 % X span of feature
              min(featurePoints.down(:,2)),max(featurePoints.down(:,2));...                 % Y span of feature
              min(featurePoints.down(:,3)),max(featurePoints.down(:,3));...                 % Z span - height of feature
              median(featurePoints.supportBtm(:,3)),median(featurePoints.overhangTop(:,3))];    % median height from bottom of support to top of overhang
        
        
        if BB(3,1)==BB(3,2)         % if feature is horizontally flat -> add height of tight section until top of overhang
            BB(3,2) = BB(4,2);
        end

        % centroid of feature
        centrX = round(mean(featurePoints.down(:,1)));   
        centrY = round(mean(featurePoints.down(:,2)));

        
        % feature parameters save
        propsFeatures(featureIdx,1).Area = size(featurePoints.down,1);
        propsFeatures(featureIdx,1).Centroid = [centrX,centrY];
        propsFeatures(featureIdx,1).BoundingBox = BB;
        propsFeatures(featureIdx,1).featurePoints = featurePoints;



    end

   %% FILTER OUT THIN FEATURES
   % based on ratio of lenght and area of feature hull

    for iFeature = numel(propsFeatures):-1:1

        featureProjection = [];    
        
        % feature 2D projection
        for n = 1:numel(propsFeatures(iFeature).featurePoints.down(:,1))
            featureProjection(propsFeatures(iFeature).featurePoints.down(n,1),propsFeatures(iFeature).featurePoints.down(n,2)) = 1;
        end
        
        regionConvexHull = regionprops(featureProjection,"ConvexHull");
        
        lengthHull = size(regionConvexHull(1).ConvexHull,1);


        if lengthHull/propsFeatures(iFeature).Area > 1 
            propsFeatures(iFeature) = [];
        end
        
    end

end