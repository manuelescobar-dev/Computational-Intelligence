function [x,y,z]=lemniscata(Ts,ini,size)
    x=[(ini(1))]; %X,Y,Z inicial.
    y=[(ini(2))];
    z=[0];
    %Parametros lumniscata
    a=3;
    b=1.5;
    m=1.5;
    n=3;
    t=0:1/Ts:1; %Tiempo de muestreo
    for h=0:9 %Altura final, va subiendo de a 1 metro.
        for i=1:length(t)
            x_1=a*cos(2*pi*m*t(i))*size+ini(1); %Ecuaciones parametricas.
            y_1=b*sin(2*pi*n*t(i))*size+ini(2);
            x=[x x_1]; %Se agrega X,Y,Z a la trayectoria.
            y=[y y_1];
            z=[z h];
        end
        n_x=(a*cos(2*pi*m)*size+ini(1)-x_1)/2+x_1; %Calcula un paso intermedio entre la posicion en la que estaba y donde comienza.
        n_y=(b*sin(2*pi*n)*size+ini(2)-y_1)/2+y_1;
        x=[x n_x];
        y=[y n_y];
        z=[z h+1]; %Sube 1 metro cada que termina de realizar la figura.
    end
end
