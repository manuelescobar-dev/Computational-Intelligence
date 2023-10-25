function [k] = normalizar(kx,ky,kz)
    mag=sqrt((kx^2)+(ky^2)+(kz^2));
    k=[kx/mag;ky/mag;kz/mag];
end