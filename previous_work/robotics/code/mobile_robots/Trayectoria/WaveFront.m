% Campos de potencial por método de wavewfront
% Obstáculos
clc
tic
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
% ploteando los obstáculos
for k=1:length(Sr_Bi) 
    subplot(1,2,1)
    plot([Sr_Bi(k,1) Sr_Bi(k,3)],[Sr_Bi(k,2) Sr_Bi(k,4)],'b')
    hold on
end
% los puntos inicial y final son
Pi=[1 18];
Pf=[17,5];
subplot(1,2,1)
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
subplot(1,2,1)
plot([0 20 20 0 0],[0 0 20 20 0],'b','LineWidth',3) % plot workspace
%% Se debe generar el grid para el espacio de trabajo
% se establece una resolución
 res=1;
% res=0.2;
%res=0.5;
resXY=res:res:20-res;
% Vector de puntos del grid
WavePoints=[];
WaveMat=[];
contPunt=1;
for x=res:res:20-res % evaluando
    for y=res:res:20-res
        % Se guarda la matriz de puntos
        WaveMat(x,y)=0;
        % se guarda la ubicación del punto
        WavePoints(contPunt,:)=[x y];
        % se checa por si el punto del grid se encuentra en el obstáculo
        [in1,on1] = inpolygon(x,y,B1(:,1),B1(:,2));
        [in2,on2] = inpolygon(x,y,B2(:,1),B2(:,2));
        [in3,on3] = inpolygon(x,y,B3(:,1),B3(:,2));
        [in4,on4] = inpolygon(x,y,B4(:,1),B4(:,2));
        % si el punto es parte del obstáculo, o se encuentra dentro
        if (in1+in2+in3+in4)==1 || (on1+on2+on3+on4)==1 
           WaveMat(x,y)=1; 
           WavePoints(contPunt,:)=[0 0];
           scatter(x,y,'xr')
        else
           subplot(1,2,1)
           scatter(x,y,'.g') % se grafica
           %pause(0.1)
        end
        contPunt=contPunt+1;
    end
end
% Se eliminan puntos vacíos de WavePoints
cont=1;
for i=1:length(WavePoints)
    if WavePoints(i,:)==0 
       ind(cont)=i;
       cont=cont+1;
    end
end
WavePoints(ind,:)=[];
% se agregan las paredes del espacio de trabajo
WaveMat=[ones(19,1) WaveMat ones(19,1)];
WaveMat=[ones(1,21);WaveMat;ones(1,21)];
% se aumentan las posiciones en los puntos
WavePoints=WavePoints+1;
%% Se encuentran los puntos más cercanos en WavePoints a Pi y Pf
for i=1:length(WavePoints)
   dist_Pi(i)=sqrt((WavePoints(i,1)-Pi(1))^2+(WavePoints(i,2)-Pi(2))^2); 
   dist_Pf(i)=sqrt((WavePoints(i,1)-Pf(1))^2+(WavePoints(i,2)-Pf(2))^2); 
end
[~,IndexPi]=min(dist_Pi);
[~,IndexPf]=min(dist_Pf);

%% Se genera la wave a partir del punto más cercano al final
% punto más cercano al final
WaveFin=WavePoints(IndexPf,:);
WaveMat(WaveFin(1),WaveFin(2))=2;
flag=0;
cont=2;
while flag==0
    [index1,index2]=find(WaveMat==cont);
    for i=1:length(index1)
        % se cambian los 8 puntos adyacentes si son espacio libre (0)
        if WaveMat(index1(i)+1,index2(i))==0
            WaveMat(index1(i)+1,index2(i))=cont+1;
        end
        if WaveMat(index1(i)-1,index2(i))==0
            WaveMat(index1(i)-1,index2(i))=cont+1;
        end
        if WaveMat(index1(i),index2(i)+1)==0
            WaveMat(index1(i),index2(i)+1)=cont+1;
        end
        if WaveMat(index1(i),index2(i)-1)==0
            WaveMat(index1(i),index2(i)-1)=cont+1;
        end
        if WaveMat(index1(i)+1,index2(i)+1)==0 
            WaveMat(index1(i)+1,index2(i)+1)=cont+1;
        end
        if WaveMat(index1(i)-1,index2(i)+1)==0 
            WaveMat(index1(i)-1,index2(i)+1)=cont+1;
        end
        if WaveMat(index1(i)+1,index2(i)-1)==0 
            WaveMat(index1(i)+1,index2(i)-1)=cont+1;
        end
        if WaveMat(index1(i)-1,index2(i)-1)==0 
            WaveMat(index1(i)-1,index2(i)-1)=cont+1;
        end        
    end
    if cont==20 % si se llega al límite del espacio de trabajo, se detiene
        flag=1;
    end
    cont=cont+1;
end
% Se grafica 
[index1,index2]=find(WaveMat==1);
PlotWaveMat=WaveMat;
for i=1:length(index1)
    PlotWaveMat(index1(i),index2(i))=21;
end
PlotWaveMat(:,1)=1;
PlotWaveMat(:,21)=1;
PlotWaveMat(1,:)=1;
PlotWaveMat(21,:)=1;
            %PlotWaveMat=flip(PlotWaveMat);
            %PlotWaveMat = rot90(fliplr(PlotWaveMat),-1)
subplot(1,2,2)
mesh(1:21,1:21,PlotWaveMat)
hold on
%% El proceso de encontrar el camino se puede lograr por medio de la 
% evaluación de los vecinos y selección del más bajo
% se inicia la trayectoria en el punto inicial Pi
tau=WavePoints(IndexPi,:);
flag=0;
cont=1;
while flag==0
    % se evalúan las soluciónes adyacentes a tau
    s1=[1 -1 0 0 1 -1 +1 -1]+tau(cont,1);
    s2=[0 0 +1 -1 1 1 -1 -1]+tau(cont,2);
    Sol=[s1;s2]'; % soluciones adjacentes
    for i=1:length(Sol)
        tauEval(i)=WaveMat(Sol(i,1),Sol(i,2));
        if tauEval(i)==1 % si es obstáculo se suma 100
            tauEval(i)=tauEval(i)+100;
        end
    end
    % se encuentra el valor mínimo 
    [MinVal,MinIndex]=min(tauEval);
    % se agrega este valor a la trayectoria
    tau(cont+1,:)=Sol(MinIndex,:);
    if MinVal==2 % si se llega al Pf
        tau(cont+1,:)=WavePoints(IndexPf,:);
        flag=1;
    end
    cont=cont+1;
end
% graficando la trayectoria
subplot(1,2,1)
scatter(tau(:,1),tau(:,2),'r')
for i=1:length(tau)-1
   plot([tau(i,1) tau(i+1,1)],[tau(i,2) tau(i+1,2)],'r') 
end
toc