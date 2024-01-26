function [rot]= angulos_fijos(a,b,c,dega,degb,degc,deg)
   rot=rotacion(degc,c,deg)*rotacion(degb,b,deg)*rotacion(dega,a,deg);
end