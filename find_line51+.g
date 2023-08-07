LineQMPKD := [ # only cases where b = 1
    [51, 3, 2, 2, 2, 18]  # For some reason, et "+" here takes significantly longer than every other parameter
];;


# CHANGE THIS TO THE DIRECTORY YOU WANT TO SAVE STUFF IN
OutputDirr := "/home/spamakin/projects/research/classification/results";;

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

    for et in ["+"] do

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

        # Cycle through all subgroups of GLp, printing data about the solvable, primitive ones of low rank
        # Iteratively take maximal subgroups to save memory
        CongClassesN := [GLp];
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
            #   rank <= 6
            if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and rank <= 6 then
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
            if IsPrimitiveMatrixGroup(G0) and rank <= 6 then
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

