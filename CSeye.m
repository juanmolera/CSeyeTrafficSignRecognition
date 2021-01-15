function [tipo]=CSeye(ImOriginal,RFformaR,RFformaB,RFcircHOGR,RFcircHOGB,RFtriangHOGR,RFtriangHOGB)


%tratamiento de Imagen original
ImTratada=tratamientoIm(ImOriginal);


%normalizacion en R y B de imagegen tratada
[ImRn,ImBn,Rmax]=normalizadoRB(ImTratada);

%obtener distancias para sacar forma y recortar Imagen tratada

%Intento sacar distancias e imagen recortada de nRoja
    try 
        [DistIm(1,1:80),ImrecortadaRn]=getDistanciasMSER(ImRn,Rmax,ImTratada);
    catch
         DistIm(1,1:80) = zeros(1,80);
         ImrecortadaRn  = ImTratada;
    end
    
%Intento sacar distancias e imagen recortada de nAzul
    try 
        [DistIm(1,81:160),ImrecortadaBn]=getDistanciasMSER(ImBn,Rmax,ImTratada);
    catch
         DistIm(1,81:160) = zeros(1,80);
         ImrecortadaBn  = ImTratada;
    end

%%%%%%%%%%%%%%%%Mostrar ims originales recortadas%%%%%%%%%%%%%%%%%%%%
%         figure
%         imshow(ImrecortadaRn)
%         figure
%         imshow(ImrecortadaBn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Llamada al random forest para que devuelva la forma

forma=analizarForma(DistIm,RFformaR,RFformaB);

%%%%%%%%%%%%%%%%%%%%Mostrar im con forma%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       imshow(ImOriginal)
%       title(forma,'FontSize',18);
%       drawnow;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Llamada al random forest para que devuelva el tipo de señal segun la forma

tipo=analizarTipo(forma,ImrecortadaRn,ImrecortadaBn,RFcircHOGR,RFcircHOGB,RFtriangHOGR,RFtriangHOGB);

end