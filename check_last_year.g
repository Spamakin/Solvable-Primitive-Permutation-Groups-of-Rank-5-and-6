SetRecursionTrapInterval(10000);

# q := 2;;
# m := 1;;
# p := 83;;
# k := 1;;
# d := 2;;
# et := "-";;

# Read("/home/kolton/texas_reu/Solvable-Primitive-Permutation-Groups-of-Rank-5/rank-4-gps/Line29grps.g");

QMPKDET := [ # last year's irreducible cases
    [2,1,3,1,2,"-"],
    [2,1,5,1,2,"-"],
    [2,1,7,1,2,"-"],
    [2,1,7,1,2,"+"],
    [2,1,11,1,2,"-"],
    [2,1,23,1,2,"-"],
    [2,2,3,1,4,"-"],
    [3,1,2,2,3,"+"],
    [2,1,3,2,4,"-"],
    [2,1,13,1,2,"-"],
    [2,1,17,1,2,"-"],
    [2,1,19,1,2,"-"],
    [2,1,23,1,2,"+"],
    [2,1,3,3,6,"-"],
    [2,1,29,1,2,"-"],
    [2,1,31,1,2,"-"],
    [2,1,47,1,2,"-"],
    [2,2,3,1,4,"+"],
    [2,2,7,1,4,"-"],
    [3,1,7,1,3,"+"],
    [2,1,5,2,4,"-"],
    [2,1,31,1,2,"+"],
    [2,1,37,1,2,"-"],
    [2,1,41,1,2,"-"],
    [2,1,43,1,2,"-"],
    [2,1,53,1,2,"-"],
    [2,1,59,1,2,"-"],
    [2,1,71,1,2,"-"],
    [2,2,5,1,4,"+"]
];;


for qmpkdet in QMPKDET do
    q := qmpkdet[1];
    m := qmpkdet[2];
    p := qmpkdet[3];
    k := qmpkdet[4];
    d := qmpkdet[5];
    et := qmpkdet[6];


    NumGrps := 0;
    MaxOrder := 0;
    RankOfMax := 0;
    groupDescriptions := [];
    groupList := [];

    GLpk := GL(q^m, p^k);
    GLp := GL(k * q^m, p);
    permpk := IsomorphismPermGroup(GLpk);
    permp := IsomorphismPermGroup(GLp);
    GLpkPerm := Image(permpk,GLpk);
    GLpPerm := Image(permp,GLp);

    # Construct E, the extraspecial subgroup of G_0, as a subgroup of GL(q^m, p^k)
    Extraspecial := ExtraspecialGroup(q^(2*m+1), et);

    # Identify subgroups of GL(q^m, p^k) isomorphic to E
    # There may be more than 1 (?)
    GLpkSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLpkPerm,q)), Representative);
    GLpkSubgroups := Filtered(GLpkSubgroups,x->Order(x) = Order(Extraspecial));
    GLpkSubgroups := Filtered(GLpkSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
    for ExCand in GLpkSubgroups do
        # Calculate normalizer of ExCand in GL(q^m,p^k)
        NE := Normalizer(GLpkPerm, ExCand);

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

        # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
        # TODO: Rewrite into own function + trim using maximal subgroups
        # Conjugacy suffices since conjugate groups will have the same orbit structure
        for G0 in List((ConjugacyClassesSubgroups(N)), Representative) do
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;

            # Requirements:
            #   G0 Solvable
            #   G0 Irreducible
            #   If in B then G0 is primitive matrix group
            #   1 < rank < 5
            if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and 1 < rank and rank < 5 then
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
                        failed := true; #if G0 is iso to any previous group with these parameters, don't count it
                        # Print(StructureDescription(G0), " ISO TO ", StructureDescription(H), "\n\n");
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
                    if Order(G0) > MaxOrder then
                        MaxOrder := Order(G0);
                        RankOfMax := rank;
                    fi;
                    # Print("        q=", String(q), ", m=", String(m), ", p=", String(p), ", k=", String(k), ", d=", String(d), ", et=", et, "\n");
                    # Print("        G_0 = ", structDesc, "\n");
                    # Print("        Order of G_0 = ", Order(G0), "\n");
                    # Print("        Rank = ", rank, "\n");
                    # Print("        E = ", StructureDescription(Ex_in_G0), "\n");
                od;
            fi;
        od;
    od;
    NumGrps := Length(groupList);
    Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n");
    # for desc in groupDescriptions do
    #     Print(desc, "\n");
    # od;
    # Print("\n");
od;
