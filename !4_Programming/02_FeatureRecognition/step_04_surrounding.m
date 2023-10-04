clc; close all


surroundingWidht = 10/resolution;   % surrounding offset in mm divided by resolution in mm/px > px

for iFeature = 1:numel(propsFeatures)

% CUT X 

CutX = propsFeatures(iFeature).CutX;

tightCutBoundaries(1) = CutX.CutBoundaries(1) - CutX.CutBoundariesExt(1);
tightCutBoundaries(2) = CutX.CutBoundaries(2) - CutX.CutBoundariesExt(1)+1;

negSurroundings = zeros(1,surroundingWidht,size(CutX.CutTightWide,3));
posSurroundings = zeros(1,surroundingWidht,size(CutX.CutTightWide,3));

negSurroundings(find(CutX.CutTightWide(1,1:tightCutBoundaries(1),:))) = 1;
posSurroundings(find(CutX.CutTightWide(1,tightCutBoundaries(2)+1:end,:))) = 1;


figure
subplot(2,2,[1,3])
imshow(squeeze(CutX.CutTightWide)) 
axis on

subplot(2,2,2)
imshow(squeeze(negSurroundings))
axis on

subplot(2,2,4)
imshow(squeeze(posSurroundings))
axis on

close all

end