function [features]=HOG(A)
    %figure('Name','Original Image');
    %imshow(A)
    A=imresize(A,[35 35]);

    
    [features,visualization]=extractHOGFeatures(A);

end
