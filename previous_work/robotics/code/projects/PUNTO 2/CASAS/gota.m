function [x,y,z]=gota(Ts,ini,size)
    x=[(ini(1))];
    y=[(ini(2))];
    z=[0];
    a=4;
    t=0:pi/Ts:pi;
    for h=0:9
        for i=1:length(t)
            x_1=a*size*(cos(t(i)))^2+ini(1);
            y_1=a*size*sin(t(i))*(cos(t(i)))^3+ini(2);
            x=[x x_1];
            y=[y y_1];
            z=[z h];
        end
        n_x=(a*size*(cos(1))^2+ini(1)-x_1)/2+x_1;
        n_y=(a*size*sin(1)*(cos(1))^3+ini(2)-y_1)/2+y_1;
        x=[x n_x];
        y=[y n_y];
        z=[z h+1];
    end
end
