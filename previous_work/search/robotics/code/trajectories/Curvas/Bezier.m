function [funcion_x,funcion_y]=Bezier(Px,Py)
    figure
    %Numero de puntos en el plano 
    n = length(Px)-1;
    %inicializar las variables en cero
    funcion_x = 0;
    funcion_y = 0;
    %Poner un contador para ir recorriendo las coordenadas 
    i=0;
    %El tiempo establecido 
    t = 0: 1/20 : 1 ;
    % se inician las iteraciones
    for j = 1:n+1
        %Hacer la funcion de x con la formula de curvas de bezier 
        funcion_x = funcion_x +(((factorial(n))/(factorial(i).*factorial(n-i))*((1-t).^(n-i)).*(t.^i)).*Px(j));
        %Hacer la funcion de y con la formula de curvas de bezier 
        funcion_y = funcion_y +(((factorial(n))/(factorial(i).*factorial(n-i))*((1-t).^(n-i)).*(t.^i)).*Py(j));
        %Graficar las coordenadas que se metieron para comparar con la curva
        scatter(Px(j),Py(j),'rs');
        hold on;
        % aumentar contador para las proximas coordenadas
        i= i+1;
    end
    %Imprimir las dos funciones juntas
    for k=1:length(funcion_x)
       scatter(funcion_x(k), funcion_y(k),'b') 
       hold on 
       pause(0.1)
    end
    plot(funcion_x, funcion_y,'b')
    %Obtener los mínimos y máximos de las coordenadas para establecer los limites
    %de la grafica 
    maximo_x = max(Px(:))+1;
    minimo_x = min(Px(:))-1;
    maximo_y = max(Py(:))+1;
    minimo_y = min(Py(:))-1;
    %Poner los ejes para que se puedan ver los puntos 
    axis([minimo_x maximo_x minimo_y  maximo_y])
end