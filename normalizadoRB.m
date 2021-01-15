function [Rn,Bn,Rmax]=normalizadoRB(D)

Im=D;        
    [r,c,s]=size(Im);
    Rn=zeros(r,c);
    Bn=zeros(r,c);
    for i=1:r
        for j=1:c
            R=double(Im(i,j,1));
            G=double(Im(i,j,2));
            B=double(Im(i,j,3));
            SumaRGB=R+G+B;
            Rn(i,j)=uint8(255*(R/SumaRGB));
            Bn(i,j)=uint8(255*(B/SumaRGB));                   
        end
    end     
    Rn=uint8(Rn);
    Bn=uint8(Bn);
%     figure
%     imshow(Rn)

    % figure
    % imshow(Gray)
    Rmax=min(r/2,c/2);


end