function [x1,x2,y1,y2] = Cindir(th1,th2,l1,l2)
% Cinemática directa para un robot de 2GDL
% th1 y th2 en radianes.
x1=l1*cos(th1);
x2=x1 + l2*cos(th1+th2);
y1=l1*sin(th1);
y2=y1 + l2*sin(th1+th2);