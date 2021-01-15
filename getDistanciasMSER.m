function [Distancias, D]=getDistanciasMSER(ImN,Rmax,D)

    Rmin=Rmax*0.2;
    MaxArea=round(pi*Rmax^2);
    MinArea=round(pi*Rmin^2);
    
    [regions,mserCC] = detectMSERFeatures(ImN,'ThresholdDelta',2,'MaxAreaVariation',0.7,'RegionAreaRange',[MinArea MaxArea]);
    
    stats = regionprops('table',mserCC,'Eccentricity','Centroid','MajorAxisLength','MinorAxisLength','PixelIdxList');
    stats.Radios=(stats.MajorAxisLength+stats.MinorAxisLength)/4;
    stats(stats.Eccentricity>0.7,:)=[];
    stats(stats.Radios>Rmax,:)=[];
    
    mserCC.NumObjects=height(stats);
    mserCC.PixelIdxList=stats.PixelIdxList;

    %Saco identificador de cada región MSER
    labeledImage = labelmatrix(mserCC);
    unique(labeledImage);

    % Me quedo solo con las regiones MSER
    mask = labeledImage >0;
    
    %imshow(mask);
    %figure('Name','Binary Image');
    %imshow(V5)
    
    VL = mask;     %Cambio de nombre a la variable para independizar esta parte del código de la anterior
    s=size(VL);  %Como podemos trabar con imágenes en distintas resoluciones necesitamos conocer su tamaño
    VL=logical(VL);
    %figure('Name','Original')
    %imshow(VL)
    %Filtramos los conjuntos de pixeles que estén más aislados
    Filtrada = zeros(s(1),s(2));
    for aux=1 : round((s(1)+s(2))/45)
        for i=2 : (s(1)-2)
            for j=2 : (s(2)-2)
                for auxi= -1 : 1
                    for auxj = -1 : 1
                        Filtrada(i,j) = Filtrada(i,j) + VL(i+auxi,j+auxj);
                    end
                end
                if Filtrada(i,j)>7
                    Filtrada(i,j)=1;
                else
                    Filtrada(i,j)=0;
                end
            end
        end
        VL=Filtrada;
    end
    %figure('Name','filtrada')
    %imshow(Filtrada)


    VL = imfill(VL,'holes');    %Rellenamos los agujeros de la imagen original ya que suponemos que no habrá ningún elemento conexo grande a parte de la señal 
    %figure('Name','VL Relleno')
    %imshow(VL)
    CC = bwconncomp(VL);    %Extraemos las propiedades de los distintos elementos conexos de la imagen
    numPixels = cellfun(@numel,CC.PixelIdxList); 
    [biggest,idx] = max(numPixels); %Sacamos el elemento conexo mayor
    %Contamos el número total de píxeles blancos
    pixeles_totales=0;
    for i= 1 : CC.NumObjects
        pixeles_totales=pixeles_totales+numPixels(i);
    end
    %Eliminamos todas las regiones que sean inferiores a la tercera parte de la
    %región mayor
    n=0;
    for i= 1 : CC.NumObjects
        if (biggest/numPixels(i))>3 
            VL(CC.PixelIdxList{i}) = 0;
        else
            n=n+1;
        end
    end

    %figure('Name','VL')
    %imshow(VL)
    
    try
        %Calculamos los centroides de cada región superviviente
        prop = regionprops(VL,'centroid');
        centroids = cat(1,prop.Centroid);

        %Hacemos un cambio de variable a la matriz imagen VL para poder hallar el
        %centroide total de la suma de todas las regiones
        mat=zeros(s(1),s(2));
        for i=1 : s(1)
            for j=1 : s(2)
                if VL(i,j)>0
                    mat(i,j)=1;
                end
            end
        end
        prop = regionprops(mat,'centroid');
        centroide = cat(1,prop.Centroid);

        %Medimos las distancias de cada centroide individual al total y eliminamos
        %las regiones cuyo centroide esté excesivamente alejado respecto a la
        %distancia media
        distancia=zeros(n,1);
        distancia_media=0;
        for i=1 : n
            distancia(i)=sqrt((centroide(1)-centroids(i,1))^2+(centroide(2)-centroids(i,2))^2);
            distancia_media=distancia_media+distancia(i);
        end
        distancia_media=distancia_media/n;
        for i=1 : n
            if distancia(i)>(1.5*distancia_media)
                VL(CC.PixelIdxList{i}) = 0;
            end
        end
    catch
    end

    Filtrada=VL;
    %Se va a proceder a recortar los márgenes vacíos. 
    % Empezamos eliminando las filas marginales vacías, y para ello medimos
    % cuántos píxeles hay en cada fila
    pixeles_totales=0;
    pixeles_totalesant=0;
    pixeles_encontrados=zeros(s(1),1);
    for i= 1 : s(1)
        for j=1 : s(2)
            pixeles_totales=pixeles_totales+Filtrada(i,j);
        end
        pixeles_encontrados(i)=pixeles_totales-pixeles_totalesant;
        pixeles_totalesant=pixeles_totales;
    end
    %Ahora buscamos fila a fila hasta encontrar la primera y la última que 
    %cumpla con los requisitos de comienzo de imagen y guardamos su posición 
    primera_fila=1;
    ultima_fila=1;
    for i=1 : s(1)
        if pixeles_encontrados(i)>1
            primera_fila=i;
            break
        end
    end
    for i=s(1) :-1 :1
        if pixeles_encontrados(i)>1
            ultima_fila=i;
            break
        end
    end
    %Eliminamos todas las filas vacías salvo las 3 últimas para dejar cierto
    %margen
    for i=s(1) :-1 : (ultima_fila+3)
        Filtrada(i,:) = [];
    end

    %figure('Name','Filt_Recort')
    %imshow(Filtrada);
    s=size(Filtrada);
    if s(1)>(primera_fila-3)
        for i= 1 : (primera_fila-3)
            Filtrada(1,:) = [];
        end
    end
    %figure('Name','Filt_Recort')
    %imshow(Filtrada);
    s=size(Filtrada);

    %Repetimos la operación con las columnas:
    pixeles_totales=0;
    pixeles_totalesant=0;
    pixeles_encontrados=zeros(s(2),1);
    for j= 1 : s(2)
        for i=1 : s(1)
            pixeles_totales=pixeles_totales+Filtrada(i,j);
        end
        pixeles_encontrados(j)=pixeles_totales-pixeles_totalesant;
        pixeles_totalesant=pixeles_totales;
    end
    primera_columna=1;
    ultima_columna=s(2);
    for j=1 : s(2)
        if pixeles_encontrados(j)>(pixeles_totales/(10*s(2)))
            primera_columna=j;
            break
        end
    end
    for j=s(2) :-1 :1
        if pixeles_encontrados(j)>1
            ultima_columna=j;
            break
        end
    end
    for j=s(2) :-1 :(ultima_columna+3)
        Filtrada(:,j) = [];
    end
    %figure('Name','Filt_Recort')
    %imshow(Filtrada);
    s=size(Filtrada);
    if s(2)>(primera_columna-3)
        for j=1: (primera_columna-3)
            Filtrada(:,1) = [];
        end
    end

    %figure('Name','Filt_Recort')
    %imshow(Filtrada);
    s=size(Filtrada);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Comenzamos las medidas
    verticalu=zeros(20, 1);
    verticald=zeros(20, 1);
    horizontald=zeros(20, 1);
    horizontali=zeros(20, 1);

    if (s(1)>10 && s(2)>10)
        %Medida de las distancias horizontales, 20 de izq a dcha y 20 de dcha a izq
        for i=1 : 20    %20 medidas en sus correspondientes 20 filas
            n=0;    %Numero de pixeles blancos presentes en toda la fila
            fila=round(i*s(1)/21);  %Buscamos que las 20 filas estén un poco centradas
            for j=1 : round(s(2)/2) %Buscaremos hasta la mitad de la imagen , más allá se deja a la medida del otro lado
                n=n+Filtrada(fila,j);   %Contamos cada pixel blanco que hay en la media fila
            end
            contando=0; %Bandera que indica si se viene de atravesar pixeles blancos
            cuentas=0;  %Numero de pixeles blancos atravesados seguidos
            %Comenzamos a medir:
            for j=1 : round(s(2)/2)
                if Filtrada(fila,j)==1
                    if contando==0  %Si el pixel es blanco y no estábamos contando
                        contando=1; %Subimos la bandera de que estamos contando
                        resultado_provisional=j;    %Guardamos la posición del pixel donde empezamos a contar
                        cuentas=1;
                    else            %Si ya estábamos contando:
                        cuentas=cuentas+1;  %Sumamos una cuenta más
                        if cuentas>=(n/3)   %Si llevamos suficientes cuentas, asumimos que estamos en la región correcta, por lo que hemos terminado
                            break
                        end
                    end
                else    %Si el pixel es negro
                    cuentas=0;
                    contando=0;
                    resultado_provisional=round(s(2)/2);
                end
            end
            horizontald(i)=resultado_provisional/round(s(2)/2);

            %Lo mismo pero de dcha a izq

            for j=round(s(2)) :-1 :round(s(2)/2) %Buscaremos hasta la mitad de la imagen , más allá se deja a la medida del otro lado
                n=n+Filtrada(fila,j);   %Contamos cada pixel blanco que hay en la media fila
            end
            contando=0; %Bandera que indica si se viene de atravesar pixeles blancos
            cuentas=0;  %Numero de pixeles blancos atravesados seguidos
            %Comenzamos a medir:
            for j=round(s(2)) :-1 :round(s(2)/2)
                if Filtrada(fila,j)==1
                    if contando==0  %Si el pixel es blanco y no estábamos contando
                        contando=1; %Subimos la bandera de que estamos contando
                        resultado_provisional=s(2)-j;    %Guardamos la posición del pixel donde empezamos a contar
                        cuentas=1;
                    else            %Si ya estábamos contando:
                        cuentas=cuentas+1;  %Sumamos una cuenta más
                        if cuentas>=(n/3)   %Si llevamos suficientes cuentas, asumimos que estamos en la región correcta, por lo que hemos terminado
                            break
                        end
                    end
                else    %Si el pixel es negro
                    cuentas=0;
                    contando=0;
                    resultado_provisional=round(s(2)/2);
                end
            end
            horizontali(i)=resultado_provisional/round(s(2)/2);
        end




        %Medida de las distancias verticales, 20 up y 20 down
        for j=1 : 20    %20 medidas en sus correspondientes 20 columnas
            n=0;    %Numero de pixeles blancos presentes en toda la columna
            columna=round(j*s(2)/21);  %Buscamos que las 20 columnas estén un poco centradas
            for i=1 : round(s(1)/2) %Buscaremos hasta la mitad de la imagen , más allá se deja a la medida del otro lado
                n=n+Filtrada(i,columna);   %Contamos cada pixel blanco que hay en la media columna
            end
            contando=0; %Bandera que indica si se viene de atravesar pixeles blancos
            cuentas=0;  %Numero de pixeles blancos atravesados seguidos
            %Comenzamos a medir:
            for i=1 : round(s(1)/2)
                if Filtrada(i,columna)==1
                    if contando==0  %Si el pixel es blanco y no estábamos contando
                        contando=1; %Subimos la bandera de que estamos contando
                        resultado_provisional=i;    %Guardamos la posición del pixel donde empezamos a contar
                        cuentas=1;
                    else            %Si ya estábamos contando:
                        cuentas=cuentas+1;  %Sumamos una cuenta más
                        if cuentas>=(n/3)   %Si llevamos suficientes cuentas, asumimos que estamos en la región correcta, por lo que hemos terminado
                            break
                        end
                    end
                else    %Si el pixel es negro
                    cuentas=0;
                    contando=0;
                    resultado_provisional=round(s(1)/2);
                end
            end
            verticald(j)=resultado_provisional/round(s(1)/2);

            %Lo mismo pero de abajo a arriba

            for i=round(s(1)) :-1 :round(s(1)/2) %Buscaremos hasta la mitad de la imagen , más allá se deja a la medida del otro lado
                n=n+Filtrada(i,columna);   %Contamos cada pixel blanco que hay en la media columna
            end
            contando=0; %Bandera que indica si se viene de atravesar pixeles blancos
            cuentas=0;  %Numero de pixeles blancos atravesados seguidos
            %Comenzamos a medir:
            for i=round(s(1)) :-1 :round(s(1)/2)
                if Filtrada(i,columna)==1
                    if contando==0  %Si el pixel es blanco y no estábamos contando
                        contando=1; %Subimos la bandera de que estamos contando
                        resultado_provisional=s(1)-i;    %Guardamos la posición del pixel donde empezamos a contar
                        cuentas=1;
                    else            %Si ya estábamos contando:
                        cuentas=cuentas+1;  %Sumamos una cuenta más
                        if cuentas>=(n/3)   %Si llevamos suficientes cuentas, asumimos que estamos en la región correcta, por lo que hemos terminado
                            break
                        end
                    end
                else    %Si el pixel es negro
                    cuentas=0;
                    contando=0;
                    resultado_provisional=round(s(1)/2);
                end
            end
            verticalu(j)=resultado_provisional/round(s(1)/2);
        end

    else
        for i=1:20
            horizontald(i)=1;
            horizontali(i)=1;
            verticalu(i)=1;
            verticald(i)=1;
        end
    end

    
    Distancias(1,1:20)=horizontald;
    Distancias(1,21:40)=horizontali;
    Distancias(1,41:60)=verticalu;
    Distancias(1,61:80)=verticald;
    
    %Nuevo
    %Se va a proceder a recortar los márgenes vacíos.
%Eliminamos todas las filas vacías salvo las 3 últimas para dejar cierto
%margen
s=size(D);
for i=s(1) :-1 : (ultima_fila+3)
    D(i,:,:) = [];
end
s=size(D);
if s(1)>(primera_fila-3)
    for i= 1 : (primera_fila-3)
        D(1,:,:) = [];
    end
end
s=size(D);
%Columnas
for j=s(2) :-1 :(ultima_columna+3)
    D(:,j,:) = [];
end
s=size(D);
if s(2)>(primera_columna-3)
    for j=1: (primera_columna-3)
        D(:,1,:) = [];
    end
end
s=size(D);
    end