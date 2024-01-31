% Algoritmo de retracción usando diagramas de Voronoi
% Obstáculos
clc
clear
close all
% para graficar
figure
axis([-1 20 -1 20])
grid on
% los obstáculos se encuentran definidos por los puntos
B1=[4 14;6 14;5 12;5 10]; 
B2=[3 6;5 7;6 6;4 4]; 
B3=[12 12;14 8;13 16]; 
B4=[10 4;10 2;13 2;13 5;12 5;12 4];
Bi=[B1;B2;B3;B4];
B_vi={B1,B2,B3,B4}; % se crea una celda con los obstáculos
% los segmentos de recta de los obstáculos son [x1 y1 x2 y2]
Sr_B1=[4 14 5 10;5 10 5 12;5 12 6 14;6 14 4 14];
Sr_B2=[3 6 4 4;4 4 6 6;6 6 5 7;5 7 3 6];
Sr_B3=[12 12 14 8;14 8 13 16;13 16 12 12];
Sr_B4=[10 4 10 2;10 2 13 2;13 2 13 5;13 5 12 5;12 5 12 4;12 4 10 4];
Sr_Bi=[Sr_B1;Sr_B2;Sr_B3;Sr_B4];
% Indice de la conectividad de los obstáculos
Sr_index=[1 4;4 3;3 2;2 1;5 8;8 7;7 6;6 5;9 10;10 11;11 9;12 13;13 14;14 15;15 16;16 17;17 12];
for i=1:4
    for k=1:length(Sr_Bi) % ploteando los obstáculos
        subplot(2,2,i)
        plot([Sr_Bi(k,1) Sr_Bi(k,3)],[Sr_Bi(k,2) Sr_Bi(k,4)],'b')
        hold on
    end
    % los puntos inicial y final son
    Pi=[1 18];
    Pf=[17,5];
    subplot(2,2,i)
    scatter([Pi(1) Pf(1)],[Pi(2) Pf(2)],'k','filled') %Ploteando los puntos ini y fin
    text(Pi(1),Pi(2)-0.5,'P_i')
    text(Pf(1),Pf(2)-0.5,'P_f')
    % los segmentos de recta que delimitan el espacio de trabajo
    % son [x1 y1 x2 y2]
    Et_sup=[20 20 0 20];
    Et_inf=[0 0 20 0];
    Et_izq=[0 20 0 0];
    Et_der=[20 0 20 20];
    Et=[0 0;20 0;20 20;0 20];
    % celda de espacio de trabajo
    subplot(2,2,i)
    plot([0 20 20 0 0],[0 0 20 20 0],'b','LineWidth',3) % plot workspace
end
%% Se discretizan los obstáculos considerando los segmentos de recta de
% los obstáculos y el espacio de trabajo
% se crea una celda con los segmentos de recta
ObstCell={Sr_B1,Sr_B2,Sr_B3,Sr_B4,Et_sup,Et_inf,Et_izq,Et_der};
n=5; %número de puntos a obtener de cada segmento de recta
Puntos={};
Puntos_2=[];
for i=1:length(ObstCell)
    [reng,~]=size(ObstCell{i});
    for j=1:reng
        Puntos_1=LinDis(ObstCell{i}(j,:),n);
        Puntos_2=[Puntos_2;Puntos_1];
    end
    % la celda Puntos tiene los puntos de cada obstáculo
    Puntos{i}=Puntos_2;
    Puntos_2=[];
end
% gráfica de la discretización
for k=1:3
    for i=1:length(Puntos)
        subplot(2,2,k)
        scatter(Puntos{i}(:,1),Puntos{i}(:,2),'k')
    end
end
%% comparar cada punto de un obstáculo con los otros obstáculos para 
% encontrar el punto más cercano, determinando el punto medio entre ellos
Decoy=Puntos;
for i=1:length(Puntos)
    Decoy(i)=[]; % quitando los puntos del obstáculo a evaluar
    % convertir en un solo arreglo
    Test_points=[];
    for k=1:length(Decoy)
        Test_points=[Test_points;Decoy{k}];
    end
    % comparar contra el obstáculo i
    for k=1:length(Puntos{i})
        for j=1:length(Test_points)
           dist(k,j)=sqrt((Puntos{i}(k,1)-Test_points(j,1))^2+...
                     (Puntos{i}(k,2)-Test_points(j,2))^2); 
        end
    end
    % se debe determinar cual es el púnto más cercano con el mínimo de la
    % distancia
    [~,index]=min(dist');
    PuntosConex{i}=Test_points(index,:);
    dist=[];
    Decoy=Puntos;
end
% encontrando los puntos medios entre los puntos y los puntos de conexión
cont=1;
for i=1:length(Puntos)
    for j=1:length(Puntos{i})
       Sr_Voronoi(cont,:)=[Puntos{i}(j,1) Puntos{i}(j,2) PuntosConex{i}(j,1) PuntosConex{i}(j,2)];
       VoronoiPoints(cont,:)=[(Puntos{i}(j,1)+PuntosConex{i}(j,1))/2 (Puntos{i}(j,2)+PuntosConex{i}(j,2))/2]; 
       cont=cont+1; 
    end 
end
%Graficando
for j=1:length(Sr_Voronoi)
    subplot(2,2,2)
    plot([Sr_Voronoi(j,1) Sr_Voronoi(j,3)],[Sr_Voronoi(j,2) Sr_Voronoi(j,4)],'r')
end
subplot(2,2,2)
scatter(VoronoiPoints(:,1),VoronoiPoints(:,2),'r')
%% Se reducen el número de puntos para el roadmap de Voronoi
% quitando los puntos que pertenencen al límite del espacio de trabajo
index_Et=[];
for i=1:length(VoronoiPoints)
    [~,on_Et] = inpolygon(VoronoiPoints(i,1),VoronoiPoints(i,2),Et(:,1),Et(:,2));
    if on_Et==1
        index_Et=[index_Et i];
    end
end
VoronoiPoints(index_Et,:)=[];
Sr_Voronoi(index_Et,:)=[];
% quitando los puntos que tienen colisión con obstáculos
col=zeros(length(VoronoiPoints),length(B_vi));
for i=1:length(VoronoiPoints)
    for j=1:length(B_vi)
        [in1,on1] = inpolygon(VoronoiPoints(i,1),VoronoiPoints(i,2),B_vi{j}(:,1),B_vi{j}(:,2));
        if in1==1 || on1==1 
            col(i,j)=1;
        end
    end
end
index_Bi=find(sum(col'));
VoronoiPoints(index_Bi,:)=[];
Sr_Voronoi(index_Bi,:)=[];
% Graficando los puntos medios
subplot(2,2,3)
scatter(VoronoiPoints(:,1),VoronoiPoints(:,2),'r')
for i=1:length(Sr_Voronoi)
subplot(2,2,3)
plot([Sr_Voronoi(i,1) Sr_Voronoi(i,3)],[Sr_Voronoi(i,2) Sr_Voronoi(i,4)],'r') 
end
%% Ahora se debe realizar un grafo de conectividad para los puntos
% Se crea la matriz de adyacencia que define 0 cuando hay colisión
A=zeros(length(VoronoiPoints));
for i=1:length(VoronoiPoints)
   for j=1:length(VoronoiPoints)
      for k=1:length(Sr_Bi)
          % se comparan las rectas de los puntos trapezoidales con los
          % obstáculos
          Col(k)=DetCol([VoronoiPoints(i,:) VoronoiPoints(j,:)],[Sr_Bi(k,:)]);
      end
      if sum(Col)==0 % si la suma de todas las comparaciones es cero
            A(i,j)=1;   
      end
   end    
end
% Plot
for i=1:length(VoronoiPoints)
   for j=1:length(VoronoiPoints)
      if A(i,j)~=0
          subplot(2,2,4)
          plot([VoronoiPoints(i,1) VoronoiPoints(j,1)],[VoronoiPoints(i,2) VoronoiPoints(j,2)],'k')
      end
   end    
end
%% Se encuentran los puntos más cercanos en GridPoints a Pi y Pf
for i=1:length(VoronoiPoints)
   dist_Pi(i)=sqrt((VoronoiPoints(i,1)-Pi(1))^2+(VoronoiPoints(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((VoronoiPoints(i,1)-Pf(1))^2+(VoronoiPoints(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);
%% Habiendo encontrado la matriz de adyacencia se puede proceder a usar
% algún algoritmo de búsqueda para encontrar el camino del inicio al fin
tau=RandomSearch(A,VoronoiPoints,IndexPi,IndexPf);
Tray_fin=[Pi;VoronoiPoints(tau,:);Pf];
% plot
for i=1:length(Tray_fin)-1
    subplot(2,2,4)
    plot([Tray_fin(i,1) Tray_fin(i+1,1)],[Tray_fin(i,2) Tray_fin(i+1,2)],'g','LineWidth',3)
end