a := [ [ Z(2^2), 0*Z(2), 0*Z(2) ], [ 0*Z(2), Z(2^2), 0*Z(2) ], [ 0*Z(2), 0*Z(2), Z(2^2) ] ];
b := [ [ Z(2)^0, 0*Z(2), 0*Z(2) ], [ 0*Z(2), Z(2)^0, 0*Z(2) ], [ 0*Z(2), 0*Z(2), Z(2)^0 ] ];
hom := GroupHomomorphismByImages(GL(1,4), GL(3,4), GeneratorsOfGroup(GL(1,4)), [a, b]);
