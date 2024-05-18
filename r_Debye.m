%% r=r_Debye(tau,eps,ep_inf,w) 
% Función que determina el coeficiente de reflexión en un
%material modelado por la dispersión de Debye (de primer orden).
%El programa requiere los siguientes parámetros de entrada
%tau, eps_s, ep_in    Escalares para los parámetros del modelo
% w                   Frecuencia angular (w=2*pi*frecuencia)
%Vamos a tener
%r                    Coeficiente de reflexión
%EL MEDIO 1 ES EL VACÍO Y LA INCIDENCIA ES NORMAL

function r=r_Debye(tau,ep_s,ep_inf,w)
r=( 1 - sqrt(1+(ep_s-ep_inf)./ (ep_inf*(1+1j*w*tau))) ) ./ ...
  ( 1 + sqrt(1+(ep_s-ep_inf)./ (ep_inf*(1+1j*w*tau))) )  ;
end
