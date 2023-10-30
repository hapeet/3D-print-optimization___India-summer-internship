function showRotation(gm,rot_angle_X,rot_angle_Y)

            for i = 1:size(gm,1)
                for u = 1:3
                    gm_rot(i,:,u) = ROTATE_gm(gm(i,:,u), 1, rot_angle_X);
                    gm_rot(i,:,u) = ROTATE_gm(gm_rot(i,:,u), 2, rot_angle_Y);
                end
            end

             %% Voxelization and XY surface calculation
            
            % %% find min max dimensions of stl in all 3 coordiantes
            xmin = min(min(gm_rot(:,1,:)));
            xmax = max(max(gm_rot(:,1,:)));
            
            ymin = min(min(gm_rot(:,2,:)));
            ymax = max(max(gm_rot(:,2,:)));
            
            zmin = min(min(gm_rot(:,3,:)));
            zmax = max(max(gm_rot(:,3,:)));
            
            
            % %% Voxelise the STL:
            resolution = 1; % size of voxel in mm
            xVoxNum = abs(ceil((xmax-xmin)/resolution));
            yVoxNum = abs(ceil((ymax-ymin)/resolution));
            zVoxNum = abs(ceil((zmax-zmin)/resolution));
            
            [OUTPUTgrid] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,gm_rot,'xyz');
            % XYprojection = rot90((squeeze(any(OUTPUTgrid,3))));
            % XYprojection = rot90(squeeze(OUTPUTgrid));

            %     % %Show the voxelised result:
%%

            f = figure;
            axes(f,"Position",[0.1 0 0.32 1]);
            % subplot(1,2,1)
            
            xco = squeeze( gm(:,1,:) )';
            yco = squeeze( gm(:,2,:) )'+20;
            zco = squeeze( gm(:,3,:) )';
            patch(xco,yco,zco,'b');
            axis equal
            axis tight
            xlabel('X [mm]')
            ylabel('Y [mm]')
            zlabel('Z [mm]')
            title Original orientation

            grid on        
            view(30,15)

            % subplot(1,2,2)
            axes(f,"Position",[0.52 0 0.43 1]);
            xco = -squeeze( gm_rot(:,1,:) )';
            yco = squeeze( gm_rot(:,2,:) )' + 60;
            zco = squeeze( gm_rot(:,3,:) )' + 20;
            patch(xco,yco,zco,'r');
            % legend('original','rotated','Location','southeast')
            % title('Optimized part orientation')
            axis equal
            axis tight
            xlabel('X [mm]')
            ylabel('Y [mm]')
            zlabel('Z [mm]')
            title Optimized orientation

            grid on
            view(30,15)



end

