g1:=[[Z(7)^2,Z(7)^2,Z(7)^0],
     [Z(7)^4,Z(7)^2,Z(7)^4],
     [Z(7)^0,Z(7)^2,Z(7)^2]];
g2:=[[Z(7)^3,Z(7),Z(7)],
     [Z(7)^3,Z(7)^3,Z(7)^5],
     [Z(7),Z(7)^3,Z(7)]];
g3:=[[Z(7)^2,Z(7)^2,Z(7)^2],
     [Z(7)^4,Z(7)^2,Z(7)^0],
     [Z(7)^0,Z(7)^2,Z(7)^4]];
g4:=[[0*Z(7),Z(7)^5,0*Z(7)],
     [Z(7),0*Z(7),0*Z(7)],
     [0*Z(7),0*Z(7),Z(7)^3]];
g5:=[[0*Z(7),0*Z(7),Z(7)^0],
     [Z(7)^0,0*Z(7),0*Z(7)],
     [0*Z(7),Z(7)^0,0*Z(7)]];
g6:=[[Z(7)^0,0*Z(7),0*Z(7)],
     [0*Z(7),Z(7)^2,0*Z(7)],
     [0*Z(7),0*Z(7),Z(7)^4]];
g7:=[[Z(7)^2,0*Z(7),0*Z(7)],
     [0*Z(7),Z(7)^2,0*Z(7)],
     [0*Z(7),0*Z(7),Z(7)^2]];

G1:=Group(g1,g2,g3,g4,g5,g6,g7);

h1:=[[Z(7)^4,Z(7)^0],
     [Z(7)^4,Z(7)]];
h2:=[[Z(7)^3,Z(7)^2],
     [Z(7),0*Z(7)]];
h3:=[[0*Z(7),Z(7)^3],
     [Z(7)^0,0*Z(7)]];
h4:=[[Z(7)^2,Z(7)],
     [Z(7),Z(7)^5]];

G2:=Group(h1,h2,h3,h4);

# KroneckerProduct is how you take tensor prod of matrices
k1:=KroneckerProduct(g1,h1);
k2:=KroneckerProduct(g1,h2);
k3:=KroneckerProduct(g1,h3);
k4:=KroneckerProduct(g2,h1);
k5:=KroneckerProduct(g2,h2);
k6:=KroneckerProduct(g2,h3);
k7:=KroneckerProduct(g3,h1);
k8:=KroneckerProduct(g3,h2);
k9:=KroneckerProduct(g3,h3);
k10:=KroneckerProduct(g4,h1);
k11:=KroneckerProduct(g4,h2);
k12:=KroneckerProduct(g4,h3);
k13:=KroneckerProduct(g5,h1);
k14:=KroneckerProduct(g5,h2);
k15:=KroneckerProduct(g5,h3);
k16:=KroneckerProduct(g6,h1);
k17:=KroneckerProduct(g6,h2);
k18:=KroneckerProduct(g6,h3);
k19:=KroneckerProduct(g7,h1);
k20:=KroneckerProduct(g7,h2);
k21:=KroneckerProduct(g7,h3);


G:=Group(k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20,k21);

vecs:=FullRowSpace(GF(7),6);
