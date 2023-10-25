% INSTRUCCIONES: Correr todo el codigo y observar generacion de cspace,
% trayectoria, y movimiento 3d del final del actuador.

clear all
close all

%Se define la resolucion del C-space. En este caso tiene el doble de
%puntos.
res=2;
% Ubicación inicial y ubicación de cada casa.
puntos=[2 5*res+2 22.5*res+2 40*res+2 57.5*res+2 75*res+2;2 5*res+2 5*res+2 5*res+2 5*res+2 5*res+2];
% Longitudes de la impresora.
lx=80*res;
ly=10*res;
lz=20*res;
%Longitud en X de el area donde ira ubicada cada casa y obstaculo.
lxcasa=10*res;
lxobs=7.5*res;
%Radio del actuador final.
r=0.5*res;

%% C-Space
%Creación del cspace
% se crea una matriz de ceros con paredes
cspaceXY=zeros(ly+3,lx+3);
cspaceXY(1,:)=1;
cspaceXY(ly+3,:)=1;
cspaceXY(:,1)=1;
cspaceXY(:,lx+3)=1;


%OBSTACULOS:

%Cada obstaculo se ubica en el centro del area designada para este.
%Obstaculo 1
o1x=lxcasa; %Posicion en X del area donde irá el obstaculo.
%Creación del obstaculo.
cspaceXY(:,o1x+2+2.5*res-r:lxobs+2+o1x-2.5*res+r)=1; 
cspaceXY(2*res+2+r:4*res+2-r,o1x+2+2.5*res-r:lxobs+2+o1x-2.5*res+r)=0;

%Obstaculo2
o2x=lxcasa*2+lxobs;
cspaceXY(:,o2x+2+1*res-r:lxobs+2+o2x-1*res+r)=1;
cspaceXY(2:3*res+2-r,o2x+2-r:lxobs+2+o2x+r)=0;

%Obstaculo3
o3x=lxcasa*3+lxobs*2;
cspaceXY(2+2*res-r:8*res+2+2*res,o3x+2+1.25*res-r:o3x+2+1.25*res+1.5*res+r)=1;
cspaceXY(2:8*res+2+r,(o3x+2+1.25*res+3.5*res-r):(o3x+2+1.25*res+3.5*res+1.25*res+r))=1;

%Obstaculo4
o4x=lxcasa*4+lxobs*3;
cspaceXY(2+2*res-r:8*res+2+2*res,o4x+2+1.25*res-r:o4x+2+1.25*res+1.5*res+r)=1;
cspaceXY(2:8*res+2+r,(o4x+2+1.25*res+3.5*res-r):(o4x+2+1.25*res+3.5*res+1.25*res+r))=1;

%Gráficar C-Space
figure 
spy(sparse(cspaceXY),'k')
grid on
title('C-space')
xlabel('x')
ylabel('y')
pause(1)

%% TRAYECTORIA
x=[];
y=[];
z=[];

%CASA 1
%Trayectoria hasta el punto donde se va a construir la casa.
ini=[puntos(1,1),puntos(2,1)]; %Punto inicial
fin=[puntos(1,2),puntos(2,2)]; %Punto final (donde se construira la casa / centro del lote de cada casa)
hold on
cspaceXY(ini(2),ini(1))=2; %El punto en el cual inicia ya no es el punto final y es necesario volverlo 2.
plot(ini(1),ini(2),'or') %Graficar punto inicial
hold on
cspaceXY(fin(2),fin(1))=3; %Se define nuevo objetivo.
plot(fin(1),fin(2),'xb') %Graficar punto final.
[nx,ny,nz]=PrimeroVoraz(ini,fin,cspaceXY); %Algoritmo de busqueda para encontrar trayectoria.
x=[x nx]; %Se agregan los puntos que necesita recorrer para llegar al objetivo.
y=[y ny];
z=[z nz];
%Construcción
[nx,ny,nz]=lemniscata(50,fin,res); %Se define la figura, el tiempo de muestreo y el punto en el cual la realizará.
x=[x nx]; %Se agregan los puntos que necesita para realizar la figura.
y=[y ny];
z=[z nz];

% CASA 2
ini=[puntos(1,2),puntos(2,2)];
fin=[puntos(1,3),puntos(2,3)];
hold on
cspaceXY(ini(2),ini(1))=2;
plot(ini(1),ini(2),'or')
hold on
cspaceXY(fin(2),fin(1))=3;
plot(fin(1),fin(2),'xb')
[nx,ny,nz]=PrimeroVoraz(ini,fin,cspaceXY);
x=[x nx];
y=[y ny];
z=[z nz];

[nx,ny,nz]=cardioide(50,fin,res);
x=[x nx];
y=[y ny];
z=[z nz];

% CASA 3
ini=[puntos(1,3),puntos(2,3)];
fin=[puntos(1,4),puntos(2,4)];
hold on
cspaceXY(ini(2),ini(1))=2;
plot(ini(1),ini(2),'or')
hold on
cspaceXY(fin(2),fin(1))=3;
plot(fin(1),fin(2),'xb')
[nx,ny,nz]=PrimeroVoraz(ini,fin,cspaceXY);
x=[x nx];
y=[y ny];
z=[z nz];

[nx,ny,nz]=cornoide(50,fin,res);
x=[x nx];
y=[y ny];
z=[z nz];

% CASA 4
ini=[puntos(1,4),puntos(2,4)];
fin=[puntos(1,5),puntos(2,5)];
hold on
cspaceXY(ini(2),ini(1))=2;
plot(ini(1),ini(2),'or')
hold on
cspaceXY(fin(2),fin(1))=3;
plot(fin(1),fin(2),'xb')
[nx,ny,nz]=PrimeroVoraz(ini,fin,cspaceXY);
x=[x nx];
y=[y ny];
z=[z nz];

[nx,ny,nz]=gota(50,fin,res);
x=[x nx];
y=[y ny];
z=[z nz];

% CASA 5
ini=[puntos(1,5),puntos(2,5)];
fin=[puntos(1,6),puntos(2,6)];
hold on
cspaceXY(ini(2),ini(1))=2;
plot(ini(1),ini(2),'or')
hold on
cspaceXY(fin(2),fin(1))=3;
plot(fin(1),fin(2),'xb')
[nx,ny,nz]=PrimeroVoraz(ini,fin,cspaceXY);
x=[x nx];
y=[y ny];
z=[z nz];

[nx,ny,nz]=espiral_arqui(50,fin,res);
x=[x nx];
y=[y ny];
z=[z nz];

%% GRAFICAR
for i=1:length(x)
    hold on
    plot(x(i),y(i),'or')
    pause(0.000000001)
end

Graficar trayectoria en 3D
figure
plot3(x,y,z)

%% SIMULACIÓN EN SIMSCAPE
% Se debe ejecutar primero este archivo y luego ejecutar la simulación en
% simulink.
x=(x-2)/res;
y=(y-2)/res;
z=(z)-20; %En simscape se configuro como z=0 cuando el actuador final esta en cero, por lo cual para que se extienda se necesita un z negativo.