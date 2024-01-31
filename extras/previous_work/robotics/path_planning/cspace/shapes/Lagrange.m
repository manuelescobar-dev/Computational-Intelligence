function [ValX,y]=Lagrange(Px,Py)
    figure
    %% Polinomio de Lagrange  
    %Inicializacion de los acumuladores
    funcion_sumada = 0;
    funcion_multiplicada = 1;
    syms x ;
    %Algoritmo de generacion del polinomio
    for j = 1:length(Px)
        for m = 1: length(Px)
            if(j ~= m)
                funcion_multiplicada = funcion_multiplicada.*(x - Px(m)) / (Px(j)- Px(m));
            end
        end
        funcion_sumada = funcion_sumada + (Py(j).*funcion_multiplicada);
        funcion_multiplicada = 1;
    end 
    %Polinomio resultante simbólico simplificado
    Polinomio = simplify(funcion_sumada);
    % Se discretizan los valores de x
    ValX=min(Px):0.1:max(Px);
    for k=1:length(ValX)
       x=ValX(k); 
       % Se evalua el polinomio en cada valor de x
       y(k)=subs(Polinomio); 
    end
    % se convierte de simbólico a decimal
    y=double(y);
    % Se grafican los puntos
    scatter(Px,Py,'b')
    hold on
    axis([min(Px(:))-5 max(Px(:))+5 min(Py(:))-5 max(Py(:))+5])
    % se grafica la curva
    plot(ValX,y)
    grid on
end