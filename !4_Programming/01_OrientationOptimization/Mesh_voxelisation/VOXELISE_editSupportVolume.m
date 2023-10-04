
%Plot the original STL mesh:
figure
[stlcoords] = READ_stl('Body_04.STL');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal
axis tight

%% Voxelise the STL:

[OUTPUTgrid] = VOXELISE(100,30,50,['Body_04.STL'],'xyz');

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% support volume calc
volume = 0;


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
        
        volume = volume + volA;
    end
end

