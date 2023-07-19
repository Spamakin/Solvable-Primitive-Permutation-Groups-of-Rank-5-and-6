SetRecursionTrapInterval(10000);

# Minimal Cases where this breaks
# Following Notation of [HY23] - [HY23] - Regular orbits of finite primitive solvable groups,the final classification
# [Line Num, q, m, p, k , d]
# e := q^m
# k := a
LineQMPKD := [ # only b=1 cases where e is a prime power
    [1, 2, 1, 3, 1, 2],
    # [2, 2, 1, 3, 2, 2],
];;

Print("\nStarting Unoptimized Version we look at every subgroup up to conjugacy\n\n");

for lqmpkd in LineQMPKD do
    line := lqmpkd[1];
    q := lqmpkd[2];
    m := lqmpkd[3];
    p := lqmpkd[4];
    k := lqmpkd[5];
    d := lqmpkd[6];

    # Type of Extraspecial Group
    for et in ["-","+"] do

        if et = "-" then
            eText := "Plus";
        else
            eText := "Minus";
        fi;

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
        # FIXME: sometimes this filtering is non-unique, why?
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
                        if Order(G0) > MaxOrder then
                            MaxOrder := Order(G0);
                            RankOfMax := rank;
                        fi;
                        Print("!! FOUND RANK = ", rank, "\n");
                    od;
                fi;
            od;
        od;
        NumGrps := Length(groupList);
        Print("Unoptimized version:\n");
        Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n");
    od;
od;


##################################################################################################
##################################################################################################


SetRecursionTrapInterval(10000);

Print("\nStarting Optimized Version we iteratively look at maximal subgroups\n");

for lqmpkd in LineQMPKD do
    line := lqmpkd[1];
    q := lqmpkd[2];
    m := lqmpkd[3];
    p := lqmpkd[4];
    k := lqmpkd[5];
    d := lqmpkd[6];

    # Type of Extraspecial Group
    for et in ["-","+"] do

        if et = "-" then
            eText := "Plus";
        else
            eText := "Minus";
        fi;

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
        # FIXME: sometimes this filtering is non-unique, why?
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
            conjugacyClasses := List((ConjugacyClassesMaximalSubgroups(N)), Representative);
            while (Size(conjugacyClasses) > 0) do
                G0 := Remove(conjugacyClasses);
                G0Perm := Image(permp, G0);
                rank := Size(Orbits(G0Perm)) + 1;

                # Requirements:
                #   G0 Solvable
                #   G0 Irreducible
                #   If in B then G0 is primitive matrix group
                #   1 < rank < 5
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
                        if Order(G0) > MaxOrder then
                            MaxOrder := Order(G0);
                            RankOfMax := rank;
                        fi;
                        Print("!! FOUND RANK = ", rank, "\n");
                    od;
                fi;

                # even if you add all possible maximal groups up to conjugacy without any more filtering, you miss some groups
                conjugacyClasses := Concatenation(conjugacyClasses, List((ConjugacyClassesMaximalSubgroups(G0)), Representative));
            od;
        od;
        NumGrps := Length(groupList);
        Print("Optimized version:\n");
        Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n");
    od;
od;

Print("\nYou'll see that the optimized version misses out on some groups of low rank\n");
