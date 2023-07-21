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

for lqmpkd in LineQMPKD do
    line := lqmpkd[1];
    q := lqmpkd[2];
    m := lqmpkd[3];
    p := lqmpkd[4];
    k := lqmpkd[5];
    d := lqmpkd[6];

    Print("Computing Permutation Representations for GL(q^m, p^k) and GL(k * q^m, p)...\n");
    GLpk := GL(q^m, p^k);
    GLp := GL(k * q^m, p);
    permpk := IsomorphismPermGroup(GLpk);
    permp := IsomorphismPermGroup(GLp);
    GLpkPerm := Image(permpk,GLpk);
    GLpPerm := Image(permp,GLp);
    Print("Computed Permutation Representations for GL(q^m, p^k) and GL(k * q^m, p)\n");

    # for et in ["+"] do
    # for et in ["-"] do
    for et in ["-","+"] do

        Print("q = ", String(q), ", m = ", String(m), ", p = ", String(p), ", k = ", String(k), ", d = ", String(d), ", et = ", et, "\n");
        OutputFile := Concatenation("/home/ec2-user/classification/one_E_results/line", String(line), et, ".g");;
        PrintTo(OutputFile, "");;
        if et = "-" then
            eText := "Minus";
        else
            eText := "Plus";
        fi;
        AppendTo(OutputFile, Concatenation("Line", String(line), eText, "Grps := [ \n"));;

        NumGrps := 0;
        MaxOrder := 0;
        RankOfMax := 0;
        groupList := [];

        # Construct E, the extraspecial subgroup of G_0, as a subgroup of GL(q^m, p^k)
        Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
	
	      Print("  Searching for Copies of E...\n");
        # Identify subgroups of GL(q^m, p^k) isomorphic to E
        # There may be more than 1 (?)
        GLpkSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLpkPerm,q)), Representative);
        GLpkSubgroups := Filtered(GLpkSubgroups,x->Order(x) = Order(Extraspecial));
        GLpkSubgroups := Filtered(GLpkSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
        Print("  Constructed Candidate Subgroups Isomorphic to E\n");
        Print("  Number of Candidates = ", Length(GLpkSubgroups), "\n");

        # TEST, take only the first one
        if Length(GLpkSubgroups) > 0 then
            GLpkSubgroups :=  [GLpkSubgroups[1]];
        fi;

        # FIXME: sometimes this filtering is non-unique, why?
        for ExCand in GLpkSubgroups do
            NE := Normalizer(GLpkPerm, ExCand);
            Print("  Computed NE\n");

            if k = 1 then
                # If k=1, GL(q^m,p^k) = GL(q^m,p) so no embedding is needed
                N := Normalizer(GLpk,PreImage(permpk, NE));
            else
		            Print("  k > 1\n");
                basis := Basis(GF(p^k));
                GLpkGens := GeneratorsOfGroup(GLpk);
		            Print("  Computed Generators of GL(q^m, p^k)\n");
                GLpGens := [];
                for GLpkGen in GLpkGens do
                    Append(GLpGens, [BlownUpMat(basis, GLpkGen)]);
                od;
		            Print("  Computed Generators of GL(k * q^m, p)\n");

                embedding := GroupHomomorphismByImagesNC(GLpk, GLp, GLpkGens, GLpGens);
                NEp := Image(embedding, PreImage(permpk, NE));
		            Print("  Computed Embedding of NE into GL(k * q^m, p)\n");

                N := Normalizer(GLp, NEp);
            fi;
            Print("  Computed N\n");

            # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
            # Conjugacy suffices since conjugate groups will have the same orbit structure
            CongClassesN := [N];
            while Length(CongClassesN) > 0 do
                G0 := Remove(CongClassesN);		

                G0Perm := Image(permp, G0);
                rank := Size(Orbits(G0Perm)) + 1;

                # Requirements:
                #   G0 Solvable
                #   G0 Irreducible
                #   If in B then G0 is primitive matrix group
                #   rank <= 5
                if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and rank <= 5 then
                    # Check if E is a subgroup of G0
                    copies_of_E := [];
                    for mono in List(IsomorphicSubgroups(G0, ExCand : findall:=false)) do
                        Add(copies_of_E, Image(mono, ExCand));
                    od;
                    copies_of_E_unique := Unique(copies_of_E);
                    if Length(copies_of_E) = 0 then
                        continue;
                    fi;

                    failed := false;
                    for H in groupList do
                        if not (IsomorphismGroups(G0, H) = fail) then
                            failed := true;
                            # Print(StructureDescription(G0), " ISO TO ", StructureDescription(H), "\n\n");
                        fi;
                    od;
                    if failed then
                        continue;
                    fi;
                    Append(groupList, [G0]);

                    # TODO: Do we even need this?
                    for Ex_in_G0 in copies_of_E_unique do
                        NumGrps := NumGrps + 1;
                        if Order(G0) > MaxOrder then
                            MaxOrder := Order(G0);
                            RankOfMax := rank;
                        fi;
                        Print("    !! FOUND RANK = ", rank, "\n");
                        AppendTo(OutputFile,"    ", G0, ",\n");;
                    od;
                fi;

                if IsPrimitiveMatrixGroup(G0) and rank <= 5 then
                    CongClassesG0 := List(ConjugacyClassesMaximalSubgroups(G0), Representative);
                    for Cong in CongClassesG0 do
                        Add(CongClassesN, Cong);
                    od;
                fi;
            od;
        od;
        NumGrps := Length(groupList);
        Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n\n\n");
        AppendTo(OutputFile, "];\n\n");;
    od;
od;
