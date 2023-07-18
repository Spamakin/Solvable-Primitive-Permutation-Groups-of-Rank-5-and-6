SetRecursionTrapInterval(10000);

LineQMPKD := [ # only irreducible cases where e is a prime power
    [1, 2, 1, 3, 1, 2],
    [2, 2, 1, 3, 2, 2],
    [3, 2, 1, 3, 2, 4],
    [4, 2, 1, 3, 3, 2],
    [5, 2, 1, 3, 3, 6],
    [6, 2, 1, 3, 4, 2],
    [7, 2, 1, 3, 4, 4],
    [8, 2, 1, 3, 4, 8],
    [9, 2, 1, 3, 5, 10],
    [10, 2, 1, 5, 1, 2],
    [11, 2, 1, 5, 2, 2],
    [12, 2, 1, 5, 2, 4],
    [13, 2, 1, 5, 3, 6],
    [14, 2, 1, 7, 1, 2],
    [15, 2, 1, 7, 2, 2],
    [16, 2, 1, 7, 2, 4],
    [17, 2, 1, 11, 1, 2],
    [18, 2, 1, 11, 2, 4],
    [19, 2, 1, 13, 1, 2],
    [20, 2, 1, 13, 2, 4],
    [21, 2, 1, 17, 1, 2],
    [22, 2, 1, 19, 1, 2],
    [23, 2, 1, 23, 1, 2],
    [24, 2, 1, 29, 1, 2],
    [25, 2, 1, 31, 1, 2],
    [26, 2, 1, 37, 1, 2],
    [27, 2, 1, 41, 1, 2],
    [28, 2, 1, 43, 1, 2],
    [29, 2, 1, 47, 1, 2],
    [30, 2, 1, 53, 1, 2],
    [31, 2, 1, 59, 1, 2],
    [32, 2, 1, 61, 1, 2],
    [33, 2, 1, 67, 1, 2],
    [34, 2, 1, 71, 1, 2],
    [35, 2, 1, 73, 1, 2],
    [36, 2, 1, 79, 1, 2],
    [37, 2, 1, 83, 1, 2],
    [38, 2, 1, 89, 1, 2],
    [39, 2, 2, 3, 1, 4],
    [40, 2, 2, 3, 2, 4],
    [41, 2, 2, 3, 2, 8],
    [42, 2, 2, 5, 1, 4],
    [43, 2, 2, 7, 1, 4],
    [44, 2, 2, 11, 1, 4],
    [45, 2, 2, 13, 1, 4],
    # [46, 2, 3, 3, 1, 8],
    # [47, 2, 3, 5, 1, 8],
    # [48, 2, 4, 3, 1, 16],
    [49, 3, 1, 2, 2, 3],
    [50, 3, 1, 2, 2, 6],
    [51, 3, 1, 2, 4, 3],
    [52, 3, 1, 2, 4, 6],
    [53, 3, 1, 2, 4, 12],
    # [54, 3, 1, 2, 6, 18],
    [55, 3, 1, 5, 2, 3],
    [56, 3, 1, 5, 2, 6],
    [57, 3, 1, 7, 1, 3],
    [58, 3, 1, 13, 1, 3],
    [59, 3, 1, 19, 1, 3],
    # [60, 3, 2, 2, 2, 9],
    # [61, 3, 2, 2, 2, 18],
];;


# Change this to wherever you want to have the output file.
CurrDir := "/home/ec2-user/classification/results";;
inc := 0;;

for lqmpkd in LineQMPKD do
    line := lqmpkd[1];
    q := lqmpkd[2];
    m := lqmpkd[3];
    p := lqmpkd[4];
    k := lqmpkd[5];
    d := lqmpkd[6];
    Print("q =", String(q), ", m =", String(m), ", p =", String(p), ", k =", String(k), ", d =", String(d), "\n");

    GLpk := GL(q^m, p^k);
    GLp := GL(k * q^m, p);
    permpk := IsomorphismPermGroup(GLpk);
    permp := IsomorphismPermGroup(GLp);
    GLpkPerm := Image(permpk,GLpk);
    GLpPerm := Image(permp,GLp);
    Print("Computed Permutation Representations of GL(", String(q^m), ", ", String(p^k), ") and GL(", String(k * q^m), ", ", String(p), ")\n");

    for et in ["-","+"] do
        Print("  Computations for Extraspecial Group of type ", et, "\n");
        # Begin Formatting file
        OutputFile := Concatenation(CurrDir, "/lines", String(line), et, ".g");;
        PrintTo(OutputFile, "");;
        AppendTo(OutputFile, "LineGrps := [ \n");;

        NumGrps := 0;
        MaxOrder := 0;
        RankOfMax := 0;
        groupDescriptions := [];
        groupList := [];

        # Construct E, the extraspecial subgroup of G_0, as a subgroup of GL(q^m, p^k)
        Extraspecial := ExtraspecialGroup(q^(2*m+1), et);

        # Identify subgroups of GL(q^m, p^k) isomorphic to E
        GLpkSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLpkPerm,q)), Representative);
        GLpkSubgroups := Filtered(GLpkSubgroups,x->Order(x) = Order(Extraspecial));
        GLpkSubgroups := Filtered(GLpkSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
        # Print("  Number of subgroups of GL(q^m, p^k) isomorphic to Extraspecial found = ", Length(GLpkSubgroups), "\n");
        # FIXME: sometimes this filtering is non-unique, why?
        for ExCand in GLpkSubgroups do
            # Calculate normalizer of ExCand in GL(q^m,p^k)
            NE := Normalizer(GLpkPerm, ExCand);
            Print("    Computed NE\n");

            if k = 1 then
                # If k=1, GL(q^m,p^k) = GL(q^m,p) so no embedding is needed
                N := Normalizer(GLpk,PreImage(permpk, NE));
            else
                basis := Basis(GF(p^k));
                GLpkGens := GeneratorsOfGroup(GLpk);
                GLpGens := [];
                for GLpkGen in GLpkGens do
                    Append(GLpGens, [BlownUpMat(basis, GLpkGen)]);
                od;

                # Embed NE into GL(k * q^m, p)
                embedding := GroupHomomorphismByImagesNC(GLpk, GLp, GLpkGens, GLpGens);
                NEp := Image(embedding, PreImage(permpk, NE));

                # Calculate its normalizer
                N := Normalizer(GLp, NEp);
            fi;
            Print("    Computed N\n");

            # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
            # TODO: Rewrite into own function + trim using maximal subgroups
            # Conjugacy suffices since conjugate groups will have the same orbit structure
            CongClassN := List(ConjugacyClassesMaximalSubgroups(N), Representative);
            while Length(CongClassN) > 0 do
                Print("    Number of Maximal Subgroups Remaining = ", Length(CongClassN), "\n");
                G0 := Remove(CongClassN);
                if Float((p^d - 1) / Size(G0)) + 1 > 5.0 then
                    continue;
                fi;
                G0Perm := Image(permp, G0);
                rank := Size(Orbits(G0Perm)) + 1;
                FoundLowRank := false;

                # Requirements:
                #   G0 Solvable
                #   G0 Irreducible
                #   If in B then G0 is primitive matrix group
                #   rank <= 5
                if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and rank <= 5 then
                    # Get number of subgroups of G0 isomorphic to E

                    copies_of_E := [];
                    for mono in List(IsomorphicSubgroups(G0, ExCand : findall:=false)) do
                        Add(copies_of_E, Image(mono, ExCand));
                    od;

                    # Check if we have any copies of E
                    copies_of_E_unique := Unique(copies_of_E);
                    if Length(copies_of_E) = 0 then
                        continue;
                    fi;
                    failed := false;
                    for H in groupList do
                        if not (IsomorphismGroups(G0, H) = fail) then
                            failed := true;
                        fi;
                    od;
                    if failed then
                        continue;
                    fi;
                    Append(groupList, [G0]);
                    structDesc := StructureDescription(G0);
                    Append(groupDescriptions, [structDesc]);

                    for Ex_in_G0 in copies_of_E_unique do
                        permEx := IsomorphismPermGroup(Ex_in_G0);
                        ImEx := Image(permEx, Ex_in_G0);
                        NumGrps := NumGrps + 1;
                        if Size(G0) > MaxOrder then
                            MaxOrder := Size(G0);
                            RankOfMax := rank;
                        fi;
                        Print("    !! FOUND RANK = ", rank, "\n");
                        AppendTo(OutputFile,"    ", G0, ",\n");;
                        FoundLowRank := true;
                    od;
                fi;

                # Add maximal subgroups of G0 is primitive and if we saw anything of low rank
                #   Subgroup of imprimitive is imprimitive
                #   Subgroups can never decrease rank
                if FoundLowRank and IsPrimitiveMatrixGroup(G0, GF(p)) then
                    for Cong in ConjugacyClassesMaximalSubgroups(G0) do
                        Add(CongClassN, Cong);
                    od;
                fi;
            od;
        od;
        NumGrps := Length(groupList);
        Print("    ", q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n");
    od;
od;

AppendTo(OutputFile, "];");;
