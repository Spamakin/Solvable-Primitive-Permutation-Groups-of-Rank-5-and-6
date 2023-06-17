################################################################################
# Possible q, m, p, k combinations that we need to test for B_I case:
# (a) q^m = 3^1, p^k = 4^1 or 7^1
# (b) q^m = 2^1, [p,k] in list below:
# [[3,1],[5,1],[7,1],[3,2],[11,1],[13,1],[17,1],[19,1],[23,1],[5,2],[3,3],[29,1],[31,1],[37,1],[41,1],[43,1],[47,1],[7,2],[53,1],[59,1],[61,1],[67,1],[71,1]]
# (c) q^m = 2^2, p^k = 3^1, 5^1 or 7^1
################################################################################
# 2231 2271



p := -1;
k := -1;
q := 2; # r
m := 1; # e
d := 4; # d/a - should be equal to q^m for the B_I case
b := d/(q^m);
if q^m = 2 then
  Etype := ["-"];
else if q^m mod 2 <> 0  then
  Etype := [q];
else
  Etype := ["-"]; # Need to check both + and - for this
fi;
fi;
# Etype := "+"; # "+" for E+, "-" for E-, q for q odd, must be "-" for q^m = 2 case

lineCount := 32;
PK := [[5,1]];
Etype := "-";
eName := "M";

checkSubgrps := function(gens,d,p,k);
  checked := [gens[1]];
  maxGroup := Subgroup(GL(d*k,p), gens[1]);
  i := 2;
  while i <= Length(gens) do
    current := Subgroup(GL(d*k,p), gens[i]);
    if IsSubgroup(maxGroup, current) = false then
      if Order(current) < 2000 then Print(IdGroup(current), " is not a subgroup of maximal one!"); fi;
    else Add(checked, gens[i]); fi;
    i := i + 1;
  od;
  return checked;
end;

for pk in PK do
  p := pk[1];
  k := pk[2];

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

result := [];
resultId := [];
maxOrder := -1;

  # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
  for G in List((ConjugacyClassesSubgroups(N)), Representative) do
    if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p)) then
      G0 := Image(permp, G);
      rank := Size(Orbits(G0)) + 1;
      if rank < 5 and rank > 1 then
   GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(G,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), Etype);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  if GLeSubgroups = [] then Print(IdGroup(G)); else
if Order(G) > 2000 then
gId := [3000,1];
maxOrder := Order(G);
Add(resultId, gId);
Add(result,GeneratorsOfGroup(G),1);

else
 
# if IsomorphicSubgroups(SylowSubgroup(G,q), Ex) <> [] then
gId := IdGroup(G);
if (gId in resultId) = false then
Add(resultId, gId);

if Order(G) > maxOrder then maxOrder := Order(G); Add(result,GeneratorsOfGroup(G),1);else Add(result,GeneratorsOfGroup(G)); fi;
fi;
fi;
# fi;
# Print("\n",q," & ",m," & ",p," & ",k," & ",d," & ");
#      Print(rank," & ",Order(G0), " & ");
#      if flagE then Print("E", et); fi;

 # Print(" & ");
# if Order(G0) < 2000 then Print(IdGroup(G0)); fi;      

# Print(" \\\\ \hline");
  fi;  fi;  fi;
  od;

if result <> [] then
result := checkSubgrps(result,d,p,k);

OutputLogTo(Concatenation("Line",String(lineCount),"grps", eName, ".g"));
Print("\n \n Line",String(lineCount), "grps", eName, " := List(", result, ", x->Subgroup(GL(",d*k,",",p^k,"),x));\n");
OutputLogTo();
Print("num of grps: ", Length(result));
lineCount := lineCount + 1;
fi;
od;
