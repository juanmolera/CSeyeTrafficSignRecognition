function [D]=tratamientoIm(A)

B=rgb2hsv(A);
    C=B(:,:,3);

    %Luminance Enhancement
    V2=[];
    for i=1:length(C(:,1))
        for j=1:length(C(1,:))
            %Con esta función las zonas con luminancia baja sufren un
            %incremento brusco. Las que la tienen elevada también aumentan pero
            %en menor medida.
            V2(i,j)=(C(i,j)^(0.24)+0.5*(1-2*C(i,j))+C(i,j)^2)/2;
        end
    end
    B(:,:,3)=V2;
    %figure('Name','Luminance Enhacement');
    D=hsv2rgb(B);
    %imshow(D)

    %Contrast Enhancement
    V4=[];
    V3=imgaussfilt(C);
    for i=1:length(C(:,1))
        for j=1:length(C(1,:))
            %Sobre el canal con la luminancia potenciada, cada pixel se ve
            %potenciado en función del resultado de comparar dicho pixel de la
            %imagen original (C) con el mismo tras ser suavizada la imagen (V3, 
            %convolución gaussiana) para resaltar así los contrastes. Este
            %efecto se potencia aun más elevando a 5 ese constraste.
            V4(i,j)=V2(i,j)^((V3(i,j)/C(i,j))^5);
        end
    end
    B(:,:,3)=V4;
    %figure('Name','Constrast Enhacement');
    D=hsv2rgb(B);
   
end