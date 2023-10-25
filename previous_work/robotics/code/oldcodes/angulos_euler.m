function [rot]= angulos_fijos(a,b,c,dega,degb,degc,deg)
   rot=rotacion(dega,a,deg)*rotacion(degb,b,deg)*rotacion(degc,c,deg);
end