# for now, e = 6 is its own file

qm := 6;;
p := 7;;
k := 1;;


for et2 in ["-","+"] do
    for et3 in ["-", "+"] do

        NumGrps := 0;
        MaxOrder := 0;
        RankOfMax := 0;
        groupDescriptions := [];
        groupList := [];

        GLpk := GL(qm, p^k);
        GLp := GL(k * qm, p);
        permpk := IsomorphismPermGroup(GLpk);
        permp := IsomorphismPermGroup(GLp);
        GLpkPerm := Image(permpk,GLpk);
        GLpPerm := Image(permp,GLp);

        Extraspecial1 := ExtraspecialGroup(8, et2);
        Extraspecial2 := ExtraspecialGroup(27, et3);
        Extraspecial := DirectProduct(Extraspecial1, Extraspecial2);
        permex := IsomorphismPermGroup(Extraspecial);
        ExtraspecialPerm := Image(permex, Extraspecial);
        Print("(", et2, ",", et3, ") = ", StructureDescription(Extraspecial), "\n");

        NE := Normalizer(GLpkPerm, ExtraspecialPerm);
        N := Normalizer(GLpk,PreImage(permpk, NE));

        for G0 in List((ConjugacyClassesSubgroups(N)), Representative) do
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;

            # Requirements:
            #   G0 Solvable
            #   G0 Irreducible
            #   If in B then G0 is primitive matrix group
            #   1 < rank < 5
            if IsSolvable(G0) and IsIrreducibleMatrixGroup(G0) and IsPrimitiveMatrixGroup(G0, GF(p)) and rank = 5 then
                copies_of_E := [];
                for mono in List(IsomorphicSubgroups(G0, Extraspecial : findall:=false)) do
                    Add(copies_of_E, Image(mono, Extraspecial));
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
                    Print("        G_0 = ", structDesc, "\n");
                    Print("        Order of G_0 = ", Order(G0), "\n");
                    Print("        Rank = ", rank, "\n");
                    Print("        E = ", StructureDescription(Ex_in_G0), "\n");
                od;
            fi;
        od;
    od;
od;
