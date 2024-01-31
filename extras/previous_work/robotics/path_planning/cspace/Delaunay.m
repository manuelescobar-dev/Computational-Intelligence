function [DT]=Delaunay(r,cx,cy)
    [x,y]=circle(cx,cy,r);
   %vector de puntos del círculo
    figure
    scatter(x,y)
    axis square
    figure
    %el círculo
    DT = delaunay(x,y);
    triplot(DT,x,y);
    % DT contiene tres columnas, donde se incluyen los
    % índices de p que conforman un triángulo
end