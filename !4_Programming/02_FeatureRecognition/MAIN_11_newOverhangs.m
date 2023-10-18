% %% INIT
clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('testBodies')); 


%% imported body and parameters
% body = 'Body_07';   % input stl 
body = 'Body_08';   % input stl 
% body = 'Body_09';   % input stl 
% body = 'Body_10';   % input stl
% body = '14_11';   % input stl 
% body = '04_01';

resolution = 1; %resolution in mm
bottomCutoffHeight = 3;     % bottom cutof height in mm 
btmOffsetPx = bottomCutoffHeight/resolution;
filterSmallFeatures = true;     % if true features which are shaped as lines/edges are filtered out
smallFeaturesTreshold = 1;      % if feature XY projection is smaller than 
                                % smallFeaturesTreshold percents of whole image then is this feature filtered out

mergeDistance = 6;              % maximum distance of two point to be joined while clustering 

filterUpfaceFeatures = true;

maxCutOffsetmm = 15;     % maximal cut offset in mm
maxCutOffsetpx = maxCutOffsetmm / resolution;

cutOffsetPercent    = 50;                  % cut offset ar percents of feature width

wireframeOffset = 3;
wireframeMaxAngle = 25;         % wireframe triangles treshold angle

captionFontSize = 14;
textFontSize = 14;
%% STL import to 3D grid and XY projection I

[I,G] = importStlToGrid(body,resolution);
cutoffSize = floor(btmOffsetPx);

G = cat(3,zeros([size(G,[1,2]),cutoffSize]),G);        % add 3mm layer under body
originalImage = rot90(flip(I,2));

% Display the grayscale image.
% subplot(2, 1, 1);

% Maximize the figure window.
f1 = figure;
f1.Units = 'normalized';
% hFig1.WindowState = 'maximized'; % Go to full screen
f1.Position = [0 0.5 0.5 0.5];
f1.NumberTitle = 'off'; % Get rid of "Figure 1"
image(originalImage);
axis('on', 'xy');
axis equal tight
colormap gray
xlabel x
ylabel y


title('Original image', 'FontSize', captionFontSize);


%% IMPORT WIREFRAME 

wireframe = wireframeImport(body,wireframeMaxAngle,btmOffsetPx,resolution);

 f2 = figure ;
    f2.Units = "Normalized";
    f2.Position = [0 0 0.5 0.5];
% 
for i = 1:size(wireframe,1)
  plot3(squeeze(wireframe(i,1,:)),squeeze(wireframe(i,2,:)),squeeze(wireframe(i,3,:)));
  hold on
end
xlabel x
ylabel y
zlabel z
axis equal
title Wireframe

%% FEATURES FROM OVERHANG

[propsFeatures,ptsDown,ptsDownNoBtmFiltered, labelsNoBtmFiltered, ptsUp] = findOverhangs_v2(G,btmOffsetPx,mergeDistance,wireframe, wireframeOffset);


pcshow(ptsDownNoBtmFiltered.Location,labelsNoBtmFiltered)
colormap(hsv(numel(unique(labelsNoBtmFiltered))))

title('down facing features - 1st layer removed')
%%



Centroids = vertcat(propsFeatures.Centroid);      % centroid of down facing features coordinates.

numberOfFeatures = numel(propsFeatures); 

	% Used to control size of "blob number" labels put atop the image.



%% numbering in image, drawing position of centers
centroidsX = Centroids(:, 1);			% Extract out the centroid x values into their own vector.
centroidsY = Centroids(:, 2);			% Extract out the centroid y values into their own vector.
% Put the labels on the rgb labeled image also.

figure(f1);

for k = 1 : numberOfFeatures           % Loop through all blobs.
	% Place the blob label number at the centroid of the blob.
	text(centroidsX(k)+0.5, centroidsY(k) + 8.5, num2str(k),'Color','k', 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

    text(centroidsX(k), centroidsY(k) + 8, num2str(k),'Color','g', 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

end


% subplot(2, 1, 1);
hold on; % Don't blow away image.
for k = 1 : numberOfFeatures           % Loop through all keeper blobs.
		plot(centroidsX(k), centroidsY(k), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
end


%% cutting 

propsFeatures = cutFeatures_v4(G, propsFeatures, maxCutOffsetpx, cutOffsetPercent);






%% OUTRO

toc

bodyData.G = G;
bodyData.propsFeatures = propsFeatures;
bodyData.params.resolution = resolution;
bodyData.params.maxCutOffsetPx = maxCutOffsetpx;

filename = strcat('testBodies\',body,'_res_',num2str(resolution));
save(filename,"bodyData");

% rmpath(genpath('lib\')); % add whole library to searchpath
% rmpath(genpath('dataset\')); % add whole dataset to searchpath

