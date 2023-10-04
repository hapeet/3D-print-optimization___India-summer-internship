
function [locsLowBoundaries, locsHigh] = histogramFilter(pixelCount)

    
    [pks, locs] = findpeaks(pixelCount);
    
    locs = [1;locs;256] - 1;
    pks = [pixelCount(1);pks;pixelCount(256)];
    
    
    
    
    % %% HIGH / SMALL PEAK FILTERING
    
    locsHigh = locs(pks>(max(pks)/20));
    pksHigh = pks(pks>(max(pks)/20));
    
    locsLow = locs(pks<=(max(pks)/20));
    pksLow = pks(pks<=(max(pks)/20));
    
    
    % subplot(3,1,1); xlim([1 256]);
    % bar(pixelCount);
    % title('original')
    % 
    % subplot(3,1,2)
    % bar(locsHigh,pksHigh,0.05);xlim([1 256]);
    % title('high peaks')
    % 
    % subplot(3,1,3)
    % bar(locsLow,pksLow,0.3);xlim([1 256]);
    % title('low peaks')

    if ~isempty(locsLow)
        locsLowBoundaries(1,1) = locsLow(1);
        for i = 2:length(locsLow)
            if (locsLow(i)-locsLow(i-1)) > 10
                locsLowBoundaries(end,2) = locsLow(i-1);
                locsLowBoundaries(end+1,1) = locsLow(i);
                i = i+1;
            end
        end
        locsLowBoundaries(end,2) = locsLow(end);
    else
        locsLowBoundaries = [];
    end

end