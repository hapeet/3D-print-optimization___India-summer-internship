%% INIT
clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath

%% parameters
body = 'Body_07';   % input stl 
resolution = 1; %resolution in mm
filterSmallFeatures = true;     % if true features which are shaped as lines/edges are filtered out
smallFeaturesTreshold = 1;      % if feature XY projection is smaller than 
                                % smallFeaturesTreshold percents of whole image then is this feature filtered out
filterUpfaceFeatures = true;

maxCutOffsetmm = 10;     % maximal cut offset in mm
maxCutOffsetpx = maxCutOffsetmm / resolution;

cutOffsetPercent    = 30;                  % cut offset ar percents of feature width

captionFontSize = 14;
%% STL import to 3D grid and XY projection I

[I,G] = importStlToGrid(body,resolution);
originalImage = rot90(flip(I,2));

% Display the grayscale image.
subplot(2, 2, 1);

% Maximize the figure window.
hFig1 = gcf;
hFig1.Units = 'normalized';
hFig1.WindowState = 'maximized'; % Go to full screen
hFig1.NumberTitle = 'off'; % Get rid of "Figure 1"
image(originalImage);
axis('on', 'xy');
axis equal tight
colormap gray

% Force it to display RIGHT NOW (otherwise it might not display until it's all done, unless you've stopped at a breakpoint.)
% drawnow;

title('Original image', 'FontSize', captionFontSize);

%% mask of non supported features

M = zeros(size(G,1:2)); %mask

for ix = 1:size(G,1)
    for iy = 1:size(G,2)
        A = squeeze(G(ix, iy, :))' ;  % one collumn sum

        dA = diff(A);
        if ~isempty(find(dA>0,1))
            M(ix,iy) = 1;
        end
    end
end

subplot(2, 2, 2);
imshow(rot90(flip(M,2)));
title('Down face features mask', 'FontSize', captionFontSize);
text(size(M,1)+5 , 5, 'white - in air');
text(size(M,1)+5 , 10, 'black - bottom surface');
axis('on', 'xy');


%% histogram
[pixelCount, grayLevels] = imhist(originalImage);

[locsLowBoundaries, locsHigh] = histogramFilter(pixelCount);

% subplot(2, 2, 2);
% bar(pixelCount);
% title('Histogram of original image', 'FontSize', captionFontSize);
% xlim([0 grayLevels(end)]); % Scale x axis manually.
% grid on;


%% Identify individual features by seeing which pixels are connected to each other.

[labeledImage, numberOfFeatures] = imageLabel(originalImage, locsLowBoundaries, locsHigh);


subplot(2, 2, 3);
imshow(labeledImage, []);  % Show the gray scale image.
axis('on', 'xy');
title('Sectioned image', 'FontSize', captionFontSize);
% drawnow;

% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(2, 2, 4);
imshow(coloredLabels);
axis('on', 'xy');
title('Colored regions', 'FontSize', captionFontSize);






%%  Feature properties
propsAll = regionprops(labeledImage, originalImage, 'all');

% clear empty and auxalar regions 
propsAll([propsAll.Area] == 0) = [];

propsFeatures = propsAll;

%% filtering-out upface features

allFeatureCentroids = vertcat(propsFeatures.Centroid);      % centroid coordinates.
idxs = [];
    for i = 1:size(propsFeatures,1)
        if  ~M(round(allFeatureCentroids(i,1)),round(allFeatureCentroids(i,2)))
            propsFeatures(i).FaceDir = 'up';
        else
            propsFeatures(i).FaceDir = 'down';
        end
    end
 
    if filterUpfaceFeatures
        propsFeatures = propsFeatures(ismember({propsFeatures.FaceDir},{'down'}));
    end
    propsFeatures = rmfield(propsFeatures, 'FaceDir');

%% filtering-out small features

projectionArea = size(G,1)*size(G,2);

for i = 1:size(propsFeatures,1)
        propsFeatures(i).PercentualSize =propsFeatures(i).Area/projectionArea*100;
end
 
if filterSmallFeatures
    propsFeatures(cell2mat({propsFeatures.PercentualSize})<smallFeaturesTreshold) = [];
end

    propsFeatures = rmfield(propsFeatures, 'PercentualSize');


%% FILTERING CONNECTED FEATURES


propsFeatures = connectedFeatures(propsFeatures,originalImage,G);





%%

Centroids = vertcat(propsFeatures.Centroid);      % centroid of down facing features coordinates.

numberOfFeatures = numel(propsFeatures); 

textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% Print header line in the command window.
% fprintf(1,'\nBlob #      Mean Intensity  Centroid \n');
% 
% for k = 1 : numberOfFeatures           
% 	meanGL = propsFeatures(k).MeanIntensity;		% Get average intensity.
% 	featureCentroid = propsFeatures(k).Centroid;		% Get centroid one at a time
% 
% 	fprintf(1,'#%2d %8.1f %8.1f \n', k, meanGL, featureCentroid);
% 
%     % Put the "blob number" labels on the grayscale image that is showing the red boundaries on it.
% 	% text(blobCentroid(1), blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% end


%% numbering in image, drawing position of centers
centroidsX = Centroids(:, 1);			% Extract out the centroid x values into their own vector.
centroidsY = Centroids(:, 2);			% Extract out the centroid y values into their own vector.
% Put the labels on the rgb labeled image also.
subplot(2, 2, 4);
for k = 1 : numberOfFeatures           % Loop through all blobs.
	% Place the blob label number at the centroid of the blob.
	text(centroidsX(k), centroidsY(k), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end


subplot(2, 2, 1);
hold on; % Don't blow away image.
for k = 1 : numberOfFeatures           % Loop through all keeper blobs.
		plot(centroidsX(k), centroidsY(k), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
end


%% cutting 
figure
n = ceil(sqrt(numberOfFeatures));

[height, dG] = supportHeight(G);  % support height calculation
for featureID = 1:numberOfFeatures
    BoundingBox = propsFeatures(featureID).BoundingBox;     % bounding box of top view projection
    
    cutXOffset = min(maxCutOffsetpx,ceil(cutOffsetPercent/100 * BoundingBox(4)));
    cutYOffset = min(maxCutOffsetpx,ceil(cutOffsetPercent/100 * BoundingBox(3)));



    propsFeatures(featureID).CutX.CutLine           =  round(propsFeatures(featureID).Centroid(1));    % x coordinate of cut
    propsFeatures(featureID).CutX.CutBoundaries    = [ceil(BoundingBox(2)), floor(BoundingBox(2)+BoundingBox(4))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.CutBoundariesExt = [max(1,ceil(BoundingBox(2))-cutXOffset), min(size(G,2), floor(BoundingBox(2)+BoundingBox(4))+cutXOffset)];   % y coordinates from - to of cut
    propsFeatures(featureID).CutX.Cut               = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundaries(1):propsFeatures(featureID).CutX.CutBoundaries(2)],:);
    propsFeatures(featureID).CutX.CutExt           = G(propsFeatures(featureID).CutX.CutLine,[propsFeatures(featureID).CutX.CutBoundariesExt(1):propsFeatures(featureID).CutX.CutBoundariesExt(2)],:);


    propsFeatures(featureID).CutY.CutLine          = round(propsFeatures(featureID).Centroid(2));     % x coordinate of cut
    propsFeatures(featureID).CutY.CutBoundaries    = [ceil(BoundingBox(1)), floor(BoundingBox(1)+BoundingBox(3))];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.CutBoundariesExt = [max(1,ceil(BoundingBox(1))-cutYOffset), min(size(G,1),floor(BoundingBox(1)+BoundingBox(3))+cutYOffset)];   % y coordinates from - to of cut
    propsFeatures(featureID).CutY.Cut              = G([propsFeatures(featureID).CutY.CutBoundaries(1):propsFeatures(featureID).CutY.CutBoundaries(2)],propsFeatures(featureID).CutY.CutLine,:);
    propsFeatures(featureID).CutY.CutExt           = G([propsFeatures(featureID).CutY.CutBoundariesExt(1):propsFeatures(featureID).CutY.CutBoundariesExt(2)],propsFeatures(featureID).CutY.CutLine,:);


    H = zeros(1,length(propsFeatures(featureID).PixelList));

    for u = 1:length(propsFeatures(featureID).PixelList)
        H(1,u) = height(propsFeatures(featureID).PixelList(u,1),propsFeatures(featureID).PixelList(u,2));
    end

    propsFeatures(featureID).FeatureHeight.All = H;
    propsFeatures(featureID).FeatureHeight.Max = max(H);
    propsFeatures(featureID).FeatureHeight.Min = min(H);




    % propsFeatures(featureID).CutZ.CutLine = ceil(mean(H)/2);
    % propsFeatures(featureID).CutZ.Cut = G([propsFeatures(featureID).CutY.CutBoundaries (1):propsFeatures(featureID).CutY.CutBoundaries (2)],...
                                    % [propsFeatures(featureID).CutX.CutBoundaries(1):propsFeatures(featureID).CutX.CutBoundaries(2)],propsFeatures(featureID).CutZ.CutLine);

    subplot(n,2*n,featureID)
    showCutSectionsIn3D(propsFeatures, featureID,n)
end

hFig2 = gcf;
hFig2.WindowState = 'maximized';






%% OUTRO

rmpath(genpath('lib\')); % add whole library to searchpath
rmpath(genpath('dataset\')); % add whole dataset to searchpath

