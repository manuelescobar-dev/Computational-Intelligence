function [trans]= transformacion3(a,b,c,dega,degb,degc,deg,borgP,tipo)
    if tipo == "fijos"
        rot=angulos_fijos(a,b,c,dega,degb,degc,deg);
    end
    if tipo == "euler"
        rot=angulos_euler(a,b,c,dega,degb,degc,deg);
    end
    trans=[rot(1,1) rot(1,2) rot(1,3) borgP(1);rot(2,1) rot(2,2) rot(2,3) borgP(2);rot(3,1) rot(3,2) rot(3,3) borgP(3);0 0 0 1];
end