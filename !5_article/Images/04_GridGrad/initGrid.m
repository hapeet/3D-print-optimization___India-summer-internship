load('angles.mat')


f1 = figure
scatter(angles_X,angles_Y,'filled','r')
set(gca,'XTick',-pi:pi/2:pi)
set(gca,'XTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

set(gca,'YTick',-pi:pi/2:pi)
set(gca,'YTickLabel',{'-\pi','-\pi/2','0','\pi/2','\pi'})

grid on
axis equal

xlim ([-4,4])
ylim ([-4,4])

xlabel('\phi_x [rad]')
ylabel('\phi_y [rad]')

f1.Position = [0 0 300 300];

saveas(f1,'initGrid.png')