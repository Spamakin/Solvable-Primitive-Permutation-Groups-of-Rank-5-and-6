###############################################################################
# Possible q, m, p, k combinations that we need to test for B_R case:
# q^m = 2^1 in all cases
# (a) d = 4, p^k = 3^1, 5^1, or 7^1
# (b) d = 6, p^k = 3^1
# (c) d = 10, p^k = 3^1
################################################################################
q := 2; # r
m := 2; # e
d := 8; # d/a - This code is too slow for the d = 6,10 cases
b := d/(q^m); # d/(ea) - Should be greater than 1 for the B_R case
Etype := "-"; # "+" for E+, "-" for E-

for pk in [[3,1]] do
  p := pk[1];
  k := pk[2];
  Print("\n", "q = ", q, ", m = ", m, ", p = ", p, ", k = ", k, ", d = ", d, "\n");

  GLe := GL(q^m,p^k);
  GLeb := GL(q^m*b,p^k);
  perme := IsomorphismPermGroup(GLe);
  permeb := IsomorphismPermGroup(GLeb);
  GLePerm := Image(perme,GLe);
  GLebPerm := Image(permeb,GLeb);

  # Find the extraspecial subgroup of GL(q^m,p^k)
  GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLePerm,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), Etype);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  Ex := PreImage(perme, GLeSubgroups[1]);

  for ex in GLeSubgroups do
    Print("this has order: ", Order(PreImage(perme, ex)), "\n");
  od;

  # Find its normalizer in GL(q^m,p^k)
  NA := Normalizer(GLe, Ex);
  # Embed GL(q^m,p^k) into GL(q^m*b,p^k)
  GLeGens := GeneratorsOfGroup(GLe);
  GLebGens := [];
  for GLeGen in GLeGens do
       Append(GLebGens, [KroneckerProduct(GLeGen, IdentityMat(b,GF(p^k)))]);
  od;
  embedding := GroupHomomorphismByImages(GLe, GLeb, GLeGens, GLebGens);
  NAeb := Image(embedding, NA);
  # Take the second normalizer in GL(q^m*b,p^k)
  N := Normalizer(GLeb, NAeb);
  #Print(Order(N));
  #Print(GeneratorsOfGroup(N));
  #Check every subgroup class of N for the properties we require of G
  for G in List(ConjugacyClassesSubgroups(N), Representative) do # SLOW!!!
    if IsSolvable(G) and IsPrimitiveMatrixGroup(G) then
      G0 := Image(permeb, G);
      rank := Size(Orbits(G0)) + 1;
      if rank <= 5 and rank > 1 then
        Print("Rank = ", rank, ". Order = ", Size(G),"\n");
        if Size(List(IsomorphicSubgroups(G0, ExCand : findall:=false))) > 0 then
            Print("Contains a subgroup iso to E\n");
        else
            Print("Does not contain a subgroup iso to E\n");
        fi;
      fi;
    fi;
  od;
od;