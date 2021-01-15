function tipo=analizarTipo(forma,ImRn,ImBn,RFcircHOGR,RFcircHOGB,RFtriangHOGR,RFtriangHOGB)

    
    try 
          HOGnR=HOG(ImRn);
          HOGnB=HOG(ImBn);
    catch
          tipo="no reconocido";
          return;
    end

    switch forma
                case 'circle'
                   tipo=getTipoCirc(HOGnR,HOGnB,RFcircHOGR,RFcircHOGB);
                case 'triangle'
                   tipo=getTipoTriang(HOGnR,HOGnB,RFtriangHOGR,RFtriangHOGB);
                case 'rhombus'
                    tipo=12;
                case 'inverted'
                    tipo=13;
                otherwise
                    tipo="404";
    end
    
    tipo=getTipo(tipo);
end