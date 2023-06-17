#############################################################################
# File: NoRegOrbitGroupsAnalysis.g
# Date: June 20, 2022
# Proj: Solvable Primitive Permutation Groups of Low Rank
# Desc: The folder GapNonRegOrbFiles contains all of the groups listed
#       in Table 4.1 of the Holt-Yang paper, "Regular Orbits of Finite
#       Primitive Solvable Groups, The Final Classification". This file
#       contains functions to load in these groups and analyze them by their
#       ranks and their properties.
#############################################################################

get_non_reg_groups := function()
    local i, fn, fn2, fn3, path, path2, path3, non_reg_groups;

    for i in [1..117] do
        fn := Concatenation("Line", String(i), "gps.g");
        fn2 := Concatenation("Line", String(i), "gpsm.g");
        fn3 := Concatenation("Line", String(i), "gpsp.g");
        path := Filename(Directory("GapNonRegOrbFiles"), fn);
        path2 := Filename(Directory("GapNonRegOrbFiles"), fn2);
        path3 := Filename(Directory("GapNonRegOrbFiles"), fn3);

        if IsReadableFile(path) then
            Read(String(path));
        fi;
        if IsReadableFile(path2) then
            Read(String(path2));
        fi;
        if IsReadableFile(path3) then
            Read(String(path3));
        fi;
    od;

    #####
    # line numbers with p or m after the number, ("1p"), correspond to
    # the groups with extra special group of power of 2, where the p and
    # m are used to differentiate which extra special group is used
    #####

    non_reg_groups :=
        [["1m", Line1gpsm], ["3", Line3gps], ["9p", Line9gpsp],
        ["9m", Line9gpsm], ["10", Line10gps], ["19p", Line19gpsp],
        ["19m", Line19gpsm], ["20", Line20gps], ["21p", Line21gpsp],
        ["22", Line22gps], ["23p", Line23gpsp], ["24", Line24gps],
        ["25", Line25gps], ["28", Line28gps], ["48", Line48gps],
        ["49", Line49gps], ["50", Line50gps], ["51", Line51gps],
        ["52", Line52gps], ["53", Line53gps], ["62", Line62gps],
        ["63", Line63gps], ["64", Line64gps], ["65", Line65gps],
        ["66", Line66gps], ["67", Line67gps], ["68", Line68gps],
        ["69", Line69gps], ["71", Line71gps], ["72", Line72gps],
        ["74", Line74gps], ["75", Line75gps], ["117", Line117gps]];

    return non_reg_groups;
end;

rank := function(G)
    local iso, gperm, stab, orbs;

    iso := IsomorphismPermGroup(G);
    gperm := Image(iso);
    stab := Stabilizer(gperm, 1);
    orbs := Orbits(stab);

    return Size(orbs);
end;

non_reg_groups := get_non_reg_groups();

for line_groups in non_reg_groups do
    line_num := line_groups[1];
    groups := line_groups[2];

    Print("\n********************\nLine Number: ", line_num, "\n");
    Print("Number of Groups: ", Size(groups), "\n********************\n");

    j := 0;
    for group in groups do
        Print("Rank: ", Size(Orbits(Image(IsomorphismPermGroup(group),group))) + 1, "\n");
        # PUT SOMETHING HERE YOU WANT TO DO FOR ALL GROUPS
    od;

    Print("********************\n");
od;
