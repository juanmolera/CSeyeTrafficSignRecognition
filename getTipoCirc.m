function tipo=getTipoCirc(HOGRn,HOGBn,RFR,RFB)

    [YfitR,scoresR] = predict(RFR,HOGRn);  
    [YfitB,scoresB] = predict(RFB,HOGBn);
    
    cR = str2double(YfitR);
    cB = str2double(YfitB);

    if max(scoresR) > max(scoresB)
       tipo=cR;
    else
       tipo=cB; 
    end

end