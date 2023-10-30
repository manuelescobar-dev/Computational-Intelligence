function [trans]= transformacion(angulo,eje,deg,borgP)
    rot=rotacion(angulo,eje,deg);
    trans=[rot(1,1) rot(1,2) rot(1,3) borgP(1);rot(2,1) rot(2,2) rot(2,3) borgP(2);rot(3,1) rot(3,2) rot(3,3) borgP(3);0 0 0 1];
end