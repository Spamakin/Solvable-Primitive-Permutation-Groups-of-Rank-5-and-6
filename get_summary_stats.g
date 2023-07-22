folderPath := "/home/ec2-user/classification/one_E_results";

for i in [1 .. 59] do
    for et in ["-","+"] do
        if (i in [46,47,48,54]) then
            continue;
        fi;
        currFile := Concatenation(folderPath, "/line", String(i), et, ".g");
        Read(currFile);;
    od;
od;

allGroups := [
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
    Line44PlusGrps,
    Line45MinusGrps,
    Line45PlusGrps,
    [],
    [],
    [],
    [],
    [],
    [],
    Line49MinusGrps,
    Line49PlusGrps,
    Line50MinusGrps,
    Line50PlusGrps,
    Line51MinusGrps,
    Line51PlusGrps,
    Line52MinusGrps,
    Line52PlusGrps,
    Line53MinusGrps,
    Line53PlusGrps,
    [],
    [],
    Line55MinusGrps,
    Line55PlusGrps,
    Line56MinusGrps,
    Line56PlusGrps,
    Line57MinusGrps,
    Line57PlusGrps,
    Line58MinusGrps,
    Line58PlusGrps,
    Line59MinusGrps,
    Line59PlusGrps
];;


LineQMPKD := [ # only irreducible cases where e is a prime power
    [1, 2, 1, 3, 1, 2],
    [2, 2, 1, 3, 2, 2],
    [3, 2, 1, 3, 2, 4],
    [4, 2, 1, 3, 3, 2],
    [5, 2, 1, 3, 3, 6],
    [6, 2, 1, 3, 4, 2],
    [7, 2, 1, 3, 4, 4],
    [8, 2, 1, 3, 4, 8],
    [9, 2, 1, 3, 5, 10],
    [10, 2, 1, 5, 1, 2],
    [11, 2, 1, 5, 2, 2],
    [12, 2, 1, 5, 2, 4],
    [13, 2, 1, 5, 3, 6],
    [14, 2, 1, 7, 1, 2],
    [15, 2, 1, 7, 2, 2],
    [16, 2, 1, 7, 2, 4],
    [17, 2, 1, 11, 1, 2],
    [18, 2, 1, 11, 2, 4],
    [19, 2, 1, 13, 1, 2],
    [20, 2, 1, 13, 2, 4],
    [21, 2, 1, 17, 1, 2],
    [22, 2, 1, 19, 1, 2],
    [23, 2, 1, 23, 1, 2],
    [24, 2, 1, 29, 1, 2],
    [25, 2, 1, 31, 1, 2],
    [26, 2, 1, 37, 1, 2],
    [27, 2, 1, 41, 1, 2],
    [28, 2, 1, 43, 1, 2],
    [29, 2, 1, 47, 1, 2],
    [30, 2, 1, 53, 1, 2],
    [31, 2, 1, 59, 1, 2],
    [32, 2, 1, 61, 1, 2],
    [33, 2, 1, 67, 1, 2],
    [34, 2, 1, 71, 1, 2],
    [35, 2, 1, 73, 1, 2],
    [36, 2, 1, 79, 1, 2],
    [37, 2, 1, 83, 1, 2],
    [38, 2, 1, 89, 1, 2],
    [39, 2, 2, 3, 1, 4],
    [40, 2, 2, 3, 2, 4],
    [41, 2, 2, 3, 2, 8],
    [42, 2, 2, 5, 1, 4],
    [43, 2, 2, 7, 1, 4],
    [44, 2, 2, 11, 1, 4],
    [45, 2, 2, 13, 1, 4],
    [46, 2, 3, 3, 1, 8],
    [47, 2, 3, 5, 1, 8],
    [48, 2, 4, 3, 1, 16],
    [49, 3, 1, 2, 2, 3],
    [50, 3, 1, 2, 2, 6],
    [51, 3, 1, 2, 4, 3],
    [52, 3, 1, 2, 4, 6],
    [53, 3, 1, 2, 4, 12],
    [54, 3, 1, 2, 6, 18],
    [55, 3, 1, 5, 2, 3],
    [56, 3, 1, 5, 2, 6],
    [57, 3, 1, 7, 1, 3],
    [58, 3, 1, 13, 1, 3],
    [59, 3, 1, 19, 1, 3],
    [60, 3, 2, 2, 2, 9],
    [61, 3, 2, 2, 2, 18],
];;


for i in [1 .. 59] do
    q := LineQMPKD[i][2];
    m := LineQMPKD[i][3];
    p := LineQMPKD[i][4];
    k := LineQMPKD[i][5];
    d := LineQMPKD[i][6];
    for et in ["-","+"] do
        if (i in [46,47,48,54]) then
            continue;
        fi;

        if et = "-" then
            j := 2 * i - 1;
        else
            j := 2 * i;
        fi;
        Print("Line ", i, et, ":\n");
        Print("q,m,p,k,d,et = ", q, ",", m, ",", p, ",", k, ",", d, ",", et, "\n");
	Grps := allGroups[j];
	ranks := [0, 0, 0, 0, 0];
        GLp := GL(k * q^m, p);
        permp := IsomorphismPermGroup(GLp);
	for G0 in Grps do
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;
            ranks[rank] := ranks[rank] + 1;
	od;
        for rank in [2..5] do
            Print("Number of rank ", rank, " = ", ranks[rank], "\n");
        od;
        Print(Size(Grps), " groups\n\n");
    od;
od;
