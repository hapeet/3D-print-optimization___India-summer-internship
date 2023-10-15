clc; clear all; close all;

%% stl read 
% readFileName = 'testBodies\Body_01.stl';
% readFileName = 'testBodies\Body_02.stl';
% readFileName = 'testBodies\Body_03.stl';
% readFileName = 'testBodies\Body_04.stl';
% readFileName = 'testBodies\TestBody_03.STL';
readFileName = 'testBodies\testBody_10.stl';


gm = READ_stl(readFileName);
results = struct();
structIdx = 1; 

BodyName = readFileName;
BodyName(strfind(BodyName,'.stl'):end) = '';
BodyName(1:strfind(BodyName,'\')) = '';
%% geometry rotate

rotXmin = 0;
rotYmin = 0;
dPoint = pi/2;


[angles_X,angles_Y] = meshgrid(rotXmin - 2*dPoint:dPoint:rotXmin + 2*dPoint,...
                               rotYmin - 2*dPoint:dPoint:rotYmin + 2*dPoint);
XYsupportVolume = zeros(size(angles_X));
    
for j = 1:size(angles_X,1)
    for k = 1:size(angles_X,2)

        rot_angle_X = angles_X(j,k);
        rot_angle_Y = angles_Y(j,k);

            
        XYsupportVolume(j,k) = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y)

        results(structIdx).Body = BodyName;
        results(structIdx).rotX = rot_angle_X;
        results(structIdx).rotY = rot_angle_Y;
        results(structIdx).SupportVolume = XYsupportVolume(j,k);

        structIdx = structIdx+1;
    end
end

[minVal, minIdx] = min([results.SupportVolume]);
rotXmin = results(minIdx).rotX;
rotYmin = results(minIdx).rotY;


%% gradient descent

dRX = 0.3;
dRY = 0.3;
dumping = 0.000001;
% rot_angle_X = rotXmin;
% rot_angle_Y = rotYmin;
rot_angle_X = 1;
rot_angle_Y = 1;




iterations = struct();
structIdx = 1;  

for i = 1:20

    if i>5
        dRX = 0.01;
        drY = 0.01;
        dumping = 0.0000001;
    end

    if i>10
        dRX = 0.0001;
        drY = 0.0001;
        dumping = 0.000000001;
    end

    Fxy = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y);

    iterations(i).Body = BodyName;
    iterations(i).rotX = rot_angle_X;
    iterations(i).rotY = rot_angle_Y;
    iterations(i).SupportVolume = Fxy;


    gradF =  [(supportVolumeFromAngles(gm,rot_angle_X+dRX,rot_angle_Y) - Fxy)/dRX;
              (supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y+dRY) - Fxy)/dRY];
    
    rot_angle_X = rot_angle_X - dumping*gradF(1) + randi([-10,10])/1000;
    rot_angle_Y = rot_angle_Y - dumping*gradF(2) + randi([-10,10])/1000;

     
    disp(i)


end

[minVal, minIdx] = min([results.SupportVolume]);
rotXmin = results(minIdx).rotX;
rotYmin = results(minIdx).rotY;


%% results interpretation
close all
figure
plot3([iterations.rotX],[iterations.rotY],[iterations.SupportVolume])
shg

figure;
plot([iterations.SupportVolume])
shg

figure
scatter3([iterations.rotX],[iterations.rotY],[iterations.SupportVolume],'r+')


showRotation(gm,rotXmin,rotYmin)

