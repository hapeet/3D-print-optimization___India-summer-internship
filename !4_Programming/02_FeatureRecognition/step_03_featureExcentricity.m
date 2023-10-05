

for iFeature = 1:numel(bodyData.propsFeatures)
    
    
    projection = not(bodyData.propsFeatures(iFeature).CutZ.Cut);

    iProps = regionprops(projection,"Eccentricity");
    bodyData.propsFeatures(iFeature).dimensions.eccentricity = iProps.Eccentricity;
end
