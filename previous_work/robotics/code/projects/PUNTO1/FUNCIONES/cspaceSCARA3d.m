function [cspace]=cspaceSCARA3d()
    close all
    % Dimensiones del robot
    l1=300;
    l2=280;
    l3=280;
    r=25;
    rgarra=25; %Se utiliza para identificar colisiones con los objetos sin tener que asumir que no tiene espesor.
    % Resolución del algoritmo
    epsilon=15; %Epsilon para los thetas
    epsilond=30; %Epsilon para d.
    % Condiciones iniciales
    th1=-150;
    th2=-120;
    d=300; %Comienza en d=300, que corresponde a z=0

    cspace=zeros(302,242,302); % se crea un arreglo de unos para el C-space
    cspace(1,:,:)=1;
    cspace(302,:,:)=1;
    cspace(:,1,:)=1;
    cspace(:,302,:)=1;
    cspace(:,:,1)=1;
    cspace(:,:,302)=1;
    % Se inicia una figura
    figure
    for f=0:epsilond:300 % Progreso de d de 300 a 0 mm
        for i=0:epsilon:300 % Progreso de th1 de -150 a 150 grados
             for j=0:epsilon:240 % Progrso de th2 de -120 a 120 grados
        %        % modelo cinemático directo para obtener los puntos del robot
                 [x1,x2,x3,y1,y2,y3,z1,z2,z3] = cinematica(th1,th2,d,l1,l2,l3);
                 % gráfica del obstáculo
                 if z3<=150 %Si z3 es menor a 150 entonces puede colisionar con la caja.
                     %La ccaja tiene una seccion hueca, entonces se crean
                     %estas condiciones teniendo un cuenta el radio de la
                     %garra  y el espesor de pared.
                     if (x3>=(200-rgarra) && x3<=(350+rgarra) && y3<=(-200+rgarra) && y3>=(-210-rgarra)) || (x3>=(200-rgarra) && x3<=(350+rgarra) && y3<=(-340+rgarra) && y3>=(-350-rgarra)) || (x3>=(200-rgarra) && x3<=(210+rgarra) && y3<=(-210-rgarra) && y3>=(-340+rgarra)) || (x3>=(340-rgarra) && x3<=(350+rgarra) && y3<=(-210-rgarra) && y3>=(-340+rgarra))
                        %Se detecta el obstaculo y se agrega al cspace
                        cspace(i+1,j+1,f+1)=1;
                        subplot(1,2,2)
                        hold on
                        grid on
                        %Se grafica en 3d el cspace.
                        scatter3(th1,th2,d,'.k');
                        xlim([-150,150])
                        ylim([-120,120])
                        zlim([0,300])
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
                     %Grafica la caja en el w-space
                     plot([200 350 350 200 200],[-200 -200 -350 -350 -200],'Color','b','LineWidth',2);
                     hold on
                     plot([210 340 340 210 210],[-210 -210 -340 -340 -210],'Color','b','LineWidth',2);
                     %Si z3 es menor a 100 entonces ya se puede colisionar
                     %con los cilindros tambien.
                     if z3<=100
                         subplot(1,2,1)
                         hold on
                         %Funcion para discretizar un punto en una posicion
                         %de x y y con radio r.
                         [xc1,yc1]=circle(300,100,r);
                         %Grafica el circulo
                         plot(xc1,yc1,'Color','g','LineWidth',2)
                         %Para detectar la colision con los cilindros se
                         %toma la area rectangular de este por facilidad y
                         %ya que no es muy relevante tener tanta precisión.
                         if (x3>=(275-rgarra) && x3<=(325+rgarra) && y3>=(75-rgarra) && y3<=(125+rgarra))
                            cspace(i+1,j+1,f+1)=1;
                            subplot(1,2,2)
                            hold on
                            grid on
                            scatter3(th1,th2,d,'.k');
                            xlim([-150,150])
                            ylim([-120,120])
                            zlim([0,300])
                            title('C-space')
                            xlabel('\theta_1')
                            ylabel('\theta_2')
                         end
                         subplot(1,2,1)
                         hold on
                         [xc2,yc2]=circle(200,100,r);
                         plot(xc2,yc2,'Color','y','LineWidth',2)
                         if (x3>=(175-rgarra) && x3<=(215+rgarra) && y3>=(75-rgarra) && y3<=(125+rgarra))
                            cspace(i+1,j+1,f+1)=1;
                            subplot(1,2,2)
                            hold on
                            grid on
                            scatter3(th1,th2,d,'.k');
                            xlim([-150,150])
                            ylim([-120,120])
                            zlim([0,300])
                            title('C-space')
                            xlabel('\theta_1')
                            ylabel('\theta_2')
                         end
                         subplot(1,2,1)
                         hold on
                         [xc3,yc3]=circle(300,250,r);
                         plot(xc3,yc3,'Color','c','LineWidth',2)
                         if (x3>=(275-rgarra) && x3<=(325+rgarra) && y3>=(225-rgarra) && y3<=(275+rgarra))
                            cspace(i+1,j+1,f+1)=1;
                            subplot(1,2,2)
                            hold on
                            grid on
                            scatter3(th1,th2,d,'.k');
                            xlim([-150,150])
                            ylim([-120,120])
                            zlim([0,300])
                            title('C-space')
                            xlabel('\theta_1')
                            ylabel('\theta_2')
                         end
                         subplot(1,2,1)
                         hold on
                         [xc4,yc4]=circle(50,350,r);
                         plot(xc4,yc4,'Color','m','LineWidth',2)
                         if (x3>=(25-rgarra) && x3<=(75+rgarra) && y3>=(325-rgarra) && y3<=(375+rgarra))
                            cspace(i+1,j+1,f+1)=1;
                            subplot(1,2,2)
                            hold on
                            scatter3(th1,th2,d,'.k');
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
                 % grafica un punto representando el actuador final y su
                 % radio.
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
        % se aumenta th1 por un epsilon y se resetea th2
        d=d-epsilond;
        th1=-150;
    end
end