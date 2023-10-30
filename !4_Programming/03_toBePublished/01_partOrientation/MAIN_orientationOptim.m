clc; clearvars; close all;

%% INIT
tic; % Start timer.

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath


%% STL read 
% reads vertices of selected body STL file


% readFileName = 'Body_01.stl';
readFileName = 'Body_02.stl';
% readFileName = 'Body_03.stl';
% readFileName = 'Body_04.stl';
% readFileName = 'TestBody_01.STL';
% readFileName = 'testBody_10.stl';

BodyName = readFileName;
BodyName(strfind(BodyName,'.stl'):end) = '';
BodyName(1:strfind(BodyName,'\')) = '';

gm = READ_stl(readFileName);        % XYZ coordinates of vertices in triangles

%% GRID SEARCH 

rotXmean = 0;   % mean values of rotation angles [rad]
rotYmean = 0;   % mean values of rotation angles [rad]
dPoint = pi/2;  % distance between points in grid search

% points of search
[angles_X,angles_Y] = meshgrid(rotXmean - 2*dPoint:dPoint:rotXmean + 2*dPoint,...
                               rotYmean - 2*dPoint:dPoint:rotYmean + 2*dPoint);

XYsupportVolume = zeros(size(angles_X)); % support volume for position given by angles_X angles_Y
    
results = struct(); % struct with support volumes for orientations 
structIdx = 1; 

% cycle for calculation all points from angles_X angles_Y
for j = 1:size(angles_X,1)
    for k = 1:size(angles_X,2)

        rot_angle_X = angles_X(j,k); 
        rot_angle_Y = angles_Y(j,k); 

        XYsupportVolume(j,k) = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y);
        
        clc
        disp(XYsupportVolume)

        % current point values log
        results(structIdx).Body = BodyName;
        results(structIdx).rotX = rot_angle_X;
        results(structIdx).rotY = rot_angle_Y;
        results(structIdx).SupportVolume = XYsupportVolume(j,k);

        structIdx = structIdx+1;
    end
end

% after search of space, position with minimal volume is found, this
% position is start for gradient descent search
[minVal, minIdx] = min([results.SupportVolume]);
rotXmean = results(minIdx).rotX;
rotYmean = results(minIdx).rotY;


%% GRADIENT DESCENT

% init values
dRX = 0.05;    % angle of rotation in X step for gradient calculation
dRY = 0.05;    % angle of rotation in Y step for gradient calculation
dumping = 0.000001;     % dumping coefficient (potential improvement - determine based on body size resp. amount of volume voxels

% initial point of gradient descent are outputs of grid search
rot_angle_X = rotXmean;  
rot_angle_Y = rotYmean;


for i = 1:20

    if i>5              % for later iterations parameters are fined
        dRX = 0.01;
        drY = 0.01;
        dumping = 0.0000001;
    end

    if i>10
        dRX = 0.0001;
        drY = 0.0001;
        dumping = 0.000000001;
    end

    % Fxy - function to be optimized by gradient descent
    Fxy = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y);      % function value in current search point

    % current point values log
    structIdx = structIdx+1; 
    results(structIdx).Body = BodyName;
    results(structIdx).rotX = rot_angle_X;
    results(structIdx).rotY = rot_angle_Y;
    results(structIdx).SupportVolume = Fxy;

    % gradient of 2D function Fxy in current position
    gradF =  [(supportVolumeFromAngles(gm,rot_angle_X+dRX,rot_angle_Y) - Fxy)/dRX;
              (supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y+dRY) - Fxy)/dRY];
    
    % edit of variables - rotation angles for next step
    rot_angle_X = rot_angle_X - dumping*gradF(1) + randi([-10,10])/1000;
    rot_angle_Y = rot_angle_Y - dumping*gradF(2) + randi([-10,10])/1000;

    clc
    fprintf("Iteration: %d \n",i);

end

% overall best position
[minVal, minIdx] = min([results.SupportVolume]);
rotXmin = results(minIdx).rotX;
rotYmin = results(minIdx).rotY;




%% results interpretation
close all
figure
title("Gradient descent")
plot3([results(end-20:end).rotX],[results(end-20:end).rotY],[results(end-20:end).SupportVolume])
xlabel("rot X")
ylabel("rot Y")
zlabel("Support volume")
shg

figure;
plot([results(end-20:end).SupportVolume])
title("Support volume during gradient descent search")
xlabel("iteration")
ylabel("Support volume")
shg

figure
scatter3([results.rotX],[results.rotY],[results.SupportVolume],'r+')
title("all search points GRID and GRADIENT DESC")
xlabel("rot X")
ylabel("rot Y")
zlabel("support volume")

showRotation(gm,rotXmin,rotYmin)


