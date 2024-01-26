%% CSPACE
clear all
close all
Cspace=CspaceEjemplo(10);

methods={'A*','Random Search','Simulated Aneeling','Stochastic Hill Climbing','Primero Mejor','Primero Voraz'};

figure
for i=1:6
    subplot(2,3,i)
    spy(sparse(Cspace),'k')
    grid on
    title(methods(i))
    xlabel('\theta_1')
    ylabel('\theta_2')
end
pause(3)

%% INCIO/FINAL
hold on
flag=0;
while flag==0
ini=input('Punto de inicio [x,y] :');
    if Cspace(ini(2),ini(1))==1
        disp('El punto seleccionado es un obstáculo, por favor, seleccione otro punto')
    else
        Cspace(ini(2),ini(1))=2;
        plot(ini(1),ini(2),'or')
        flag=1;
    end
end
flag=0;
while flag==0
fin=input('Punto de término [x,y] :');
    if Cspace(fin(2),fin(1))==1
        disp('El punto seleccionado es un obstáculo, por favor, seleccione otro punto')
    else
       Cspace(fin(2),fin(1))=3;
       plot(fin(1),fin(2),'xb')
        flag=1;
    end
end

for i=1:6
    subplot(2,3,i)
    hold on
    plot(ini(1),ini(2),'or')
    hold on
    plot(fin(1),fin(2),'xb')
end
pause(0.1)
%% BUSQUEDA
iter=5;
[t1,d1]=AEstrella(ini,fin,Cspace,1);
pause(0.1)
t2=0; t3=0; t4=0; d2=0; d3=0; d4=0;
disp('Iterando metodos estocasticos (tenga paciencia o bajele a las iteraciones)...')
for i=1:iter
    [tRS,dRS]=RandomSearch(ini,fin,Cspace,2);
    pause(0.1)
    t2=t2+tRS;
    d2=d2+dRS;
    [tSA,dSA]=RecocidoSimulado(ini,fin,Cspace,3);
    pause(0.1)
    t3=t3+tSA;
    d3=d3+dSA;
    [tHC,dHC]=HillClimbingEstoc(ini,fin,Cspace,4);
    pause(0.1)
    t4=t4+tHC;
    d4=d4+dHC;
end
t2=t2/iter; t3=t3/iter; t4=t4/iter; d2=d2/iter; d3=d3/iter; d4=d4/iter;
pause(0.1)
[t5,d5]=PrimeroMejor(ini,fin,Cspace,5);
pause(0.1)
[t6,d6]=PrimeroVoraz(ini,fin,Cspace,6);
pause(0.1)

%% GRAFICAR
X = categorical(methods);
X = reordercats(X,methods);
figure
bar(X,[t1,t2,t3,t4,t5,t6])
title('Tiempo')
xlabel('Metodo')
ylabel('Tiempo [s]')
figure
bar(X,[d1,d2,d3,d4,d5,d6])
title('Distancia Trayectoria')
xlabel('Metodo')
ylabel('Distancia [u]')

%% ANALISIS
disp('')
