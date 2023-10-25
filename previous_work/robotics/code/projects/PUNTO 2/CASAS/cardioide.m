function [x,y,z]=cardioide(Ts,ini,size)
    x=[(ini(1))];
    y=[(ini(2))];
    z=[0];
    r=1;
    R=1;
    t=0:2*pi/Ts:2*pi;
    for h=0:9
        for i=1:length(t)
            x_1=((R+r)*cos(t(i))-r*cos(t(i)*R/r+t(i)))*size+ini(1);
            y_1=((R+r)*sin(t(i))-r*sin(t(i)*R/r+t(i)))*size+ini(2);
            x=[x x_1];
            y=[y y_1];
            z=[z h];
        end
        n_x=(((R+r)*cos(1)-r*cos(R/r+1))*size+ini(1)-x_1)/2+x_1;
        n_y=(((R+r)*sin(1)-r*sin(R/r+t(i)))*size+ini(2)-y_1)/2+y_1;
        x=[x n_x];
        y=[y n_y];
        z=[z h+1];
    end
end

