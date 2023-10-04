function wireframe = wireframeImport(body,tresholdAngle,btmOffsetPx,resolution)


TR = stlread(strcat(body,'.STL'));
F = TR.ConnectivityList;
V = TR.Points;
V = V/resolution;



%%
numFacet = size(F,1);

triangleCombinations = nchoosek(1:numFacet,2);

wireframe = [];

for i = 1:size(triangleCombinations,1)
    face1id = triangleCombinations(i,1);
    face2id = triangleCombinations(i,2);
    
    F1 = F(face1id,:);
    F2 = F(face2id,:);

    T1 = V(F1,:); 
    T2 = V(F2,:);

    T11 = T1(1,:);
    T12 = T1(2,:);
    T13 = T1(3,:);
    
    T21 = T2(1,:);
    T22 = T2(2,:);
    T23 = T2(3,:);

    v1T1 = T11 - T12;
    v2T1 = T11 - T13;
    % Compute the normal vector using the cross product
    N1 = cross(v1T1, v2T1);



    % Calculate two vectors lying on the plane
    v1T2 = T21 - T22;
    v2T2 = T21 - T23;
    % Compute the normal vector using the cross product
    N2 = cross(v1T2, v2T2);

    % Calculate the dot product of the two vectors
    dot_product = dot(N1, N2);
    % Calculate the magnitudes (norms) of the vectors
    magnitude1 = norm(N1);
    magnitude2 = norm(N2);

    % Calculate the absolute angle in radians using the arccosine function
    absolute_angle_rad = (acos((dot_product) / (magnitude1 * magnitude2)));

    % Convert the angle from radians to degrees if needed
    absolute_angle_deg = rad2deg(absolute_angle_rad); 



    if absolute_angle_deg>=tresholdAngle


        if any(all(T2 == T11,2)) & any(all(T2 == T12,2))
            wireframe(end+1,:,1)    = T11;
            wireframe(end,:,2)      = T12;
        elseif any(all(T2 == T12,2)) & any(all(T2 == T13,2))
            wireframe(end+1,:,1)    = T12;
            wireframe(end,:,2)      = T13;
        elseif any(all(T2 == T13,2)) & any(all(T2 == T11,2))
            wireframe(end+1,:,1)    = T13;
            wireframe(end,:,2)      = T11;
        end
        



    end

   
end

% add btm offset

wireframe(:,3,:) = wireframe(:,3,:) +btmOffsetPx;
%% 
% 
   


end