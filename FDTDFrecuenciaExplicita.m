%% SIMULACIÓN "REALISTA" DE UNA ONDA 
% EN EL VACÍO CON FRECUENCIA EXPLÍCITA

%% PROGRAMA PRINCIPAL

%Permitividad del vacío
eps0= 8.85e-12;
%Permeabilidad del vacío
mu0= 4*pi*1e-7;
%Impedancia en el vacío
eta0=sqrt(mu0/eps0);
%Velocidad de la luz en el vacío
c0=1/sqrt(mu0*eps0);
M=1500; % Nuúmero de nodos espaciales
Q=1320; %Número de pasos temporales

%% Parámetros de la excitación
%Onda de Ricker
fp=94.9e6; %Frecuencia del pulso en Hz
t0=1/fp; % Corriemiento en tiempo
lambda=c0/fp; % Longitud de onda en fp
Sc=1; %Número de Courant
Nl=100; %Puntos por longitud de onda
deltax=lambda/Nl; %Incremento en el espacio
deltat=(deltax*Sc)/(c0); %Incremento en el tiempo
%% Parámetros computacionales

% Creamos el ciclo for para la evaluación del campo (Programa MUY MALO)
ls=[deltax*M,20]; %Material: NO, SI
campos=zeros(2,Q);
for h=1:2


%% Variables físicas
%Punto de frontera vacío-material
xb=round(ls(h)/deltax);
%Permeabilidad relativa
muR=1; %Pues estamos en el vacío
%Permitividad relativa
epsR=ones(1,M); %Vacío
epsR(xb:end)=1.585^2; %Policarbonato
%Permitividad del material
epsilon=epsR*eps0;
%Permeabiilidad del material
mu=muR*mu0;

%% Inicialización de los campos eléctricos y magnéticos
Ez=zeros(1,M);
Hy=zeros(1,M);
t=(1:Q)*deltat; %Tiempo de la simulación
x=(1:M)*deltax; %Espacio de la simulación

%% Parámetros de los sensores
sE1=zeros(1,Q); %Sensor 1 del campo eléctrico
sE2=zeros(1,Q); %Sensor 2 del campo eléctrico
x1=round(10/deltax); %Posición del sensor 1
x2=round(30/deltax); %Posición del sensor 2

%% Inicializamos la gráfica para mostrar resultados
subplot(2,1,1)
VentanaSimulacion=plot(x,Ez,LineWidth=3);
hold on 
plot([xb*deltax,xb*deltax],[-2,2],'--k',LineWidth=2)
plot([x1,x2]*deltax,[0,0],'dr')
hold off
text(xb*deltax,1,'\leftarrow Frontera vacío-material',FontWeight='bold',FontSize=12)
ylim([-2,2])
xlim([0,x(end)])
xlabel('Eje X [m]', 'FontSize',13)
ylabel({'Amplitud del' ,'campo eléctrico'}, 'FontSize',13)
grid on

% Gráfica de los sensores en el tiempo
subplot(2,1,2)
sensorOscil=plot(t,sE1,'r',t,sE2,'b');
%sensorOscil2=plot(t,sE2,'b');
xlabel('Tiempo [s]')
ylim([-1.5,1.5])
ylabel({'Amplitud del', 'campo eléctrico [UA]'})
%% Programa Principal

for q=1:Q
    %Actualización del campo magnético
    Hy(1:M-1)=Hy(1:M-1) + ... 
        (deltat/(mu*deltax))*(Ez(2:M) - Ez(1:M-1));
    %Actualización del campo eléctrico
    Ez(2:M)=Ez(2:M) + ...
        (deltat./(epsilon(2:M)*deltax)).*(Hy(2:M)-Hy(1:M-1));
    %Introducimos la perturbación
    Ez(1)=OndaDeRicker(t(q),fp,t0);

    %Medimos los campos en el tiempo
    sE1(q)=Ez(x1);
    sE2(q)=Ez(x2);
    %Mostramos resultados
    set(VentanaSimulacion, 'YData',Ez);
    set(sensorOscil(1), 'YData', sE1);
    set(sensorOscil(2), 'YData', sE2);
    %Esperamos para el siguiente paso en el tiempo
    pause(0.01)
end
%Guardamos el campo
campos(h,:)=sE1;
end

%% Determinamos los campos INCIDENTE Y REFLEJADO
Ei=campos(1,:);
Er=campos(2,:) - Ei;

%Determinamos la transformada de Fourier
[eI,nu]=FFT_Completa(Ei,t);
[eR,~]=FFT_Completa(Er,t);

%Calculamos el coeficiente de reflexión
r=eR./eI;

%Mostramos los resultados
clf
subplot(3,1,1)
%Campos en el tiempo
plot(t,Ei,'r',t,Er,'b',LineWidth=3)
legend('Campo incidente','Campo reflejado')
grid
xlabel('Tiempo [s]')
ylabel('Amplitud [UA]')

%Espectros de los campos
subplot(3,1,2)
plot(nu,abs(eI),'r',nu,abs(eR),'b',LineWidth=3)
xlim([0,0.25e9])
legend('Espectro Ei', 'Espectro Er')
grid
xlabel('Frecuencias [Hz]')
ylabel('Espectro [UA]')

%Coeficiente de reflexión
subplot(3,1,3)
plot(nu,abs(r),'k',LineWidth=3)
xlim([0,0.25e9])
ylim([0,0.5])
legend('Coeficiente de reflexión')
grid
xlabel('Frecuencias [Hz]')
ylabel('Espectro [UA]')





