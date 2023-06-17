
for p in [3,5,7,9,11,13,17,19,23,25,27,29,31] do
G := SmallGroup(8,3);
GLp := GL(2,GF(p));
GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLp,2)), Representative);
Extraspecial := G;
GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
Ex := GLeSubgroups[1];
Print(IsPrimitiveMatrixGroup(Normalizer(GLp, Ex)));
od;
