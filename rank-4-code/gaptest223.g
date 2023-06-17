# GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GL(2,3),2)), Representative);
# Extraspecial := ExtraspecialGroup(2^3, "-");
# GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
# GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
# Ex := GLeSubgroups[1];
# Print(Ex);
#
# GLeGens := GeneratorsOfGroup(GL(2,3));
# GLebGens := [];
# for GLeGen in GLeGens do
#      Append(GLebGens, [KroneckerProduct(GLeGen, IdentityMat(5,GF(3)))]);
# od;
# embedding := GroupHomomorphismByImages(GL(2,3), GL(10,3), GLeGens, GLebGens);
# Ex := Image(embedding, Ex);

basis := Basis(GF(3^5));
GLeGens := GeneratorsOfGroup(GL(2,3^5));
GLpGens := [];
for GLeGen in GLeGens do
  Append(GLpGens, [BlownUpMat(basis, GLeGen)]);
od;
# Embed NA into GL(d,p)

embedding := GroupHomomorphismByImagesNC(GL(2,3^5), GL(10,3), GLeGens, GLpGens);
G := Image(embedding, GL(2,3^5));
Read("./GapRankGrps/Line33grpsM.g");
H := LineTwo4grps[1];
#Print(Order(GL(2,3^5)));
Print(IsSubgroup(G,H));
