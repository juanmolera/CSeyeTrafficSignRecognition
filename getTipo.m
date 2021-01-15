function tipo=getTipo(tipo)
    switch tipo
        case 0
            tipo="20[km/h] limit";
        case 1      
            tipo="30[km/h] limit";
        case 2      
            tipo="50[km/h] limit";
        case 3      
            tipo="60[km/h] limit";
        case 4      
            tipo="70[km/h] limit";
        case 5      
            tipo="80[km/h] limit";
        case 6
            tipo="80[km/h] limit ends";
        case 7
            tipo="100[km/h] limit";
        case 8              
            tipo="120[km/h] limit";
        case 9
            tipo="overtaking not allowed";
        case 10
            tipo="overtaking prohibited for trucks";
        case 11
            tipo="crossroad ahead, side roads to right and left";
        case 12
            tipo="priority road ahead";
        case 13
            tipo="give way to all traffic";
        case 14
            tipo="stop";
        case 15
            tipo="entry not allowed ";
        case 16
            tipo="entry not allowed for trucks";
        case 17
            tipo="no entry (one way traffic)";
        case 18
            tipo="other warnings";
        case 19
            tipo="dangerous curve left";
        case 20
            tipo="dangerous curve right";
        case 21
            tipo="dangerous curves";
        case 22
            tipo="irregular road surface";
        case 23
            tipo="slippery road surface";
        case 24
            tipo="Construction up ahead";
        case 25
            tipo="construction on road";
        case 26
            tipo="traffic light";
        case 27
            tipo="pedestrians up ahead";
        case 28
            tipo="children up ahead";
        case 29
            tipo="cyclists up ahead";
        case 30
            tipo="snow or ice up ahead";		
        case 31
            tipo="deer crossing";
        case 32
            tipo="end of restrictions";
        case 33
            tipo="turn right compulsory";
        case 34
            tipo="turn left compulsory";
        case 35
            tipo="ahead only";
        case 36
            tipo="turn right or keep straight only";
        case 37
            tipo="turn left or keep straight only";
        case 38
            tipo="passing right compulsory";
        case 39
            tipo="passing left compulsory";
        case 40
            tipo="roundabout direction";
        case 41
            tipo="end of overtaking restriction";
        case 42
            tipo="end of overtaking restriction for trucks";
        otherwise
            tipo="Not recognized";
    end
end