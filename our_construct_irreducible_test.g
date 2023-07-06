SetRecursionTrapInterval(10000);

# q := 2;;
# m := 1;;
# p := 83;;
# k := 1;;
# d := 2;;
# et := "-";;

QMPKD := [ # only irreducible cases where e is a prime power
    [2,1,3,1,2],
    [2,1,3,2,2],
    [2,1,3,2,4],
    [2,1,3,3,2],
    [2,1,3,3,6],
    [2,1,3,4,2],
    [2,1,3,4,4],
    [2,1,3,4,8],
    [2,1,3,5,10],
    [2,1,5,1,2],
    [2,1,5,2,2],
    [2,1,5,2,4],
    [2,1,5,3,6],
    [2,1,7,1,2],
    [2,1,7,2,2],
    [2,1,7,2,4],
    [2,1,11,1,2],
    [2,1,11,2,4],
    [2,1,13,1,2],
    [2,1,13,2,4],
    [2,1,17,1,2],
    [2,1,19,1,2],
    [2,1,23,1,2],
    [2,1,29,1,2],
    [2,1,31,1,2],
    [2,1,37,1,2],
    [2,1,41,1,2],
    [2,1,43,1,2],
    [2,1,47,1,2],
    [2,1,53,1,2],
    [2,1,59,1,2],
    [2,1,61,1,2],
    [2,1,67,1,2],
    [2,1,71,1,2],
    [2,1,73,1,2],
    [2,1,79,1,2],
    [2,1,83,1,2],
    [2,1,89,1,2],
    [2,2,3,1,4],
    [2,2,3,2,4],
    [2,2,3,2,8],
    [2,2,5,1,4],
    [2,2,7,1,4],
    [2,2,11,1,4],
    [2,2,13,1,4],
    [2,3,3,1,8],
    [2,3,5,1,8],
    [2,4,3,1,16],
    [3,1,2,2,3],
    [3,1,2,2,6],
    [3,1,2,4,3],
    [3,1,2,4,6],
    [3,1,2,4,12],
    [3,1,2,6,18],
    [3,1,5,2,3],
    [3,1,5,2,6],
    [3,1,7,1,3],
    [3,1,13,1,3],
    [3,1,19,1,3],
    [3,2,2,2,9],
    [3,2,2,2,18]
];;


for qmpkd in QMPKD do
    q := qmpkd[1];
    m := qmpkd[2];
    p := qmpkd[3];
    k := qmpkd[4];
    d := qmpkd[5];

    # if k <> 1 then continue; fi;
    if d <> 2 then continue; fi; # it seems to break for d != 2 right now

    for et in ["-","+"] do

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
        Print("q=", String(q), ", m=", String(m), ", p=", String(p), ", k=", String(k), ", d=", String(d), ", et=", et, ":\n");
        Print("Number of Extraspecial Groups found for these parameters = ", Length(GLpkSubgroups), "\n");
        # FIXME: sometimes this filtering is non-unique, why?
        for Ex in GLpkSubgroups do
            # Calculate normalizer of E in GL(q^m,p^k)
            NE := Normalizer(GLpkPerm, Ex);

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
            # Conjugacy suffices since conjugate groups will have the same orbit structure
            for G0 in List((ConjugacyClassesSubgroups(N)), Representative) do
                # If in B then G_0 is primitive matrix group
                if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) then
                    G0Perm := Image(permp, G0);
                    rank := Size(Orbits(G0Perm)) + 1;
                    if rank < 5 and rank > 1 then
                        # Get number of subgroups of G0 isomorphic to E
                        copies_of_E := [];
                        for mono in List(IsomorphicSubgroups(G0, Ex)) do
                            Add(copies_of_E, Image(mono, Ex));
                        od;
                        copies_of_E_unique := Unique(copies_of_E);
                        if Length(copies_of_E_unique) > 0 then
                            Print("Number of Subgroups Iso. to E = ", Length(copies_of_E_unique), "\n");
                            # Check if we have any copies of E
                            for Ex_in_G0 in copies_of_E_unique do
                                permEx := IsomorphismPermGroup(Ex_in_G0);
                                ImEx := Image(permEx, Ex_in_G0);
                                Print("q=", String(q), ", m=", String(m), ", p=", String(p), ", k=", String(k), ", d=", String(d), ", et=", et, ":\n");
                                Print("E = ", StructureDescription(Ex_in_G0), "\n");
                                Print("E normal in G_0 = ", IsNormal(G0Perm, ImEx), "\n");
                                Print("Rank = ", rank, "\n");
                                Print("Order of G_0 = ", Order(G0), "\n");
                                Print("G_0 = ", StructureDescription(G0), "\n\n");
                            od;
                        fi;
                    fi;
                fi;
            od;
        od;

    od;
    Print("\n");
od;
