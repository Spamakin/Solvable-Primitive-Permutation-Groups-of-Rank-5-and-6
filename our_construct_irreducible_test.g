SetRecursionTrapInterval(10000);

q := 2;;
m := 1;;
# p := 83;;
# k := 1;;
# d := 2;;
# et := "-";;

PKD := [
[3,	1,2],
[3,	2,2],
[3,	2,4],
[3,	3,2],
[3,	3,6],
[3,	4,2],
[3,	4,4],
[3,	4,8],
[3,	5,10],
[5,	1,2],
[5,	2,2],
[5,	2,4],
[5,	3,6],
[7,	1,2],
[7,	2,2],
[7,	2,4],
[11,1,2],
[11,2,4],
[13,1,2],
[13,2,4],
[17,1,2],
[19,1,2],
[23,1,2],
[29,1,2],
[31,1,2],
[37,1,2],
[41,1,2],
[43,1,2],
[47,1,2],
[53,1,2],
[59,1,2],
[61,1,2],
[67,1,2],
[71,1,2],
[73,1,2],
[79,1,2],
[83,1,2],
[89,1,2]
];

for pkd in PKD do
    p := pkd[1];
    k := pkd[2];
    d := pkd[3];

    if k <> 1 then continue; fi;

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
        embedding := GroupHomomorphismByImages(GLe, GLp, GLeGens, GLpGens);
        NAp := Image(embedding, PreImage(perme, NA));
        # Calculate its normalizer
        N := Normalizer(GLp, NAp);
        fi;

        # Cycle through all subgroups of N, printing data about the solvable, primitive ones of low rank
        for G in List((ConjugacyClassesSubgroups(N)), Representative) do
            if IsSolvable(G) and IsIrreducibleMatrixGroup(G) and IsPrimitiveMatrixGroup(G, GF(p)) then
                G0 := Image(permp, G);
                rank := Size(Orbits(G0)) + 1;
                if rank < 5 and rank > 1 then
                    # Print(G0, " rank: ", rank, " structure: ", StructureDescription(G0), "\n");
                    if Length(IsomorphicSubgroups(G, Extraspecial)) > 0 then
                        Print("rank: ", rank, ", et: ", et, ", structure: ", StructureDescription(G0), "\n");
                    fi;
                fi;
            fi;
        od;
    od;
    Print("\n");
od;