function [forma]=analizarForma(DistIm,RFR,RFB)

        TsR=DistIm(:,1:80);
        TsB=DistIm(:,81:160);
        
        [YfitR,scoresR] = predict(RFR,TsR);  
        [YfitB,scoresB] = predict(RFB,TsB);
        cR = str2double(YfitR);
        cB = str2double(YfitB);
        
        if max(scoresR) > max(scoresB)
           c=cR;
        else
           c=cB;
        end    

        switch c
            case 1
               forma="circle";
            case 2
               forma="triangle";
            case 3
                forma="rhombus";
            case 4
                forma="inverted";
            otherwise
                forma="NaN";
        end
         
end
