function [height, dG] = supportHeight(G)
    % calculates height of supports
    % no feature-air -> NaN
    % feature with overhang - height
    % more features over itself - highest one
    
    dG = diff(G,1,3);
    height = NaN(size(G,[1 2]));
    
    for ix = 1:size(G,1)
        for iy = 1:size(G,2)
    
            if isempty(find(dG(ix,iy,:)>0,1))
                if  G(ix,iy,1)==1
                    height(ix,iy) = 0;
                else
                    height(ix,iy) = NaN;
                end
            else
                height(ix,iy) = find(dG(ix,iy,:)>0,1,'last');
            end
        end
    end

end