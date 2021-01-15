
clear;
close all;

disp("Loading variables...");
c=load('Clasificadores.mat');

imagenes=load('Ims.mat');

disp("Finished.");


imNames = fieldnames(imagenes);

for i=1:length(imNames)
   Im=imagenes.(imNames{i});
   
   txt=CSeye(Im,c.RFR,c.RFB,c.RFHOGCircRed,c.RFHOGCircBlue,c.RFHOGTriangRed,c.RFHOGTriangBlue);
   
   imshow(Im)
   disp("Original image number "+string(i));
   
   pause(2);
   close all;   
   
   Im=imresize(Im,[150 150]);
   imshow(Im)
   title(txt,'FontSize',15);
   drawnow;
   disp("Prediction for image number "+string(i));
   
   pause(2);
   close all;
end

clear all;

