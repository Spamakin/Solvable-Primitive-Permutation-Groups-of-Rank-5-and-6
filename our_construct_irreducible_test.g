SetRecursionTrapInterval(10000);

# q := 2;;
# m := 1;;
# p := 83;;
# k := 1;;
# d := 2;;
# et := "-";;

QMPKD := [ # only imprimitive cases where e is a prime power
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
];

for qmpkd in QMPKD do
    q := qmpkd[1];
    m := qmpkd[2];
    p := qmpkd[3];
    k := qmpkd[4];
    d := qmpkd[5];

    # if k <> 1 then continue; fi;
    if d <> 2 then continue; fi; # it seems to break for d != 2 right now

    Print("q=", String(q), ", m=", String(m), ", p=", String(p), ", k=", String(k), ", d=", String(d), ":\n");
    for et in ["-","+"] do

        GLe := GL(q^m,p^k);
        GLp := GL(d*k,p);
        perme := IsomorphismPermGroup(GLe);
        permp := IsomorphismPermGroup(GLp);
        GLePerm := Image(perme,GLe);
        GLpPerm := Image(permp,GLp);

        # Find the extraspecial subgroup of GL(q^m,p^k)
        GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLePerm,q)), Representative);
        Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
        GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
        GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
        Ex := GLeSubgroups[1];
        # Calculate its normalizer in GL(q^m,p^k)
        NA := Normalizer(GLePerm, Ex);
        NAp := NA;

        if k = 1 then
        # If k=1, GL(q^m,p^k) = GL(d,p) so no embedding is needed
        N := Normalizer(GLe,PreImage(perme, NA));
        else
        basis := Basis(GF(p^k));
        GLeGens := GeneratorsOfGroup(GLe);
        GLpGens := [];
        for GLeGen in GLeGens do
            Append(GLpGens, [BlownUpMat(basis, GLeGen)]);
        od;
        # Embed NA into GL(d,p)
        embedding := GroupHomomorphismByImagesNC(GLe, GLp, GLeGens, GLpGens);
        NAp := Image(embedding, PreImage(perme, NA));
        # Calculate its normalizer
        N := Normalizer(GLp, NAp);
        fi;

        # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
        for G in List((ConjugacyClassesSubgroups(N)), Representative) do
            if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p)) then
                G0 := Image(permp, G);
                rank := Size(Orbits(G0)) + 1;
                if rank < 6 and rank > 1 then
                    # Print(G0, " rank: ", rank, " structure: ", StructureDescription(G0), "\n");
                    if Length(IsomorphicSubgroups(G, Extraspecial)) > 0 then
                        Print("rank: ", rank, ", et: ", et, ", order: ", Order(G0), ", structure: ", StructureDescription(G0), "\n");
                    fi;
                fi;
            fi;
        od;
    od;
    Print("\n");
od;