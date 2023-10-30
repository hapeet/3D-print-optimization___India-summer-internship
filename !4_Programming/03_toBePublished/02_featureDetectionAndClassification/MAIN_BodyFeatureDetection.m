%% INIT
clc; clearvars; close all; workspace
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('testBodies')); 


%% IMPORTED BODY AND PARAMETERS
% body = 'Body_07';   % input stl 
body = 'Body_08';   
% body = 'Body_09';   
% body = 'Body_10';   
% body = '14_11';   
% body = '04_01';

resolution = 1;             % VOXELISATION GRID resolution in mm
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
wireframeMaxAngle = 25;         % wireframe triangles treshold angle - bigger angle will be filtered out


%% STL import to 3D grid 

[I,G] = importStlToGrid(body,resolution);

cutoffSize = floor(btmOffsetPx);
G = cat(3,zeros([size(G,[1,2]),cutoffSize]),G);        % add 3mm layer under body
originalImage = rot90(flip(I,2));

% Display the grayscale image.


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
xlabel('X [mm]')
ylabel('Y [mm]')
zlabel('Z [mm]')

axis equal


%% FEATURES FROM OVERHANG POINTS

[propsFeatures,ptsDown,ptsDownNoBtmFiltered, labelsNoBtmFiltered, ptsUp] = findOverhangs_v2(G,btmOffsetPx,mergeDistance,wireframe, wireframeOffset);


pcshow(ptsDownNoBtmFiltered.Location,labelsNoBtmFiltered,"MarkerSize",40,"BackgroundColor",[1 1 1])
colors =[     1.0000         0         0;
    1.0000    1         1;              % feature 2 white on white background > dissapeared
    1.0000    1.0000         0;
    0.5000    1.0000         0;
         0    1.0000         0;
         0    1.0000    0.5000;
         0    1.0000    1.0000;
         0    0.5000    1.0000;
         0         0    1.0000;
    0.5000         0    1.0000;
    1.0000         0    1.0000;
    1.0000         0    0.5000;];
colormap(colors);

% colormap(hsv(numel(unique(labelsNoBtmFiltered))))



xlabel('X [mm]')
ylabel('Y [mm]')
zlabel('Z [mm]')
title('Downfacing features - 1st layer removed')
%% 





%% numbering in image, drawing position of centers

Centroids = vertcat(propsFeatures.Centroid);      % centroid of down facing features coordinates.
centroidsX = Centroids(:, 1);			% Extract out the centroid x values into their own vector.
centroidsY = Centroids(:, 2);			% Extract out the centroid y values into their own vector.


% Put the labels on the image
figure(f1);

numberOfFeatures = numel(propsFeatures); 
for k = 1 : numberOfFeatures           % Loop through all blobs.
	% Place the label number and  at the centroid of the feature.
	text(centroidsX(k)+0.5, centroidsY(k) + 8.5, num2str(k),'Color','k', 'FontSize', 14, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    text(centroidsX(k), centroidsY(k) + 8, num2str(k),'Color','g', 'FontSize', 14, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

end


hold on; 
% place centermarks on image
for k = 1 : numberOfFeatures
		plot(centroidsX(k), centroidsY(k), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
end


%% CUT DETECTED FEATURES

propsFeatures = cutFeatures_v4(G, propsFeatures, maxCutOffsetpx, cutOffsetPercent);


%% OUTRO

toc

% save calculated parameters of examined body into .mat file
bodyData.G = G;
bodyData.propsFeatures = propsFeatures;
bodyData.params.resolution = resolution;
bodyData.params.maxCutOffsetPx = maxCutOffsetpx;

filename = strcat('testBodies\',body,'_res_',num2str(resolution));
save(filename,"bodyData");

