################################################################################
# Possible q, m, p, k combinations that we need to test for B_I case:
# (a) q^m = 3^1, p^k = 4^1 or 7^1
# (b) q^m = 2^1, [p,k] in list below:
# [[3,1],[5,1],[7,1],[3,2],[11,1],[13,1],[17,1],[19,1],[23,1],[5,2],[3,3],[29,1],[31,1],[37,1],[41,1],[43,1],[47,1],[7,2],[53,1],[59,1],[61,1],[67,1],[71,1]]
# (c) q^m = 2^2, p^k = 3^1, 5^1 or 7^1
################################################################################
q := 3; # r
m := 1; # e
d := 3; # d/a - should be equal to q^m for the B_I case
Etype := q; # "+" for E+, "-" for E-, q for q odd, must be "-" for q^m = 2 case

for pk in [[5,2]] do
  p := pk[1];
  k := pk[2];
  Print("\n", "q = ", q, ", m = ", m, ", p = ", p, ", k = ", k, ", d = ", d, ", EType = ", Etype, "\n");

  GLe := GL(q^m,p^k);
  GLp := GL(d*k,p);
  perme := IsomorphismPermGroup(GLe);
  permp := IsomorphismPermGroup(GLp);
  GLePerm := Image(perme,GLe);
  GLpPerm := Image(permp,GLp);

  # Find the extraspecial subgroup of GL(q^m,p^k)
  GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLePerm,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), Etype);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  Ex := GLeSubgroups[1];
  # Calculate its normalizer in GL(q^m,p^k)
  NA := Normalizer(GLePerm, Ex);

  if k = 1 then
    # If k=1, GL(q^m,p^k) = GL(d,p) so no embedding is needed
    N := Normalizer(GLe,PreImage(perme, NA));
  else
    basis := Basis(GF(p^k));
    GLeGens := GeneratorsOfGroup(GLe);
    GLpGens := [];
    for GLeGen in GLeGens do
      Append(GLpGens, [BlownUpMat(basis, GLeGen)]);
    od;
    # Embed NA into GL(d,p)
    embedding := GroupHomomorphismByImages(GLe, GLp, GLeGens, GLpGens);
    NAp := Image(embedding, PreImage(perme, NA));
    # Calculate its normalizer
    N := Normalizer(GLp, NAp);
  fi;

  # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
  grps := [];
  for G in List((ConjugacyClassesSubgroups(N)), Representative) do
    if IsSolvable(G) and IsPrimitiveMatrixGroup(G) then
      G0 := Image(permp, G);
      rank := Size(Orbits(G0)) + 1;
      if rank < 20 and rank > 1 then
        if Length(IsomorphicSubgroups(G, ExtraspecialGroup(q^(2*m+1),Etype))) > 0 then
          Print("Rank = ", rank, ". Group ID = ", IdGroup(G), "\n");
          Add(grps, GeneratorsOfGroup(G), 1);
        fi;
      fi;
    fi;
  od;
od;
Print(grps);
