clc; clear all; close all

%% stl read 
readFileName = 'TestBody_01.stl';
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

filename = strcat(sprintf('rotX%0.2f_rotY%0.2f_',rot_angle_X,rot_angle_Y),readFileName);
stl_save(gm_rot,filename);

