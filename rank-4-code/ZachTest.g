Read("./GapNonRegOrbFiles/Line62gps.g");
Groups := Line62gps;
for i in [1..Size(Groups)] do
  GPerm := Image(IsomorphismPermGroup(GL(2,3)),Groups[i]);
  orb := Orbits(GPerm);
  Print(IsPrimitive(GPerm));
  Print(i, ": ", "Rank = ", Size(orb) + 1, ". Order = ", Size(GPerm), "\n");
od;
