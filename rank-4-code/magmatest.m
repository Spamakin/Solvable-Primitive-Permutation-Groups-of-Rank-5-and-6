LowRank := function(G,V)
  orbs := Orbits(G);
  if #orbs le 6 then
    return true;
  else
    return false;
  end if;
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

for q in [3,5,7] do
  N := ESN(q);
  if IsSoluble(N) and LMGIsPrimitive(N) then
          rank := #Orbits(N);
          if rank le 4 and rank ge 2 then
              print("\n we have a group!");
              print(rank);
              print(Order(N));
          else
              possibleSubgroups := MaximalSubgroups(N);
          end if;
  else
      possibleSubgroups := MaximalSubgroups(N);
  end if;

while #possibleSubgroups ge 1 do
  g := possibleSubgroups[1]`subgroup;

  if IsSoluble(g) and LMGIsPrimitive(g) then
          rank := #Orbits(g);
          if rank le 4 and rank ge 2 then
              print("\n we have a group!");
              print(rank);
              print(Order(g));
          else
              possibleSubgroups := possibleSubgroups cat MaximalSubgroups(g);
          end if;
  else
      possibleSubgroups := possibleSubgroups cat MaximalSubgroups(g);
  end if;
  possibleSubgroups := Remove(possibleSubgroups,1);
end while;
end for;

MaxQPrimSolSubsRQ := function(G,phi,K)
  //Now we just find all examples with no regular orbits
  GG := G @@ phi; // preimage of G under phi
  V := GModule(GG);
  if (#GG le 10^7 or IsSolvable(G)) and not LowRank(G,V) then
    return [];
  end if;
  gps := []; cands := [G];
  if IsSolvable(G) then Append(~gps,G @@ phi); end if;
  i := 1;
  while i le #cands do
   M := [m`subgroup : m in MaximalSubgroups(cands[i])]; // M is list of maxsubgroups
   MI := [m @@ phi : m in M]; // Preimage under phi
   inds := [j : j in [1..#M] | IsIrreducible(MI[j])]; // Taking irreducible groups of M
   "  i,#irredmax,#cands,#gps = ", i,#inds,#cands,#gps;
   for j in inds do
     got:=false;
     for g in cands do if IsConjugate(G,M[j],g) then got:=true; break;
   end if; end for; // conjugacy testing
     if not got then
        iqp := LMGIsPrimitive(MI[j]); // Check if primitive
        V := GModule(MI[j]);
        if (#MI[j] gt 10^7 and not IsSolvable(G)) or LowRank(MI[j],V) then
          if iqp eq true then Append(~cands,M[j]); end if;
          if IsSolvable(M[j]) and iqp eq true and LowRank(MI[j],V) then
            Append(~gps, MI[j]);
          end if;
        end if;
     end if;
   end for;
   i +:= 1;
  end while;
  return gps;
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
"Lines 104-109, b=2, p=3,5,7,11,13,17, a=1, d=4";
for q in [3,5,7] do
  GG := ESN(q);
  F := FittingSubgroup(GG);
  GG := TensorProduct(GG,GL(2,q));
  FG :=  TensorProduct(F,sub<GL(2,q)|>); // ??
  K := FG;
  Q, phi := quo< GG | K >; // phi homo from GG -> GG/K
  S := MaxQPrimSolSubsRQ(Q, phi, K); #S; // How does phi work?
  V := VectorSpace(GG);
  for s in S do "next s";
    J :=  sub< s | Centraliser(s,FG), FG >;
    W := {w : w in VectorSpace(FiniteField(q),4)};
    PmGps := sub<Sym(W) | {[w*g : w in W] : g in Generators(s)}>;
    _, permmap := IsIsomorphic(PmGps,s);
    PmGpJ := sub<Sym(W) | {[w*g : w in W] : g in Generators(J)}>;
    PmGpFG := sub<Sym(W) | {[w*g : w in W] : g in Generators(FG)}>;
    CC := J eq FG select [s] else Complements(PmGps,PmGpJ,PmGpFG);
    CCRQ := [ c : c in CC | IsPrimitive(sub<Sym(W) | {[w*g : w in W] : g in Generators(c)}>) eq true];
    for c in CCRQ do
      if LowRank(c,V) then
        ce:=c; "Example of order",#ce,"with low rank", #Orbits(c);
      end if;
    end for;
  end for;
end for; //all have regular orbits

// "Lines 111, 112, b=3, p=3,5, a=1, d=6";
// for q in [3,5] do
//   GG := ESN(q);
//   F := FittingSubgroup(GG);
//   GG := TensorProduct(GG,GL(3,q));
//   FG :=  TensorProduct(F,sub<GL(3,q)|>);
//   K := FG;
//   Q, phi := quo< GG | K >;
//   S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
//   V := VectorSpace(GG);
//   for s in S do "next s";
//     J :=  sub< s | Centraliser(s,FG), FG >;
//     CC := J eq FG select [s] else Complements(s,J,FG);
//     CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
//     #CCRQ;
//     for c in CCRQ do
//       if NoRegOrb(c,V) then
//         ce:=c; "Example of order",#ce,"with no regular orbit found";
//       end if;
//     end for;
//   end for;
// end for; //all have regular orbits
