%% Interferencia de Dos Ondas planas armónicas con longitud de onda
% y un ángulo 2 theta entre ellas

%% Programa principal
%% Variables física default

%Longitud de onda (m)
lambda=420e-9;

%Periodo de las franjas (m)
Lambda=5e-3;

%Determinamos el periodo adecuado (rad)
theta=asin(lambda/(2*Lambda));

%% Inicializamos los parametros de simulación
colormap bone
x=linspace(-7.5e-3, 7.5e-3,200);
z=x;
%Rejilla
[X,Z]=meshgrid(x,z); Y= 10e-2;

% Determinación de los campos, intensidad y patrón

patronIntensidad;

%Comenzamos la variable de opción
opcion=0;
while opcion~=3 
  %Limpiamos la pantalla
  clc
  %Colocamos la información actual
  disp(['Longitud de onda default: ', num2str(lambda/1e-9)] );
  disp(['Ángulo theta default: ', num2str(theta*180/pi)] );
  disp(' ');
  disp('1) Longitud de onda');
  disp('2) Ángulo de interferencia (theta)');
  disp('3) Finalizar');
  %Leer la opción (Valor numérico)
  opcion=input('Opción: ');

  %% Agregamos el valor de las opciones
  if opcion==1 %Longitud de onda
      %Limpiamos pantalla
      clc
      %Ingresa longitud de onda
      lambda=...
          input('Ingresa la longitud de onda (nm): ')*1e-9;
  elseif opcion==2 %ángulo de interferencia

      %Limpiamos pantalla
      clc
      %Ingresa longitud de onda
      theta=...
          input('Ingresa el ángulo de interferencia (grad): ')*pi/180;
  end
  %Actualizo el patrón de intensidad
  patronIntensidad;
end

%Finalizamos el programa
disp('Terminamos, Buen día!')
%%Liberamos memoria y limpiamos ventanas
pause(1)
clc