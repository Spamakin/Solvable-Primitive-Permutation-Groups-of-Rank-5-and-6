# for now, e = 6 is its own file

# We are interested in G0 Primitive Solvable <= GL(6, 7);
# By {TODO: Reference} we know that G0 takes the form G2 x G3 where
#   G2 Primitive Solvable <= GL(2, 7);
#   G3 Primitive Solvable <= GL(3, 7);
# and x in this case is the Kronecker product

# Change this to wherever you want to have the output file.
CurrDir := "/home/spamakin/projects/research/classification";;
# Begin Formatting file
OutputFile := Concatenation(CurrDir, "/e6_out.g");;
PrintTo(OutputFile, "");;
AppendTo(OutputFile, "LineGrps := [ \n");;

LinGrp2 := GL(2, 7);;
LinGrp3 := GL(3, 7);;
LinGrp2Cong := List(ConjugacyClassesMaximalSubgroups(LinGrp2), Representative);;
iso := IsomorphismPermGroup(GL(6, 7));;

while Length(LinGrp2Cong) > 0 do
    G2 := Remove(LinGrp2Cong);;
    Gens2 := GeneratorsOfGroup(G2);;
    SeenLowRank2 := false;;
    AnyPrimitive2 := false;;
    LinGrp3Cong := List(ConjugacyClassesMaximalSubgroups(LinGrp3), Representative);;
    while Length(LinGrp3Cong) > 0 do
        G3 := Remove(LinGrp3Cong);;
        Gens3 := GeneratorsOfGroup(G3);;
        SeenLowRank3 := false;;
        # compute G via Kronecker Product
        Gens := [];;
        for Pair in Cartesian(Gens2, Gens3) do
            Add(Gens, KroneckerProduct(Pair[1], Pair[2]));;
        od;
        if Size(Gens) = 0 then continue; fi;
        G := Group(Gens);;
        if ((7^6 - 1) / Order(G)) + 1 > 5 then continue; fi;

	      if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(7)) then
            # Compute Rank
            GPerm := Image(iso, G);;
            rank := Size(Orbits(GPerm)) + 1;;
            if rank <= 5 then
                Print("!! FOUND RANK = ", rank, "\n");
                AppendTo(OutputFile,"    ", G, ",\n");;
                SeenLowRank2 := true;;
                SeenLowRank3 := true;;
            fi;
	      fi;

        if IsPrimitiveMatrixGroup(G, GF(7)) then
            AnyPrimitive2 := true;;
            AnyPrimitive3 := true;;
        fi;

        # Add maximal subgroups if small enough
        if SeenLowRank3 or AnyPrimitive3 then
            for Cong in List(ConjugacyClassesMaximalSubgroups(G3), Representative) do
                Add(LinGrp3Cong, Cong);;
            od;
        fi;
    od;

    # Add maximal subgroups if small enough
    if SeenLowRank2 or AnyPrimitive2 then
        for Cong in List(ConjugacyClassesMaximalSubgroups(G2), Representative) do
            Add(LinGrp2Cong, Cong);;
        od;
    fi;
od;

AppendTo(OutputFile, "];");;
