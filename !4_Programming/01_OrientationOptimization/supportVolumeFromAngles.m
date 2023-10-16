function [supportVolume] = supportVolumeFromAngles(gm,rot_angle_X,rot_angle_Y)

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
            resolution = 2; % size of voxel in mm
            xVoxNum = abs(ceil((xmax-xmin)/resolution));
            yVoxNum = abs(ceil((ymax-ymin)/resolution));
            zVoxNum = abs(ceil((zmax-zmin)/resolution));
            
            [OUTPUTgrid] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,gm_rot,'xyz');
 
            %% add cutoff gap 
            gap = 3; % 3mm of gap
            gapCount = ceil(gap/resolution);
                
            GAPgrid = zeros(size(OUTPUTgrid,1),size(OUTPUTgrid,2),gapCount);
            
            OUTPUTgrid = cat(3,GAPgrid,OUTPUTgrid);
          
            %% Support volume
            supportVolume = 0;

            for ix = 1:size(OUTPUTgrid,1)
                for iy = 1:size(OUTPUTgrid,2)
                    
                    % one collumn sum
                    A = squeeze(OUTPUTgrid(ix, iy, :))';
            
                    dA = diff(A);
                    idxs = [0, find(diff(A))];
                    
                    volA = 0;
                    for i = 2:length(idxs)
                        if dA(idxs(i))>0
            %               adds only overhangs
                            volA = volA + (idxs(i) - idxs(i-1));
                        end
                    end
                    
                    supportVolume = supportVolume + volA;
                end
           end



end

