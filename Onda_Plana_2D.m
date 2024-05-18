%% ONDA ARMÓNICA PLANA EN 2D

%% PROGRAMA PRINCIPAL

%% CONSTANTES FÍSICAS
lambda0=632e-9; %Longitud de onda (m)
k=2*pi/lambda0; % Numero de onda
mu0=4*pi*1e-7; % Permeabilidad(H/m)
eps0=8.854e-12; % Permitividad en el vacío (F*m)
c0=1/sqrt(mu0*eps0); % Velocidad de la luz en el vacío
nu0=c0/lambda0; % Frecuencia de la luz (Hz)
T=1/nu0; %Periodo temporal (s)
w=2*pi*nu0; % %Frecuencia angular (rad*Hz)
theta=0*(pi/180); % Angulo del vector de onda (rads)
kx=k*cos(theta); %Componente del vector de onda en X
ky=k*sin(theta); %Componente del vector de onda en Y
E0=1; %Amplitud del campo eléctrico (UA)
phi0=0*(pi/180); %Fase inicial (Rads)

%% PARÁMETROS DE LA REGIÓN DE SIMULACIÓN
xmin=-2.5*lambda0; %Intervalo de medición en X
xmax=2.5*lambda0;
ymin=-2.5*lambda0; %Intervalo de medición en Y
ymax=2.5*lambda0;
Nx=200; %Puntos en X
Ny=200; %Puntos en Y
x=linspace(xmin,xmax,Nx); %Intervalos
y=linspace(ymin,ymax,Ny);
[X,Y]=meshgrid(x,y); %Rejilla de simulación
Q=10; %Número de puntos por periodo
delta_t=T/Q; 

%% SIMULACIÓN DE LA ONDA
for q=0:5*Q
    E=E0*cos(kx*X + ky*Y -w*q*delta_t + phi0);
    
    %% MOSTRAMOS LOS RESULTADOS
    imagesc(x*1e6,y*1e6,E) % Mostramos la onda
    set(gca,'YDir','normal')
    colormap gray
    colorbar   %Mostramos la barra de color
    %Información de la gráfica
    xlabel('Eje X (\mum)')
    ylabel('Eje Y (\mum)')
    title('Onda armónica plana')
    pause(0.1)
end
