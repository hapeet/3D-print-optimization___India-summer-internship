%% INIT
clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath


%% parameters
body = 'Body_07';   % input stl 
resolution = 1; %resolution in mm

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
colormap gray

% Force it to display RIGHT NOW (otherwise it might not display until it's all done, unless you've stopped at a breakpoint.)
drawnow;

title('Original image', 'FontSize', captionFontSize);
axis('on', 'xy');
%% mask of non supported features

M = zeros(size(G,1:2)); %mask

for ix = 1:size(G,1)
    for iy = 1:size(G,2)
        A = squeeze(G(ix, iy, :))' ;  % one collumn sum

        dA = diff([A]);
        if ~isempty(find(dA>0));
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


%% Identify individual blobs by seeing which pixels are connected to each other.

[labeledImage, numberOfBlobs] = imageLabel(originalImage, locsLowBoundaries, locsHigh);


subplot(2, 2, 3);
imshow(labeledImage, []);  % Show the gray scale image.
axis('on', 'xy');
title('Sectioned image', 'FontSize', captionFontSize);
drawnow;

% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(2, 2, 4);
imshow(coloredLabels);
axis('on', 'xy');
title('Colored regions', 'FontSize', captionFontSize);






%%  Print the all blob properties.
props = regionprops(labeledImage, originalImage, 'all');

% clear empty and auxalar regions 
props([props.Area] == 0) = [];

%% filtering upface features
allBlobCentroids = vertcat(props.Centroid);      % centroid coordinates.

idxs = [];
for i = 1:size(allBlobCentroids,1)
    if  ~M(round(allBlobCentroids(i,1)),round(allBlobCentroids(i,2)))
        props(i).FaceDir = 'up';
    else
        props(i).FaceDir = 'down';
    end
end

propsDownFace = props(ismember({props.FaceDir},{'down'}));

Data = struct('allFeatures',props, 'downFacingFeatures',propsDownFace,'resolution',resolution);
Centroids = vertcat(props(ismember({props.FaceDir},{'down'})).Centroid);      % centroid of down facing features coordinates.

%%


numberOfBlobs = numel(propsDownFace); 

textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% Print header line in the command window.
fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
blobECD = [propsDownFace.EquivDiameter];

for k = 1 : numberOfBlobs           
	meanGL = propsDownFace(k).MeanIntensity;		% Get average intensity.
	blobArea = propsDownFace(k).Area;				% Get area.
	blobPerimeter = propsDownFace(k).Perimeter;		% Get perimeter.
	blobCentroid = propsDownFace(k).Centroid;		% Get centroid one at a time

	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));

    % Put the "blob number" labels on the grayscale image that is showing the red boundaries on it.
	% text(blobCentroid(1), blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end


%% numbering in image, drawing position of centers
centroidsX = Centroids(:, 1);			% Extract out the centroid x values into their own vector.
centroidsY = Centroids(:, 2);			% Extract out the centroid y values into their own vector.
% Put the labels on the rgb labeled image also.
subplot(2, 2, 4);
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Place the blob label number at the centroid of the blob.
	text(centroidsX(k), centroidsY(k), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end


subplot(2, 2, 1);
hold on; % Don't blow away image.
for k = 1 : numberOfBlobs           % Loop through all keeper blobs.
		plot(centroidsX(k), centroidsY(k), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
end


%% results save

saveFileName = strcat(body,'_Data.mat');
save(saveFileName,"Data");


%% cutline search
minSpanX = 10; %10 px max span
minSpanY = 10; %10 px max span

allBlobCentroids = vertcat(propsDownFace.Centroid);		% A 10 row by 2 column array of (x,y) centroid coordinates.
centroidsX = sort(allBlobCentroids(:, 1));			% Extract out the centroid x values into their own vector.
centroidsY = sort(allBlobCentroids(:, 2));			% Extract out the centroid y values into their own vector.


%%%% X lines

cutlineX = [];
i = 1;
while i < length(centroidsX)
    A = centroidsX(i); 
    C = [];
    C = centroidsX(and(centroidsX>=A,centroidsX<=(A+minSpanX)));
    cutlineX(end+1,1) = mean([C]);
    i = i+numel(C);
end

%%%% X lines

cutlineY = [];
i = 1;
while i < length(centroidsY)
    A = centroidsY(i); 
    C = [];
    C = centroidsY(and(centroidsY>=A,centroidsY<=(A+minSpanY)));
    cutlineY(end+1,1) = mean([C]);
    i = i+numel(C);
end

subplot(2,2,1)
imSz = size(originalImage);
for i = 1:length(cutlineX)
    hold on
    line([cutlineX(i),cutlineX(i)],[0 imSz(1)], "Color",'red');
    text(cutlineX(i),-20,sprintf('CutX %i',i),"HorizontalAlignment","center","VerticalAlignment","middle","Rotation",90)
end

for i = 1:length(cutlineY)
    hold on
    line([0 imSz(2)],[cutlineY(i),cutlineY(i)],"Color",'red');
    text(imSz(2) + 20,cutlineY(i),sprintf('CutY %i',i),"HorizontalAlignment","center","VerticalAlignment","middle")
end

%% cutting
 
% cutting acc x coordinate
CutsX = [];
figure;

subplotidx = 1;


for i = 1:length(cutlineX)
    CutsX(i,:,:) = G(round(cutlineX(i)),:,:);

    subplot(2,max(length(cutlineX),length(cutlineY)),subplotidx)
    imshow(squeeze(CutsX(i,:,:)))
    axis('on','xy')
    title(sprintf('CutX %i',i))
    subplotidx = subplotidx +1;

end

CutsY = [];
subplotidx = max(length(cutlineX),length(cutlineY)) + 1;
for i = 1:length(cutlineY)
    CutsY(i,:,:) = G(:,round(cutlineY(i)),:);


    subplot(2,max(length(cutlineX),length(cutlineY)),subplotidx)    
    imshow(rot90(flip(squeeze(CutsY(i,:,:))),2))
    axis('on','xy')
    title(sprintf('CutY %i',i))
    subplotidx = subplotidx +1;

end











toc