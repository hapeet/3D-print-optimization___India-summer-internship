


for feature = 1:size(IM_trainingDataset,1)
    
    Body_cutX_cut = table2array(IM_BodyDataset(feature,"CutX_CutTight"));
    Body_cutY_cut = table2array(IM_BodyDataset(feature,"CutY_CutTight"));
    
    
    for i = 1:size(IM_trainingDataset,1)
        Training_cutX_cut = table2array(IM_trainingDataset(i,"CutX_Cut"));
        Training_cutY_cut = table2array(IM_trainingDataset(i,"CutY_Cut"));
        
        diffXXYY(i,1) = sum(abs(Body_cutX_cut-Training_cutX_cut));
        diffXXYY(i,2) = sum(abs(Body_cutY_cut-Training_cutY_cut));
    
        diffXYXY(i,1) = sum(abs(Body_cutX_cut-Training_cutY_cut));
        diffXYXY(i,2) = sum(abs(Body_cutY_cut-Training_cutX_cut));
    end
    
    SXXYY = sum(diffXXYY,2);
    SXYXY = sum(diffXYXY,2);
    
    
    figure
    bar(SXXYY)
    hold on
    bar(SXYXY)
    
    
    [valxx posxx] = min(SXXYY);
    [valxy posxy] = min(SXYXY);
    
    predictedClassXX = IM_trainingDataset(posxx,"bodyCategory");
    predictedClassXY = IM_trainingDataset(posxy,"bodyCategory");
end