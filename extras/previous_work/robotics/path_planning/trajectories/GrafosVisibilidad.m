% Algoritmo de grafos de visibilidad
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
% plot de los nodos numerados
for i=1:length(Bi)
   subplot(2,2,1)
   scatter(Bi(i,1),Bi(i,2),'.k')
   hold on
   str=string(i);
   text(Bi(i,1)-0.5,Bi(i,2)-0.5,str)
end
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
    % los segmentos de recta que delimitan arriba y abajo el espacio de trabajo
    % son [x1 y1 x2 y2]
    Et_sup=[0 20 20 20];
    Et_inf=[0 0 20 0];
    subplot(2,2,i)
    plot([0 20 20 0 0],[0 0 20 20 0],'b','LineWidth',3) % plot workspace
end
%% Se procede a realizar el grafo de visibilidad
cont=1;
for i=1:length(Bi)
   for j=1:length(Bi)
            Graph(cont,:)=[Bi(i,1) Bi(i,2) Bi(j,1) Bi(j,2)];
            cont=cont+1;
   end    
end
% gráfica animada del grafo de visibilidad
for i=1:length(Graph)
subplot(2,2,2)
plot([Graph(i,1) Graph(i,3)],[Graph(i,2) Graph(i,4)],'k')
hold on
pause(0.1)
end
% se determina si los nodos del grafo están dentro de los obstáculos
GraphIndex=zeros(length(Graph),1);
for i=1:length(Graph)
    % se crean n=10 puntos discretizados para cada segmento de recta
    Puntos=LinDis(Graph(i,:),10);
    if isempty(Puntos)~=1
        Puntos(length(Puntos),:)=[];
        Puntos(1,:)=[];
    else
        in=1000;
    end
    %plotear los puntos
    subplot(2,2,3)
    scatter(Puntos(:,1),Puntos(:,2),'.k')
    % para cada punto discretizado se revisa si está dentro del los
    % obstáculos
    for k = 1:length(Puntos)
        for j=1: length(B_vi)
            [in(k,j),~] = inpolygon(Puntos(k,1),Puntos(k,2),B_vi{1,j}(:,1),B_vi{1,j}(:,2));
        end 
    end
    ContObs(i)=sum(sum(in));
    if ContObs(i)~=0
        GraphIndex(i)=i;
        subplot(2,2,3)
        scatter(Puntos(:,1),Puntos(:,2),'xr')
         pause(0.1)
    elseif ContObs(i)==1000
        GraphIndex(i)=i;
    end
end
%% se eliminan los índices que no están contenidos en el obstáculo
GraphIndex=GraphIndex(GraphIndex~=0);
% Se crea la matriz de adjacencia 
A=ones(length(Bi));
for i=1:length(GraphIndex)
    A(GraphIndex(i))=0;
end
% se añaden las aristas de los obstáculos como caminos viables
for i=1:length(Sr_index)
   A(Sr_index(i,1),Sr_index(i,2))=1; 
end
% Se eliminan las líneas con colisión para graficar
Graph(GraphIndex,:)=[];
for i=1:length(Graph)
    subplot(2,2,4)
    plot([Graph(i,1) Graph(i,3)],[Graph(i,2) Graph(i,4)],'r')
    pause(0.1)
end
%% Encontrar los puntos más cercanos a Pi y Pf
for i=1:length(Bi)
   dist_Pi(i)=sqrt((Bi(i,1)-Pi(1))^2+(Bi(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((Bi(i,1)-Pf(1))^2+(Bi(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);
% con los índices de los números más cercanos podemos iniciar la búsqueda
%% Se usa una un algoritmo de búsqueda para encontrar la solución
tau=RandomSearch(A,Bi,IndexPi,IndexPf); % búsqueda aleatoria
Tray_fin=[Pi;Bi(tau,:);Pf]
% plot
for i=1:length(Tray_fin)-1
    subplot(2,2,4)
    plot([Tray_fin(i,1) Tray_fin(i+1,1)],[Tray_fin(i,2) Tray_fin(i+1,2)],'g','LineWidth',3)
end