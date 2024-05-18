%% Modelación de un material dispersivo con una aproximación de 
% 2do orden (Modelo de Lorentz)

%% Programa principal
%% Definimos los parámetros computacionales
Sc=1;  %Número de Courant
M=600; %Número de nodos espaciales
Q=600; %Numero de pasos temporales
%% Constantes físicas 
eps0= 8.85e-12;      %Permitividad del vacío
mu0= 4*pi*1e-7;      %Permeabilidad del vacío
eta0=sqrt(mu0/eps0); %Impedancia en el vacío
c0=1/sqrt(mu0*eps0); %Velocidad de la luz en el vacío
muR=1;               %Permeabilidad relativa
mu=muR*mu0;          %Permitividad del medio
%% Parámetros del modelo de Lorentz
epsinf=eps0;
epsS=2.25*eps0;      
w0=4e16;             % Frecuencia rensonante
delta=0.28e16;       % Coef. de amortiguamiento
%% Parámetros de la excitación
%Onda de Ricker
fp=(w0)/(2*pi);     %Frecuencia del pulso en Hz
t0=1/fp;      % Corriemiento en tiempo
lambda=c0/fp; % Longitud de onda en fp
%% Parametros FDTD
Nl=50;                  %Puntos por longitud de onda
deltax=lambda/Nl;        %Incremento espacial
deltat=(deltax*Sc)/(c0); %Incremento temporal
t=(1:Q)*deltat;          %Vector de tiempo
x=(1:M)*deltax;          %Vector de espacio
%% Inicializamos los vectores
Hy_qMasUnMedio=zeros(1,M);   %Futuro
Hy_qMenosUnMedio=zeros(1,M); %Pasado
Dz_qMasUno=zeros(1,M);       %Futuro
Dz_q=zeros(1,M);             %Presente
Dz_qMenosUno=zeros(1,M);     %Pasado
Ez_qMasUno=zeros(1,M);       %Futuro
Ez_q=zeros(1,M);             %Presente
Ez_qMenosUno=zeros(1,M);     %Pasado
sensorE=zeros(1,Q);          %Sensor 
Ein=zeros(1,Q);
%% Frontera vacío material y sensores
mFrontera=round(M/2);                %Nodo espacial de la frontera 
mSensor=round(3*M/8);                %Nodo espacial de posición del sensor
epsS_vec=ones(2,M)*eps0;             %Forma vectorial de epsS sin material
epsS_vec(2,mFrontera:end)=2.25*eps0; %Forma vectorial de epsS con material
%% Inicializamos la gráfica para mostrar resultados
%Forma de los campos y simulación del material
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
%Gráfica de los sensores en el tiempo
subplot(2,1,2)
sensorOscil=plot(t,sensorE,'b');
xlabel('Tiempo [s]')
ylim([-1.5,1.5])
ylabel({'Amplitud del', 'campo eléctrico [UA]'})
grid on
%% Modelación de material dispersivo con FDTD
%Frontera del vacío material
for rr=1:2
    Hy_qMasUnMedio(:)=0;   %Futuro
    Hy_qMenosUnMedio(:)=0; %Pasado
    Dz_qMasUno(:)=0;       %Futuro
    Dz_q(:)=0;             %Presente
    Dz_qMenosUno(:)=0;     %Pasado
    Ez_qMasUno(:)=0;       %Futuro
    Ez_qMenosUno(:)=0;     %Pasado
    Ez_q(:)=0;             %Presente
    sensorE(:)=0;          %Sensor
    for q=1:Q
        %Actualización del campo magnético
        Hy_qMasUnMedio(1:M-1)=Hy_qMenosUnMedio(1:M-1) + ...
            (deltat/(mu*deltax))*(Ez_q(2:M) - Ez_q(1:M-1));
        %Actualizamos el vector de desplazamiento
        Dz_qMasUno(2:M)=Dz_q(2:M) + ...
            (deltat/(deltax)).*(Hy_qMasUnMedio(2:M)-Hy_qMasUnMedio(1:M-1));
        %Actualizamos el campo eléctrico
        A=w0^2*deltat^2 + 2*delta*deltat + 2;
        B=w0^2*deltat^2 - 2*delta*deltat + 2;
        C=w0^2*deltat^2.*epsS_vec(rr,:) -2*delta*deltat*epsinf + 2*epsinf;
        D=w0^2*deltat^2.*epsS_vec(rr,:) +2*delta*deltat*epsinf + 2*epsinf;
        Ez_qMasUno=(A.*Dz_qMasUno - 4*Dz_q + B.*Dz_qMenosUno...
            +4*epsinf.*Ez_q - C.*Ez_qMenosUno)./D  ;
        %Introducimos la perturbación
        Ez_qMasUno(1)=OndaDeRicker(t(q),fp,t0);
        %Medimos con nuestro sensor virtual
        sensorE(q) = Ez_qMasUno(mSensor);
        %Mostramos la evolución temporal
        set(VentanaSimulacion, 'YData',Ez_qMasUno);
        set(sensorOscil(1), 'YData', sensorE);
        %Nos preparamos para la siguiente iteración
        Ez_qMenosUno=Ez_q;
        Ez_q=Ez_qMasUno;
        Dz_qMenosUno=Dz_q;
        Dz_q=Dz_qMasUno;
        Hy_qMenosUnMedio=Hy_qMasUnMedio;
        %Esperamos para tener una animación padriuris
        pause(0.01)
    end
    if rr==1
        %Determinamos el campo
        Ein=sensorE;
    end
end
%Determinamos el campo reflejado
Er=sensorE-Ein;
%% Determinación del coeficiente de reflexión
[eIN,nu]=FFT_Completa(Ein,t);
[eR,~]=FFT_Completa(Er,t);
%Coeficiente de reflexión
r=eR./eIN;
%Coeficiente de reflexión usando coef. de fresnel
epsL=r_Lorentz(delta,epsS,epsinf,w0,2*pi*nu);
%% Mostramos las medidas de los campos
figure(2)
subplot(1,3,1) 
plot(t*1e15,Ein,'r',t*1e15,Er,'b');
xlabel('Tiempo [s]*10^{15}')
ylabel({'Amplitud del', 'campo eléctrico [UA]'})
grid on
legend('Campo incidente','Campo reflejado')

subplot(1,3,2)
plot(nu*1e-16,abs(eIN),'dr',nu*1e-16,abs(eR),'db')
xlabel('Fecuencia [Hz]*10^{16}')
ylabel({'Amplitud del', 'espectro [UA]'})
xlim([0,2])
grid on
legend('Espectro incidente','Espectro reflejado')

subplot(1,3,3)
plot(nu*2*pi*1e-16,abs(r),'dk',nu*2*pi*1e-16, abs(epsL),'k')
xlabel('Frecuencia angular [rad/seg]*10^{16}')
ylabel({'Magnitud del ', 'coeficiente de reflexión [UA]'})
xlim([0,10])
ylim([0,0.8])
legend('FD-TD','Exacto')
grid on
