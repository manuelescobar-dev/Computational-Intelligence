% Algoritmo de planificación usando probabilistic road maps
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
%% se crean n puntos aleatorios en el espacio de trabajo
n=20;
for i=1:n
   PRM_points(i,:)=[20*rand 20*rand]; 
end
subplot(2,2,1)
scatter(PRM_points(:,1),PRM_points(:,2),'.r')
%% se eliminan los que estén dentro o en los obstáculos
% quitando los puntos que pertenencen al límite del espacio de trabajo
index_Et=[];
for i=1:length(PRM_points)
    [~,on_Et] = inpolygon(PRM_points(i,1),PRM_points(i,2),Et(:,1),Et(:,2));
    if on_Et==1
        index_Et=[index_Et i];
    end
end
PRM_points(index_Et,:)=[];
% quitando los puntos que tienen colisión con obstáculos
col=zeros(length(PRM_points),length(B_vi));
for i=1:length(PRM_points)
    for j=1:length(B_vi)
        [in1,on1] = inpolygon(PRM_points(i,1),PRM_points(i,2),B_vi{j}(:,1),B_vi{j}(:,2));
        if in1==1 || on1==1 
            col(i,j)=1;
        end
    end
end
index_Bi=find(sum(col'));
PRM_points(index_Bi,:)=[];
%% Se realiza un grafo encontrando los vecinos más cercanos a cada punto 
% en un radio r
% en la misma operación se crea la matriz de adyacencia
r=7;
cont=1;
A=zeros(length(PRM_points));
for i=1:length(PRM_points)
    for j=1:length(PRM_points)
       % se encuentra la distancia 
        dist=sqrt((PRM_points(i,1)-PRM_points(j,1))^2+(PRM_points(i,2)-PRM_points(j,2))^2);
        if dist<2 && dist~=0 % si la distancia es menor s dos, pero no cero
            Sr_PRM(cont,:)=[PRM_points(i,1) PRM_points(i,2) PRM_points(j,1) PRM_points(j,2)];
            cont=cont+1;
            % se crea la conexión en A
            A(i,j)=1;
        end
    end
end
% plot
for i=1:length(Sr_PRM)
   subplot(2,2,2)
   plot([Sr_PRM(i,1) Sr_PRM(i,3)],[Sr_PRM(i,2) Sr_PRM(i,4)],'r')
end
subplot(2,2,2)
scatter(PRM_points(:,1),PRM_points(:,2),'.k')
%% quitando las rectas que tienen colisión con los obstáculos
col=zeros(length(Sr_PRM),length(Sr_Bi));
for i=1:length(Sr_PRM)
    for j=1:length(Sr_Bi)
        col(i,j)=DetCol(Sr_PRM(i,:),Sr_Bi(j,:));
        % también se retiran de la matriz de adyacencia
        if col(i,j)==1
            % se encuentra el segmento de recta en el arreglo de puntos PRM
           indexA1=find(Sr_PRM(i,1)== PRM_points(:,1)); 
           indexB1=find(Sr_PRM(i,3)== PRM_points(:,1));
           indexA2=find(Sr_PRM(i,2)== PRM_points(:,2)); 
           indexB2=find(Sr_PRM(i,4)== PRM_points(:,2));   
           if indexA1==indexA2 && indexB1==indexB2
                A(indexA1,indexB1)=0;
           end
        end
    end 
end    
index_Bi=find(sum(col'));
Sr_PRM(index_Bi,:)=[];
% plot
for i=1:length(Sr_PRM)
   subplot(2,2,3)
   plot([Sr_PRM(i,1) Sr_PRM(i,3)],[Sr_PRM(i,2) Sr_PRM(i,4)],'r')
end
subplot(2,2,3)
scatter(PRM_points(:,1),PRM_points(:,2),'.k')
%% Se encuentran los puntos más cercanos en GridPoints a Pi y Pf
for i=1:length(PRM_points)
   dist_Pi(i)=sqrt((PRM_points(i,1)-Pi(1))^2+(PRM_points(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((PRM_points(i,1)-Pf(1))^2+(PRM_points(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);
%% Habiendo encontrado la matriz de adyacencia se puede proceder a usar
% algún algoritmo de búsqueda para encontrar el camino del inicio al fin
tau=RandomSearch(A,PRM_points,IndexPi,IndexPf);
Tray_fin=[Pi;PRM_points(tau,:);Pf];
% plot
for i=1:length(Sr_PRM)
   subplot(2,2,4)
   plot([Sr_PRM(i,1) Sr_PRM(i,3)],[Sr_PRM(i,2) Sr_PRM(i,4)],'r')
end
subplot(2,2,4)
scatter(PRM_points(:,1),PRM_points(:,2),'.k')
for i=1:length(Tray_fin)-1
    subplot(2,2,4)
    plot([Tray_fin(i,1) Tray_fin(i+1,1)],[Tray_fin(i,2) Tray_fin(i+1,2)],'g','LineWidth',3)
end