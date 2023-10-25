function [punto]=rot_trans_eje(kx,ky,kz,theta,deg,borgP,bP)
    punto=transformacion_eje(kx,ky,kz,theta,deg,borgP)*[bP(1);bP(2);bP(3);1];
    punto=[punto(1);punto(2);punto(3)];
end