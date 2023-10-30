function SAVE_stl(geometry,filename)
    

    sz = size(geometry,1);  %number of triangles
    P = [geometry(:,:,1);geometry(:,:,2);geometry(:,:,3)];

    T = [1:sz]';        % connectivity list
    T(:,2) = T(:,1) + sz;
    T(:,3) = T(:,2) + sz;
    
    TR = triangulation(T,P);
    
    stlwrite(TR,filename);

end

