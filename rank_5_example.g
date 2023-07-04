# Run using gap -q < rank_5_example.g

deg := 5;;
limit := 10;;
while deg <= limit do
  nr := NrPrimitiveGroups(deg);;
  Print("Degree = ", deg, "\n");
  Print("Number of Primitive Groups of Degree ", deg," = ", nr, "\n");
  for j in [1..nr] do
    Prim := PrimitiveGroup(deg, j);;
    iso := IsomorphismPermGroup(Prim);;
    G := Image(iso, Prim);;
    if IsSolvableGroup(G) and RankAction(G) = 5 then
        Print("Example Found!\n");
        Print("    ", StructureDescription(Prim), "\n");
        stab := Stabilizer(G, 1);;
        Print("    Stabilizer: ", stab, "\n");
        Print("    Orbits: ", "\n");
        for o in Orbits(stab, [1..deg]) do
          Print("        ", o, "\n");
        od;
        Print("\n");
    fi;
  od;
  Print("\n");
  deg := deg + 1;;
od;

QUIT;
