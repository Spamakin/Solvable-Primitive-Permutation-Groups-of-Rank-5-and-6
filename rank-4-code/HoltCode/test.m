IsQuasiPrimitive := function(G,K)
/* K is a normal subgroup of G
 * returns 1 if G is quasiprimitive
 * returns -1 if there is a non-homogeneous normal subgroup contained in K
 * returns 0 otherwise.
 */
  if LMGIsPrimitive(G) then return 1; end if;
  N := [n`subgroup : n in NormalSubgroups(G)];
  NK := [n : n in N | n subset K];
  NA := [n : n in N | not n in NK ];
  if exists(t){t: t in NK | #Constituents(GModule(t)) gt 1}
    then return -1;
  end if;
  if forall(t){t: t in NA | #Constituents(GModule(t)) eq 1}
     then return 1;
  end if;
  return 0;
end function;

NoRegOrb := function(G,V)
//test whether G has no regular orbits in its action on V
//this can be slow and expensive if G and V are big, so we
//avoid calling it if possible
  orbs := {V!0};
  while #V-#orbs ge #G do
    repeat v:=Random(V); until not v in orbs;
    O := Orbit(G,v);
    orbs join:= {x: x in O};
 // "New orbit of length",#O,"Total length=",#orbs, "number left =", #V-#orbs;
    if #O eq #G then /* "Regular orbit"; */ return false; end if;
  end while;
  return true;
end function;

MaxQPrimSolSubsRQ := function(G,phi,K)
  //Find all solvable quasiprimitive subgroups of GG with no regular orbits
  GG := G @@ phi;
  V := GModule(GG);
  //if GG is large and not solvable then it is unlikely to have regular
  //orbits, so we will not waste time testing and just keep it.
  if (#GG le 10^7 or IsSolvable(G)) and not NoRegOrb(GG,V) then
    return [];
  end if;
  gps := []; cands := [G];
  //cands are the groups for which we need to compute subgroups.
  //gps are the solvable quasiprimitive examples with no regular orbits.
  //GG itself is primitive and hence quasiprimitive
  if IsSolvable(G) then Append(~gps,GG); end if;
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
        iqp := IsQuasiPrimitive(MI[j],K);
        V := GModule(MI[j]);
  //if MI[j] is large and not solvable then it is unlikely to have regular
  //orbits, so we will not waste time testing and just keep it.
        if (#MI[j] gt 10^7 and not IsSolvable(G)) or NoRegOrb(MI[j],V) then
          //if iqp = -1 then there is a non-homogeneous normal subgroup
          //contained in K, so the same will apply to all subgroups, and
          //we do not need to keep it.
          if iqp ne -1 then Append(~cands,M[j]); end if;
          //if #MI[j] le 10^7 then NoRegOrb(MI[j],V) has already been called
          //and returned true, so no need to repeat
          if IsSolvable(M[j]) and iqp eq 1 and
                                  (#MI[j] le 10^7 or NoRegOrb(MI[j],V)) then
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

for q in [3] do
  GG := ESN(q);
  F := FittingSubgroup(GG);
  GG := TensorProduct(GG,GL(2,q));
  FG :=  TensorProduct(F,sub<GL(2,q)|>);
  K := FG;
  Q, phi := quo< GG | K >;
  S := MaxQPrimSolSubsRQ(Q, phi, K); "number of S", #S;
  V := VectorSpace(GG);
  for s in S do "next s";
    J :=  sub< s | Centraliser(s,FG), FG >;
    CC := J eq FG select [s] else Complements(s,J,FG);
    CCRQ := [ c : c in CC | LMGIsPrimitive(c)];
    "number of CCRQ", #CCRQ;
    for c in CCRQ do
      if #Orbits(c) eq 4 then
        ce:=c; "Example of group order",Order(c),"with rank 4";
      end if;
    end for;
  end for;
end for; //all have regular orbits
