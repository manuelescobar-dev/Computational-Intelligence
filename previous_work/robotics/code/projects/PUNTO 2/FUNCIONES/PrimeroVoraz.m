function [x,y,z]=PrimeroVoraz(ini,fin, Cspace)
    %clear k c Tau epoch SumMinCosto SolPos costo tiempo
    format long g
    %Note que debido a la gráfica del C-space, siempre que se llama a la
    %función Cspace se invierten los índices Cspace(2,1)!
    hold on
    x=[(ini(1))];%Se inicializan los vectores en su posicion inicial.
    y=[(ini(2))];
    z=[10];
    try
        k=0;
        c=ini;
        Tau=[];
        epoch=1;
        SumMinCosto=0;
        while k==0
            % Para el algoritmo A* se exploran todas las posibilidades
            % adjacentes a la solución c. 
            SolPos=c+[0 -1;1 1;1 0;1 -1;0 1;-1 -1;-1 0;-1 1];
            % se calculan las funciónes g(n) y h(n) 
            costo=zeros(8,1);
            for i = 1:8
                obst=0; % si la solución adjacente es un obstáculo la distancia se penaliza con 1000
                if Cspace(SolPos(i,2),SolPos(i,1)) == 1 || Cspace(SolPos(i,2),SolPos(i,1)) == 2 || Cspace(SolPos(i,2),SolPos(i,1)) == 3
                    obst=99999999999999;
                    if Cspace(SolPos(i,2),SolPos(i,1)) == 3
                        disp('Se encontró la solución')
                        k=1;
                        c=[SolPos(i,1) SolPos(i,2)];
                        x=[x (c(1))]; %Se agrega nueva posicion en X,Y y Z.
                        y=[y (c(2))];
                        z=[z 10];
                        break
                    end
                end
                h=sqrt((SolPos(i,1)-fin(1))^2+(SolPos(i,2)-fin(2))^2);
                costo(i)=h+obst;
            end
            % Se obtiene el minimo
            [minCost,index]=min(costo); % si hay repetidos, selecciona el primero
            % Se selecciona el mejor y se asigna como el nuevo punto c
            c=[SolPos(index,1) SolPos(index,2)];
            x=[x (c(1))]; %Se agrega nueva posicion en X,Y y Z.
            y=[y (c(2))];
            z=[z 10];
            SumMinCosto=SumMinCosto+minCost;
            Cspace(SolPos(index,2),SolPos(index,1))=2;
            % se guarda la trayectoria Tau
            if k==0
                Tau(epoch,:)=c;
                %scatter(Tau(epoch,1),Tau(epoch,2),'og')
            end
            epoch=epoch+1;
        end
    catch
       disp('Se encontró un mínimo local, el algoritmo no puede resolver') 
    end
end