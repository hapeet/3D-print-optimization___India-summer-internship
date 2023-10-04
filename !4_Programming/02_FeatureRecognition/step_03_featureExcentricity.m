

for iFeature = 1:numel(propsFeatures)
    
    
    projection = not(propsFeatures(iFeature).CutZ.Cut);

    iProps = regionprops(projection,"Eccentricity");
    propsFeatures(iFeature).dimensions.eccentricity = iProps.Eccentricity;
end
