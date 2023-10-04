clc; clear all; close all;

%% stl read 
% readFileName = 'testBodies\Body_01.stl';
readFileName = 'testBodies\Body_02.stl';
% readFileName = 'testBodies\TestBody_03.STL';


gm = READ_stl(readFileName);
results = struct();
structIdx = 1; 

BodyName = readFileName;
BodyName(strfind(BodyName,'.stl'):end) = '';
BodyName(1:strfind(BodyName,'\')) = '';
%% geometry rotate

rotXmin = 0;
rotYmin = 0;
for iteration = 1:3

    if iteration==1
        dPoint = pi/2;
    else
        dPoint = pi/(3^iteration);
    end

    [angles_X,angles_Y] = meshgrid(rotXmin - 2*dPoint:dPoint:rotXmin + 2*dPoint,...
                                   rotYmin - 2*dPoint:dPoint:rotYmin + 2*dPoint);
    XYsufrace = zeros(size(angles_X));
    

    

    
    for j = 1:size(angles_X,1)
        for k = 1:size(angles_X,2)
    
            rot_angle_X = angles_X(j,k);
            rot_angle_Y = angles_Y(j,k);
    
                
            XYsufrace(j,k) = areaFromAngles(gm,rot_angle_X,rot_angle_Y)
    
            results(structIdx).Body = BodyName;
            results(structIdx).rotX = rot_angle_X;
            results(structIdx).rotY = rot_angle_Y;
            results(structIdx).SurfaceArea = XYsufrace(j,k);
    
            structIdx = structIdx+1;
        end
    end

    [minVal, minIdx] = min([results.SurfaceArea]);
    rotXmin = results(minIdx).rotX;
    rotYmin = results(minIdx).rotY;
end
%% results interpretation



close all
figure
scatter3([results.rotX],[results.rotY],[results.SurfaceArea],'r+')

xlim([0 pi])
ylim([0 pi])
xlabel('X'); ylabel('Y'); zlabel('Z'); 


showRotation(gm,rotXmin,rotYmin)



