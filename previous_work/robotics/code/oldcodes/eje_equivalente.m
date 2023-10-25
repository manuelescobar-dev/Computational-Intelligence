function [rot]= angulos_fijos(kx,ky,kz,theta,deg)
    if deg == "deg" 
        v=1-cosd(theta)
        c=cosd(theta)
        s=sind(theta)
    end 
    if deg == "rad" 
        v=1-cos(theta)
        c=cos(theta)
        s=sin(theta)
    end 
    rot=[(kx^2)*v+c kx*ky*v-kz*s kx*kz*v+ky*s;kx*ky*v+kz*s ky*ky*v+c ky*kz*v-kx*s;kx*kz*v-ky*s ky*kz*v+kx*s kz*kz*v+c]
end