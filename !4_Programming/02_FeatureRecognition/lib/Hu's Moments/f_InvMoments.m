function inv_moments = f_InvMoments(image)

    mask = ones(size(image));
    
    eta = SI_Moment(image, mask);   % invariant moment matrix - order 3
    inv_moments = Hu_Moments(eta);  % 7 invariant moments
end