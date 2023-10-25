clear
close all
clc
% Dimensiones del robot
l1=3;
l2=2;
% Características del obstáculo
obs1=[3 1.5 4 0.5;4 0.5 3.5 2;3.5 2 3 1.5];
[row,col]=size(obs1); % el número de líneas de obstáculo es n (row)
% Resolución del algoritmo
epsilon=10;
% Condiciones iniciales
th1=-120;
th2=-120;
cspace=ones(180*90); % se crea un arreglo de unos para el C-space
% Se inicia una figura
figure
for i=0:epsilon:240 % Progreso de th1 de 0 a 90 grados
     for j=0:epsilon:240 % Progrso de th2 de -90 a 90 grados
%        % modelo cinemático directo para obtener las rectas del robot
         [x1,x2,y1,y2] = Cindir(deg2rad(th1),deg2rad(th2),l1,l2);   
         % gráfica del obstáculo
         subplot(1,2,1)
         plot([3 3.5 4 3],[1.5 2 0.5 1.5]);
         title('W-space')
         xlabel('x')
         ylabel('y')
         hold on
         % gráfica del robot
         plot([0 x1 x2],[0 y1 y2],'r');
         axis([-5 5 -5 5])
         pause(0.000000001)
        hold off % se permite reescribir para ver mejor la animación
            for k=1:row % para cada línea del obstáculo 
                % Se llama a la función DetCol para detectar la colisión
                % Primero para el eslabón l1 del robot
                DetColE1=DetCol([0 0;x1 y1],[obs1(k,1) obs1(k,2);obs1(k,3) obs1(k,4)]);
                % Segundo para el eslabón l2 del robot
                DetColE2=DetCol([x1 y1;x2 y2],[obs1(k,1) obs1(k,2);obs1(k,3) obs1(k,4)]);
                % Si alguno de las detecciones de colisión es verdadera, se
                % cambia el uno del C-space a cero
                if DetColE1==1 || DetColE2==1
                    cspace(i+1,j+1)=0;
                    % si hay obstáculo se grafica un punto negro
                    subplot(1,2,2)
                    plot(th1,th2,'.k'); hold on
                    %plot(15,39,'or','LineWidth',3)
                    axis([-200 200 -200 200])
                    title('C-space')
                    xlabel('\theta_1')
                    ylabel('\theta_2')
                    pause(0.00001)
                end
            end
            % se aumenta th2 por un epsilon
         th2=th2+epsilon;
     end  
     % se aumenta th1 por un epsilon y se resetea th2
     th1=th1+epsilon;
     th2=-90;
end