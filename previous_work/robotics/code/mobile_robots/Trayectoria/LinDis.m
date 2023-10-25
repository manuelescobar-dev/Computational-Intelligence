% función que discretiza una línea
function Puntos=LinDis(Linea,n)
% la linea está definida por Linea=[ax ay bx by];
x1=Linea(1);
y1=Linea(2);
x2=Linea(3);
y2=Linea(4);
% resolución es el número de puntos a crear
% se calcula la distancia
dx=abs(x2-x1);
dy=abs(y2-y1);
% Resolución
res_x=dx/n;
res_y=dy/n;
% se calcula la pendiente
m=(y2-y1)/(x2-x1);
if m==0 % es horizontal
    if x2>x1
        px=x1:res_x:x2;
    else
        px=x1:-res_x:x2;
    end
    py=ones(1,length(px))*y1;
elseif abs(m)==Inf % es vertical
    if y2>y1
        py=y1:res_y:y2;
    else
        py=y1:-res_y:y2;
    end
    px=ones(1,length(py))*x1;    
else
    if x2>x1
        px=x1:res_x:x2;
    else
        px=x1:-res_x:x2;
    end    
    if y2>y1
        py=y1:res_y:y2;
    else
        py=y1:-res_y:y2;
    end    
end
Puntos=[px;py]';