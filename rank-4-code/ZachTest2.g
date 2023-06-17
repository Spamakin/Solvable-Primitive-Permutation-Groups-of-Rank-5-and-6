################################################################################
# Possible q, m, p, k combinations that we need to test for B_R case:
# q^m = 2^1 in all cases
# (a) d = 4, p^k = 3^1, 5^1, or 7^1
# (b) d = 6, p^k = 3^1
# (c) d = 10, p^k = 3^1
################################################################################
q := 2; # r
m := 1; # e
d := 6; # d/a
b := d/(q^m); # d/(ea) - Should be greater than 1 for the B_R case
Etype := "-"; # "+" for E+, "-" for E-

for pk in [[3,1]] do
  p := pk[1];
  k := pk[2];
  Print("\n", "q = ", q, ", m = ", m, ", p = ", p, ", k = ", k, ", d = ", d, "\n");

  GLe := GL(q^m,p^k);
  GLb := GL(b,p^k);
  GLeb := GL(q^m*b,p^k);
  perme := IsomorphismPermGroup(GLe);
  permb := IsomorphismPermGroup(GLb);
  permeb := IsomorphismPermGroup(GLeb);
  GLePerm := Image(perme,GLe);
  GLbPerm := Image(permb,GLb);
  GLebPerm := Image(permeb,GLeb);

  # Find the extraspecial subgroup of GL(q^m,p^k)
  GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLebPerm,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), Etype);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  Ex := GLeSubgroups[1];

  # As k = 1 in all cases, GL(q^m*b*,p) = GL(q^m*b,p), we don't need to embed NA
  # and can just calculate it's normalizer directly
  NA := Normalizer(GLeb, PreImage(permeb,Ex));
  #N := Normalizer(GLeb, NA);
  Print(Order(NA));
  # Cycle through all maximal subgroups of N, printing data about the solvable,
  # primitive ones of low rank
  for G in MaximalSubgroupClassReps(NA) do # SLOW!! to find all maximal subgroups
    if IsSolvable(G) and IsPrimitiveMatrixGroup(G) then
      G := Image(permeb, G);
      rank := Size(Orbits(G)) + 1;
      if rank < 6 and rank > 1 then
        Print("Rank = ", rank, ". Order = ", Size(G), "\n", "Structure = ");
        Print(StructureDescription(G),"\n");
      fi;
    fi;
  od;
od;
