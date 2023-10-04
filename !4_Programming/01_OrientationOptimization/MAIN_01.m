clc; clear all; close all;

%% stl read 
readFileName = 'TestBody_02.stl';
gm = READ_stl(readFileName);

%% geometry rotate

gm_rot = gm;
rot_angle_X = pi/6;
rot_angle_Y = pi/4;

for i = 1:size(gm,1)
    for u = 1:3
        gm_rot(i,:,u) = ROTATE_gm(gm_rot(i,:,u), 1, rot_angle_X);
        gm_rot(i,:,u) = ROTATE_gm(gm_rot(i,:,u), 2, rot_angle_Y);
    end
end

%% plot original - blue and rotated - red model
xco = squeeze( gm(:,1,:) )';
yco = squeeze( gm(:,2,:) )';
zco = squeeze( gm(:,3,:) )';
patch(xco,yco,zco,'b');
axis equal
axis tight

xco = squeeze( gm_rot(:,1,:) )';
yco = squeeze( gm_rot(:,2,:) )';
zco = squeeze( gm_rot(:,3,:) )';
patch(xco,yco,zco,'r');
axis equal
axis tight

xlabel('X')
ylabel('Y')
zlabel('Z')



%% stl save 
rotFilename = strcat('rotated\',strcat(sprintf('rotX%0.2f_rotY%0.2f_',rot_angle_X,rot_angle_Y),readFileName));
SAVE_stl(gm_rot,rotFilename);



%% Voxelization and XY surface calculation

STL_file = rotFilename;

[stlcoords] = READ_stl(STL_file);


% %% find min max dimensions of stl in all 3 coordiantes
xmin = min(min(stlcoords(:,1,:)));
xmax = max(max(stlcoords(:,1,:)));

ymin = min(min(stlcoords(:,2,:)));
ymax = max(max(stlcoords(:,2,:)));

zmin = min(min(stlcoords(:,3,:)));
zmax = max(max(stlcoords(:,3,:)));


% %% Voxelise the STL:
resolution = 1; % size of voxel in mm
xVoxNum = abs(ceil((xmax-xmin)/resolution));
yVoxNum = abs(ceil((ymax-ymin)/resolution));
zVoxNum = abs(ceil((zmax-zmin)/resolution));

[OUTPUTgrid] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,[STL_file],'xyz');

% %% output show

% %Show the voxelised result:
figure;
XYprojection = rot90((squeeze(any(OUTPUTgrid,3))));
imagesc(XYprojection);
colormap(gray(256));
ylabel('Y-direction');
xlabel('X-direction');
axis equal tight

%% XY surface area evaluation

XYsufrace = sum(XYprojection,'all') * resolution^2
