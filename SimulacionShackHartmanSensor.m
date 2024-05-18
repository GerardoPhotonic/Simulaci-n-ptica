%% Este programa modela el funcionamiento un sensor de tipo SHW 
% con micro lentes usando óptica de Fourier, replicando los resultados del
% artículo "Analysis on Shack–Hartmann wave-front sensor with Fourier
% optics"

%% Programa principal
%Definimos las variables físicas del sistema
%longitud de onda
lambda=632e-9; 
%Número de onda
k=2*pi/lambda;
%Diametro de la lente
a=300e-6;
%Distancia focal de la ulente
f=25e-3;
%Numero de ulentes por arista
N=8;
%Numero total de ulentes
num_ulentes=N*N;
%Determinamos la pendiente máxima
m_max=(a/2)/f;
%% Definimos las constantes computacionales de la simulación
%Número de pixeles
num_pixeles=2^7*N;
%Determinamos la zona de medición restringida
T=2*(num_pixeles/2 -1)*lambda*f/(N*a); %(a*num_ulentes) 
%Region de simulación física
x=linspace(-T/2,T/2,num_pixeles);
y=x;
[X,Y]=meshgrid(x,y);
tm=zeros(num_pixeles,num_pixeles);
%% Simulación del arreglo de ulentes
for q=-7:2:7
    for r=-7:2:7
    tm=tm + exp(-1i*(k/(2*f)*((X-q*a/2).^2+(Y-r*a/2).^2) )) .*...
        rectpuls(X-q*a/2,a).*rectpuls(Y-r*a/2,a);
    %imagesc(angle(tm))
    end
end
%% Campo eléctrico a analizar
%Visualización del trabajo del SH
for q=0:10
    %Establecemos la inclinación del frente de onda
    mx=(q/10)*m_max/(8*a);
    my=0.5*(q/10)*m_max/(8*a);
    %Creamos la amplitud del campo
    E0=1 + 0*rand(num_pixeles,num_pixeles);
    %Creamos el campo eléctrico incidente a las ulentes
    WF=-(k*mx*X.^2 - k*2*my*Y.^2 + 0*rand(num_pixeles,num_pixeles));
    u0=E0.*exp(1i*WF);
    %% Evaluamos el campo en el plano focal
    [UF,nux,nuy]=FFT2_Completa(...
        u0.*tm.*exp(1i*k*(X.^2 + Y.^2)/(2*f) ), ...
        x,y);
    %Evaluamos la intensidad
    If=abs(UF).^2;
    %% Mostramos resultados
    colormap gray
    %Arreglo de microlentes
    subplot(2,2,1)
    imagesc(x/1e-3,y/1e-3,angle(tm));
    set(gca,'YDir','normal');
    axis equal
    xlim([-a*N/2/1e-3,a*N/2/1e-3])
    ylim([-a*N/2/1e-3,a*N/2/1e-3])
    xlabel('Eje X [mm]')
    ylabel('Eje Y [mm]')
    
    %Frente de onda
    subplot(2,2,2)
    mesh(X/1e-3,Y/1e-3,WF)
    zlim([-50,50])
    xlim([-a*N/2/1e-3,a*N/2/1e-3])
    ylim([-a*N/2/1e-3,a*N/2/1e-3])
    xlabel('Eje X [mm]')
    ylabel('Eje Y [mm]')
    
    %Patrón de intensidad de las ulentes
    subplot(2,1,2)
    imagesc(nux*lambda*f/1e-3,nuy*lambda*f/1e-3,If)
    set(gca,'YDir','normal');
    axis equal
    xlabel('Eje X [mm]')
    ylabel('Eje Y [mm]')
    pause(.1)

end