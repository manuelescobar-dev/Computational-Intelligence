% Se encuentra una trayectoria usando la búsqueda Random Search
function tau=RandomSearch(A,P,Pi,Pf)
flag=0;
% la solución actual es la distancia euclidiana hasta el punto final
SolIni=sqrt((P(Pi,1)-P(Pf,1))^2+(P(Pi,2)-P(Pf,2))^2);
cont=1;
tau=Pi;
while flag==0
        RandSol=randi(length(A)); % se genera una solución aleatoria
        Sol=A(RandSol,Pi); %Se evalúa si es viable (existe conectividad)
        SolProp=1000; % Se propone una distancia alta
        if Sol==1 % si existe conectividad, se calcula la distancia real
           SolProp=sqrt((P(RandSol,1)-P(Pf,1))^2+(P(RandSol,2)-P(Pf,2))^2); 
        end
        if SolProp<SolIni % si es menor la distancia propuesta, se elije
           Pi=RandSol; % Se asigna el indice nuevo a Punto actual
           SolIni=SolProp; % se actualiza la solución 
           tau(cont+1)=Pi; % se guarda la trayectoria
           cont=cont+1;
        end
        if Pi==Pf
            flag=1; % si se llega al punto final, se detiene
        end
end
end
