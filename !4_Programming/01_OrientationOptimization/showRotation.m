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
            axes(f,"Position",[0.1 0.05 0.55 0.9]);
            % subplot(1,2,1)
            
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
            legend('original','rotated','Location','southeast')
            title('Optimized part orientation')
            axis equal
            axis tight
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            
            view(30,15)

            axes(f,"Position",[0.7 0.05 0.25 0.9])
            % imagesc(XYprojection);
            imagesc(squeeze(sum(OUTPUTgrid,3)));
            colormap(gray(256));
            title('XY projection')
            ylabel('Y-direction');
            xlabel('X-direction');
            axis equal tight


end

