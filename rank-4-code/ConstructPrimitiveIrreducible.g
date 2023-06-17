################################################################################
# Possible q, m, p, k combinations that we need to test for B_I case:
# (a) q^m = 3^1, p^k = 4^1 or 7^1
# (b) q^m = 2^1, [p,k] in list below:
# [[3,1],[5,1],[7,1],[3,2],[11,1],[13,1],[17,1],[19,1],[23,1],[5,2],[3,3],[29,1],[31,1],[37,1],[41,1],[43,1],[47,1],[7,2],[53,1],[59,1],[61,1],[67,1],[71,1]]
# (c) q^m = 2^2, p^k = 3^1, 5^1 or 7^1
################################################################################
# 2231 2271

flagE := true;


p := -1;
k := -1;
q := 2; # r
m := 1; # e
d := q^m; # d/a - should be equal to q^m for the B_I case
if q^m = 2 then
  Etype := ["-", "+"];
else if q^m mod 2 <> 0  then
  Etype := [q];
else
  Etype := ["-","+"]; # Need to check both + and - for this
fi;
fi;
# Etype := "+"; # "+" for E+, "-" for E-, q for q odd, must be "-" for q^m = 2 case

<<<<<<< HEAD
for pk in [[3,1],[5,1],[7,1],[3,2],[11,1],[13,1],[17,1],[19,1],[23,1],[5,2],[3,3],[29,1],[31,1],[37,1],[41,1],[43,1],[47,1],[7,2],[53,1],[59,1],[61,1],[67,1],[71,1]] do

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
>>>>>>> 2c545816f3b487c7a2f02b72d2595cc89fc04568
  p := pk[1];
  k := pk[2];

  EMresult := [];
  EMresultId := [];

  for et in Etype do
  if et = "-" then eName := "M"; else eName := "P"; fi;

  GLe := GL(q^m,p^k);
  GLp := GL(d*k,p);
  perme := IsomorphismPermGroup(GLe);
  permp := IsomorphismPermGroup(GLp);
  GLePerm := Image(perme,GLe);
  GLpPerm := Image(permp,GLp);

  # Find the extraspecial subgroup of GL(q^m,p^k)
  GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLePerm,q)), Representative);
  Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
  GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
  GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
  Ex := GLeSubgroups[1];
  # Calculate its normalizer in GL(q^m,p^k)
  NA := Normalizer(GLePerm, Ex);
  NAp := NA;

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


result := [];
resultId := [];
maxOrder := -1;

  # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
  for G in List((ConjugacyClassesSubgroups(N)), Representative) do
    if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p)) then
      G0 := Image(permp, G);
      rank := Size(Orbits(G0)) + 1;
      if rank < 5 and rank > 1 then
<<<<<<< HEAD
  #GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(G,q)), Representative);
 # Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
 # GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
 # GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
 # Ex := GLeSubgroups[1];
 if IsomorphicSubgroups(SylowSubgroup(G,q), Ex) <> [] then
  Print("\n",q," & ",m," & ",p," & ",k," & ",d," & ");
      Print(rank," & ",Order(G0), " & ");
      if flagE then Print("E", et); fi;

  Print(" & ");
 if Order(G0) < 2000 then Print(IdGroup(G0)); fi;

Print(" \\\\ \hline");
      fi;
    fi;  fi;
  od;


if eName = "P" and result <> [] then
  flag := 0;
  for gId in resultId do
  if (gId in EMresultId) = false then flag := 1; Print("!!!", gId, "\n\n"); fi;
  od;
  if flag = 0 then result := []; fi;
fi;

if result <> [] then
result := checkSubgrps(result,d,p,k);

if eName = "M" then EMresult := result; EMresultId := resultId; fi;

OutputLogTo(Concatenation("Line",String(lineCount),"grps", eName, ".g"));
Print("\n \n Line",String(lineCount), "grps", eName, " := List(", result, ", x->Subgroup(GL(",d*k,",",p^k,"),x));\n");
OutputLogTo();
Print("num of grps: ", Length(result));
lineCount := lineCount + 1;
fi;
	od;
od;
=======
Print(N); od;od;

# result := [];
# resultId := [];
# maxOrder := -1;
#
#   # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
#   for G in List((ConjugacyClassesSubgroups(N)), Representative) do
#     if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p)) then
#       G0 := Image(permp, G);
#       rank := Size(Orbits(G0)) + 1;
#       if rank < 5 and rank > 1 then
#    GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(G,q)), Representative);
#   Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
#   GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
#   GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
#   if GLeSubgroups = [] then Print(IdGroup(G)); else
# if Order(G) > 2000 then
# gId := [3000,1];
# maxOrder := Order(G);
# Add(resultId, gId);
# Add(result,GeneratorsOfGroup(G),1);
#
# else
#
# # if IsomorphicSubgroups(SylowSubgroup(G,q), Ex) <> [] then
# gId := IdGroup(G);
# if (gId in resultId) = false then
# Add(resultId, gId);
#
# if Order(G) > maxOrder then maxOrder := Order(G); Add(result,GeneratorsOfGroup(G),1);else Add(result,GeneratorsOfGroup(G)); fi;
# fi;
# fi;
# # fi;
# # Print("\n",q," & ",m," & ",p," & ",k," & ",d," & ");
# #      Print(rank," & ",Order(G0), " & ");
# #      if flagE then Print("E", et); fi;
#
#  # Print(" & ");
# # if Order(G0) < 2000 then Print(IdGroup(G0)); fi;
#
# # Print(" \\\\ \hline");
#   fi;  fi;  fi;
#   od;
#
#
# if eName = "P" and result <> [] then
#   flag := 0;
#   for gId in resultId do
#   if (gId in EMresultId) = false then flag := 1; Print("!!!", gId, "\n\n"); fi;
#   od;
#   if flag = 0 then result := []; fi;
# fi;
#
# if result <> [] then
# result := checkSubgrps(result,d,p,k);
#
# if eName = "M" then EMresult := result; EMresultId := resultId; fi;
#
# OutputLogTo(Concatenation("Line",String(lineCount),"grps", eName, ".g"));
# Print("\n \n Line",String(lineCount), "grps", eName, " := List(", result, ", x->Subgroup(GL(",d*k,",",p^k,"),x));\n");
# OutputLogTo();
# Print("num of grps: ", Length(result));
# lineCount := lineCount + 1;
# fi;
# 	od;
# od;
>>>>>>> 34652862bd5300a956739a65546d6612d67a9624
