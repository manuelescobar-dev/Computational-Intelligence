%Rotacion alrededor de x
function [rot] = rotacion(angulo,eje,deg)
    if deg == "deg"
        if eje == "x"
        rot = [1 0 0;0 cosd(angulo) -sind(angulo);0 sind(angulo) cosd(angulo)];
        end
        if eje == "y"
            rot = [cosd(angulo) 0 sind(angulo);0 1 0;-sind(angulo) 0 cosd(angulo)];
        end
        if eje == "z"
            rot = [cosd(angulo) -sind(angulo) 0;sind(angulo) cosd(angulo) 0;0 0 1];
        end
    end
    if deg == "rad"
        if eje == "x"
        rot = [1 0 0;0 cos(angulo) -sin(angulo);0 sin(angulo) cos(angulo)];
        end
        if eje == "y"
            rot = [cos(angulo) 0 sin(angulo);0 1 0;-sin(angulo) 0 cos(angulo)];
        end
        if eje == "z"
            rot = [cos(angulo) -sin(angulo) 0;sin(angulo) cos(angulo) 0;0 0 1];
        end
    end
end
   
    


