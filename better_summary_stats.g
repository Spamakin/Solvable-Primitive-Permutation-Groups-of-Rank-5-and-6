# Utility to help enumerate all groups

# Change this to point to where the results are stored
FolderPath := "/home/spamakin/projects/research/classification/6_results";;

# Load all groups
# b = 1, e <> 6
for i in [1 .. 51] do
    for et in ["-","+"] do
        CurrFile := Concatenation(FolderPath, "/line", String(i), et, ".g");;
        Read(CurrFile);;
    od;
od;
# e = 6
CurrFile := Concatenation(FolderPath, "/line52.g");;
Read(CurrFile);;
# b > 1
for i in [53, 54] do
    for et in ["-","+"] do
        CurrFile := Concatenation(FolderPath, "/line", String(i), et, ".g");;
        Read(CurrFile);;
    od;
od;

# List of Groups + Parameters
# [Name,           Line,  q, m, p,   k, d,  b, et]
GroupList := [
    [Line1MinusGrps,  1,  2, 1, 3,   1, 2,  1, "-"],
    [Line1PlusGrps,   1,  2, 1, 3,   1, 2,  1, "+"],
    [Line2MinusGrps,  2,  2, 1, 3,   2, 4,  1, "-"],
    [Line2PlusGrps,   2,  2, 1, 3,   2, 4,  1, "+"],
    [Line3MinusGrps,  3,  2, 1, 3,   3, 6,  1, "-"],
    [Line3PlusGrps,   3,  2, 1, 3,   3, 6,  1, "+"],
    [Line4MinusGrps,  4,  2, 1, 3,   4, 8,  1, "-"],
    [Line4PlusGrps,   4,  2, 1, 3,   4, 8,  1, "+"],
    [Line5MinusGrps,  5,  2, 1, 3,   5, 10, 1, "-"],
    [Line5PlusGrps,   5,  2, 1, 3,   5, 10, 1, "+"],
    [Line6MinusGrps,  6,  2, 1, 5,   1, 2,  1, "-"],
    [Line6PlusGrps,   6,  2, 1, 5,   1, 2,  1, "+"],
    [Line7MinusGrps,  7,  2, 1, 5,   2, 4,  1, "-"],
    [Line7PlusGrps,   7,  2, 1, 5,   2, 4,  1, "+"],
    [Line8MinusGrps,  8,  2, 1, 5,   3, 6,  1, "-"],
    [Line8PlusGrps,   8,  2, 1, 5,   3, 6,  1, "+"],
    [Line9MinusGrps,  9,  2, 1, 7,   1, 2,  1, "-"],
    [Line9PlusGrps,   9,  2, 1, 7,   1, 2,  1, "+"],
    [Line10MinusGrps, 10, 2, 1, 7,   2, 4,  1, "-"],
    [Line10PlusGrps,  10, 2, 1, 7,   2, 4,  1, "+"],
    [Line11MinusGrps, 11, 2, 1, 11,  1, 2,  1, "-"],
    [Line11PlusGrps,  11, 2, 1, 11,  1, 2,  1, "+"],
    [Line12MinusGrps, 12, 2, 1, 11,  2, 4,  1, "-"],
    [Line12PlusGrps,  12, 2, 1, 11,  2, 4,  1, "+"],
    [Line13MinusGrps, 13, 2, 1, 13,  1, 2,  1, "-"],
    [Line13PlusGrps,  13, 2, 1, 13,  1, 2,  1, "+"],
    [Line14MinusGrps, 14, 2, 1, 13,  2, 4,  1, "-"],
    [Line14PlusGrps,  14, 2, 1, 13,  2, 4,  1, "+"],
    [Line15MinusGrps, 15, 2, 1, 17,  1, 2,  1, "-"],
    [Line15PlusGrps,  15, 2, 1, 17,  1, 2,  1, "+"],
    [Line16MinusGrps, 16, 2, 1, 19,  1, 2,  1, "-"],
    [Line16PlusGrps,  16, 2, 1, 19,  1, 2,  1, "+"],
    [Line17MinusGrps, 17, 2, 1, 23,  1, 2,  1, "-"],
    [Line17PlusGrps,  17, 2, 1, 23,  1, 2,  1, "+"],
    [Line18MinusGrps, 18, 2, 1, 29,  1, 2,  1, "-"],
    [Line18PlusGrps,  18, 2, 1, 29,  1, 2,  1, "+"],
    [Line19MinusGrps, 19, 2, 1, 31,  1, 2,  1, "-"],
    [Line19PlusGrps,  19, 2, 1, 31,  1, 2,  1, "+"],
    [Line20MinusGrps, 20, 2, 1, 37,  1, 2,  1, "-"],
    [Line20PlusGrps,  20, 2, 1, 37,  1, 2,  1, "+"],
    [Line21MinusGrps, 21, 2, 1, 41,  1, 2,  1, "-"],
    [Line21PlusGrps,  21, 2, 1, 41,  1, 2,  1, "+"],
    [Line22MinusGrps, 22, 2, 1, 43,  1, 2,  1, "-"],
    [Line22PlusGrps,  22, 2, 1, 43,  1, 2,  1, "+"],
    [Line23MinusGrps, 23, 2, 1, 47,  1, 2,  1, "-"],
    [Line23PlusGrps,  23, 2, 1, 47,  1, 2,  1, "+"],
    [Line24MinusGrps, 24, 2, 1, 53,  1, 2,  1, "-"],
    [Line24PlusGrps,  24, 2, 1, 53,  1, 2,  1, "+"],
    [Line25MinusGrps, 25, 2, 1, 59,  1, 2,  1, "-"],
    [Line25PlusGrps,  25, 2, 1, 59,  1, 2,  1, "+"],
    [Line26MinusGrps, 26, 2, 1, 61,  1, 2,  1, "-"],
    [Line26PlusGrps,  26, 2, 1, 61,  1, 2,  1, "+"],
    [Line27MinusGrps, 27, 2, 1, 67,  1, 2,  1, "-"],
    [Line27PlusGrps,  27, 2, 1, 67,  1, 2,  1, "+"],
    [Line28MinusGrps, 28, 2, 1, 71,  1, 2,  1, "-"],
    [Line28PlusGrps,  28, 2, 1, 71,  1, 2,  1, "+"],
    [Line29MinusGrps, 29, 2, 1, 73,  1, 2,  1, "-"],
    [Line29PlusGrps,  29, 2, 1, 73,  1, 2,  1, "+"],
    [Line30MinusGrps, 30, 2, 1, 79,  1, 2,  1, "-"],
    [Line30PlusGrps,  30, 2, 1, 79,  1, 2,  1, "+"],
    [Line31MinusGrps, 31, 2, 1, 83,  1, 2,  1, "-"],
    [Line31PlusGrps,  31, 2, 1, 83,  1, 2,  1, "+"],
    [Line32MinusGrps, 32, 2, 1, 89,  1, 2,  1, "-"],
    [Line32PlusGrps,  32, 2, 1, 89,  1, 2,  1, "+"],
    [Line33MinusGrps, 33, 2, 1, 97,  1, 2,  1, "-"],
    [Line33PlusGrps,  33, 2, 1, 97,  1, 2,  1, "+"],
    [Line34MinusGrps, 34, 2, 1, 101, 1, 2,  1, "-"],
    [Line34PlusGrps,  34, 2, 1, 101, 1, 2,  1, "+"],
    [Line35MinusGrps, 35, 2, 1, 103, 1, 2,  1, "-"],
    [Line35PlusGrps,  35, 2, 1, 103, 1, 2,  1, "+"],
    [Line36MinusGrps, 36, 2, 1, 107, 1, 2,  1, "-"],
    [Line36PlusGrps,  36, 2, 1, 107, 1, 2,  1, "+"],
    [Line37MinusGrps, 37, 2, 2, 3,   1, 4,  1, "-"],
    [Line37PlusGrps,  37, 2, 2, 3,   1, 4,  1, "+"],
    [Line38MinusGrps, 38, 2, 2, 3,   2, 8,  1, "-"],
    [Line38PlusGrps,  38, 2, 2, 3,   2, 8,  1, "+"],
    [Line39MinusGrps, 39, 2, 2, 5,   1, 4,  1, "-"],
    [Line39PlusGrps,  39, 2, 2, 5,   1, 4,  1, "+"],
    [Line40MinusGrps, 40, 2, 2, 7,   1, 4,  1, "-"],
    [Line40PlusGrps,  40, 2, 2, 7,   1, 4,  1, "+"],
    [Line41MinusGrps, 41, 2, 2, 11,  1, 4,  1, "-"],
    [Line41PlusGrps,  41, 2, 2, 11,  1, 4,  1, "+"],
    [Line42MinusGrps, 42, 2, 2, 13,  1, 4,  1, "-"],
    [Line42PlusGrps,  42, 2, 2, 13,  1, 4,  1, "+"],
    [Line43MinusGrps, 43, 2, 3, 3,   1, 8,  1, "-"],
    [Line43PlusGrps,  43, 2, 3, 3,   1, 8,  1, "+"],
    [Line44MinusGrps, 44, 2, 3, 5,   1, 8,  1, "-"],
    [Line44PlusGrps,  44, 2, 3, 5,   1, 8,  1, "+"],
    [Line45MinusGrps, 45, 3, 1, 2,   2, 6,  1, "-"],
    [Line45PlusGrps,  45, 3, 1, 2,   2, 6,  1, "+"],
    [Line46MinusGrps, 46, 3, 1, 2,   4, 12, 1, "-"],
    [Line46PlusGrps,  46, 3, 1, 2,   4, 12, 1, "+"],
    [Line47MinusGrps, 47, 3, 1, 5,   2, 6,  1, "-"],
    [Line47PlusGrps,  47, 3, 1, 5,   2, 6,  1, "+"],
    [Line48MinusGrps, 48, 3, 1, 7,   1, 3,  1, "-"],
    [Line48PlusGrps,  48, 3, 1, 7,   1, 3,  1, "+"],
    [Line49MinusGrps, 49, 3, 1, 13,  1, 3,  1, "-"],
    [Line49PlusGrps,  49, 3, 1, 13,  1, 3,  1, "+"],
    [Line50MinusGrps, 50, 3, 1, 19,  1, 3,  1, "-"],
    [Line50PlusGrps,  50, 3, 1, 19,  1, 3,  1, "+"],
    [Line51MinusGrps, 51, 3, 2, 2,   2, 18, 1, "-"],
    [Line51PlusGrps,  51, 3, 2, 2,   2, 18, 1, "+"],
    [Line52Grps,      52, 6, 1, 7,   1, 6,  1, " "],
    [Line53MinusGrps, 53, 2, 1, 3,   1, 4,  2, "-"],
    [Line53PlusGrps,  53, 2, 1, 3,   1, 4,  2, "+"],
    [Line54MinusGrps, 54, 2, 2, 3,   1, 8,  2, "-"],
    [Line54PlusGrps,  54, 2, 2, 3,   1, 8,  2, "+"],
];;

OutputFile := "/home/spamakin/projects/research/classification/final_table_tex.txt";;
PrintTo(OutputFile, "");;
for Params in GroupList do
    Grps := Params[1];
    Line := Params[2];
    q    := Params[3];
    m    := Params[4];
    p    := Params[5];
    k    := Params[6];
    d    := Params[7];
    b    := Params[8];
    et   := Params[9];

    # Replace the following with any code you want
    if Length(Grps) > 0 then
        Ranks := [0, 0, 0, 0, 0, 0];
        GLp := GL(b * k * q^m, p);
        permp := IsomorphismPermGroup(GLp);
        for G0 in Grps do
            G0Perm := Image(permp, G0);
            rank := Size(Orbits(G0Perm)) + 1;
            Ranks[rank] := Ranks[rank] + 1;
        od;
        AppendTo(OutputFile, Line, " & ", q, " & ", m, " & ", p, " & ", k, " & ", d, " & ", b, " & ", et, " & ", Ranks[2], " & ", Ranks[3], " & ", Ranks[4], " & ", Ranks[5], " & ", Ranks[6], "\n");;
    fi;
od;

quit;
