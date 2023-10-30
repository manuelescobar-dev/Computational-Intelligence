function colision = DetCol(Linea1,Linea2)
%Esta función detecta la colisión entre dos lineas.
%Para dos rectas a-b y c-d se tienen dos vectores del tipo:
%Linea1=[ax ay bx by]; Linea2=[cx cy dx dy]
colision=false; %salida binaria para comfirmar colisión colisión 1, no colisión 0
a=Linea1(1:2);
b=Linea1(3:4);
c=Linea2(1:2);
d=Linea2(3:4);
m1= (b(2) - a(2)) / (b(1) - a(1));
m2= (d(2) - c(2)) / (d(1) - c(1));
%condiciones para las situaciones de rectas horizontales y verticales, suma
%y resta un pococ para hacerlas inclinadas
%horizontales
if m1==0 
   a=a-[0,0.01];
   b=b+[0,0.01];
   m1= (b(2) - a(2)) / (b(1) - a(1));
   %disp('Una es horizontal');
end
if m2==0 
   c=c-[0,0.01]; 
   d=d+[0,0.01];
   m2= (d(2) - c(2)) / (d(1) - c(1));
   %disp('Una es horizontal');
end
%verticales
if m1==Inf || m1==-Inf
   a=a-[0.01,0];
   b=b+[0.01,0];
   m1= (b(2) - a(2)) / (b(1) - a(1)); 
   %disp('Una es vertical');
end
if m2==Inf || m2==-Inf
   c=c-[0.01,0]; 
   d=d+[0.01,0];
   m2= (d(2) - c(2)) / (d(1) - c(1)); 
   %disp('Una es vertical');
end
% determinando la configuración de las rectas en base a sus pendientes
if m1 == m2
    %disp('son paralelas');
end

if m1 == -(1/m2)
    %disp('Son perpendiculares');
end

if m1 ~= m2
    %disp('Son diferentes');
end
% determinando el punto de intersección
xc= ((-m2 * c(1)) + (m1 * a(1)) - a(2) + c(2)) / (m1 - m2);
yc = m1 * (xc - a(1)) + a(2);

%se reordena para las condiciones de colisión, encontrando el
%máximo y mínimo de cada recta
vr1=[a;b];%recta 1
min1x=min(vr1(:,1));
max1x=max(vr1(:,1));
min1y=min(vr1(:,2));
max1y=max(vr1(:,2));

vr2=[c;d];%recta 2
min2x=min(vr2(:,1));
max2x=max(vr2(:,1));
min2y=min(vr2(:,2));
max2y=max(vr2(:,2));

%Condiciones de colision:
if min1x <= xc && xc <= max1x && min2x <= xc && xc <= max2x && min1y <= yc && yc <= max1y && min2y <= yc && yc <= max2y
   %disp('Si hay colision');
   colision=true;
else
   %disp('No hay colision');
end

% gráfica
% figure
% plot([c(1) d(1)],[c(2) d(2)],'b')
% hold on
% plot([a(1) b(1)],[a(2) b(2)],'r')