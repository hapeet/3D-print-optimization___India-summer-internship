function showCutSectionsIn3D(props, i,n)
    
%% tight cutout 

    cutX = squeeze(props(i).CutX.CutTight);
    cutXline = props(i).CutX.CutLine;
    cutXBoundaries = props(i).CutX.CutBoundaries;  % y coordinates from - to of cut
    
    cutY = squeeze(props(i).CutY.CutTight);
    cutYline = props(i).CutY.CutLine;
    cutYBoundaries = props(i).CutY.CutBoundaries;  % y coordinates from - to of cut
    
    cutZ = squeeze(props(i).CutZ.Cut);
    cutZline = props(i).CutZ.CutLine;
    cutZBoundaries = props(i).CutZ.CutBoundaries;  % Z coordinates from - to of cut


%% show cuts
    if size(cutX,2)<=1
        cutX = [cutX';cutX'];
    elseif size(cutX,1)<=1
        cutZ = [cutX;cutX];
    end

    if size(cutY,2)<=1
        cutY = [cutY';cutY'];
    elseif size(cutY,1)<=1
        cutZ = [cutY;cutY];
    end

    if size(cutZ,2)<=1
        cutZ = [cutZ';cutZ'];
    elseif size(cutZ,1)<=1
        cutZ = [cutZ;cutZ];
    end

    subplot(n,2*n,2*i-1)
    [Z,Y] = meshgrid(1:size(cutX,2),1:size(cutX,1));
    Y = Y + cutXBoundaries(1);
    Z = Z + props(i).BoundingBox(3,1);
    X = cutXline * ones(size(cutX));
    surf(X,Y,Z, double(cutX),"EdgeColor","none","FaceAlpha",0.8)
    hold on
    
    [Z,X] = meshgrid(1:size(cutY,2),1:size(cutY,1));
    X = X + cutYBoundaries(1);
    Z = Z + props(i).BoundingBox(3,1);
    Y = cutYline * ones(size(cutY));
    surf(X,Y,Z, double(cutY),"EdgeColor","none","FaceAlpha",0.8)
    hold on

    [Y,X] = meshgrid(1:size(cutZ,2),1:size(cutZ,1));
    X = X + cutZBoundaries(1,1)-1;
    Y = Y + cutZBoundaries(2,1)-1;
    Z = cutZline * ones(size(cutZ));
    surf(X,Y,Z, double(cutZ),"EdgeColor","none","FaceAlpha",0.8)

    axis equal
    colormap winter
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title(sprintf('Cut sections no. %d',i))

%% extended cutout

    cutX = squeeze(props(i).CutX.CutTightWide);
    cutXline = props(i).CutX.CutLine;
    cutXBoundaries = props(i).CutX.CutBoundariesExt;    % y coordinates from - to of cut
    
    cutY = squeeze(props(i).CutY.CutTightWide);
    cutYline = props(i).CutY.CutLine;
    cutYBoundaries = props(i).CutY.CutBoundariesExt;    % y coordinates from - to of cut

    cutZ = squeeze(props(i).CutZ.CutExt);
    cutZline = props(i).CutZ.CutLine;
    cutZBoundaries = props(i).CutZ.CutBoundariesExt;   

    if size(cutX,2)<=1
        cutX = [cutX';cutX'];
    elseif size(cutX,1)<=1
        cutZ = [cutX;cutX];
    end

    if size(cutY,2)<=1
        cutY = [cutY';cutY'];
    elseif size(cutY,1)<=1
        cutZ = [cutY;cutY];
    end

    if size(cutZ,2)<=1
        cutZ = [cutZ';cutZ'];
    elseif size(cutZ,1)<=1
        cutZ = [cutZ;cutZ];
    end


    subplot(n,2*n,2*i)
    [Z,Y] = meshgrid(1:size(cutX,2),1:size(cutX,1));
    Y = Y + cutXBoundaries(1);
    Z = Z + props(i).BoundingBox(3,1);
    X = cutXline * ones(size(cutX));
    surf(X,Y,Z, double(cutX),"EdgeColor","none","FaceAlpha",0.8)
    hold on
    
    [Z,X] = meshgrid(1:size(cutY,2),1:size(cutY,1));
    X = X + cutYBoundaries(1);
    Z = Z + props(i).BoundingBox(3,1);
    Y = cutYline * ones(size(cutY));
    surf(X,Y,Z, double(cutY),"EdgeColor","none","FaceAlpha",0.8)
    hold on

    [Y,X] = meshgrid(1:size(cutZ,2),1:size(cutZ,1));
    X = X + cutZBoundaries(1,1)-1;
    Y = Y + cutZBoundaries(2,1)-1;
    Z = cutZline * ones(size(cutZ));
    surf(X,Y,Z, double(cutZ),"EdgeColor","none","FaceAlpha",0.8)



    axis equal
    colormap winter
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title(sprintf('Cut sections extended no. %d',i))



end