clc; clear all; close all;

%% stl read 
% readFileName = 'testBodies\Body_01.stl';
% readFileName = 'testBodies\Body_02.stl';        %55sec
% readFileName = 'testBodies\Body_03.stl';        %51sec
% readFileName = 'testBodies\Body_04.stl';        %41sec
% readFileName = 'testBodies\Body_06.stl'; 
% readFileName = 'testBodies\Body_07.stl'; 
readFileName = 'testBodies\testBody_10.stl';

gm = READ_stl(readFileName);
results = struct();
structIdx = 1; 

BodyName = readFileName;
BodyName(strfind(BodyName,'.stl'):end) = '';
BodyName(1:strfind(BodyName,'\')) = '';
%% geometry rotate
tic 
rotXmin = 0;
rotYmin = 0;

% for iteration = 1:3

    % if iteration==1
    %     dPoint = pi/2;
    % else
    %     dPoint = pi/(3^iteration);
    % end
    % 
    % [angles_X,angles_Y] = meshgrid(rotXmin - 2*dPoint:dPoint:rotXmin + 2*dPoint,...
    %                                rotYmin - 2*dPoint:dPoint:rotYmin + 2*dPoint);

        [angles_X,angles_Y] = meshgrid(-pi:pi/30:pi,...
                                       -pi:pi/30:pi);
    XYsupportVolume = zeros(size(angles_X));
    

    

    
    for j = 1:size(angles_X,1)
        for k = 1:size(angles_X,2)
    
            rot_angle_X = angles_X(j,k);
            rot_angle_Y = angles_Y(j,k);
    
                
            XYsupportVolume(j,k) = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y);
    
            results(structIdx).Body = BodyName;
            results(structIdx).rotX = rot_angle_X;
            results(structIdx).rotY = rot_angle_Y;
            results(structIdx).SupportVolume = XYsupportVolume(j,k);
    
            structIdx = structIdx+1;

            % showRotation(gm,rot_angle_X,rot_angle_Y)
            disp(j)
            disp(k)
        end
    end

    [minVal, minIdx] = min([results.SupportVolume]);
    rotXmin = results(minIdx).rotX;
    rotYmin = results(minIdx).rotY;
% end
toc

%% results interpretation

close all
figure
scatter3([results.rotX],[results.rotY],[results.SupportVolume],'r+')
xlabel('rotation X axis [rad]')
ylabel('rotation Y axis [rad]')

% xlim([0 pi])
% ylim([0 pi])
% xlabel('X'); ylabel('Y'); zlabel('Z'); 


showRotation(gm,rotXmin,rotYmin) 

%%
close all

XYsupportVolume = XYsupportVolume / max(XYsupportVolume,[],'all')
figure
colormap winter
s = surf(angles_X,angles_Y,XYsupportVolume)
xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)
zlabel('V_{support} [-]','FontSize',20)

fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'

colorbar
axis tight
view([45,60])
