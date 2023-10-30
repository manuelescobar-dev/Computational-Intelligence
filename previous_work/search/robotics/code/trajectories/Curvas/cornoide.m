function [x,y,z]=cornoide(Ts,ini,size)
    x=[(ini(1))];
    y=[(ini(2))];
    z=[0];
    a=2;
    t=0:2*pi/Ts:2*pi;
    for h=0:9
        for i=1:length(t)
            x_1=a*cos(t(i))*cos(2*t(i))*size+ini(1);
            y_1=a*sin(t(i))*(2+cos(2*t(i)))*size+ini(2);
            x=[x x_1];
            y=[y y_1];
            z=[z h];
        end
        n_x=(a*cos(1)*cos(2)*size+ini(1)-x_1)/2+x_1;
        n_y=(a*sin(1)*(2+cos(2))*size+ini(2)-y_1)/2+y_1;
        x=[x n_x];
        y=[y n_y];
        z=[z h+1];
    end
end
