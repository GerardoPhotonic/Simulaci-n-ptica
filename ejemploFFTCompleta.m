%% Un ejemplo rápido de la aplicación de la FFT_Completa 

%Creamos el intervalo de medición
x=linspace(0,1,600);
armonica=cos(2*pi*15*x);
gaussiana=exp(-(x-0.5).^2/0.1^2);

%Creamos el producto

ga=armonica.*gaussiana;
[G,nu]=FFT_Completa(gaussiana,x);
[A,~]=FFT_Completa(armonica,x);
[GA,~]=FFT_Completa(ga,x);

%%Mostramos los resultados
subplot(2,2,1)
plot(x,armonica,'b','linewidth',3)
hold on
plot(x,gaussiana,'r','linewidth',3)
hold off
legend('Armonica','Gaussiana')
xlabel('Eje X')
ylabel('Amplitud de la señal')

subplot(2,2,2)
 plot(x,gaussiana.*armonica,'m','LineWidth',3)
legend('Producto')
xlabel('Eje X')
ylabel('Amplitud de la señal')

subplot(2,2,3)
plot(nu,abs(G),'r',nu,abs(A),'b','linewidth',3)
legend('Gaussiana','Armonica')
xlabel('Eje X')
ylabel('Amplitud del espectro')

subplot(2,2,4)
plot(nu,abs(GA),'d-m','LineWidth',3)
xlabel('Eje X')
legend('Producto Gaussiana*Armonica')
ylabel('Amplitud del espectro')