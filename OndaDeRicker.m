%% Este programa grafica la onda de Ricker y su respectiva transformada
% Ricker(t,fp,t0) requiere los siguientes patámetros:
% t: Un escalar o vector que representa el tiempo
% t0: Un escalar que representa el corrimiento en el tiempo
% fp: Un escalar que determina la frecuencia de la componente de amplitud
%     MÁXIMA en el espectro de la onda de Ricker
%Los parámetros de salida son:
% ondaR: Un escalar o vector con el perfil de la onda de Ricker

%% PROGRAMA PRINCIPAL
function ondaR=OndaDeRicker(t,fp,t0)
ondaR=(1-2*(pi*fp*(t-t0)).^2).*exp( -(pi*fp*(t-t0)).^2 );
end