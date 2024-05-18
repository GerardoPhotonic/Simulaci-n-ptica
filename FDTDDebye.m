%% Modelación de un material dispersivo con una aproximación de 
% 1er orden (Modelo de Debye)

%% Programa principal
%% Definimos los parámetros computacionales
%Número de Courant
Sc=1;
%Número de nodos espaciales
M=600;
%Numero de pasos temporales
Q=600;
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
%% Parámetros del modelo de Debye
tau=1e-12;
epsinf=eps0;
epsS=2.25*eps0;

%% Parámetros de la excitación
%Onda de Ricker
fp=2.5e12; %1/tau; %Frecuencia del pulso en Hz
t0=1/fp; % Corriemiento en tiempo
lambda=c0/fp; % Longitud de onda en fp
%% Parametros FDTD
Nl=50; %Puntos por longitud de onda
deltax=lambda/Nl; %Incremento en el espacio
deltat=(deltax*Sc)/(c0); %Incremento en el tiempo
%Vectores espacio temporales
t=(1:Q)*deltat;
x=(1:M)*deltax;
 %% Inicializamos los vectores
 Hy_qMasUnMedio=zeros(1,M); %futuro
 Hy_qMenosUnMedio=zeros(1,M); %pasada
 Dz_qMasUno=zeros(1,M); %futuro
 Dz_q=zeros(1,M); %presente
 Ez_qMasUno=zeros(1,M); %futuro
 Ez_q=zeros(1,M); %presente
 sensorE=zeros(1,Q); %sensor
 Ein=zeros(1,Q); %Campo incidente
 %Er=zeros(1,Q); %Campo reflejado
%% Frontera vacío material y sensores
%Nodo espacial de la frontera vacío-material
mFrontera=round(M/2);
%Nodo espacial de posición del sensor
mSensor=round(3*M/8);
% Forma vectorial de epsS
epsS_vec=ones(2,M)*eps0;
epsS_vec(2,mFrontera:end)=2.25*eps0;
%% Inicializamos la gráfica para mostrar resultados
figure(1)
subplot(2,1,1)
VentanaSimulacion=plot(x,Ez_qMasUno,LineWidth=3);
hold on
plot([mFrontera*deltax,mFrontera*deltax],[-2,2],'--k',LineWidth=2)
plot(mSensor*deltax,0,'dr')
hold off
text(mFrontera*deltax,1,...
    '\leftarrow Frontera vacío-material',FontWeight='bold',FontSize=12)
ylim([-2,2])
xlim([0,x(end)])
xlabel('Eje X [m]', 'FontSize',13)
ylabel({'Amplitud del' ,'campo eléctrico'}, 'FontSize',13)
grid on

% Gráfica de los sensores en el tiempo
subplot(2,1,2)
sensorOscil=plot(t,sensorE,'b');
xlabel('Tiempo [s]')
ylim([-1.5,1.5])
ylabel({'Amplitud del', 'campo eléctrico [UA]'})
grid on
%% Modelación de material dispersivo con FDTD
%Frontera del vacío material
for rr=1:2
     Hy_qMasUnMedio(:)=0; %futuro
     Hy_qMenosUnMedio(:)=0; %pasada
     Dz_qMasUno(:)=0; %futuro
     Dz_q(:)=0; %presente
     Ez_qMasUno(:)=0; %futuro
     Ez_q(:)=0; %presente
     sensorE(:)=0; %sensor
    for q=1:Q
        %Actualización del campo magnético
        Hy_qMasUnMedio(1:M-1)=Hy_qMenosUnMedio(1:M-1) + ...
            (deltat/(mu*deltax))*(Ez_q(2:M) - Ez_q(1:M-1));
        %Actualizamos el vector de desplazamiento
        Dz_qMasUno(2:M)=Dz_q(2:M) + ...
            (deltat/(deltax)).*(Hy_qMasUnMedio(2:M)-Hy_qMasUnMedio(1:M-1));
        %Actualizamos el campo eléctrico
        A=(2*epsinf*tau - epsS_vec(rr,:)*deltat)./...
            (2*epsinf*tau + epsS_vec(rr,:)*deltat);
        B=(deltat + 2*tau)./(2*epsinf*tau + epsS_vec(rr,:)*deltat);
        C=(deltat - 2*tau)./(2*epsinf*tau + epsS_vec(rr,:)*deltat);
        Ez_qMasUno=  A.*Ez_q + B.*Dz_qMasUno + C.*Dz_q;

        %Introducimos la perturbación
        Ez_qMasUno(1)=OndaDeRicker(t(q),fp,t0);

        %Medimos con nuestro sensor virtual
        sensorE(q) = Ez_qMasUno(mSensor);

        %Mostramos la evolución temporal
        set(VentanaSimulacion, 'YData',Ez_qMasUno);
        set(sensorOscil(1), 'YData', sensorE);

        %Nos preparamos para la siguiente iteración
        Ez_q=Ez_qMasUno;
        Dz_q=Dz_qMasUno;
        Hy_qMenosUnMedio=Hy_qMasUnMedio;

        %Esperamos para tener una animación padriuris
        pause(0.01)
    end
    if rr==1
        %Determinamos el campo
        Ein=sensorE;
    end
%     disp('Vamos por las chelas')
%     pause(2)
end
%Determinamos el campo reflejado
Er=sensorE-Ein;
%% Determinación del coeficiente de reflexión
[eIN,nu]=FFT_Completa(Ein,t);
[eR,~]=FFT_Completa(Er,t);
%Coeficiente de reflexión
r=eR./eIN;
%Coeficiente de reflexión usando coef. de fresnel
rD=r_Debye(tau,epsS,epsinf,2*pi*nu);
%Mostramos las medidas de los campos
figure(2)
subplot(1,3,1) 
plot(t,Ein,'r',t,Er,'b');
xlabel('Tiempo [s]')
ylabel({'Amplitud del', 'campo eléctrico [UA]'})
grid on

subplot(1,3,2)
plot(nu,abs(eIN),'dr',nu,abs(eR),'db')
xlabel('Fecuencia [Hz]')
ylabel({'Amplitud del', 'espectro [UA]'})
xlim([0,5e12])
grid on

subplot(1,3,3)
plot(nu,abs(r),'dr',nu, abs(rD),'k')
xlabel('Frecuencia [Hz]')
ylabel({'Amplitud del', 'espectro [UA]'})
xlim([0,5e12])
ylim([0,0.3])
grid on
