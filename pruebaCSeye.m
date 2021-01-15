function pruebaCSeye(RFR,RFB,RFHOGCircRed,RFHOGCircBlue,RFHOGTriangRed,RFHOGTriangBlue)

    dirIms="C:\Users\inigo\OneDrive\Escritorio\uni\MASTER\VisionPorComputador\grupo\ImTest";
    cont=0;
    contF=0;
    E=0;

    numST="/00000";
    numFoto="_00000";
    
    while 1
        
        forma    = randi ([1 7]);
        switch forma
            case 1
                etiqueta = randi([0 10]);
            case 2
                etiqueta = randi([14 17]);%%%14 es stop
            case 3
                etiqueta = randi([32 42]);
               
            case 4
                etiqueta = 11;
            case 5
                etiqueta = 13;
            case 6
                etiqueta = randi([18 31]);
                
            case 7
                etiqueta = 12;
        end

        numST    = randi([0 10]);
        numFoto  = randi([20 28]);
        
        if (etiqueta<10)
            carpeta=(dirIms+"/0000"+num2str(etiqueta));
        else
            carpeta=(dirIms+"/000"+num2str(etiqueta));
        end
        
        if (numST<10)
                numST="/0000"+num2str(numST);
        else
                numST="/000"+num2str(numST);
        end
        
        if (numFoto<10)
             numFoto="_0000"+num2str(numFoto);
        else
             numFoto="_000"+num2str(numFoto);
        end 
         
        DirIm=carpeta+numST+numFoto+".ppm";
        
        try
            Im=imread(DirIm);
        catch 

            continue
            
        end
        tic;
        tipo=CSeye(Im,RFR,RFB,RFHOGCircRed,RFHOGCircBlue,RFHOGTriangRed,RFHOGTriangBlue);
        fps=1/toc;
        texto=tipo;
        imshow(Im);
        
        truesize([300 300]);
        
        title(texto,'FontSize',12);
        drawnow;
        text(180,0,string(fps),'Color','red','FontSize',10,'HorizontalAlignment','right','VerticalAlignment','top')
        
        pause
       
    end
    
end
