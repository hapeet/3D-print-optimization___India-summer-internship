clc; clear all; close all;
STL_file = 'Body_07.STL';

[stlcoords] = READ_stl(STL_file);


%% find min max dimensions of stl in all 3 coordiantes
xmin = min(min(stlcoords(:,1,:)));
xmax = max(max(stlcoords(:,1,:)));

ymin = min(min(stlcoords(:,2,:)));
ymax = max(max(stlcoords(:,2,:)));

zmin = min(min(stlcoords(:,3,:)));
zmax = max(max(stlcoords(:,3,:)));


%% Voxelise the STL:
resolution = 4; % size of voxel in mm
xVoxNum = abs(ceil((xmax-xmin)/resolution));
yVoxNum = abs(ceil((ymax-ymin)/resolution));
zVoxNum = abs(ceil((zmax-zmin)/resolution));

[OUTPUTgrid] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,[STL_file],'xyz');

%% output show

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(any(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(any(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(any(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight
