%% epsL=r_Lorentz(delta,eps_s,eps_inf,w0,w)
% Función que determina el coeficiente de reflexión en un
% material modelado por la dispersión de Lorentz (de segundo orden),donde:
% delta, w0, eps_inf            Constantes físicas del sistema
% eps_s                         Constante (que puede ser un vector)
% w                             Vector de frecuencia angular (w=2*pi*f)  

%% Función de la permitividad de Lorentz
% 
function epsL =r_Lorentz(delta,eps_s,eps_inf,w0,w)
epsL=(1 - sqrt(1 + w0.^2 *(eps_s-eps_inf) ./ (eps_inf.*(-w.^2 + 2*1i*w.*delta + w0.^2)))) ./ ...
        (1 + sqrt(1 + w0.^2 *(eps_s-eps_inf) ./ (eps_inf*(-w.^2 + 2*1i*w.*delta + w0.^2))));
 end
