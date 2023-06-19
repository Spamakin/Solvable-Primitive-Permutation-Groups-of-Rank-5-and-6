Line1grps := List(
[ [ [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0 ] ], [ [ Z(3)^0, Z(3) ], [ 0*Z(3), Z(3)^0 ] ],
      [ [ Z(3)^0, Z(3) ], [ Z(3), Z(3) ] ], [ [ Z(3), Z(3) ], [ Z(3), Z(3)^0 ] ],
      [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ] ],
  [ [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ], [ [ 0*Z(3), Z(3) ], [ Z(3)^0, 0*Z(3) ] ],
      [ [ Z(3)^0, Z(3)^0 ], [ Z(3)^0, Z(3) ] ], [ [ 0*Z(3), Z(3) ], [ Z(3)^0, Z(3) ] ] ],
  [ [ [ 0*Z(3), Z(3)^0 ], [ Z(3)^0, 0*Z(3) ] ], [ [ 0*Z(3), Z(3) ], [ Z(3), 0*Z(3) ] ],
      [ [ 0*Z(3), Z(3) ], [ Z(3)^0, 0*Z(3) ] ], [ [ Z(3)^0, Z(3)^0 ], [ Z(3)^0, Z(3) ] ] ],
  [ [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ], [ [ 0*Z(3), Z(3) ], [ Z(3)^0, 0*Z(3) ] ],
      [ [ Z(3)^0, Z(3)^0 ], [ Z(3)^0, Z(3) ] ] ] ], x->Subgroup(GL(2,3),x));

Line2grps := List(
[ [ [ [ Z(5)^3, Z(5)^2 ], [ 0*Z(5), Z(5)^0 ] ], [ [ Z(5)^3, Z(5)^3 ], [ Z(5)^2, Z(5)^0 ] ],
      [ [ Z(5)^2, Z(5)^0 ], [ 0*Z(5), Z(5)^0 ] ], [ [ Z(5), 0*Z(5) ], [ Z(5)^2, Z(5)^3 ] ],
      [ [ Z(5)^2, Z(5)^0 ], [ Z(5)^3, Z(5)^0 ] ], [ [ Z(5)^2, 0*Z(5) ], [ 0*Z(5), Z(5)^2 ] ] ],
  [ [ [ Z(5)^0, 0*Z(5) ], [ Z(5), Z(5)^2 ] ], [ [ Z(5)^2, 0*Z(5) ], [ 0*Z(5), Z(5)^2 ] ],
      [ [ Z(5)^0, Z(5)^2 ], [ 0*Z(5), Z(5)^2 ] ], [ [ Z(5), 0*Z(5) ], [ 0*Z(5), Z(5) ] ],
      [ [ 0*Z(5), Z(5)^0 ], [ Z(5)^2, Z(5)^2 ] ] ],
  [ [ [ Z(5)^2, 0*Z(5) ], [ 0*Z(5), Z(5)^2 ] ], [ [ Z(5)^0, Z(5)^2 ], [ Z(5), Z(5)^2 ] ],
      [ [ Z(5), Z(5)^3 ], [ 0*Z(5), Z(5)^3 ] ], [ [ 0*Z(5), Z(5)^0 ], [ Z(5)^2, Z(5)^2 ] ] ]
 ], x->Subgroup(GL(2,5),x));

G := Line2grps[1];

d := 2;
k := 1;
p := 5;
GLp := GL(d*k,p);
permp := IsomorphismPermGroup(GLp);
G0 := Image(permp, G);
rank := Size(Orbits(G0)) + 1;
Print(rank, "\n");
QUIT;