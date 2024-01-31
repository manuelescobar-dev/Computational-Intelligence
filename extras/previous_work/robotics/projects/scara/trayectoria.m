%% cinematica inversa para trayectoria de quinto orden
%Se deben correr todas las secciones del codigo


% se decidió generar la trayectoria por este metodo ya que 
% no era necesario evadir obstaculos porque esto se hacia mediante la
% altura en el eje z y con este metodo se podria en un trabajo posterior
% controlar ciertas caracteristicas de las velocidades y acelaraciones de
% los actuadores. No es necesario evadir obstaculos ya que puede coger un
% objeto, subir completamente, y luego posicionarlo en la caja.

% Inicialización de parámetros

clear 
clc
l1=0.280; %medida del brazo 1
l2=0.280; %medida del brazo2
l=0.3; %medida de la base
h_cil=0.1; %altura de los cilindros
epsi=0.1; % paso de discretizacion
th1=0; %valor inicial para vector de datos de theta1 
th2=0; %valor inicial para vector de datos de theta2 
P=[0.56 0;0.05 -0.35;0.24 0.24;0.2 -0.1;0.24 0.31;0.3 -0.1;0.31 0.31;0.3 -0.25;0.31 0.24]; %puntos para planificar las trayectorias del SCARA


% aqui se hace el for para generar las trayectorias punto a punto
% la trayectoria se planificó con los grados de libertad mas no con
% las coordenadas cartesianas, es decir, se hallaron los thetas iniciales y
% finales y se planifico una trayectoria de quinto orden entre ellos
% una trayectoria para cada par de puntos, haciendo el empalme entre el
% punto inicial y el punto final anterior

for k=1:8
    clear theta1 theta2
    %coordenadas cartesianas iniciales
    x0=P(k,1);
    y0=P(k,2);
    %coordenadas cartesianas finales
    x1=P(k+1,1);
    y1=P(k+1,2);
    
    %cinematica inversa para encontrar los thetas iniciales
    P0=[x0 y0];
    gamma0 = atan2(P0(1,2),P0(1,1));
    L0 = sqrt(P0(1,1)^2+P0(1,2)^2);
    alpha0 = acos((L0^2+l1^2-l2^2)/(2*L0*l1));
    beta0 = acos((l2^2+l1^2-L0^2)/(2*l2*l1));
    th1a0 = gamma0-alpha0;
    th2a0 = pi-beta0;

    %cinematica inversa para encontrar los thetas finales
    P1=[x1 y1];
    gamma1 = atan2(P1(1,2),P1(1,1));
    L1 = sqrt(P1(1,1)^2+P1(1,2)^2);
    alpha1 = acos((L1^2+l1^2-l2^2)/(2*L1*l1));
    beta1 = acos((l2^2+l1^2-L1^2)/(2*l2*l1));
    th1a1 = gamma1-alpha1;
    th2a1 = pi-beta1;

    %Teniendo los thetas iniciales y finales para cada grado de libertad se
    %calcula la trayectoria para cada uno 

    % trayectoria theta1

    t0=0; %tiempo inicial
    tf=1; %tiempo de duracion de la trayectoria
    
    %condiciones iniciales de posicion, velocidad y aceleracion

    theta10=th1a0;
    theta1f=th1a1;
    theta_10=0;
    theta_1f=0;
    theta__10=0;
    theta__1f=0;

    %calculo de coeficientes del polinomio
    a0=theta10;
    a1=theta_10;
    a2=theta__10/2;
    a3=(20*(theta1f-theta10)-4*tf*(2*theta_1f+3*theta_10)-tf^2*(3*theta__10-theta__1f))/(2*(tf)^3);
    a4=(30*(theta10-theta1f)+tf*(14*theta_1f+16*theta_10)+tf^2*(3*theta__10-2*theta__1f))/(2*(tf)^4);
    a5=(12*(theta1f-theta10)-tf*(6*theta_1f+6*theta_10)-tf^2*(theta__10-theta__1f))/(2*(tf)^5);

    %generacion del vector con los valores de posicion, velocidad y aceleracion en el tiempo
    t=t0:epsi:tf;
    for i=1:length(t)
        theta1(i)=a0+a1*t(i)+a2*t(i)^2+a3*t(i)^3+a4*t(i)^4+a5*t(i)^5;
        theta_1(i)=a1+2*a2*t(i)+3*a3*t(i)^2+4*a4*t(i)^3+5*a5*t(i)^4;
        theta__1(i)=2*a2+6*a3*t(i)+12*a4*t(i)^2+20*a5*t(i)^3;
    end

    %se hace lo mismo para theta2

    % trayectoria theta2
    t01=0;
    tf1=1;
    theta20=th2a0;
    theta2f=th2a1;
    theta_20=0;
    theta_2f=0;
    theta__20=0;
    theta__2f=0;
    a01=theta20;
    a11=theta_20;
    a21=theta__20/2;
    a31=(20*(theta2f-theta20)-4*tf1*(2*theta_2f+3*theta_20)-tf1^2*(3*theta__20-theta__2f))/(2*(tf1)^3);
    a41=(30*(theta20-theta2f)+tf1*(14*theta_2f+16*theta_20)+tf1^2*(3*theta__20-2*theta__2f))/(2*(tf1)^4);
    a51=(12*(theta2f-theta20)-tf1*(6*theta_2f+6*theta_20)-tf1^2*(theta__20-theta__2f))/(2*(tf1)^5);
    
    t1=t01:epsi:tf1;
    for i=1:length(t1)
        theta2(i)=a01+a11*t1(i)+a21*t1(i)^2+a31*t1(i)^3+a41*t1(i)^4+a51*t1(i)^5;
        theta_2(i)=a11+2*a21*t1(i)+3*a31*t1(i)^2+4*a41*t1(i)^3+5*a51*t1(i)^4;
        theta__2(i)=2*a21+6*a31*t1(i)+12*a41*t1(i)^2+20*a51*t1(i)^3;
    end

    %aqui se le agregan unos valores al final del vector para que se
    %mantenga en la ultima posicion x,y mientras el actuador z baja y recoge
    %el cilindro 

    theta1=[theta1 theta1(1,11) theta1(1,11)];
    theta2=[theta2 theta2(1,11) theta2(1,11)];

    %se van acumulando los valores en los vectores finales que se usaran
    %en la simulacion
    th1=[th1 theta1];
    th2=[th2 theta2];
end
%% Actuador lineal en zeta
% se creea el vector de posiciones en zeta el cual será un vector de ceros
% y solo se le cambia el valor en los instantes en que baja por un
% cilindro

zeta=zeros(1,105);
zeta(1,13)=-(l-h_cil);
zeta(1,26)=-(l-h_cil);
zeta(1,39)=-(l-h_cil);
zeta(1,52)=-(l-h_cil);
zeta(1,65)=-(l-h_cil);
zeta(1,78)=-(l-h_cil);
zeta(1,91)=-(l-h_cil);
zeta(1,104)=-(l-h_cil);

%% Movimiento cilindros
% Por gomosear se quiso que se movieran tambien los cilindros entonces aqui
% se crean los vectores de las coordenadas x,y,z de cada uno de los
% cilindros en el tiempo

%aqui se generan los valores de z en el tiempo para cada uno 
zeta_cil1=zeros(1,105);
zeta_cil1(1,14:25)=(l-h_cil);

zeta_cil2=zeros(1,105);
zeta_cil2(1,40:51)=(l-h_cil);

zeta_cil3=zeros(1,105);
zeta_cil3(1,66:77)=(l-h_cil);

zeta_cil4=zeros(1,105);
zeta_cil4(1,92:103)=(l-h_cil);

%se obtiene con la cinematica directa del SCARA las coordenadas x,y para
%que estas sean las mismas de los cilindros y sigan la misma trayectoria
%del actuador final durante el lapso de tiempo en que se traslada el
%cilindro desde su posicion inicial hasta la caja

for h=1:105
    x_cil(h)=l1*cos(th1(h))+l2*cos(th1(h)+th2(h));
    y_cil(h)=l1*sin(th1(h))+l2*sin(th1(h)+th2(h));
end

%aqui se crean finalmente las coordenadas x,y de cada uno 
%al inicio de cada vector estan las posiciones iniciales de cada cilindro
% luego estan las coordenadas de la trayectoria hasta la caja y al final
% se mantiene el ultimo valor de esta trayectoria para que permanezca en la
% ccaja

x_cil1(1,1:13)=-0.050;
x_cil1(1,14:25)=-x_cil(1,14:25);
x_cil1(1,26:105)=-x_cil(1,25);
y_cil1(1,1:13)=0.350;
y_cil1(1,14:25)=-y_cil(1,14:25);
y_cil1(1,26:105)=-y_cil(1,25);

x_cil2(1,1:39)=-0.20;
x_cil2(1,40:51)=-x_cil(1,40:51);
x_cil2(1,52:105)=-x_cil(1,51);
y_cil2(1,1:39)=0.1;
y_cil2(1,40:51)=-y_cil(1,40:51);
y_cil2(1,52:105)=-y_cil(1,51);

x_cil3(1,1:65)=-0.3;
x_cil3(1,66:77)=-x_cil(1,66:77);
x_cil3(1,78:105)=-x_cil(1,77);
y_cil3(1,1:65)=0.1;
y_cil3(1,66:77)=-y_cil(1,66:77);
y_cil3(1,78:105)=-y_cil(1,77);

x_cil4(1,1:91)=-0.3;
x_cil4(1,92:103)=-x_cil(1,92:103);
x_cil4(1,104:105)=-x_cil(1,103);
y_cil4(1,1:91)=0.25;
y_cil4(1,92:103)=-y_cil(1,92:103);
y_cil4(1,104:105)=-y_cil(1,103);