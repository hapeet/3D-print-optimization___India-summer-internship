clc; clear all; close all;

%% stl read 
% readFileName = 'testBodies\Body_01.stl';
readFileName = 'testBodies\TestBody_03.STL';


gm = READ_stl(readFileName);

%% geometry rotate

n = 3; 
[angles_X,angles_Y] = meshgrid(0:pi/5:pi);
XYsurfrace = zeros(size(angles_X));

results = struct();
structIdx = 1; 

BodyName = readFileName;
BodyName(strfind(BodyName,'.stl'):end) = '';
BodyName(1:strfind(BodyName,'\')) = '';

for j = 1:size(angles_X,1)
    for k = 1:size(angles_X,2)

        close all; clear gridCOx gridCOy gridCOz OUTPUTgrid gm_rot xco
        rot_angle_X = angles_X(j,k);
        rot_angle_Y = angles_Y(j,k);

        % gm_rot = gm;
        % % geometry rotation
        %     for i = 1:size(gm,1)
        %         for u = 1:3
        %             gm_rot(i,:,u) = ROTATE_gm(gm(i,:,u), 1, rot_angle_X);
        %             gm_rot(i,:,u) = ROTATE_gm(gm(i,:,u), 2, rot_angle_Y);
        %         end
        %     end
        % 
        %     %% plot original - blue and rotated - red model
        %     figure
        %     subplot(1,2,1)
        %     xco = squeeze( gm(:,1,:) )';
        %     yco = squeeze( gm(:,2,:) )';
        %     zco = squeeze( gm(:,3,:) )';
        %     patch(xco,yco,zco,'b');
        %     axis equal
        %     axis tight
        % 
        %     xco = squeeze( gm_rot(:,1,:) )';
        %     yco = squeeze( gm_rot(:,2,:) )';
        %     zco = squeeze( gm_rot(:,3,:) )';
        %     patch(xco,yco,zco,'r');
        %     axis equal
        %     axis tight
        % 
        %     xlabel('X')
        %     ylabel('Y')
        %     zlabel('Z')
        % 
        % 
        % 
        %     % %% stl save 
        %     % rotFilename = strcat('rotated\',strcat(sprintf('rotX%0.2f_rotY%0.2f_',rot_angle_X,rot_angle_Y),readFileName));
        %     % SAVE_stl(gm_rot,rotFilename);
        %     % 
        %     % 
        %     % 
        %     %% Voxelization and XY surface calculation
        % 
        %     % STL_file = rotFilename;
        %     % [stlcoords] = READ_stl(STL_file);
        % 
        % 
        %     % %% find min max dimensions of stl in all 3 coordiantes
        %     xmin = min(min(gm_rot(:,1,:)));
        %     xmax = max(max(gm_rot(:,1,:)));
        % 
        %     ymin = min(min(gm_rot(:,2,:)));
        %     ymax = max(max(gm_rot(:,2,:)));
        % 
        %     zmin = min(min(gm_rot(:,3,:)));
        %     zmax = max(max(gm_rot(:,3,:)));
        % 
        % 
        %     % %% Voxelise the STL:
        %     resolution = 1; % size of voxel in mm
        %     xVoxNum = abs(ceil((xmax-xmin)/resolution));
        %     yVoxNum = abs(ceil((ymax-ymin)/resolution));
        %     zVoxNum = abs(ceil((zmax-zmin)/resolution));
        % 
        %     [OUTPUTgrid] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,gm_rot,'xyz');
        %     XYprojection = rot90((squeeze(any(OUTPUTgrid,3))));
        % 
        % 
        %     % %% output show
        % 
        %     % %Show the voxelised result:
        %     subplot(1,2,2)
        %     imagesc(XYprojection);
        %     colormap(gray(256));
        %     ylabel('Y-direction');
        %     xlabel('X-direction');
        %     axis equal tight
        % 
        %     %% XY surface area evaluation
        % 
        %     XYsufrace(j,k) = sum(XYprojection,'all') * resolution^2;
            
        XYsufrace(j,k) = areaFromAngles(gm,rot_angle_X,rot_angle_Y)

            results(structIdx).Body = BodyName;
            results(structIdx).rotX = rot_angle_X;
            results(structIdx).rotY = rot_angle_Y;
            results(structIdx).SurfaceArea = XYsufrace(j,k);

            structIdx = structIdx+1;
    end
end

%% 
figure
mesh(XYsufrace,'FaceColor','flat')

[minVal, minIdx] = min([results.SurfaceArea]);

rotXmin = results(minIdx).rotX;
rotYmin = results(minIdx).rotY;


% disp(sprintf('\nMinimal surface area: %d mm^2',minVal))
% disp('at rotation')
% disp(sprintf('rotX = %0.2f rad, rotY = %0.2f rad',rotXmin,rotYmin))
% 
% 

% save(strcat(strcat('results\',BodyName,'_results.mat')),"results","XYsufrace")
%% gradient descent

dRX = 0.3;
dRY = 0.3;
dumping = 0.000001;
rot_angle_X = rotXmin;
rot_angle_Y = rotYmin;

% rot_angle_X = 1;
% rot_angle_Y = 1;


iterations = struct();
structIdx = 1;  

for i = 1:20

    if i>5
        dRX = 0.01;
        drY = 0.01;
        dumping = 0.000001;
    end

    if i>10
        dRX = 0.05;
        drY = 0.05;
        dumping = 0.0000005;
    end
    Fxy = areaFromAngles(gm,rot_angle_X,rot_angle_Y);
    iterations(i).Body = BodyName;
    iterations(i).rotX = rot_angle_X;
    iterations(i).rotY = rot_angle_Y;
    iterations(i).SurfaceArea = Fxy;


    gradF =  [(areaFromAngles(gm,rot_angle_X+dRX,rot_angle_Y) - Fxy)/dRX;
              (areaFromAngles(gm,rot_angle_X,rot_angle_Y+dRY) - Fxy)/dRY];
    
    rot_angle_X = rot_angle_X - dumping*gradF(1) + randi([-10,10])/1000;
    rot_angle_Y = rot_angle_Y - dumping*gradF(2) + randi([-10,10])/1000;

     
    disp(i)
end

close all
figure
plot3([iterations.rotX],[iterations.rotY],[iterations.SurfaceArea])
shg

figure;
plot([iterations.SurfaceArea])
shg


showRotation(gm,rot_angle_X,rot_angle_Y)



