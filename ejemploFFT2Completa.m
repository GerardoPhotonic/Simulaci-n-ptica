%% Este programa es un ejemplo de como funciona la FFT2 completa

%%Definimos la zona 
x=linspace(0,1,100);
y=linspace(0,1,100);
[X,Y]=meshgrid(x,y);
funcion=cos(2*pi*3*X)+sin(2*pi*15*Y);

[F,nux,nuy]=FFT2_Completa(funcion,x,y);

%% Mostramos los resultados
figure
colormap gray

subplot(2,2,1)
imagesc(x,y,funcion)
colorbar
xlabel('Eje X')
ylabel('Eje Y')

subplot(2,2,2)
mesh(x,y,funcion)
colorbar
xlabel('Eje X')
ylabel('Eje Y')
zlabel('Eje Z')

subplot(2,2,3)
imagesc(nux,nuy,abs(F))
colorbar
xlabel('Eje X')
ylabel('Eje Y')

subplot(2,2,4)
mesh(nux,nuy,abs(F))
colorbar
xlabel('Eje X')
ylabel('Eje Y')
zlabel('Eje Z')

