clc; clear all; close all; %Despeje de espacio

%%%Definicion de las variables
z0 = 1; v0 = 0; %Valores iniciales de posicion y velocidad
R = 0.025; L = 0.5; m = 0.67; a = 0.01; h = 0.01; M = 0.02; g = 9.81; %Valores constantes
miu0 = (4*pi)*(10^(-7)); ro = 1/(5.081*10^7); %Valores constantes

%%%Formulas empleadas
iPos = 1; iVel = 2; iCont = 1; %Variables utilizadas para implementacion del codigo
k = (9/(8*pi))*(((miu0*m)^2)/(ro*R^4))*a; %Segmento de formula de fuerza magnetica
f = @(z,v) -g - (k/M) * ((5/128) * (atan(z/R) - atan((z-L)/R)) + ... %%%
    (1/64) * (sin(2*atan(z/R)) - sin(2*atan((z-L)/R))) - ...         %%%Segmento de formula
    (1/128) * (sin(4*atan(z/R)) - sin(4*atan((z-L)/R))) - ...        %%%de la aceleracion
    (1/192) * (sin(6*atan(z/R)) - sin(6*atan((z-L)/R))) - ...        %%%
    (1/1024) * (sin(8*atan(z/R)) - sin(8*atan((z-L)/R)))) * v;       %%%

%%%Vectores de almacenamiento
x = [z0,v0]; %Vector x para la manipulacion de posicion y velocidad
vZM = [z0]; vVM = [v0]; vAM = [f(x(iPos),x(iVel))]; vACL = [-g]; vVCL = [v0]; vZCL = [z0];
%%%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%%%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%%%                         Vectores de valores solicitados

%Implementacion del metodo de Runge Kutta
for i = 0+h:h:1 %Intervalo de tiempo considerando que el tiempo 0 ya fue empleado
    k1 = [x(iVel),f(x(iPos),x(iVel))];                                                 %%%Valores k para
    k2 = [x(iVel) + (h/2) * k1(2),f(x(iPos) + (h/2) * k1(1),x(iVel) + (h/2) * k1(2))]; %%%el metodo de
    k3 = [x(iVel) + (h/2) * k2(2),f(x(iPos) + (h/2) * k2(1),x(iVel) + (h/2) * k2(2))]; %%%Runge Kutta
    k4 = [x(iVel) + h * k3(2),f(x(iPos) + h * k3(1),x(iVel) + h * k3(2))];             %%%
    x = x + (h/6) * (k1 + 2*k2 + 2*k3 + k4); %Obtencion del nuevo vector x
    vZM = [vZM,x(1)]; %Se agrega la nueva posicion al vector de posiciones
    vVM = [vVM,x(2)]; %Se agrega la nueva velocidad al vector de velocidades
    vAM = [vAM,f(x(iPos),x(iVel))]; %Se calcula y agrega la nueva aceleracion
    vZCL = [vZCL, vZCL(iCont) + (vVCL(iCont)*h)]; %%%<-Mismo procedimiento
    vVCL = [vVCL, vVCL(iCont)+(-g*h)];            %%%<-considerando caida
    vACL = [vACL,-g];                             %%%<-libre
    iCont = iCont + 1; %Se incrementa el contador para determinar valores de los vectores
end
vFM = vAM.*M; %Se calcula el vector de fuerza considerando magnetismo
vFCL = vACL.*M; %Se calcula el vector de fuerza con caida libre

%%%Graficacion
t = 0:h:1; %Intervalo de tiempo
subplot(2,2,1)                                                               %%%Se grafican todos los
plot(t,vVM,'b'); hold on; grid on; plot(t,vVCL,'r--'); title('Velocidad'); hold off   %%%
subplot(2,2,2);                                                              %%%vectores con su 
plot(t,vZM,'b'); hold on; grid on; plot(t,vZCL,'r--'); title('Posicion'); hold off;   %%%
subplot(2,2,3)                                                               %%%respectiva caida libre
plot(t,vFM,'b'); hold on; grid on; plot(t,vFCL,'r--'); title('Fuerza'); hold off;     %%%
subplot(2,2,4)                                                               %%%en un subplot
plot(t,vAM,'b'); hold on; grid on; plot(t,vACL,'r--'); title('Aceleracion'); hold off %%%