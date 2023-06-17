LowRank := function(G, V)
  orbs := Orbits(G);
    if #orbs le 5 and #orbs ge 2 then
        return true;
  else
      return false;
        end if;
end function;

//extraspecial normalizers are solvable and normalizers of Q8
IsQuasiPrimitive := function(G,K)
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

   NoReg := function(G,V)
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
      //Now we just find all examples with no regular orbits
        GG := G @@ phi;
  V := GModule(GG);
    if (#GG le 10^7 or IsSolvable(G)) and not LowRank(G @@ phi,V) then
        return [];
  end if;
    gps := []; cands := [G];
      if IsSolvable(G) then Append(~gps,G @@ phi); end if;
        i := 1;
  while i le #cands do
     M := [m`subgroup : m in MaximalSubgroups(cands[i])];
        MI := [m @@ phi : m in M];
   inds := [j : j in [1..#M] | IsIrreducible(MI[j])];
      for j in inds do
           got:=false;
        for g in cands do if IsConjugate(G,M[j],g) then got:=true; break;
     end if; end for;
          if not got then
          iqp := IsQuasiPrimitive(MI[j],K);
          V := GModule(MI[j]);
          if (#MI[j] gt 10^7 and not IsSolvable(G)) or LowRank(MI[j],V) then
            if iqp ne -1 then Append(~cands,M[j]); end if;
              if IsSolvable(M[j]) and iqp eq 1 and
                                        (#MI[j] le 10^7 or LowRank(MI[j],V)) then
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
    for q in [3] do
      GG := ESN(q);
        F := FittingSubgroup(GG);
  GG := TensorProduct(GG,GL(5,q));
    FG :=  TensorProduct(F,sub<GL(5,q)|>);
      K := FG;
        Q, phi := quo< GG | K >;
  "\n\n order of Q", #Q;
    S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
      V := VectorSpace(GG);
        for s in S do
    J :=  sub< s | Centraliser(s,FG), FG >;
        CC := J eq FG select [s] else Complements(s,J,FG);
    CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
        for c in CCRQ do
      if LowRank(c,V) then
              ce:=c; "Example of order",#ce,"with rank = ", #Orbits(ce);
            end if;
        end for;
  end for;
  end for; //all have regular orbits





