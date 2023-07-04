# Run using gap -q < rank_5_example.g

deg := 5;;
limit := 100;;
while deg <= limit do
  nr := NrPrimitiveGroups(deg);;
  Print("deg = ", deg, "\n");
  Print("nr  = ", nr, "\n");
  for j in [1..nr] do
    Prim := PrimitiveGroup(deg, j);;
    iso := IsomorphismPermGroup(Prim);;
    G := Image(iso, Prim);;
    if IsSolvableGroup(G) and RankAction(G) = 5 then
        Print("Example Found!\n");
        Print("    ", StructureDescription(Prim), "\n");
        # stab := Stabilizer(G, 1);;
        # Print("    Stabilizer: ", stab, "\n");
        # Print("    Orbits: ", Orbits(G, [1..deg]), "\n");
        Print("\n");
    fi;
  od;
  Print("\n");
  deg := deg + 1;;
od;

QUIT;
