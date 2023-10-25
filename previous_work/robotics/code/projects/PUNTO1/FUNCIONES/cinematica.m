function [x1,x2,x3,y1,y2,y3,z1,z2,z3]= cinematica(th1,th2,d,l1,l2,l3)
    % Los puntos 1 corresponden a el final del primer brazo, los puntos 2
    % al final del segundo brazo, y los puntos 3 corresponden a el final
    % del actuado (donde va la garra).
    x1=l2*cosd(th1);
    x2=x1 + l3*cosd(th1+th2);
    x3=x2;
    y1=l2*sind(th1);
    y2=y1 + l3*sind(th1+th2);
    y3=y2;
    z1=l1;
    z2=z1;
    z3=l1-d;
end