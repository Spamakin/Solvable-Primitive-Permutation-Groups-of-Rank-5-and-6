maxNor := MaximalNormalSubgroups(N);
maxNor := MaximalNormalSubgroups(maxNor[1]);
maxNor := MaximalNormalSubgroups(maxNor[1]);
Niso := IsomorphismFpGroup(N);

for maxnor in maxNor do
  for gg in MaximalSubgroupClassReps(maxnor) do
    if IsSolvable(gg) then
      if IsPrimitiveMatrixGroup(gg) then
        G0 := Image(IsomorphismPermGroup(gg));
        rank := Size(Orbits(G0)) + 1;
        if rank < 5 and rank > 1 then
          Print("Rank = ", rank, ". Order = ", Size(gg), "\n");
        #Print(StructureDescription(G),"\n");
        fi;
      fi;
    fi;
  od;
od;
