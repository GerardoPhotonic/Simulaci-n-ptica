%% Este es un script que nos permite visualizar el desempeño del método
% de Fourier o de Takeda para extraer la fase con una sola señal

%% PROGRAMA PRINCIPAL

%Creamos el patrón de franjas
%Número de datos
numDatos=200;
x=linspace(-1,1,numDatos);
y=x;
% Creamos la rejilla de interés
[X,Y]=meshgrid(x,y);
%Frecuencia de la portadora 
f0=10;
% Phi es la fase de nuestro interés (gaussiana)
ancho=0.2;
phi=exp(-(X.^2 + Y.^2)/ancho.^2);


%% Creamos la señal de interés
%Creamos el término cte
a= 1 + 0.1*(rand(1,numDatos)-0.5)/2;
%Creamos el término de amplitud
b= 0.8+ 0.5*(rand(1,numDatos)-0.5)/2;
%Creamos la señal de interés
g=a+b.*cos(2*pi*f0*X+phi);

%% Método de Takeda
% Aplicamos transformada de Fourier
G=fftshift(fft2(g)); %Caso discreto 2 dimensional y correjido

%Creamos el filtro pasa banda en 2D
filtro=zeros(numDatos,numDatos);
%Definimos el ancho de banda
bandwidth=10;
%Definimos la frecuencia central
frecCentral=121;
filtro(:,frecCentral-bandwidth:frecCentral+bandwidth)=1;
%Filtramos la señal
GF=G.*filtro;

%Opción 1: Sin eliminar la portadora
c=ifft2(fftshift(GF));
%Finalmente, determinamos la fase envuelta
psiLog=imag(log(c));
psiTan=atan2(imag(c),real(c));

%Desenvolvemos la fase
phiLog=psiLog;
phiTan=psiTan;

%Desenvolvemos la primera columna
phiLog(:,1)=unwrap(phiLog(:,1));
phiTan(:,1)=unwrap(phiTan(:,1));

%Desenvolvemos renglon por renglon
for q=1:numDatos
phiLog(q,:)=unwrap(phiLog(q,:));
phiTan(q,:)=unwrap(phiTan(q,:));
end
%% Mostramos resultados 
colormap gray
subplot(3,1,1)
imagesc(x,y,g)
title('Señal de interés')
xlabel('Eje x (UA)')
ylabel('Eje y (UA)')

%Mostramos el espectro de g(x,y)
subplot(3,1,2)
imagesc(log(abs(G) + 0.05*filtro))
%plot(log(abs(G(101,:))))
colorbar
title('Espectro de g(x,y)')
xlabel('Frecuancias en x (UA)')
ylabel('Frecuancias en y (UA)')

%Mostramos las fases obtenidas
subplot(3,2,5)
mesh(phiLog - 2*pi*f0*X)
title('Fase recuperada con el ln(\psi)')
subplot(3,2,6)
mesh(phiTan - 2*pi*f0*X)
title('Fase recuperada con la Tan^{-1} (\psi)')



