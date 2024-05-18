% Este código es un ejemplo de como funciona el método de 4 pasos para la 
% extracción de fase.
%% DEFINICIONES PRINCIPALES
%Número de ddatos
numDatos=100;
%Itervalo de medición
x=linspace(0,1,numDatos);
%Frecuencia de la portadora
f=7;
%Creamos la señal de fase
portadora=2*pi*f*x;
%Señal de interés
phi=3*pi*x.^2;
%Amplitud del ruido
noiseAmp=3;
%Definimos los términos constantes y de amplitud del ruido
a1=1+ noiseAmp*0.5*(rand(1,numDatos)-0.5); b=1;
a2=1+ noiseAmp*0.5*(rand(1,numDatos)-0.5); 
a3=1+ noiseAmp*0.5*(rand(1,numDatos)-0.5); 
a4=1+ noiseAmp*0.5*(rand(1,numDatos)-0.5); 

%% METODO DE 4 PASOS
I1= a1+ b*cos(portadora + phi);
I2= a2+ b*cos(portadora + phi + pi/2);
I3= a3+ b*cos(portadora + phi + 2*pi/2);
I4= a4+ b*cos(portadora + phi + 3*pi/2);

%Obtención de la fase
psi=-atan2( (I2-I4) , (I1-I3));
%% DESENVOLVEMOS LA FASE
fase_des=unwrap(psi);

%Obtenemos la señal de interés
phi_rec=fase_des-portadora;
%% MOSTRAMOS RESULTADOS
%Gráfica de la señal original
subplot(3,1,1)
plot(x,I1);
xlabel('Variable x')
ylabel('Magnitud de la señal')

%Gráfica de la fase real y recuperada
subplot(3,1,2)
plot(x, fase_des, 'sg')
hold on
plot(x, psi, '*b')
plot(x,portadora+phi, 'r', 'linewidth',3);
hold off
xlabel('Variable x');
ylabel('Fase (Rad)');

%Colocamos las etiquetas a los datos
legend('Fase REAL','Fase RECUPERADA', 'Fase DESENVUELTA', 'Location', 'NorthWest')

%Gráfica de señal de interés
subplot(3,1,3)
plot(x, phi_rec, 'dm', x, phi, 'k', 'linewidth',2)
xlabel('Variable x')
ylabel('Fase (Rad)')
legend('Señal RECUPERADA','Señal REAL','Location', 'NorthWest')


