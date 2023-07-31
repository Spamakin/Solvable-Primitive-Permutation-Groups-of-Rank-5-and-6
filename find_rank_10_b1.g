LineQMPKD := [ # only cases where b = 1
    [1, 2, 1, 3, 1, 2],
    [2, 2, 1, 3, 2, 4],
    [3, 2, 1, 3, 3, 6],
    [4, 2, 1, 3, 4, 8],
    [5, 2, 1, 3, 5, 10],
    [6, 2, 1, 3, 6, 12],
    [7, 2, 1, 5, 1, 2],
    [8, 2, 1, 5, 2, 4],
    [9, 2, 1, 5, 3, 6],
    [10, 2, 1, 5, 4, 8],
    [11, 2, 1, 7, 1, 2],
    [12, 2, 1, 7, 2, 4],
    [13, 2, 1, 7, 3, 6],
    [14, 2, 1, 11, 1, 2],
    [15, 2, 1, 11, 2, 4],
    [16, 2, 1, 13, 1, 2],
    [17, 2, 1, 13, 2, 4],
    [18, 2, 1, 17, 1, 2],
    [19, 2, 1, 17, 2, 4],
    [20, 2, 1, 19, 1, 2],
    [21, 2, 1, 19, 2, 4],
    [22, 2, 1, 23, 1, 2],
    [23, 2, 1, 29, 1, 2],
    [24, 2, 1, 31, 1, 2],
    [25, 2, 1, 37, 1, 2],
    [26, 2, 1, 41, 1, 2],
    [27, 2, 1, 43, 1, 2],
    [28, 2, 1, 47, 1, 2],
    [29, 2, 1, 53, 1, 2],
    [30, 2, 1, 59, 1, 2],
    [31, 2, 1, 61, 1, 2],
    [32, 2, 1, 67, 1, 2],
    [33, 2, 1, 71, 1, 2],
    [34, 2, 1, 73, 1, 2],
    [35, 2, 1, 79, 1, 2],
    [36, 2, 1, 83, 1, 2],
    [37, 2, 1, 89, 1, 2],
    [38, 2, 1, 97, 1, 2],
    [39, 2, 1, 101, 1, 2],
    [40, 2, 1, 103, 1, 2],
    [41, 2, 1, 107, 1, 2],
    [42, 2, 1, 109, 1, 2],
    [43, 2, 1, 113, 1, 2],
    [44, 2, 1, 127, 1, 2],
    [45, 2, 1, 131, 1, 2],
    [46, 2, 1, 137, 1, 2],
    [47, 2, 1, 139, 1, 2],
    [48, 2, 1, 149, 1, 2],
    [49, 2, 1, 151, 1, 2],
    [50, 2, 1, 157, 1, 2],
    [51, 2, 1, 163, 1, 2],
    [52, 2, 1, 167, 1, 2],
    [53, 2, 1, 173, 1, 2],
    [54, 2, 1, 179, 1, 2],
    [55, 2, 1, 181, 1, 2],
    [56, 2, 1, 191, 1, 2],
    [57, 2, 1, 193, 1, 2],
    [58, 2, 1, 197, 1, 2],
    [59, 2, 1, 199, 1, 2],
    [60, 2, 2, 3, 1, 4],
    [61, 2, 2, 3, 2, 8],
    [62, 2, 2, 5, 1, 4],
    [63, 2, 2, 5, 2, 8],
    [64, 2, 2, 7, 1, 4],
    [65, 2, 2, 11, 1, 4],
    [66, 2, 2, 13, 1, 4],
    [67, 2, 2, 17, 1, 4],
    [68, 2, 2, 19, 1, 4],
    [69, 2, 3, 3, 1, 8],
    [70, 2, 3, 5, 1, 8],
    [71, 2, 4, 3, 1, 16],
    [72, 3, 1, 2, 2, 6],
    [73, 3, 1, 2, 4, 12],
    [74, 3, 1, 2, 6, 18],
    [75, 3, 1, 5, 2, 6],
    [76, 3, 1, 7, 1, 3],
    [77, 3, 1, 7, 2, 6],
    [78, 3, 1, 13, 1, 3],
    [79, 3, 1, 19, 1, 3],
    [80, 3, 1, 31, 1, 3],
    [81, 3, 1, 37, 1, 3],
    [82, 3, 2, 2, 2, 18],
];;


# CHANGE THIS TO THE DIRECTORY YOU WANT TO SAVE STUFF IN
OutputDirr := "/home/ec2-user/classification/10_results";;

for lqmpkd in LineQMPKD do
    line := lqmpkd[1];
    q := lqmpkd[2];
    m := lqmpkd[3];
    p := lqmpkd[4];
    k := lqmpkd[5];
    d := lqmpkd[6];

    Print("Computing permutation representations for GL(q^m, p^k) and GL(k * q^m, p)\n");
    GLpk := GL(q^m, p^k);
    GLp := GL(k * q^m, p);
    permpk := IsomorphismPermGroup(GLpk);
    permp := IsomorphismPermGroup(GLp);
    GLpkPerm := Image(permpk,GLpk);
    GLpPerm := Image(permp,GLp);

    # for et in ["+"] do
    for et in ["-"] do
    # for et in ["+","-"] do

        Print("q = ", String(q), ", m = ", String(m), ", p = ", String(p), ", k = ", String(k), ", d = ", String(d), ", et = ", et, "\n");
        OutputFile := Concatenation(OutputDirr, "/line", String(line), et, ".g");
        PrintTo(OutputFile, "");;
        if et = "-" then
            eText := "Minus";
        else
            eText := "Plus";
        fi;
        AppendTo(OutputFile, Concatenation("Line", String(line), eText, "Grps := [ \n"));

        NumGrps := 0;
        MaxOrder := 0;
        RankOfMax := 0;
        groupList := [];

        Print("  Searching for copies of E\n");
        # Construct E, the extraspecial subgroup of G_0, as a subgroup of GL(q^m, p^k)
        Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
        R := IrreducibleRepresentations(Extraspecial, GF(p^k));
        R := Filtered(R, x -> Degree(Image(x)) = q^m);
        R := [R[1]];
        ExCand := Image(permpk, Image(R[1]));

        Print("  Computing NE\n");
        NE := Normalizer(GLpkPerm, ExCand);

        Print("  Computing N\n");
        if k = 1 then
            # If k=1, GL(q^m,p^k) = GL(q^m,p) so no embedding is needed
            N := Normalizer(GLpk,PreImage(permpk, NE));
        else
            Print("  k > 1\n");
            Print("  Computing generators of GL(q^m, p^k)\n");
            basis := Basis(GF(p^k));
            GLpkGens := GeneratorsOfGroup(GLpk);
            GLpGens := [];
            for GLpkGen in GLpkGens do
                Append(GLpGens, [BlownUpMat(basis, GLpkGen)]);
            od;

            Print("  Computing embedding of NE into GL(k * q^m, p)\n");
            embedding := GroupHomomorphismByImagesNC(GLpk, GLp, GLpkGens, GLpGens);
            NEp := Image(embedding, PreImage(permpk, NE));

            N := Normalizer(GLp, NEp);
        fi;

        # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
        # Iteratively take maximal subgroups to save memory
        CongClassesN := [N];
        while Length(CongClassesN) > 0 do
            G0 := Remove(CongClassesN);
            Print("  Checking subgroup of order ", Order(G0), "\n");

            # Compute rank
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;

            # Requirements:
            #   G0 Solvable
            #   G0 Irreducible
            #   If in B then G0 is primitive matrix group
            #   rank <= 10
            if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and rank = 10 then
                Print("    Checking if we've seen G0 before\n");
                failed := false;
                for H in groupList do
                    HPerm := Image(permp, H);
                    prevRank := Size(Orbits(HPerm)) + 1;
                    if (rank = prevRank) and (IsomorphismGroups(G0, H) <> fail) then
                        failed := true;
                    fi;
                od;
                if failed then continue; fi;
                
                Append(groupList, [G0]);

                Print("    Checking if E is a subgroup of G0\n");
                Cons := ExactSizeConsiderFunction(q^(2*m+1));
                SubGrps := SubgroupsSolvableGroup(G0 : consider:=Cons);
                Found := false;
                for SubGrp in SubGrps do
                    if not Found and IsomorphismGroups(Extraspecial, SubGrp) <> fail then
                        Found := true;
                    fi;
                od;
                if not Found then continue; fi;


                NumGrps := NumGrps + 1;
                if Order(G0) > MaxOrder then
                    MaxOrder := Order(G0);
                    RankOfMax := rank;
                fi;
                Print("    !! FOUND RANK = ", rank, "\n");
                AppendTo(OutputFile,"    ", G0, ",\n");;
            fi;

            # Subgroups of imprimitive groups are imprimitive
            # Subgroups must have higher rank,
            #   so if rank(G0) >= 7 then the subgroups have rank >= 7
            if IsPrimitiveMatrixGroup(G0) and rank <= 10 then
                Print("    Searching for maximal subgroups\n");
                CongClassesG0 := List(ConjugacyClassesMaximalSubgroups(G0), Representative);
                for Cong in CongClassesG0 do
                    Add(CongClassesN, Cong);
                od;
            fi;
        od;
        Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n\n\n");
        AppendTo(OutputFile, "];\n\n");;
    od;
od;

