close all;
clc;

SUPPORTgrid = zeros(size(OUTPUTgrid));

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
                SUPPORTgrid(ix,iy,idxs(i-1)+1:idxs(i)) = 1;
                % volA = volA + (idxs(i) - );
            end
        end

       
    end
end


figure

axis equal

xlabel x
ylabel y
zlabel z
for ix = 1:size(OUTPUTgrid,1)
    for iy = 1:size(OUTPUTgrid,2)
        for iz = 1:size(OUTPUTgrid,3)
            hold on


            if OUTPUTgrid(ix,iy,iz)==1
                % X = [ix   ix   ix; 
                %      ix   ix   ix+1; 
                %      ix   ix+1 ix+1; 
                %      ix   ix+1 ix];
                % 
                % Y = [iy+1 iy iy+1; 
                %      iy   iy   iy+1; 
                %      iy   iy   iy; 
                %      iy+1 iy   iy];
                % 
                % Z = [iz+1 iz   iz+1; 
                %      iz+1 iz+1 iz+1; 
                %      iz   iz+1 iz+1; 
                %      iz   iz   iz+1];

                X = [ix   ix   ix   ix+2; 
                     ix   ix   ix+2 ix+2; 
                     ix   ix+2 ix+2 ix+2; 
                     ix   ix+2 ix   ix+2];
                
                Y = [iy+2 iy iy+2   iy+2; 
                     iy   iy   iy+2 iy  ; 
                     iy   iy   iy   iy  ; 
                     iy+2 iy   iy   iy+2];

                Z = [iz+2 iz   iz+2 iz+2; 
                     iz+2 iz+2 iz+2 iz+2; 
                     iz   iz+2 iz+2 iz; 
                     iz   iz   iz+2 iz];

                X = -X + 40;
                fill3(X,Y,Z,[0.8 0.8 0.8]);
            end

            if SUPPORTgrid(ix,iy,iz)==1
                X = [ix   ix   ix   ix+2; 
                     ix   ix   ix+2 ix+2; 
                     ix   ix+2 ix+2 ix+2; 
                     ix   ix+2 ix   ix+2];

                Y = [iy+2 iy iy+2   iy+2; 
                     iy   iy   iy+2 iy  ; 
                     iy   iy   iy   iy  ; 
                     iy+2 iy   iy   iy+2];

                Z = [iz+2 iz   iz+2 iz+2; 
                     iz+2 iz+2 iz+2 iz+2; 
                     iz   iz+2 iz+2 iz; 
                     iz   iz   iz+2 iz];   
                X = -X + 40;

                fill3(X,Y,Z,[0.8 0.1 0.1]);
            end


         end
    end
    disp(ix)
    
end


axis equal
axis off

view([-45 45])
%%
set(gcf,'color','white')    
saveas(gcf,'voxBodySupported.png')
