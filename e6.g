# for now, e = 6 is its own file

# We are interested in G0 Primitive Solvable <= GL(6, 7);
# By {TODO: Reference} we know that G0 takes the form G2 x G3 where
#   G2 Primitive Solvable <= GL(2, 7);
#   G3 Primitive Solvable <= GL(3, 7);
# and x in this case is the Kronecker product

# Change this to wherever you want to have the output file.
CurrDir := "/home/ec2-user/classification/results";;
# Begin Formatting file
OutputFile := Concatenation(CurrDir, "/line62.g");;
PrintTo(OutputFile, "");;
AppendTo(OutputFile, "Line62Grps := [ \n");;

LinGrp2 := GL(2, 7);;
LinGrp3 := GL(3, 7);;
LinGrp2Cong := List(ConjugacyClassesSubgroups(LinGrp2), Representative);;
LinGrp3Cong := List(ConjugacyClassesSubgroups(LinGrp3), Representative);;
iso := IsomorphismPermGroup(GL(6, 7));;
Total := Length(LinGrp2Cong) * Length(LinGrp3Cong);;
Curr := 0;;

for G2 in LinGrp2Cong do
    Gens2 := GeneratorsOfGroup(G2);;
    for G3 in LinGrp2Cong do
        Curr := Curr + 1;;
        Print("Computing Group ", Curr, " / ", Total, "\n");
        Gens3 := GeneratorsOfGroup(G3);;

        # Compute G via Kronecker Product
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
    od;
od;

AppendTo(OutputFile, "];");;
