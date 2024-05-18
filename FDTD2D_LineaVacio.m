%% Modelación de la FDTD en 2 dimensiones con un pulso de Ricker

%% Programa principal
%% Definimos los parámetros computacionales
%Número de Courant
Sc=1/sqrt(2);
%Número de nodos espaciales
M=300;
%Número de nodos espaciales
N=300;
%Numero de pasos temporales
Q=300;

%% Constantes físicas 
%Permitividad del vacío
eps0= 8.85e-12;
%Permeabilidad del vacío
mu0= 4*pi*1e-7;
% Permeabilidad relativa
mu_r=1;
% Permitividad del Medio
mu=mu_r*mu0;
%Impedancia en el vacío
eta0=sqrt(mu0/eps0);
%Velocidad de la luz en el vacío
c0=1/sqrt(mu0*eps0);

%% Parámetros de la excitación
%Onda de Ricker
fp=94.9e6; %1/tau; %Frecuencia del pulso en Hz
t0=1/fp; % Corriemiento en tiempo
lambda=c0/fp; % Longitud de onda en fp

%% Parametros FDTD
Nl=50; %Puntos por longitud de onda
deltax=lambda/Nl; %Incremento en el espacio en X
deltay=deltax; %Incremento en el espacio en Y
h=deltax;      %sqrt(deltax^2 + deltay^2);
deltat=(h*Sc)/(c0); %Incremento en el tiempo
%Vectores espacio temporales
t=(1:Q)*deltat;
x=(1:M)*deltax;
y=(1:N)*deltay;
[X,Y]=meshgrid(x,y);

 %% Inicializamos los vectores
 Hx=zeros(N,M); % Campo magnético en X
 Hy=zeros(N,M); % Campo magnético en Y
 Ez=zeros(N,M); % Campo eléctrico en Z
 sensorE=zeros(1,Q); % Sensor

%% Frontera vacío material y sensores
%Nodo espacial de posición del sensor
mSensor=round(3*M/8);

%% Inicializamos la gráfica para mostrar resultados
figure(1)
VentanaSimulacion=mesh(X,Y,Ez,LineWidth=3); 
zlim([-2,2])
xlabel('Eje X [m]', 'FontSize',13)
ylabel('Eje Y [m]', 'FontSize',13)
zlabel({'Amplitud del' ,'campo eléctrico'}, 'FontSize',13)
grid on
colorbar 

%% Modelación de la propagación en el vacío con FDTD    
%Frontera del vacío material
for q=1:Q
    %Actualización del campo magnético en X
    Hx(1:N-1,:)=Hx(1:N-1,:) - ...
        (deltat/(mu0*deltay))*(Ez(2:N,:) - Ez(1:N-1,:));
    %Actualización del campo magnético en Y
    Hy(:,1:M-1)=Hy(:,1:M-1) + ...
        (deltat/(mu0*deltax))*(Ez(:,2:M) - Ez(:,1:M-1));   

    %Actualizamos el campo eléctrico
    Ez(2:N,2:M)= Ez(2:N,2:M) + ...
        (deltat/(eps0*deltax))*(Hy(2:N,2:M) - Hy(2:N,1:M-1)) - ...
        (deltat/(eps0*deltay))*(Hx(2:N,2:M) - Hx(1:N-1,2:M));

    %Introducimos la perturbación
    Ez(round(M/2),round(M/2))=OndaDeRicker(t(q),fp,t0);

    %Mostramos la evolución temporal
    set(VentanaSimulacion, 'ZData',Ez);
    pause(0.01)

end

