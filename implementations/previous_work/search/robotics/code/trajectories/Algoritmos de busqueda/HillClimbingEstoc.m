function [tiempo,distancia]=HillClimbingEstoc(ini,fin,Cspace,i)
    tic
    distancia=0;
    format long g
    %Note que debido a la gráfica del C-space, siempre que se llama a la
    %función Cspace se invierten los índices Cspace(2,1)!
    subplot(2,3,i)
    hold on
    % El usuario determina cuál será el punto de inicio, y cuál será el de fin
    try
        k=0;
        c=ini;
        Tau=[];
        epoch=1;
        T=2; % se define el parámetro T diferente de 1 para no ser determinista
        % pero no muy grande para no ser aleatorio
        while k==0
            % Para el algoritmo HC est se generan todas las posibilidades
            % adjacentes a la solución c, pero se selecciona una al azar 
            % Por eso se usa una permutación de los índices, esto permite no
            % repetir avaluaciones
            SolIndex=randperm(8);
            index=1;
            j=0;
            while j==0
                SolPos=c+[0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1]; %soluciones posibles
                RandSol=SolPos(SolIndex(index),:); % se usa la primera de la permutación
                scatter(RandSol(1),RandSol(2),'xr') 
                obst=0; % si la solución adjacente es un obstáculo la distancia se penaliza con 1000
                if Cspace(RandSol(2),RandSol(1)) == 1 || Cspace(RandSol(2),RandSol(1)) == 3 || Cspace(RandSol(2),RandSol(1)) == 2
                    obst=1000;
                    if Cspace(RandSol(2),RandSol(1)) == 3
                        % si se llega al final se termina el algoritmo
                        k=1;
                        j=1;
                    end
                end
                % se calcula la distancia de la solución actual c, y de la
                % solución propuesta hasta el objetivo
                EvalC=sqrt((c(1)-fin(1))^2+(c(2)-fin(2))^2);
                EvalSol=sqrt((RandSol(1)-fin(1))^2+(RandSol(2)-fin(2))^2)+obst;
                % Se calcula el error
                Error=EvalSol-EvalC;
                % Se determina la probabilidad de moverse a la solución
                % propuesta con signo positivo para minimizar la distancia
                Pcn=1/(1+exp(Error/T));
                if Pcn>0.5
                    j=1;
                    index=0;
                    distancia=distancia+sqrt((RandSol(1)-c(1))^2+(RandSol(2)-c(2))^2);
                    c=RandSol; % se actualiza c
                end
                index=index+1;
            end
            % se guarda la trayectoria Tau
            if k==0
                Tau(epoch,:)=c;
                scatter(Tau(epoch,1),Tau(epoch,2),'og')
            end
            epoch=epoch+1;
        end
        TryFin=[ini;Tau;fin];
        plot(TryFin(:,1),TryFin(:,2))  
    catch
       disp('Se encontró un mínimo local, el algoritmo no puede resolver')
       distance=0;
    end
    tiempo=toc;
end