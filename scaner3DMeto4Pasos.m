%% EJEMPLO RÀPIDO DE UN SCANNER  3D MEDIANTE LA TÉCNICA DE 
% PROYECCION DE  FRANJAS Y LA EXTRACCION DE FASE CON LA 
% TECNICA DE 4 PASOS
clear, clc, close all

%% PROGRAMA PRINCIPAL
% Creamos la matriz para guardar la fotos
fotoPaso=uint8(zeros(480, 640,4));
%% ABRIMOS LA CAMARA
camara3D = videoinput("winvideo", 1, "YUY2_640x480");
% Establecemos las condiciones manuales
camara3D.ReturnedColorspace = "grayscale";      % Escala de grises
src = getselectedsource(camara3D);
src.Exposure = -4;                      % Tiempo de exposición
src.ExposureMode = "manual";            % Exposicion en modo manual
%% GENERACIÓN DEL PATRON DE FRANJAS 
x=linspace(0,1,400);
y=x;
[X,Y]=meshgrid(x,y);
%% CREACIÓN DE LA VENTANA DE PROYECCION
figure('units', 'normalized')
% Cambiamos el mapa de color
colormap gray
for q=1:4
    % Generamos el patro de franjas
    I=1+cos(2*pi*10*X + (q-1)*pi/2);
    
    % Mostramos el patron de franjas
    imagesc(I)
    % Esperamos 1 seg para tomar la imagen
    pause(0.1)
    %% TOMAMOS LA FOTO
    fotoPaso(:,:,q) = getsnapshot(camara3D);

    pause(0.1)
end
clear camara3D

%% PROCESAMIENTO DE 4 PASOS
fotoPaso=double(fotoPaso);
% Determinamos la fase envuelta
psi=atan2( fotoPaso(:,:,4) - fotoPaso(:,:,2), ...
    fotoPaso(:,:,1) - fotoPaso(:,:,3) );
%% Selección de la región de interés


%% MOSTRAMOS LOS DATOS
subplot(3,1,1)
imagesc(fotoPaso(:,:,1));
title('Foto del patron de FRANJAS')
subplot(3,1,2)
plot(fotoPaso(240,:,1))
xlabel('Coordenada X (Pixel)')
ylabel('Coordenada Y (Pixel)')
subplot(3,1,3)
imagesc(psi)

