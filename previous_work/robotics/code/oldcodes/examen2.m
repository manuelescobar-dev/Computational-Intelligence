syms sigma beta px py pz
angulos_euler("x","y","z",90,beta,-sigma,"deg")
angulos_fijos("x","y","z",90,sigma,beta,"deg")
rot_trans3("x","y","z",90,sigma,beta,"deg",[px,py,pz],[0,0,0],"euler")
transpose(-angulos_euler("x","y","z",90,beta,-sigma,"deg"))*[px;py;pz]
simplify(inv(transformacion3("x","y","z",90,sigma,beta,"deg",[px,py,pz],"fijos")))

syms t1 t2 t3 t4 t5 t6 t7
T01=transDH(0,0,0,t1)
T12=transDH(-90,83.87,192.5,90+t2)
T23=transDH(90,0,400,t3)
T34=transDH(90,0,168.5,180+t4)
T45=transDH(90,0,400,t5)
T56=transDH(90,0,136.3,180+t6)
T67=transDH(90,0,120,-90+t7)
T78=transDH(0,0,0,180)

T08=T01*T12*T23*T34*T45*T56*T67*T78
simplify(T08)
[  cos((pi*(t7 - 90))/180)*(sin((pi*(t6 + 180))/180)*(sin((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + cos((pi*t1)/180)*cos((pi*(t4 + 180))/180)*sin((pi*(t2 + 90))/180)) - cos((pi*(t6 + 180))/180)*(sin((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180)))) + sin((pi*(t7 - 90))/180)*(cos((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + sin((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180))), cos((pi*(t7 - 90))/180)*(cos((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + sin((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180))) - sin((pi*(t7 - 90))/180)*(sin((pi*(t6 + 180))/180)*(sin((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + cos((pi*t1)/180)*cos((pi*(t4 + 180))/180)*sin((pi*(t2 + 90))/180)) - cos((pi*(t6 + 180))/180)*(sin((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180)))),   cos((pi*(t6 + 180))/180)*(sin((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + cos((pi*t1)/180)*cos((pi*(t4 + 180))/180)*sin((pi*(t2 + 90))/180)) + sin((pi*(t6 + 180))/180)*(sin((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180))), (8387*cos((pi*t1)/180))/100 - (385*sin((pi*t1)/180))/2 + 120*cos((pi*(t6 + 180))/180)*(sin((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) + cos((pi*t1)/180)*cos((pi*(t4 + 180))/180)*sin((pi*(t2 + 90))/180)) - (1363*cos((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)))/10 + (337*cos((pi*t3)/180)*sin((pi*t1)/180))/2 + 120*sin((pi*(t6 + 180))/180)*(sin((pi*t5)/180)*(cos((pi*t3)/180)*sin((pi*t1)/180) + cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180))) - 400*sin((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - (1363*sin((pi*t5)/180)*(cos((pi*(t4 + 180))/180)*(sin((pi*t1)/180)*sin((pi*t3)/180) - cos((pi*t1)/180)*cos((pi*t3)/180)*cos((pi*(t2 + 90))/180)) - cos((pi*t1)/180)*sin((pi*(t2 + 90))/180)*sin((pi*(t4 + 180))/180)))/10 + 400*cos((pi*t1)/180)*sin((pi*(t2 + 90))/180) + (337*cos((pi*t1)/180)*sin((pi*t3)/180)*cos((pi*(t2 + 90))/180))/2 - 400*cos((pi*t1)/180)*cos((pi*(t4 + 180))/180)*sin((pi*(t2 + 90))/180)]


syms theta1 theta2 theta3 theta4 l1 l2 l3 l4 l5
T01=transDH(-90,0,l1,theta1)
T12=transDH(90,0,0,90+theta2)
T23=transDH(0,l2,l3,90+theta3)
T34=transDH(90,0,l4+l5,180+theta4)
T45=transDH(90,0,0,0)



syms theta1 theta2 theta3 theta4 l1 l2 l3 l4 l5
T01=simplify(transDH(-90,0,275.5,theta1))
T12=simplify(transDH(90,0,0,90+theta2))
T23=simplify(transDH(0,410,9.8,90+theta3))
T34=simplify(transDH(90,0,207.3+100,180+theta4))
T45=transDH(90,0,0,0)

T05=simplify(T01*T12*T23*T34*T45)