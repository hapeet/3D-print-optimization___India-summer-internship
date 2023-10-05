function [propsFeatures,ptsDown,ptsDownNoBtmFiltered, labelsNoBtmFiltered, ptsUp]  = findOverhangs_v2(G,btmOffsetPx,mergeDistance,wireframe, wireframeOffset)
    

    G = cat(3,G,zeros([size(G,[1,2]),1]));  % add 1px over body to have diff result on top of overhangs
    dG3 = diff(G,1,3);  % difference along z axis -> 1 if overhang starts, -1 if overhang ends
    
    Xdown = [];
    Ydown = [];
    Zdown = [];

    Xup = [];
    Yup = [];
    Zup = [];

    
    % makes pointcloud from all down and up facing body points
     for ix = 1:size(dG3,1)
         for iy = 1:size(dG3,2)

             coll = dG3(ix,iy,:);
             
             down = find(coll>=1);
             up = find(coll<=-1);
        
             if ~isempty(down)
                 
                 
                 Xdown = [Xdown; ix*ones(size(down))];
                 Ydown = [Ydown; iy*ones(size(down))];
                 Zdown = [Zdown; down];
             end

             if ~isempty(up)
                 
                 upFaceSum(ix,iy) = length(up);

                 Xup = [Xup; ix*ones(size(up))];
                 Yup = [Yup; iy*ones(size(up))];
                 Zup = [Zup; up];
             end
         end
     end

    XyzDown = [Xdown(:),Ydown(:),Zdown(:)];
    ptsDown = pointCloud(XyzDown);     % whole down facint body point cloud

    if max(XyzDown(:,3))>btmOffsetPx
        ptsDownNoBtm = pointCloud(XyzDown(XyzDown(:,3) > btmOffsetPx,:)); % point cloud of downfacing features higher than bottom of body
    else
        ptsDownNoBtm = pointCloud(XyzDown);     %if there is no features higher than btmOffset
    end


    XyzUp = [Xup(:),Yup(:),Zup(:)];
    ptsUp = pointCloud(XyzUp);             % whole up facint body point cloud

    

    %% FILTER WIREFRAME CLOSE POINTS

    ptsDownNoBtmFiltered = pointLineDistanceFilter(wireframe,ptsDownNoBtm, wireframeOffset);


    [labelsNoBtmFiltered,numClusters] = pcsegdist(ptsDownNoBtmFiltered,mergeDistance);       % clustering of features
    
    % f2 = figure ;
    % f2.Units = "Normalized";
    % f2.Position = [0 0 0.5 0.5];
    % subplot(1,2,1)
    % pcshow(ptsDownNoBtmFiltered.Location,labelsNoBtmFiltered)
    % colormap(hsv(numClusters))
    % title('down facing features - 1st layer removed')
    % hold on
    % 
    % 
    % subplot(1,2,2)
    % pcshow(ptsUp)
    % title('up facing faces')
    % hold 

    
    
    %% 
    
    propsFeatures = struct;
    
    numFeatures = numel(unique(labelsNoBtmFiltered));
    FeatureMat = zeros([size(G,[1,2]),numFeatures]);      % in layers are there stored idividual features projection
    
    for featureIdx = 1:numFeatures

        featurePoints.down = ptsDownNoBtmFiltered.Location(labelsNoBtmFiltered == featureIdx,:);
        featurePoints.overhangTop = [[],[],[]];
        featurePoints.supportBtm  = [[],[],[]];
        for i = 1:size(featurePoints.down,1)
            x = featurePoints.down(i,1);
            y = featurePoints.down(i,2);
            z = featurePoints.down(i,3);

            ups = ptsUp.Location(ptsUp.Location(:,1) == x & ptsUp.Location(:,2) == y,:);
            ups = sortrows(ups,3);

            higherUpIdx = min(find(ups(:,3)>z));
            lowerUpIdx  = max(find(ups(:,3)<z));

            if ~isempty(higherUpIdx)
                featurePoints.overhangTop(end+1,:) = ups(higherUpIdx,:);
            else
                featurePoints.overhangTop(end+1,:) = [x,y,size(G,3)];
            end

            % 
            if ~isempty(lowerUpIdx)
                featurePoints.supportBtm(end+1,:) = ups(lowerUpIdx,:);
            else
                featurePoints.supportBtm(end+1,:) = [x,y,1];
            end
        end
        

        % 3D bounding box [xmin,xmax;ymin,ymax;zmin,zmax] - >
        % z form support btm to overhang top
        BB = [min(featurePoints.down(:,1)),max(featurePoints.down(:,1));...                 % X span of feature
              min(featurePoints.down(:,2)),max(featurePoints.down(:,2));...                 % Y span of feature
              min(featurePoints.down(:,3)),max(featurePoints.down(:,3));...                 % Z span - height of feature
              median(featurePoints.supportBtm(:,3)),median(featurePoints.overhangTop(:,3))];    % height from bottom of support to top of overhang
        
        
        if BB(3,1)==BB(3,2)         % if feature is flat -> add height of tight section until top of overhang
            BB(3,2) = BB(4,2);
        end


        centrX = round(mean(featurePoints.down(:,1)));
        centrY = round(mean(featurePoints.down(:,2)));

        
        propsFeatures(featureIdx,1).Area = size(featurePoints.down,1);
        propsFeatures(featureIdx,1).Centroid = [centrX,centrY];
        propsFeatures(featureIdx,1).BoundingBox = BB;
        propsFeatures(featureIdx,1).featurePoints = featurePoints;



    end

    %% fileter thin features
    for iFeature = numel(propsFeatures):-1:1
        
        dBoundBox = diff(propsFeatures(iFeature).BoundingBox,1,2) +1;

        featureProjection = [];

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
