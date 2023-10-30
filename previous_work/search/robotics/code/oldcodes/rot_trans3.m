function [punto]=rot_trans3(a,b,c,dega,degb,degc,deg,borgP,bP,tipo)
    punto=transformacion3(a,b,c,dega,degb,degc,deg,borgP,tipo)*[bP(1);bP(2);bP(3);1];
    punto=[punto(1);punto(2);punto(3)]
end