function [I,G] = importStlToGrid(body,resolution)
    
    STL_file = strcat(body,'.STL');
        
    
    [stlcoords] = READ_stl(STL_file);
    
    
    %% find min max dimensions of stl in all 3 coordiantes
    xmin = min(min(stlcoords(:,1,:)));
    xmax = max(max(stlcoords(:,1,:)));
    
    ymin = min(min(stlcoords(:,2,:)));
    ymax = max(max(stlcoords(:,2,:)));
    
    zmin = min(min(stlcoords(:,3,:)));
    zmax = max(max(stlcoords(:,3,:)));
    
    
    %% Voxelise the STL:

    xVoxNum = abs(ceil((xmax-xmin)/resolution));
    yVoxNum = abs(ceil((ymax-ymin)/resolution));
    zVoxNum = abs(ceil((zmax-zmin)/resolution));
    
    [G] = VOXELISE(xVoxNum,yVoxNum,zVoxNum,stlcoords,'xyz');
  
    I = squeeze(sum(G,3));
    I = uint8(255*I/max(max(I)));
    
end

