% Un script simple para observar el comportamiento de la onda de ricker

%Generamos el vector de tiempo
t=linspace(-2,2,300);
%Establecemos la frecuencia y el desplazamiento
fp=2; t0=0;
%Creamos la onda de Ricker
ondaR=OndaDeRicker(t,fp,t0);
[ONDAr,nu]=FFT_Completa(ondaR, t);
%Mostramos los resultados
subplot(2,1,1)
plot(t,ondaR, LineWidth=3)
xlabel('Tiempo UA')
ylabel('Amplitud UA')
title('Onda de Ricker')
grid on

subplot(2,1,2)
plot(nu,abs(ONDAr), LineWidth=3)
xlim([0,10])
xlabel('Frecuencia UA')
ylabel('Amplitud del espectro UA')
title('Espectro de la onda de Ricker')
grid on