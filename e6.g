# for now, e = 6 is its own file

# We are interested in G0 Primitive Solvable <= GL(6, 7);
# By {TODO: Reference} we know that G0 takes the form G2 x G3 where
#   G2 Primitive Solvable <= GL(2, 7);
#   G3 Primitive Solvable <= GL(3, 7);
# and x in this case is the Kronecker product

# Change this to wherever you want to have the output file.
CurrDir := "/home/ec2-user/classification";;
# Begin Formatting file
OutputFile := Concatenation(CurrDir, "/e6_out.g");;
PrintTo(OutputFile, "");;
AppendTo(OutputFile, "LineGrps := [ \n");;


LinGrp2 := GL(2, 7);;
LinGrp2Cong := List(ConjugacyClassesSubgroups(LinGrp2), Representative);;
Print("Computed Conjugacy Classes of Subgroups of GL(2, 7)\n");
LinGrp3 := GL(3, 7);;
LinGrp3Cong := List(ConjugacyClassesSubgroups(LinGrp3), Representative);;
Print("Computed Conjugacy Classes of Subgroups of GL(3, 7)\n");

for G2 in LinGrp2Cong do
    if Size(G2) = 0 then continue; fi;
    Gens2 := GeneratorsOfGroup(G2);;
    for G3 in LinGrp3Cong do
        if Size(G3) = 0 then continue; fi;
        Gens3 := GeneratorsOfGroup(G3);;
        # compute G via Kronecker Product
        Gens := [];;
        for Pair in Cartesian(Gens2, Gens3) do
            Add(Gens, KroneckerProduct(Pair[1], Pair[2]));;
        od;
        if Size(Gens) = 0 then continue; fi;
        G := Group(Gens);;
        
	if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(7)) then
            # Compute Rank
            GPerm := Image(IsomorphismPermGroup(G), G);;
            rank := Size(Orbits(GPerm)) + 1;;
            if rank < 5 then
                Print("!! FOUND RANK = ", rank, "\n");
                AppendTo(OutputFile,"    ", G, ",\n");;
            fi;
	fi;
    od;
od;

# # We only care about G2, G3 up to conjugacy
# while Length(LinGrp2Cong) > 0 do
#     Print(Length(LinGrp2Cong), "\n");
#     G2 := Remove(LinGrp2Cong);;
#     SeenLowRank := false;;
#     Gens2 := GeneratorsOfGroup(G2);;
# 
#     LinGrp3Cong := List(ConjugacyClassesMaximalSubgroups(LinGrp3), Representative);;
#     while Length(LinGrp3Cong) > 0 do
#         Print("    ", Length(LinGrp3Cong), "\n");
#         G3 := Remove(LinGrp3Cong);;
#         MaxRankSeen := 0;;
#         Gens3 := GeneratorsOfGroup(G3);;
# 
#         # compute G via Kronecker Product
#         Gens := [];;
#         for Pair in Cartesian(Gens2, Gens3) do
#               Add(Gens, KroneckerProduct(Pair[1], Pair[2]));;
#         od;
#         G := Group(Gens);;
#         
# 	if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(7)) then
#             # Compute Rank
#             GPerm := Image(IsomorphismPermGroup(G), G);;
#             rank := Size(Orbits(GPerm)) + 1;;
#             MaxRankSeen := Maximum(MaxRankSeen, rank);;
#             if rank < 5 then
#                 Print("!! FOUND RANK = ", rank, "\n");
#                 AppendTo(OutputFile,"    ", G, ",\n");;
#             fi;
# 	    if rank <= 4 then
#                 SeenLowRank := true;
# 	    fi;
# 	fi;
# 
#         # Determine if we want to enumerate subgroups of G3
#         #   Subgroups of imprimitive groups are imprimitive
#         #   Rank must get larger as we check subgroups
#         if IsPrimitiveMatrixGroup(G) and MaxRankSeen < 5 then
#             for Cong in List(ConjugacyClassesMaximalSubgroups(G3), Representative) do
#                 Add(LinGrp3Cong, Cong);;
#             od;
#         fi;
#     od; 
#           
#     # Determine if we want to enumerate subgroups of G2
#     #   Rank must get larger as we check subgroups
#     if SeenLowRank then
#         for Cong in List(ConjugacyClassesMaximalSubgroups(G2), Representative) do
#             Add(LinGrp3Cong, Cong);;
#         od;
#     fi;
# od;

AppendTo(OutputFile, "];");;
