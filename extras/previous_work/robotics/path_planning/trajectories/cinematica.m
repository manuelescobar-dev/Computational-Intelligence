function [zd,phid]=cinematica(m)
    J1=sym(zeros(size(m,1),3));
    J2=sym(zeros(size(m,1),size(m,1)));
    diff=false;
    for i=1:size(m,1)
        if m(i,1)=="diff"
            diff=true;
            J2(i,i)=m(i,6);
        end
        if m(i,1)=="omni"
            J2(i,i)=m(i,6)*cosd(m(i,5));
        end
        J1(i,:)=[-sind(m(i,3)+m(i,4)+m(i,5)) cosd(m(i,3)+m(i,4)+m(i,5)) m(i,2)*cosd(m(i,4)+m(i,5))];
    end
    E = inv(J2)*J1;
    C1=zeros(size(m,1),3);
    for i=1:size(m,1)
        if m(i,1)=="diff"
            C1(i,:)=[cosd(m(i,3)+m(i,4)) sind(m(i,3)+m(i,4)) m(i,2)*sind(m(i,4))];
        end
        if m(i,1)=="omni"
            C1(i,:)=[0 0 0];
        end
    end
    syms th V w Vx Vy
    R = [cos(th) -sin(th) 0;sin(th) cos(th) 0;0 0 1];
    if diff
        zita = [V;w];
    else
        zita = [Vx;Vy;w];
    end
    S=null(C1);
    zd=R*S*zita;
    phid = E*S*zita;
    disp("J1")
    pretty(vpa(J1,3))
    disp("J2")
    pretty(vpa(J2,3))
    disp("E")
    pretty(vpa(E,3))
    disp("C1")
    pretty(vpa(C1,3))
    disp("S")
    pretty(vpa(S,3))
    disp("Z")
    pretty(vpa(zd,3))
    disp("PHI")
    pretty(vpa(phid,3))
end