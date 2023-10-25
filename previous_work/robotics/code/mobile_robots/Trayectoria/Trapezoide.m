% Este programa realiza la descomposición en celdas por el método
% trapezoidal
clc
clear
close all
% para graficar
figure
axis([-1 13 -1 13])
grid on
hold on
% los obstáculos se encuentran definidos por los puntos
B1=[1 5;4 5;2 7];
B2=[8 3;10 7;7 6];
Bi=[B1;B2];
% los segmentos de recta de los obstáculos son [x1 y1 x2 y2]
Sr_B1=[1 5 4 5;1 5 2 7;4 5 2 7];
Sr_B2=[8 3 10 7;8 3 7 6;10 7 7 6];
Sr_Bi=[Sr_B1;Sr_B2];
for k=1:length(Sr_Bi) % ploteando los obstáculos
    plot([Sr_Bi(k,1) Sr_Bi(k,3)],[Sr_Bi(k,2) Sr_Bi(k,4)],'b')
end
% los puntos inicial y final son
Pi=[0.5 2];
Pf=[11 9];
scatter([Pi(1) Pf(1)],[Pi(2) Pf(2)],'k','filled') %Ploteando los puntos ini y fin
text(Pi(1),Pi(2)-0.5,'P_i')
text(Pf(1),Pf(2)-0.5,'P_f')
% los segmentos de recta que delimitan arriba y abajo el espacio de trabajo
% son [x1 y1 x2 y2]
Et_sup=[0 12 12 12];
Et_inf=[0 0 12 0];
plot([0 12 12 0 0],[0 0 12 12 0],'b','LineWidth',3) % plot workspace
%% El primer paso es encontrar todos los segmentos de recta que dividen el 
% Q_free
% Esto se logra por medio de encontrar el punto de intersección de los
% puntos pertenecientes a B1 y B2 con los límites del espacio de trabajo
% Debido a que la pendiente de una recta vertical siempre es indeterminada
% la sección de recta será dada por la coordenada en x del punto y la
% coordenada en y de la recta del ET
for i=1:length(Bi)
    Rec_Cel_Sup(i,:)=[Bi(i,1) Bi(i,2)+0.1 Bi(i,1) Et_sup(1,2)]; 
    Rec_Cel_Inf(i,:)=[Bi(i,1) Bi(i,2)-0.1 Bi(i,1) Et_inf(1,2)];
end
% Note que a la coordenada en y superior se le suma 0.1 y a la inferior se
% le resta 0.1 esto es con la finalidad de que durante el proceso de
% detección de colisión no se tome en cuenta el mismo punto
Rec_Cel=[Rec_Cel_Sup;Rec_Cel_Inf];
% Para cada segmento de recta se deberá comprara con los obstáculos para
% garantizar que no existen colisiones. Se usa la función DetCol modificada
for i=1:length(Rec_Cel)
   for j=1:length(Sr_Bi) 
        MatCol(i,j)=DetCol(Rec_Cel(i,:),Sr_Bi(j,:));
   end
end
% Vector con los índices de las líneas que chocan
VectCol=find(sum(MatCol'));
% Se remueven los valores del arreglo Rec_Cel
Rec_Cel(VectCol,:)=[];
% Plotear las líneas
for k=1:length(Rec_Cel)
    plot([Rec_Cel(k,1) Rec_Cel(k,3)],[Rec_Cel(k,2) Rec_Cel(k,4)],'r')
end
%% Los puntos que conforman los posibles caminos para el trayecto son los
% puntos medios de las rectas de Rec_cel
for i=1:length(Rec_Cel)
    TrapPoints(i,:)=[Rec_Cel(i,1) abs(Rec_Cel(i,2)-Rec_Cel(i,4))/2+...
    min(Rec_Cel(i,2),Rec_Cel(i,4))];
end
% graficando
scatter(TrapPoints(:,1),TrapPoints(:,2),'r','filled')
%% Ahora se debe realizar un grafo de conectividad para los puntos
% Se crea la matriz de adyacencia que define 0 cuando hay colisión
A=zeros(length(TrapPoints));
for i=1:length(TrapPoints)
   for j=1:length(TrapPoints)
      for k=1:length(Sr_Bi)
          % se comparan las rectas de los puntos trapezoidales con los
          % obstáculos
          Col(k)=DetCol([TrapPoints(i,:) TrapPoints(j,:)],[Sr_Bi(k,:)]);
      end
      if sum(Col)==0 % si la suma de todas las comparaciones es cero
            A(i,j)=1;
          % A(i,j)=sqrt((TrapPoints(i,1)-TrapPoints(j,1))^2+...
          (TrapPoints(i,2)-TrapPoints(j,2))^2; 
             % no existe colisión y se pone la 
             % distancia entre los puntos       
      end
   end    
end
% Plot
for i=1:length(TrapPoints)
   for j=1:length(TrapPoints)
      if A(i,j)~=0
        plot([TrapPoints(i,1) TrapPoints(j,1)],[TrapPoints(i,2) TrapPoints(j,2)],'k')
      end
   end    
end
%% Encontrar los puntos más cercanos a Pi y Pf
for i=1:length(TrapPoints)
   dist_Pi(i)=sqrt((TrapPoints(i,1)-Pi(1))^2+(TrapPoints(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((TrapPoints(i,1)-Pf(1))^2+(TrapPoints(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);
% con los índices de los números más cercanos podemos iniciar la búsqueda
%% Se usa una un algoritmo de búsqueda para encontrar la solución
tau=RandomSearch(A,TrapPoints,IndexPi,IndexPf); % búsqueda aleatoria
Tray_fin=[Pi;TrapPoints(tau,:);Pf]
% plot
for i=1:length(Tray_fin)-1
    plot([Tray_fin(i,1) Tray_fin(i+1,1)],[Tray_fin(i,2) Tray_fin(i+1,2)],'g','LineWidth',3)
end