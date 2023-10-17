clear all; close all; clc;



load('XYsupportVolume.mat')
load('gridValues.mat')
gridValues = gridValues/ max(XYsupportVolume,[],'all');


[angles_X,angles_Y] = meshgrid(-pi:pi/30:pi,-pi:pi/30:pi);

XYsupportVolume = XYsupportVolume / max(XYsupportVolume,[],'all');
figure
subplot(2,1,1)
colormap winter
s = surf(angles_X,angles_Y,XYsupportVolume)
xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)
zlabel('V_{support} [-]','FontSize',20)

fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'

colorbar
axis tight
view([45,60])



subplot(2,1,2)
load('angles.mat')

angles_Z = zeros(size(angles_Y));
scatter3(angles_X,angles_Y,angles_Z, 'filled','r')

xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)
zlabel('V_{support} [-]','FontSize',20)

fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'
zlim([0 1])
colorbar
axis tight
view([45,60])



subplot(2,1,1)
hold on 
scatter3(angles_X,angles_Y,gridValues, 'filled','r')


