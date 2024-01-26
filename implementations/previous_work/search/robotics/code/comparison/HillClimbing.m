%Algoritmo de busqueda de aleatoria Random Search
function [tiempo,distancia]=HillClimbing(ini,fin,Cspace,i)
    tic
    distancia=0;
    format long g
    %Note que debido a la gráfica del C-space, siempre que se llama a la
    %función Cspace se invierten los índices Cspace(2,1)!
    subplot(2,4,i)
    hold on
    try
        k=0;
        c=ini;
        Tau=[];
        epoch=1;
        while k==0
            j=0;
            while j==0
                SolPos=c+[0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1]; %soluciones posibles
                RandSol=SolPos(1,:); % se usa una solución aleatoria
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
                % si la distancia de la propuesta es menor, se elije esta
                if EvalSol<EvalC
                    j=1;
                    distancia=distancia+sqrt((RandSol(1)-c(1))^2+(RandSol(2)-c(2))^2);
                    c=RandSol; % se actualiza c
                end
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
        % Si se genera un error, se entiende que es un mínimo local
       disp('Se encontró un mínimo local, el algoritmo no puede resolver')
       distance=0;
    end
    tiempo=toc;
end