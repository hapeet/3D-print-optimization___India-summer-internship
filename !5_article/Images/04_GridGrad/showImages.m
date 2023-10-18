clear all; close all; clc;



load('XYsupportVolume.mat');
load('gridValues.mat');
gridValues = gridValues/ max(XYsupportVolume,[],'all');


[angles_X,angles_Y] = meshgrid(-pi:pi/30:pi,-pi:pi/30:pi);

XYsupportVolume = XYsupportVolume / max(XYsupportVolume,[],'all');
f1 = figure
subplot(2,1,1)
colormap winter
s = surf(angles_X,angles_Y,XYsupportVolume)
xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)
zlabel('V_{support} [-]','FontSize',20)


set(gca,'XTick',-pi:pi/2:pi)
set(gca,'XTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

set(gca,'YTick',-pi:pi/2:pi)
set(gca,'YTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

grid on


fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'

set(gca,'ZTick',[0,1])
colorbar
xlim ([-4,4])
ylim ([-4,4])
axis equal
view([45,20])



subplot(2,1,2)
load('angles.mat')

angles_Z = zeros(size(angles_Y));
scatter3(angles_X,angles_Y,angles_Z, 'filled','r')

xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)

% scatter(angles_X,angles_Y,'filled','r')
set(gca,'XTick',-pi:pi/2:pi)
set(gca,'XTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

set(gca,'YTick',-pi:pi/2:pi)
set(gca,'YTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

grid on
axis equal
axis tight
zlim ([0 1])

fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'
colorbar


view([45,20])



subplot(2,1,1)
hold on 
scatter3(angles_X,angles_Y,gridValues, 'filled','r')


 f1.Position = [792   333   725   642];

 saveas(f1,'gridOrig.png')
