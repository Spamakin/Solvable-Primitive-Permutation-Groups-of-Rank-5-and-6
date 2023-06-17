################################################################################
# Possible q, m, p, k combinations that we need to test for B_R case:
# q^m = 2^1 in all cases
# (a) d = 4, p^k = 3^1, 5^1, or 7^1
# (b) d = 6, p^k = 3^1
# (c) d = 10, p^k = 3^1
################################################################################
q := 2; # r
m := 1; # e
d := 10; # d/a - This code is too slow for the d = 6,10 cases
b := d/(q^m); # d/(ea) - Should be greater than 1 for the B_R case
Etype := "+"; # "+" for E+, "-" for E-

for pk in [[3,1]] do
  p := pk[1];
  k := pk[2];
  Print("\n", "q = ", q, ", m = ", m, ", p = ", p, ", k = ", k, ", d = ", d, "\n");

  GLe := GL(q^m,p^k);
  GLeb := GL(q^m*b,p^k);
  GLdp := GL(d,p);
  GLp := GL(d*k,p);
  perme := IsomorphismPermGroup(GLe);
  permeb := IsomorphismPermGroup(GLeb);
  permdp := IsomorphismPermGroup(GLdp);
  permp := IsomorphismPermGroup(GLp);
  GLePerm := Image(perme,GLe);
  GLebPerm := Image(permeb,GLeb);
  GLdpPerm := Image(permdp, GLdp);

  # Find the extraspecial subgroup of GL(q^m,p^k)
  GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLe,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), Etype);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  
  for ex in GLeSubgroups do Print(Order(ex), "\n"); od;

  if Length(GLeSubgroups) = 1 then
    Ex := GLeSubgroups[1];
  else
    Ex := GLeSubgroups[1];
    Print("\n\n\n you have more than one extraspecial!!!\n\n");
  fi;

  # Embed GL(q^m,p^k) into GL(q^m*b,p^k)
  GLeGens := GeneratorsOfGroup(GLe);
  GLebGens := [];
  for GLeGen in GLeGens do
       Append(GLebGens, [KroneckerProduct(GLeGen, IdentityMat(b,GF(p^k)))]);
  od;
  embedding := GroupHomomorphismByImages(GLe, GLeb, GLeGens, GLebGens);
  Ex := Image(embedding, Ex);
 
  CA := Centralizer(GLdp, Ex);
  CCA := Centralizer(GLdp, CA);
  Print("\n should be the same:", Order(CA), " =? ", Order(GL(b,p)),"\n");

  Print("\n should be the same:", Order(CCA), " =? ", Order(GL(q, p)), "\n"); 
 
  NCCAE := Normalizer(CCA, Ex);

  NA := Subgroup(GL(d,p), Union(GeneratorsOfGroup(CA), GeneratorsOfGroup(NCCAE)));

  N := Normalizer(GLdp, NA);
  
  Print("now we print generators...........");
  Print(GeneratorsOfGroup(N));
  Print("Order of N: "); Print(Order(N));

  # for G in List((ConjugacyClassesSubgroups(N)), Representative) do
  #   if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p^k)) then
  #     G0 := Image(permeb, G);
  #     rank := Size(Orbits(G0)) + 1;
  #     if rank < 5 and rank > 1 then
# #   GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(G,q)), Representative);
 ##  Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
 ##  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
 ##  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
 ##  Ex := GLeSubgroups[1];
 # if IsomorphicSubgroups(SylowSubgroup(G,q), Ex) <> [] then
  # Print("\n",q," & ",m," & ",p," & ",k," & ",d," & ");
  #     Print(rank," & ",Order(G0), " & ");

 # if Order(G0) < 2000 then Print(IdGroup(G0)); fi;

# Print(" \\\\ \hline");
  #     fi;
  #   fi;  fi;
  # od;
 
od;

