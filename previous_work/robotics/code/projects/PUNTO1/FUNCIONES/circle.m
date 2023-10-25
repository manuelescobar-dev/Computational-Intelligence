function [x1,y1] = circle(x,y,r)
    %Discretiza en circulo en una posición X y Y.
    th = 0:pi/50:2*pi;
    x1 = r * cos(th) + x;
    y1 = r * sin(th) + y;
end