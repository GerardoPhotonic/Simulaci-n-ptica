%% Este programa nos permite ver las simulaciones de una onda en 1D mediante las 
% ecuaciones de Maxwell usando FDTD

%% Programa principal (con el paso mágico)
%Definimos los parámetros computacionales
%Número de Courant
Sc=1;
%Número de nodos espaciales
M=300;
%Numero de pasos temporales
Q=900;

%% Definimos los Parametros físicos
%Permitividad del vacío
eps0= 8.85e-12;
%Permeabilidad del vacío
mu0= 4*pi*1e-7;
%Impedancia en el vacío
eta0=sqrt(mu0/eps0);
%Permeabilidad relativa
muR=1; %Pues estamos en el vacío
%Permitividad relativa
epsR=1;

%% Posición de fotodetectores virtuales
%Posición del detector virtual
posicionD=150;
%Inicialización del campo detectado
Ez_tiempo=zeros(1,Q);


%% Parámetros de la excitación
%Ancho de la gaussiana
b=20;
%Desplazamiento de la gaussiana
a=2.5*b;
%Amplitud de la gaussiana
E0=1;
%% Inicialización de los vectores de los campos
%Vectores de los campos magneticos
Hy_qMasUnMedio=zeros(1,M);
Hy_qMenosUnMedio=zeros(1,M);
%Vectores de los campos eléctricos
Ez_qMasUno=zeros(1,M);
Ez_q=zeros(1,M);

%% Metodo de diferencias finitas
for q=1:Q
    %Actualizar el campo magnético
    for m=1:M-1
        Hy_qMasUnMedio(m)=Hy_qMenosUnMedio(m) + ...
            Sc/(muR*eta0)*(Ez_q(m+1) - Ez_q(m));
    end
    %Actualizar el campo eléctrico
    for m=2:M
        Ez_qMasUno(m)=Ez_q(m) + ...
            (eta0*Sc/epsR)*(Hy_qMasUnMedio(m)-Hy_qMasUnMedio(m-1));
    end
    
    %Medimos el campo eléctrico
    Ez_tiempo(q)=Ez_qMasUno(posicionD);

    %Introducimos una perturbación en la simulación
    Ez_qMasUno(1)=E0*exp(-( (q-a)/b )^2);

    %Visualizamos la evolución temporal de los campos
    subplot(3,1,1)
    plot(Ez_qMasUno,'r', LineWidth=3), hold on
    plot(posicionD,Ez_qMasUno(posicionD) ...
        , 'diamond', 'MarkerSize',12), hold off;
    xlabel('Nodos espaciales')
    ylabel('Amplitudes del campo eléctrico')
    ylim([-2,2])

    subplot(3,1,2)
    plot(Hy_qMasUnMedio, 'b', LineWidth=3)
    xlabel('Nodos espaciales')
    ylabel('Amplitudes del campo eléctrico')
    ylim([-6,6]*1e-3)
    
    subplot(3,2,5)
    plot(Ez_tiempo(1:q), 'k', LineWidth=3)
    ylabel('Campo Eléctrico')
    xlabel('Pasos temporales')
    title({'Medición en el tiempo','del campo eléctrico'})
    ylim([-2.5,2.5])
    xlim([0,Q])
    
    %Graficamos el vector de Poynting, S=0.5(ExH)
     S=abs(Ez_qMasUno.*Hy_qMasUnMedio*0.5);
     subplot(3,2,6) 
     plot(S,'m',LineWidth=3)
     ylabel('Flujo de energía')
     xlabel('Pasos temporales')
     title({'Medición en el tiempo','del flujo de energía'})
     ylim([-1.5,1.5]*1e-3)
     xlim([0,M])
    %Esperamos para realizar la animación
    pause(0.001)

    %Nos preparamos para el siguiente paso temporal
    Ez_q=Ez_qMasUno;
    Hy_qMenosUnMedio=Hy_qMasUnMedio;
end