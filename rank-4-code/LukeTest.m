Rank := function(G,V)
  #G;
  orbs := {V!0};
  num_orbits := 1;
  X := {v : v in V};
  AvailV := X diff orbs;
  while #AvailV gt 0 do
    v := Random(AvailV);
    O := Orbit(G,v);
    orbs join:= {x: x in O};
    if #O gt 0 then num_orbits := num_orbits + 1; end if;
    AvailV := X diff orbs;
  end while;
  return num_orbits;
end function;

MaxPrimSolvSubs := function(G)
    S := MaximalSubgroups(G);
    gps := [];
    if IsIrreducible(G) and IsSolvable(G) then Append(~gps, G); end if;
    i := 1;
    while i le #S do
        G := S[i]`subgroup;
        if IsIrreducible(G) and IsSolvable(G) then Append(~gps, G); end if;
        i := i + 1;
    end while;
    return gps;
end function;

G := GL(4, 3);
V := VectorSpace(G);

cands := [G];
while #cands gt 0 do
    cands2 := [];
    for group in cands do 
        maxs := MaxPrimSolvSubs(group);
        for max in maxs do Append(~cands2, max); Rank(max, V); end for;
    end for;
    cands := cands2;
end while;

Rank := function(G,V)
  stab := Stabilizer(G, V!0);
  #G;
  orbs := {V!0};
  num_orbits := 1;
  X := {v : v in V};
  AvailV := X diff orbs;
  while #AvailV gt 0 do
    v := Random(AvailV);
    O := Orbit(stab,v);
    orbs join:= {x: x in O};
    if #O gt 0 then num_orbits := num_orbits + 1; end if;
    AvailV := X diff orbs;
  end while;
  return num_orbits;
end function;

ESN := function(q) //normaliser of Q8 in GL(2,q)
 G:=SL(2,q); S:=Sylow(G,2); C:=Classes(S);    
 o4 := [c[3]: c in C | c[1] eq 4];
 o4b :=  [c[3] : c in C | c[1] eq 4 and c[2] le 2];
 Q:=sub<S|o4b>;
 if o4 ne o4b then ee := [g: g in o4 | not g in o4b][1]; Q:=sub<S|Q,ee>; 
 end if;
 return Normaliser(GL(2,q),Q);
end function;

MaxPrimSolSubs := function(G,phi,K) 
  //Now we just find all examples with no regular orbits
  GG := G @@ phi;
  V := GModule(GG);
  if IsSolvable(G) and Rank(GG, V) ge 5 then
    return [];
  end if;
  gps := []; cands := [G];
  if IsSolvable(G) then Append(~gps,G @@ phi); end if;
  i := 1;
  while i le #cands do
   M := [m`subgroup : m in MaximalSubgroups(cands[i])];
   MI := [m @@ phi : m in M];
   inds := [j : j in [1..#M] | IsIrreducible(MI[j])];
   "  i,#irredmax,#cands,#gps = ", i,#inds,#cands,#gps;
   for j in inds do
     got:=false;
     for g in cands do if IsConjugate(G,M[j],g) then got:=true; break;
     end if; end for;
     if not got then
        // ip := LMGIsPrimitive(G);
        V := GModule(MI[j]);
        if (not IsSolvable(G)) or Rank(MI[j],V) lt 5 then
          /* if ip then */ Append(~cands,M[j]); // end if;
          if IsSolvable(M[j]) // and ip eq 1 
	    then Append(~gps, MI[j]);
          end if;
        end if;
     end if;
   end for;
   i +:= 1;
  end while;
  return gps;
end function;

// "1.2 part 3 b
// "b=3, p=3, a=1, d=6";
for q in [3] do
  GG := ESN(q);
  F := FittingSubgroup(GG);
  GG := TensorProduct(GG,GL(3,q));
  FG :=  TensorProduct(F,sub<GL(3,q)|>);
  K := FG;
  Q, phi := quo< GG | K >;
  S := MaxPrimSolSubs(Q, phi, K); #S;
  V := VectorSpace(GG);
  for s in S do "next s";
    J :=  sub< s | Centraliser(s,FG), FG >;
    CC := J eq FG select [s] else Complements(s,J,FG);
    CCRQ := [ c : c in CC | IsIrreducible(c) /* and  LMGIsPrimitive(c) */ ];
    #CCRQ;
    for c in CCRQ do
      rank := Rank(c,V);
      if rank lt 5 then
        ce:=c; "Example of order",#ce,"with rank",rank;
      end if;
    end for;
  end for;
end for;

MaxPrimSolSubs := function(G,phi,K) 
  //Now we just find all examples with no regular orbits
  GG := G @@ phi;
  V := GModule(GG);
  if IsSolvable(G) and Rank(GG, V) ge 5 then
    return [];
  end if;
  gps := []; cands := [G];
  if IsSolvable(G) then Append(~gps,G @@ phi); end if;
  i := 1;
  while i le #cands do
   M := [m`subgroup : m in MaximalSubgroups(cands[i])];
   MI := [m @@ phi : m in M];
   inds := [j : j in [1..#M] | IsIrreducible(MI[j])];
   "  i,#irredmax,#cands,#gps = ", i,#inds,#cands,#gps;
   for j in inds do
     got:=false;
     for g in cands do if IsConjugate(G,M[j],g) then got:=true; break;
     end if; end for;
     if not got then
        ip := LMGIsPrimitive(G);
        V := GModule(MI[j]);
        if (not IsSolvable(G)) or Rank(MI[j],V) lt 5 then
          if ip then Append(~cands,M[j]); end if;
          if IsSolvable(M[j]) and ip eq 1 
	    then Append(~gps, MI[j]);
          end if;
        end if;
     end if;
   end for;
   i +:= 1;
  end while;
  return gps;
end function;
