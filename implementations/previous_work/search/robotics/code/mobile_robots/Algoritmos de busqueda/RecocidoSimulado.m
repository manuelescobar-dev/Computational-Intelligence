function [tiempo,distancia]=RecocidoSimulado(ini,fin,Cspace,i)
    tic
    distancia=0;

    format long g
    %Note que debido a la gráfica del C-space, siempre que se llama a la
    %función Cspace se invierten los índices Cspace(2,1)!
    subplot(2,3,i)
    hold on
    % El usuario determina cuál será el punto de inicio, y cuál será el de fin
    % Inicio del algoritmo
    try
        k=0;
        c=ini;
        Tau=[];
        epoch=1;
        T=10000; % se define el parámetro T0 con una temperatura alta
        iter=1;
        while k==0
            % Para el algoritmo SA se generan todas las posibilidades
            % adjacentes a la solución c, pero se selecciona una al azar 
            % Por eso se usa una permutación de los índices, esto permite no
            % repetir avaluaciones
            SolIndex=randperm(8);
            index=1;
            j=0;
            while j==0
                T_hist(iter)=T;
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
                Error=EvalSol-EvalC;
                Pcn=1/(1+exp(Error/T));
                if Pcn>0.5
                    j=1;
                    index=0;
                    distancia=distancia+sqrt((RandSol(1)-c(1))^2+(RandSol(2)-c(2))^2);
                    c=RandSol; % se actualiza c
                end
                index=index+1;
                iter=iter+1;
                % se decrementa la temperatura
                %T=T/(1+iter); % Criterio de Boltzmann
                %T=T*exp(-iter); % Forma exponencial
                T=T/(1+log(iter)); % Criterio de Cauchy
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