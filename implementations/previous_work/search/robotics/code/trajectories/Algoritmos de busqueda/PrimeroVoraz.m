function [tiempo,distancia]=PrimeroVoraz(ini,fin, Cspace,i)
    tic
    distancia=0;
    %clear k c Tau epoch SumMinCosto SolPos costo tiempo
    format long g
    %Note que debido a la gráfica del C-space, siempre que se llama a la
    %función Cspace se invierten los índices Cspace(2,1)!
    subplot(2,3,i)
    hold on
    try
        k=0;
        c=ini;
        Tau=[];
        epoch=1;
        SumMinCosto=0;
        while k==0
            % Para el algoritmo A* se exploran todas las posibilidades
            % adjacentes a la solución c. 
            SolPos=c+[0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1];
            % se calculan las funciónes g(n) y h(n) 
            costo=zeros(8,1);
            for i = 1:8
                obst=0; % si la solución adjacente es un obstáculo la distancia se penaliza con 1000
                if Cspace(SolPos(i,2),SolPos(i,1)) == 1 || Cspace(SolPos(i,2),SolPos(i,1)) == 2 || Cspace(SolPos(i,2),SolPos(i,1)) == 3
                    obst=1000;
                    if Cspace(SolPos(i,2),SolPos(i,1)) == 3
                        disp('Se encontró la solución')
                        k=1;
                    end
                end
                h=sqrt((SolPos(i,1)-fin(1))^2+(SolPos(i,2)-fin(2))^2);
                costo(i)=h+obst;
            end
            % Se obtiene el minimo
            [minCost,index]=min(costo); % si hay repetidos, selecciona el primero
            % Se selecciona el mejor y se asigna como el nuevo punto c
            distancia=distancia+sqrt((SolPos(i,1)-c(1))^2+(SolPos(i,2)-c(2))^2);
            c=[SolPos(index,1) SolPos(index,2)];
            SumMinCosto=SumMinCosto+minCost;
            Cspace(SolPos(index,2),SolPos(index,1))=2;
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