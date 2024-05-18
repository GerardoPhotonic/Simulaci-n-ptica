%Creamos las ondas armónicas planas
%Parametros de las ondas
E01=1;  E02=1;
k=2*pi/lambda;
%Vector de onda [j,k]
k1=[k*cos(theta), -k*sin(theta)];
k2=[k*cos(theta), k*sin(theta)];
%Fase inicial de la onda 1
phi=1*2*pi*((X.^2+Z.^2)/112.5e-6 -0.5);
%Ondas planas
E1=E01*exp(1i*(k1(1)*Y+k1(2)*Z + phi) );
E2=E02*exp(1i*(k2(1)*Y+k2(2)*Z));
%Intensidad total
ITotal= abs(E1+E2).^2;
%Mostramos los resultados
%Tomamos la parte izquierda de la ventana
subplot(1,2,1)
imagesc(x/1e-3,z/1e-3,ITotal)
set(gca, 'YDir', 'normal')
xlabel('Eje x (mm)', 'FontSize',12)
ylabel('Eje z (mm)', 'FontSize',12)
title(['\lambda(nm): ', num2str(lambda/1e-9),...
    '  \theta(miligrad): ', num2str(theta*180/(pi*1e-3))], 'FontSize',12)

%Mostramos la intensidad en vertical en el centro del patrón
subplot(1,2,2)
plot(ITotal( :, 100), z/1e3, 'r', 'LineWidth', 3)
xlabel('Intensidad de la onda(UA)');
ylabel('Eje z (mm)');
title('Distribución de intensidad')

%Método de Itoh