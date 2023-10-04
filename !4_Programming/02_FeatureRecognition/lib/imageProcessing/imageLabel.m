function [labeledImage, numberOfBlobs] = imageLabel(originalImage, locsLowBoundaries, locsHigh)
    

labeledImage = zeros(size(originalImage));
numberOfBlobs = 0;
    %% high Peaks

    for i = 1:length(locsHigh)

        binaryImage = originalImage==locsHigh(i);
        %% 
        [subLabeledImage, subNumberOfBlobs] = bwlabel(binaryImage, 8);

        subLabeledImage(subLabeledImage>0) = subLabeledImage(subLabeledImage>0)+numberOfBlobs;

        labeledImage = labeledImage + subLabeledImage;
        numberOfBlobs = numberOfBlobs + subNumberOfBlobs;
 
    end

    for i = 1:size(locsLowBoundaries,1)

        binaryImage = and(originalImage >= locsLowBoundaries(i,1), originalImage <= locsLowBoundaries(i,2));
        % figure; imshow(binaryImage);
        
        [subLabeledImage, subNumberOfBlobs] = bwlabel(binaryImage, 8);

        subLabeledImage(subLabeledImage>0) = subLabeledImage(subLabeledImage>0)+numberOfBlobs;

        % labeledImage = labeledImage + subLabeledImage;
        labeledImage(subLabeledImage>0) = subLabeledImage(subLabeledImage>0);
        numberOfBlobs = numberOfBlobs + subNumberOfBlobs;


        % figure
        % coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
        % imshow(coloredLabels);  
    end
% [labeledImage, numberOfBlobs] = bwlabel(binaryImage, 8);
    

end 