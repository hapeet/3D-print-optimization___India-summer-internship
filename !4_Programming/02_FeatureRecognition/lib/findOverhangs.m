function propsFeatures = findOverhangs(G,propsFeatures,btmOffsetPx,mergeDistance)


    dG3 = diff(G,1,3);  % difference along z axis -> 1 if overhang starts, -1 if overhang ends
    
    Xdown = [];
    Ydown = [];
    Zdown = [];

    Xup = [];
    Yup = [];
    Zup = [];
    overhangSum = zeros(size(dG3,[1,2]));   %2D array of overhang count
    
    % makes pointcloud from all down facing body points
     for ix = 1:size(dG3,1)
         for iy = 1:size(dG3,2)
            % if ix == 20 & iy == 20
            %     2020
            % end
    
             coll = dG3(ix,iy,:);
             
             down = find(coll>=1);
             up = find(coll<=-1);
        
             if ~isempty(down)
                 
                 % F(F==btmOffsetPx) = [];
                 overhangSum(ix,iy) = length(down);
                 if down(1)== btmOffsetPx
                     overhangSum(ix,iy) = overhangSum(ix,iy)-1;
                 end
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

    XYZBodyDown = [Xdown(:),Ydown(:),Zdown(:)];
    ptsBodyDown = pointCloud([Xdown(:),Ydown(:),Zdown(:)]);     % whole down facint body point cloud
    ptsBodyNoBtm = pointCloud(XYZBodyDown(XYZBodyDown(:,3) > btmOffsetPx,:)); % point cloud of downfacing features higher than bottom of body



    XYZBodyUp = [Xup(:),Yup(:),Zup(:)];
    ptsBodyUp = pointCloud([Xup(:),Yup(:),Zup(:)]);             % whole up facint body point cloud

    
    
    [labelsNoBtm,numClusters] = pcsegdist(ptsBodyNoBtm,mergeDistance);       % clustering of features
    
    % subplot(2,1,2)
    f2 = figure ;
    f2.Units = "Normalized";
    f2.Position = [0 0 0.5 0.5];
    pcshow(ptsBodyNoBtm.Location,labelsNoBtm)
    colormap(hsv(numClusters))
    title('Supported features')
    
    
    %% 

    overhangSum(overhangSum>0) = overhangSum(overhangSum>0)-1;  % number of multiple overhangs

    [x,y] = find(overhangSum);  % xy projection of overhang areas 
    z = zeros(size(x));       
    
    % figure 
    ptsOverhang = pointCloud([x(:),y(:),z(:)]);
    
    [labelOverhangs,numOverhangs] = pcsegdist(ptsOverhang,2);   % separate multiple overhangs if there are
    
    % pcshow(ptsOverhang.Location,labelOverhangs)
    % title('Overhang points')
    
    
    
    %% 
    FeatureMat = zeros([size(G,[1,2]),size(propsFeatures,2)]);      % in layers are there stored idividual features projection
    
    for i = 1:size(propsFeatures,2)
        BoundingBox = floor(propsFeatures(i).BoundingBox);
        BB = [BoundingBox(1),BoundingBox(1)+BoundingBox(3); % xmin,xmax
              BoundingBox(2),BoundingBox(2)+BoundingBox(4)]; %ymin, ymax
        FeatureMat(BB(1,1)+1:BB(1,2),BB(2,1)+1:BB(2,2),i) = i*propsFeatures(i).FilledImage';
        
    
        [x,y] = find(FeatureMat(:,:,i));
        z = ones(size(x))*i;
        
    
        ptsFeatureMat = pointCloud([x(:),y(:),z(:)]);
        % hold on
        % pcshow(ptsFeatureMat)
    end

    %% new features


    for i = 1:numOverhangs
        overhangIpoints = ptsOverhang.Location(labelOverhangs==i,:);

        featureOld_ID = find(FeatureMat(overhangIpoints(1,1),overhangIpoints(1,2),:));
        propsFeatures(featureOld_ID) = []; %remove old interconnected feature

        featureNew_ID = labelsNoBtm(find(ptsBodyNoBtm.Location(:,1)== overhangIpoints(1,1) &...
                                    ptsBodyNoBtm.Location(:,2)== overhangIpoints(1,2))); % returns number of features included in overhang
        
        for u = 1:length(featureNew_ID)
            
            FeaturePoints = ptsBodyNoBtm.Location(labelsNoBtm==featureNew_ID(u),:);
            FeatureProjection = zeros(size(G,[1,2]));
            FeatureProjection(FeaturePoints(:,1),FeaturePoints(:,2)) = 1;
            
            propsNewFeature = regionprops(rot90(flip(FeatureProjection,2)));
            
            FeatureHeight.All = FeaturePoints(:,3)';
            FeatureHeight.Max = max(FeatureHeight.All);
            FeatureHeight.Min = min(FeatureHeight.All);

            propsFeatures(end+1).Area = propsNewFeature.Area;
            propsFeatures(end).Centroid = propsNewFeature.Centroid;
            propsFeatures(end).BoundingBox = propsNewFeature.BoundingBox;
            
            propsFeatures(end).FeatureHeight = FeatureHeight;

        end
        


    end


    %% ADD HEIGHT TO ALL OTHER FEATURES


    
    
end