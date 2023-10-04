function ptsOK = pointLineDistanceFilter(wireframe,ptsDownNoBtm, wireframeOffset)

pointsAll = ptsDownNoBtm.Location;

linecloseIdx = [];

for i = 1:size(wireframe,1)    
    v1 = wireframe(i,:,1);
    v2 = wireframe(i,:,2);
    
    BB = [  v1(1), v2(1);...
            v1(2), v2(2);...
            v1(3), v2(3)];
    BB = sort(BB,2);

    BB(:,1) = BB(:,1)-wireframeOffset;
    BB(:,2) = BB(:,2)+wireframeOffset;

    idxs = find(pointsAll(:,1)>BB(1,1) & pointsAll(:,1)<BB(1,2) &...
        pointsAll(:,2)>BB(2,1) & pointsAll(:,2)<BB(2,2) &...
        pointsAll(:,3)>BB(3,1) & pointsAll(:,3)<BB(3,2));


    if ~isempty(idxs)
        pts = pointsAll(idxs,:);
        dists = point_to_line(pts, v1, v2);
        linecloseIdx = [linecloseIdx; idxs(dists<wireframeOffset)];
    end


   

end

pointsAll(unique(linecloseIdx),:) = [];
ptsOK = pointCloud(pointsAll);



% figure
% hold on
% 
% pcshow(ptsOK);
% title Wireframefiltered
% 
% 
% hold on
% for i = 1:size(wireframe,1)
%   plot3(squeeze(wireframe(i,1,:)),squeeze(wireframe(i,2,:)),squeeze(wireframe(i,3,:)));
%   hold on
% end
% 
% axis equal









function dist = point_to_line(pt, v1, v2)
    % pt should be nx3
    % v1 and v2 are vertices on the line (each 1x3)
    % d is a nx1 vector with the orthogonal distances
    v1 = repmat(v1,size(pt,1),1);
    v2 = repmat(v2,size(pt,1),1);
    a = v1 - v2;
    b = pt - v2;
    dist = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));
end


end