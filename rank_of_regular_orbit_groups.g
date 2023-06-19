fileNames := ["Line1gpsm.g", "Line3gps.g", "Line9gpsm.g", "Line9gpsp.g", "Line10gps.g", "Line19gpsm.g",
    "Line19gpsp.g", "Line20gps.g", "Line21gpsp.g", "Line22gps.g", "Line23gpsp.g"];

lineNums := [1,3,9,9,10,19,19,20,21,22,23,24,25,28,48,49,50,51,52,53,62,63,64,65,66,67,
    68,69,71,72,74,75,117];


for lineNum in lineNums do
    if lineNum > 23 then
        Append(fileNames, [Concatenation("Line", String(lineNum), "gps.g")]);
    fi;
od;


for i in [1 .. Size(lineNums)] do
    Read(Concatenation("reg-orb-grps/",fileNames[i]));
od;
allGps := [Line1gpsm,Line3gps,Line9gpsm,Line9gpsp,Line10gps,Line19gpsm,Line19gpsp,Line20gps,
    Line21gpsp,Line22gps,Line23gpsp,Line24gps,Line25gps,Line28gps,Line48gps,Line49gps,Line50gps,
    Line51gps,Line52gps,Line53gps,Line62gps,Line63gps,Line64gps,Line65gps,Line66gps,Line67gps,
    Line68gps,Line69gps,Line71gps,Line72gps,Line74gps,Line75gps,Line117gps];

dList := [16,18,8,8,8,4,4,4,4,8,4,4,4,8,6,3,3,12,3,6,2,2,2,4,2,2,2,2,4,6,4,8,8];
pList := [3,2,3,3,5,3,3,5,7,3,11,13,17,5,2,7,13,2,19,5,3,5,7,3,11,13,17,19,5,3,7,3,3];

OutputLogTo("results.txt");


for i in [2 .. Size(lineNums)] do # temporarily not doing line 1 for time constraint
    currLine := allGps[i];
    for j in [1 .. Size(currLine)] do
        G := currLine[j];

        d := dList[i];
        k := 1;
        p := pList[i];
        GLp := GL(d*k,p);
        permp := IsomorphismPermGroup(GLp);
        G0 := Image(permp, G);
        rank := Size(Orbits(G0)) + 1;
        Print("Line ", lineNums[i], " group ", j, " rank: ", rank, "\n");
    od;
od;
QUIT;