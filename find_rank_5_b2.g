# CHANGE THIS TO THE DIRECTORY YOU WANT TO SAVE STUFF IN
OutputDirr := "/home/spamakin/projects/research/classification/results";;

line := 42;;
q := 2;;
m := 1;;
d := 4;;
p := 3;;
k := 1;;
b := 2;;

Print("Computing permutation representations for GL(q^m, p^k) and GL(q^m * b, p)\n");
GLe := GL(q^m,p^k);;
GLeb := GL(q^m*b,p^k);;
perme := IsomorphismPermGroup(GLe);;
permeb := IsomorphismPermGroup(GLeb);;
GLePerm := Image(perme,GLe);;
GLebPerm := Image(permeb,GLeb);;

for et in ["+", "-"] do
    Print("\n", "q = ", q, ", m = ", m, ", p = ", p, ", k = ", k, ", d = ", d, "b = ", b, "et = ", et, "\n");

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
    # Find the extraspecial subgroup of GL(q^m,p^k)
    GLeSubgroups := List(ConjugacyClassesSubgroups(SylowSubgroup(GLePerm,q)), Representative);
    Extraspecial := ExtraspecialGroup(q^(2*m+1), et);
    GLeSubgroups := Filtered(GLeSubgroups,x->Order(x) = Order(Extraspecial));
    GLeSubgroups := Filtered(GLeSubgroups,x->IdGroup(x) = IdGroup(Extraspecial));
    Ex := PreImage(perme, GLeSubgroups[1]);

    # Find its normalizer in GL(q^m,p^k)
    NA := Normalizer(GLe, Ex);

    # Embed GL(q^m,p^k) into GL(q^m*b,p^k)
    GLeGens := GeneratorsOfGroup(GLe);
    GLebGens := [];
    for GLeGen in GLeGens do
         Append(GLebGens, [KroneckerProduct(GLeGen, IdentityMat(b,GF(p^k)))]);
    od;
    embedding := GroupHomomorphismByImages(GLe, GLeb, GLeGens, GLebGens);
    NAeb := Image(embedding, NA);

    # Take the second normalizer in GL(q^m*b,p^k)
    N := Normalizer(GLeb, NAeb);

    # Check every subgroup class of N for the properties we require of G
    #
    for G in List(ConjugacyClassesSubgroups(N), Representative) do
        if IsSolvable(G) and IsPrimitiveMatrixGroup(G) and IsIrreducibleMatrixGroup(G) then
            G0 := Image(permeb, G);
            rank := Size(Orbits(G0)) + 1;
            if rank <= 5 then
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

                NumGrps := NumGrps + 1;
                if Order(G0) > MaxOrder then
                    MaxOrder := Order(G0);
                    RankOfMax := rank;
                fi;
                Print("    !! FOUND RANK = ", rank, "\n");
                AppendTo(OutputFile,"    ", G0, ",\n");;
            fi;
        fi;
    od;

    Print(q, "  ", m, "  ", p, "  ", k, "  ", d, "  ", RankOfMax, "  ", MaxOrder, "  ", NumGrps, "  E", et, "\n\n\n");
    AppendTo(OutputFile, "];\n\n");;
od;
