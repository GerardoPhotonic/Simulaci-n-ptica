%% [F,nu] Esta función nos permite evaluar la TF en una dimensión y calcular el 
% intervalo de frecuencias presentes en la transformada

%% Programa principal
function [F,nu]=FFT_Completa(f,t)
%Determinamos el número de puntos en los datos
numDatos=length(f);
%Determianmos el intervalo de fecuencias
T=t(numDatos)-t(1);
delta_nu=1/T;
if mod(numDatos,2)==0
    %Caso par
    NummaxP=(numDatos/2-1)*delta_nu;
    NummaxN=(numDatos/2)*(-delta_nu);
else
    %Caso impar
    NummaxP=((numDatos-1)/2)*delta_nu;
    NummaxN=-NummaxP;
end
%Inervalo de frecuencias
nu=linspace(NummaxN,NummaxP,numDatos);

%Determinamos la transformada

F=fftshift(fft(f))/(numDatos/2);
end


