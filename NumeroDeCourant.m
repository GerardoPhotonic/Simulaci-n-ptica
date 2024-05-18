%% Este programa nos permite graficar y observar la influencia
% del número de Courant en las simulaciones de FDTD.
% El programa muestra curvas de la velocidad numérico y las partes real e
% imaginaria del número de onda numérico (Posible absorción o
% amplificación).


%% Programa Principal
%Definimos el número de Courant
S=0.5;
%Definimos la resolución de muestreo espacial
Nl=linspace(1,10,300);
%Definimos la variable Z (2.29b) del Taflove
z=(1/S)^2*(cos( (2*pi*S) ./ (Nl) ) -1 ) +1;
%Calculamos el número de onda numérico normalizado (Que puede ser complejo)
kn=Nl.*acos(z);
%Calculamos la velocidad numérica normalizada de la onda
vn=(2*pi) ./ (Nl.*real( acos(z) ) );
%Definimos el error porcentual en la estimación de la velocidad
error_v=abs(1-vn)*(100);
%Definimos el vector para graficar el error
Nerror=linspace(3,80,300);
%% Mostramos resultados

figure (1)
subplot(2,1,1)
plot(Nl,vn,'r',LineWidth=2)
xlabel('Resolución espacial [\lambda / \Deltax ]')
ylabel('Velocidad de la onda ([v/c])')
grid on
subplot(2,1,2)
plot(Nl, -imag(kn), 'b',LineWidth=2)
xlabel('Resolución espacial [\lambda / \Deltax ]')
ylabel('Absorción/Amplificación normalizada')
grid on

figure(2)
semilogy(Nerror,error_v,'k',LineWidth=2)
xlabel('Resolución espacial [\lambda / \Deltax ]')
ylabel('Error % de la velocidad')
xlim([3,80])


