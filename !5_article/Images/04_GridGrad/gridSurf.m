
load('XYsupportVolume.mat')

XYsupportVolume = XYsupportVolume / max(XYsupportVolume,[],'all');
[angles_X,angles_Y] = meshgrid(-pi:pi/30:pi,-pi:pi/30:pi);


f1 = figure
colormap winter
s = surf(angles_X,angles_Y,XYsupportVolume)
xlabel('\phi_x [rad]','FontSize',20)
ylabel('\phi_y [rad]','FontSize',20)
zlabel('V_{support} [-]','FontSize',20)

fontsize(gca, 15,'points')   % 'pixels', 'centimeters', 'inches'

colorbar
axis tight
axis equal
view([-50,40])

xlim([1 3])
ylim([-1 1])
zlim([0 1])


saveas(gcf, 'gradDesc.png')