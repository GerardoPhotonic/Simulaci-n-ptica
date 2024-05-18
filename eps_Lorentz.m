%% Este programa almacena y grafica la permitividad relativa
% del modelo de dispersión de Lorentz (Segundo orden)

%% Programa principal
%% Constantes físicas
eps0=8.85e-12;
epsInf=eps0;
epsS=2.25*eps0;
w0=4e16;
delta=0.28e16;

%% Parámetros computacionales
numDatos=300;
f=linspace(0,20e16,numDatos);
w=linspace(0,20e16,numDatos);
epsL=graf_Lorentz(delta,epsS,epsInf,w0,w);

%% Mostramos resultados
hold on
plot(w*1e-16,real(epsL)*1e11,'k',LineWidth=2)
plot(w*1e-16,imag(epsL)*1e11,'--k',LineWidth=2)
hold off
grid on
xlabel('Frecuencia angular [rad/seg]*10^{16}')
ylabel({'Permitividad', 'relativa'})
xlim([0,20])
% ylim([-10e-11,10e-11])


%% Función que calcula la dispersión de Lorentz (Segundo orden)
function epsL=graf_Lorentz(delta,eps_s,eps_inf,w0,w)
epsL=eps_inf + ( ( w0^2 * (eps_s - eps_inf) ) ./...
     (-w.^2 + 2*1j*delta.*w + w0^2) );
  end