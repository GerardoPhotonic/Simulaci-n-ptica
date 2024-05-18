%% [F,nux,nuy]=FFT2_Completa(f,x,y) Esta función nos permite evaluar la 
% TF en dos dimensiones y calcular el intervalo de frecuencias 
% presentes en la transformada.

%% Programa principal
function [F,nux,nuy]=FFT2_Completa(f,t1,t2)

%Determinamos el número de puntos en la matriz
[numdatosY,numdatosX]=size(f);

%Determianmos el intervalo de fecuencias en X
Tx=t1(numdatosX)-t1(1);
delta_nux=1/Tx;

%Determianmos el intervalo de fecuencias en Y
Ty=t2(numdatosY)-t2(1);
delta_nuy=1/Ty;

% Caso para el eje x
if mod(numdatosX,2)==0
    %Caso par
    NummaxP_x=(numdatosX/2-1)*delta_nux;
    NummaxN_x=(numdatosX/2)*(-delta_nux);
else
    %Caso impar
    NummaxP_x=((numdatosX-1)/2)*delta_nux;
    NummaxN_x=-NummaxP_x;
end


% Caso para el eje y
if mod(numdatosY,2)==0
    %Caso par
    NummaxP_y=(numdatosY/2-1)*delta_nuy;
    NummaxN_y=(numdatosY/2)*(-delta_nuy);
else
    %Caso impar
    NummaxP_y=((numdatosY-1)/2)*delta_nuy;
    NummaxN_y=-NummaxP_y;
end

%Intervalo de frecuencias en X
nux=linspace(NummaxN_x,NummaxP_x,numdatosX);

%Intervalo de frecuencias en Y
nuy=linspace(NummaxN_y,NummaxP_y,numdatosY);

%Determinamos la transformada
F=fftshift(fft2(f)) / (numdatosY*numdatosX/2);

end

