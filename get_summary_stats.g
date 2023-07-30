# FolderPath := "/home/spamakin/projects/research/classification/results";
FolderPath := "/home/kolton/texas_reu/Solvable-Primitive-Permutation-Groups-of-Rank-5/results";

for i in [1 .. 44] do
    for et in ["-","+"] do
        CurrFile := Concatenation(FolderPath, "/line", String(i), et, ".g");
        Read(CurrFile);;
    od;
od;

GroupList := [
    Line1MinusGrps,
    Line1PlusGrps,
    Line2MinusGrps,
    Line2PlusGrps,
    Line3MinusGrps,
    Line3PlusGrps,
    Line4MinusGrps,
    Line4PlusGrps,
    Line5MinusGrps,
    Line5PlusGrps,
    Line6MinusGrps,
    Line6PlusGrps,
    Line7MinusGrps,
    Line7PlusGrps,
    Line8MinusGrps,
    Line8PlusGrps,
    Line9MinusGrps,
    Line9PlusGrps,
    Line10MinusGrps,
    Line10PlusGrps,
    Line11MinusGrps,
    Line11PlusGrps,
    Line12MinusGrps,
    Line12PlusGrps,
    Line13MinusGrps,
    Line13PlusGrps,
    Line14MinusGrps,
    Line14PlusGrps,
    Line15MinusGrps,
    Line15PlusGrps,
    Line16MinusGrps,
    Line16PlusGrps,
    Line17MinusGrps,
    Line17PlusGrps,
    Line18MinusGrps,
    Line18PlusGrps,
    Line19MinusGrps,
    Line19PlusGrps,
    Line20MinusGrps,
    Line20PlusGrps,
    Line21MinusGrps,
    Line21PlusGrps,
    Line22MinusGrps,
    Line22PlusGrps,
    Line23MinusGrps,
    Line23PlusGrps,
    Line24MinusGrps,
    Line24PlusGrps,
    Line25MinusGrps,
    Line25PlusGrps,
    Line26MinusGrps,
    Line26PlusGrps,
    Line27MinusGrps,
    Line27PlusGrps,
    Line28MinusGrps,
    Line28PlusGrps,
    Line29MinusGrps,
    Line29PlusGrps,
    Line30MinusGrps,
    Line30PlusGrps,
    Line31MinusGrps,
    Line31PlusGrps,
    Line32MinusGrps,
    Line32PlusGrps,
    Line33MinusGrps,
    Line33PlusGrps,
    Line34MinusGrps,
    Line34PlusGrps,
    Line35MinusGrps,
    Line35PlusGrps,
    Line36MinusGrps,
    Line36PlusGrps,
    Line37MinusGrps,
    Line37PlusGrps,
    Line38MinusGrps,
    Line38PlusGrps,
    Line39MinusGrps,
    Line39PlusGrps,
    Line40MinusGrps,
    Line40PlusGrps,
    Line41MinusGrps,
    Line41PlusGrps,
    Line42MinusGrps,
    Line42PlusGrps,
    Line43MinusGrps,
    Line43PlusGrps,
    Line44MinusGrps,
    Line44PlusGrps
];;

LineQMPKD := [ # only cases where b = 1
    [1, 2, 1, 3, 1, 2],
    [2, 2, 1, 3, 2, 4],
    [3, 2, 1, 3, 3, 6],
    [4, 2, 1, 3, 4, 8],
    [5, 2, 1, 3, 5, 10],
    [6, 2, 1, 5, 1, 2],
    [7, 2, 1, 5, 2, 4],
    [8, 2, 1, 5, 3, 6],
    [9, 2, 1, 7, 1, 2],
    [10, 2, 1, 7, 2, 4],
    [11, 2, 1, 11, 1, 2],
    [12, 2, 1, 11, 2, 4],
    [13, 2, 1, 13, 1, 2],
    [14, 2, 1, 17, 1, 2],
    [15, 2, 1, 19, 1, 2],
    [16, 2, 1, 23, 1, 2],
    [17, 2, 1, 29, 1, 2],
    [18, 2, 1, 31, 1, 2],
    [19, 2, 1, 37, 1, 2],
    [20, 2, 1, 41, 1, 2],
    [21, 2, 1, 43, 1, 2],
    [22, 2, 1, 47, 1, 2],
    [23, 2, 1, 53, 1, 2],
    [24, 2, 1, 59, 1, 2],
    [25, 2, 1, 61, 1, 2],
    [26, 2, 1, 67, 1, 2],
    [27, 2, 1, 71, 1, 2],
    [28, 2, 1, 73, 1, 2],
    [29, 2, 1, 79, 1, 2],
    [30, 2, 1, 83, 1, 2],
    [31, 2, 2, 3, 1, 4],
    [32, 2, 2, 3, 2, 8],
    [33, 2, 2, 5, 1, 4],
    [34, 2, 2, 7, 1, 4],
    [35, 2, 2, 11, 1, 4],
    [36, 2, 2, 13, 1, 4],
    [37, 2, 3, 3, 1, 8],
    [38, 2, 3, 5, 1, 8],
    [39, 3, 1, 2, 2, 6],
    [40, 3, 1, 2, 4, 12],
    [41, 3, 1, 5, 2, 6],
    [42, 3, 1, 7, 1, 3],
    [43, 3, 1, 13, 1, 3],
    [44, 3, 1, 19, 1, 3],
];;

for i in [1 .. 44] do
    q := LineQMPKD[i][2];
    m := LineQMPKD[i][3];
    p := LineQMPKD[i][4];
    k := LineQMPKD[i][5];
    d := LineQMPKD[i][6];
    for et in ["-","+"] do
        if et = "-" then
            j := 2 * i - 1;
        else
            j := 2 * i;
        fi;
        Print("Line ", i, et, ":\n");
        Print("q, m, p, k, d, et = ", q, ", ", m, ", ", p, ", ", k, ", ", d, ", ", et, "\n");
        Grps := GroupList[j];
        Ranks := [0, 0, 0, 0, 0];
            GLp := GL(k * q^m, p);
            permp := IsomorphismPermGroup(GLp);
        for G0 in Grps do
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;
            Ranks[rank] := Ranks[rank] + 1;
        od;
        Print(Size(Grps), " groups\n");
        for rank in [2..5] do
            Print("  Number of rank ", rank, " = ", Ranks[rank], "\n");
        od;
        Print("\n");
    od;
od;

QUIT;
