clear; close all; clc;
%C�DIGO ENTREGABLE FINAL RETO F1013B
% Alfonso Villarreal Galindo, A00828725
% Fernando Cu�llar Mart�nez, A00827540
% Armando Monta�o Gonz�lez, A00827377
% Gilberto Ramos Salinas, A01734128
% Sergio L�pez Urzaiz, A00827462
 
%---------------------------------------------------------------%
%RECOLECCI�N DE INPUTS PARA EL PORGRAMA 
c = input(" Ingrese la magnitud de la carga \n");
Lmas = input("Ingresa la longitud de la barra positiva \n") ;
Lmenos = input("Ingresa la longitud de la barra negativa \n");
d = input("Ingresa la distancia entre la barra positiva y la negativa (UTILICE 5 O M�S PARA CORRECTA VISUALIZACI�N) \n");
puntos = input("Ingresa el numero de puntos a evaluar (100 ideal) \n");
pos = d/2;

%CONVERSI�N DE CARGAS
Qpos = c;
Qneg = -c;

%DECLARACI�N DE LOS VALORES DE LAS LAMBDAS
lambdapos = Qpos/Lmas;
lambdaneg = Qneg/Lmenos;

%DECLASRACI�N DE CONSTANTES EN LOS CALCULOS
eps = 8.854e-12;
k = 1/(4*pi*eps);

%RADDIO DE CARGA PARA LA REACION DE RECTANGULOS  
radio = 0.1*d;
%DEFINICION DE MAXIMOS Y MINIMOS PARA LAS DIMENSIONES DE LA GR�FICA 
if (d>= Lmas/2 && d>=Lmenos/2)
    may = d + 3*radio;
elseif (Lmas/2 > d && Lmas>=Lmenos)
    may = Lmas/2 + 3*radio;
elseif (Lmenos/2 > d && Lmenos>=Lmas)
     may = Lmenos/2 + 3*radio;
end
minX = -may;
maxX = may;
minY = -may;
maxY = may;

%CREANDO LOS LINSPACE DE X Y Y 
X = linspace(minX,maxX, puntos);
Y = linspace(minY,maxY, puntos);

%CREACI�N DE QUIVER PARA EL CAMPO ELECTRICO
[Xpuntos,Ypuntos] = meshgrid(X,Y);

yp = [Lmas/2, -Lmas/2];
yn = [Lmenos/2 -Lmenos/2];

%CALCULO DE LAS INTEGRALES
EposX = (lambdapos.*(yp(1) - Ypuntos).*k) ./ ( Xpuntos.*(sqrt( Xpuntos.^2 + (Ypuntos - yp(1)).^2 )))... 
-(lambdapos.*(yp(2) - Ypuntos).*k) ./ ( Xpuntos.*(sqrt( Xpuntos.^2 + (Ypuntos - yp(2)).^2 ))) ;

EposY = (lambdapos.*k) ./ (sqrt( Xpuntos.^2 + (Ypuntos - yp(1)).^2 ))... 
-(lambdapos.*k) ./ (sqrt( Xpuntos.^2 + (Ypuntos - yp(2)).^2 ));

EnegX = (-lambdaneg.*(yn(1) - Ypuntos).*k) ./ ((d-Xpuntos).*(sqrt((Xpuntos - d).^2 + (Ypuntos - yn(1)).^2 )))... 
-(-lambdaneg.*(yn(2) - Ypuntos).*k) ./ ((d-Xpuntos).*(sqrt((Xpuntos - d).^2 + (Ypuntos - yn(2)).^2 )));

EnegY = (lambdaneg.*k) ./ (sqrt((Xpuntos -d).^2 + (Ypuntos - yn(1)).^2 ))... 
-(lambdaneg.*k) ./ (sqrt((Xpuntos -d).^2 + (Ypuntos - yn(2)).^2 ));

%SUMA DE COMPONENTES DEL CAMPO ELECTRICO
Ex = EnegX + EposX;
Ey = EnegY + EposY;

%CALCULO PARA EL CAMPO ELECTRICO TOTAL
Et = sqrt(Ex .^2 + Ey .^2);

%REALIZACI�N DEL QUIVER AJUSTADO
quiver(Xpuntos,Ypuntos,Ex./Et,Ey./Et ,'black');

%REALIZACI�N DEL STREAM PARA MERJOR EST�TICA

h=streamslice(Xpuntos,Ypuntos,Ex./Et,Ey./Et);
set(h,'Color','#ff5a5f');
axis([-radio*3,d+radio*3,minY,maxY]);
hold on

%CREACI�N DE LOS RECTANGULOS PARA LA DEFINICI�N DE LOS ALAMBRES 
rectangle('Position',[-radio/4 -Lmas/2 radio Lmas], 'Curvature',0.2,'FaceColor','r','EdgeColor','r');
rectangle('Position',[d-(radio/4) -Lmenos/2 radio Lmenos], 'Curvature',0.2,'FaceColor','b','EdgeColor','b');


