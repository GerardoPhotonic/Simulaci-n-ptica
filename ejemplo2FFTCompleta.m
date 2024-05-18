
%%Otro ejemplo de la transformada de Fourier en 2D
f=imread('perrito.jpg');
%Determinamos la resolución de la imagen
[r,c]=size(f(:,:,1));
x=1:c;
y=1:r;
[X,Y]=meshgrid(x,y);

%Determino de manera sagaz las distancias
lx=x*4.3/25;
ly=y*4.3/25;
%Extraemos un color
fr=double(f(:,:,1));
%Extraemos la transformada de Fourier de la señal
%FR=fftshift(fft2(fr));
%Creamos el filtro

[FR,nux,nuy] = FFT2_Completa(fr,lx,ly);
filtro= double(  ((X-c/2).^2+(Y-r/2).^2)>50^2);

%Filtramos
FRF=FR.*filtro;

%Regresamos al dominio original
frf=ifft2(fftshift(FRF))*(r*c/2);

%%Mostramos resultados
colormap gray
subplot(4,1,1)
imagesc(lx,ly,fr)
xlabel('Eje X (cm)')
ylabel('Eje Y (cm)')
subplot(4,1,2)
imagesc(nux,nuy,abs(log(FRF)))
xlabel('Frecuencias espaciales en X (1/cm)')
ylabel('Frecuencias espaciales en Y (1/cm)')
subplot(4,1,3)
%mesh(abs(log(FR)))
imagesc(nux,nuy,filtro)
xlabel('Frecuencias espaciales en X (1/cm)')
ylabel('Frecuencias espaciales en Y (1/cm)')
subplot(4,1,4)
imagesc(lx,ly,real(frf))
xlabel('Eje X (cm)')
ylabel('Eje Y (cm)')

figure
plot (fr(95,:))
hold on
plot (real(frf(95,:)),'r')
hold off
