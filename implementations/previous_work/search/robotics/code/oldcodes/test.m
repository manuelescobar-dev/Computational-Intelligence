punto=rot_trans(30,"z","deg",[10,5,0],[3,7,0])
rot_trans(65,"y","deg",[23,8,1],[2,4,6])

rot_trans3("x","y","z",45,60,75,"deg",[20,10,5],[5,3,4],"fijos")
angulos_fijos("x","x","z",0,30,30,"deg")

%EJE EQUIVALENTE
k=normalizar(10,2,4)
transformacion_eje(k(1),k(2),k(3),50,"deg",[4,3,8])
rot_trans_eje(k(1),k(2),k(3),50,"deg",[4,3,8],[1,2,3])