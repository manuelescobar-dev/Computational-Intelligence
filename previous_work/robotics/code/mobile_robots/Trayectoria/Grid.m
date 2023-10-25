% Este programa realiza la descomposición en celdas por el método
% de grid
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
%% Se debe generar el grid para el espacio de trabajo
% se establece una resolución
 %res=1;
 %res=0.2;
res=2;
% para un WS de 0 a 12 en x y y recordar que 0 y 12 son también obstáculos
% por lo que en realidad se evaluarán los puntos del 1 al 11 (dependiendo
% de la resolución)
resXY=res:res:12-res;
% Vector de puntos del grid
GridPoints=[];
contPunt=1;
for x=res:res:12-res % evaluando del 0 al 11
    for y=res:res:12-res
        % Se asigna el punto al vector de puntos
        GridPoints(contPunt,:)=[0 0];
        % se checa por si el punto del grid se encuentra en el obstáculo
        [in1,on1] = inpolygon(x,y,B1(:,1),B1(:,2));
        [in2,on2] = inpolygon(x,y,B2(:,1),B2(:,2));
        % si el punto no es parte del obstáculo, o se encuentra dentro
        if in1==0 && on1==0 && in2==0 && on2==0
           GridPoints(contPunt,:)=[x y]; % se guarda la ubicación del punto
           scatter(x,y,'.g') % se grafica
        end
        contPunt=contPunt+1;
    end
end
% Se eliminan puntos vacíos de GridPoints
cont=1;
for i=1:length(GridPoints)
    if GridPoints(i,:)==0 
       ind(cont)=i;
       cont=cont+1;
    end
end
GridPoints(ind,:)=[];
%% Se encuentran los puntos más cercanos en GridPoints a Pi y Pf
for i=1:length(GridPoints)
   dist_Pi(i)=sqrt((GridPoints(i,1)-Pi(1))^2+(GridPoints(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((GridPoints(i,1)-Pf(1))^2+(GridPoints(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);
%% Ahora se debe realizar un grafo de conectividad para los puntos
% Se crea la matriz de adyacencia que define 0 cuando hay colisión
A=zeros(length(GridPoints));
for i=1:length(GridPoints)
   for j=1:length(GridPoints)
      for k=1:length(Sr_Bi)
          % se comparan las rectas de los puntos trapezoidales con los
          % obstáculos
          Col(k)=DetCol([GridPoints(i,:) GridPoints(j,:)],[Sr_Bi(k,:)]);
      end
      if sum(Col)==0 % si la suma de todas las comparaciones es cero
            A(i,j)=1;   
      end
   end    
end
% Plot
for i=1:length(GridPoints)
   for j=1:length(GridPoints)
      if A(i,j)~=0
        plot([GridPoints(i,1) GridPoints(j,1)],[GridPoints(i,2) GridPoints(j,2)],'k')
      end
   end    
end
%% Habiendo encontrado la matriz de adyacencia se puede proceder a usar
% algún algoritmo de búsqueda para encontrar el camino del inicio al fin
tau=RandomSearch(A,GridPoints,IndexPi,IndexPf);
Tray_fin=[Pi;GridPoints(tau,:);Pf];
% plot
for i=1:length(Tray_fin)-1
    plot([Tray_fin(i,1) Tray_fin(i+1,1)],[Tray_fin(i,2) Tray_fin(i+1,2)],'g','LineWidth',3)
end