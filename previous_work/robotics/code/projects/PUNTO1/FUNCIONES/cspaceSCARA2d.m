function [cspace]=cspaceSCARA2d(d)
    %LA EXPLICACIÓN ES LA MISMA QUE EL cspace3D, entonces mirar cspace3d
    %para ver todas las explicaciones. La unica diferencia es que ya el
    %cspace es en dos dimensiones y de ingresa el valor de d para sacar su
    %cspace en el plano XY para dicha magnitud.
    close all
    % Dimensiones del robot
    l1=300;
    l2=280;
    l3=280;
    r=25;
    rgarra=25;
    % Resolución del algoritmo
    epsilon=10;
    % Condiciones iniciales
    th1=-150;
    th2=-120;
    cspace=zeros(302,242); % se crea un arreglo de unos para el C-space
    cspace(1,:)=1;
    cspace(242,:)=1;
    cspace(:,1)=1;
    cspace(:,302)=1;
    % Se inicia una figura
    figure
    for i=0:epsilon:300 % Progreso de th1 de -150 a 150 grados
         for j=0:epsilon:240 % Progrso de th2 de -120 a 120 grados
    %        % modelo cinemático directo para obtener las rectas del robot
             [x1,x2,x3,y1,y2,y3,z1,z2,z3] = cinematica(th1,th2,d,l1,l2,l3);   
             % gráfica del obstáculo
             if z3<=150
                 if (x3>=(200-rgarra) && x3<=(350+rgarra) && y3<=(-200+rgarra) && y3>=(-210-rgarra)) || (x3>=(200-rgarra) && x3<=(350+rgarra) && y3<=(-340+rgarra) && y3>=(-350-rgarra)) || (x3>=(200-rgarra) && x3<=(210+rgarra) && y3<=(-210-rgarra) && y3>=(-340+rgarra)) || (x3>=(340-rgarra) && x3<=(350+rgarra) && y3<=(-210-rgarra) && y3>=(-340+rgarra))
                    cspace(i+1,j+1)=1;
                    subplot(1,2,2)
                    hold on
                    plot(th1,th2,'.k','Color','b');
                    xlim([-150,150])
                    ylim([-120,120])
                    title('C-space')
                    xlabel('\theta_1')
                    ylabel('\theta_2')
                 end
                 subplot(1,2,1)
                 title('W-space')
                 xlabel('x')
                 ylabel('y')
                 xlim([-600,600])
                 ylim([-600,600])
                 plot([200 350 350 200 200],[-200 -200 -350 -350 -200],'Color','b','LineWidth',2);
                 hold on
                 plot([210 340 340 210 210],[-210 -210 -340 -340 -210],'Color','b','LineWidth',2);
                 if z3<=100
                     subplot(1,2,1)
                     hold on
                     [xc1,yc1]=circle(300,100,r);
                     plot(xc1,yc1,'Color','g','LineWidth',2)
                     if (x3>=(275-rgarra) && x3<=(325+rgarra) && y3>=(75-rgarra) && y3<=(125+rgarra))
                        cspace(i+1,j+1)=1;
                        subplot(1,2,2)
                        hold on
                        plot(th1,th2,'.k','Color','g');
                        xlim([-150,150])
                        ylim([-120,120])
                        title('C-space')
                        xlabel('\theta_1')
                        ylabel('\theta_2')
                     end
                     subplot(1,2,1)
                     hold on
                     [xc2,yc2]=circle(200,100,r);
                     plot(xc2,yc2,'Color','y','LineWidth',2)
                     if (x3>=(175-rgarra) && x3<=(215+rgarra) && y3>=(75-rgarra) && y3<=(125+rgarra))
                        cspace(i+1,j+1)=1;
                        subplot(1,2,2)
                        hold on
                        plot(th1,th2,'.k','Color','y');
                        xlim([-150,150])
                        ylim([-120,120])
                        title('C-space')
                        xlabel('\theta_1')
                        ylabel('\theta_2')
                     end
                     subplot(1,2,1)
                     hold on
                     [xc3,yc3]=circle(300,250,r);
                     plot(xc3,yc3,'Color','c','LineWidth',2)
                     if (x3>=(275-rgarra) && x3<=(325+rgarra) && y3>=(225-rgarra) && y3<=(275+rgarra))
                        cspace(i+1,j+1)=1;
                        subplot(1,2,2)
                        hold on
                        plot(th1,th2,'.k','Color','c');
                        xlim([-150,150])
                        ylim([-120,120])
                        title('C-space')
                        xlabel('\theta_1')
                        ylabel('\theta_2')
                     end
                     subplot(1,2,1)
                     hold on
                     [xc4,yc4]=circle(50,350,r);
                     plot(xc4,yc4,'Color','m','LineWidth',2)
                     if (x3>=(25-rgarra) && x3<=(75+rgarra) && y3>=(325-rgarra) && y3<=(375+rgarra))
                        cspace(i+1,j+1)=1;
                        subplot(1,2,2)
                        hold on
                        plot(th1,th2,'.k','Color','m');
                        xlim([-150,150])
                        ylim([-120,120])
                        title('C-space')
                        xlabel('\theta_1')
                        ylabel('\theta_2')
                     end
                 end
             end
             % gráfica del robot
             subplot(1,2,1)
             plot([0 x1 x2],[0 y1 y2],'r');
             hold on
             scatter(x3,y3,30,'r','filled')
             title('W-space')
             xlabel('x')
             ylabel('y')
             xlim([-600,600])
             ylim([-600,600])
             pause(0.000000001)
             hold off
             th2=th2+epsilon;
         end  
         % se aumenta th1 por un epsilon y se resetea th2
         th1=th1+epsilon;
         th2=-120;
    end
end