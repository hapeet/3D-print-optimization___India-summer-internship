function vertex = ROTATE_gm(V, indice, angle)
   

    if(indice==1)
        Rx = [ 1,           0,              0 ;
               0,           cos(angle),     -sin(angle);
               0,           sin(angle),     cos(angle) ];
           vertex = V*Rx;
    end
    if(indice==2)
        Ry = [cos(angle),   0,              sin(angle) ;
              0,            1,              0 ;
              -sin(angle),  0,              cos(angle) ];
        vertex = V*Ry;

    end
    if(indice==3)
        Rz = [ cos(angle),  -sin(angle),    0 ;
              sin(angle),   cos(angle),     0 ;
              0,            0,              1 ];
           vertex = V*Rz;
    end
end 