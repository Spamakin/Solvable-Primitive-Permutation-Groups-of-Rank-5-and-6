load 'normes.m'; //for O^+(4,q)

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

"line 117, b=2, p=3, a=1, d=8; Case 1";
C:=ClassicalMaximals("S",4,3:classes:={6},normaliser:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,3));
FG :=  TensorProduct(F,sub<GL(2,3)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  //we only wnat examples with C(FG) <= FG.
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps117a",gps); end if;

"line 117, b=2, p=3, a=1, d=8; Case 2";
GG := COPlus(4,3); //solvable
F := FittingSubgroup(GG);
GG := TensorProduct(GG,GL(2,3));
FG :=  TensorProduct(F,sub<GL(2,3)|>);
K := FG;
Q, phi := quo< GG | K >;
//Q, phi, K := RadicalQuotient(GG);
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c;
      new := true;
      for g in gps do
        if IsConjugate(GG,ce,g) then new:=false; break; end if;
      end for;
      if new then "Example of order",#ce,"with no regular orbit found";
         Append(~gps,ce);
      end if;
    end if;
  end for;
end for; //Example of order 2304 with no regular orbit found
if gps ne [] then PrintFileMagma("E4q.gps117b",gps); end if;

"line 118, b=2, p=5, a=1, d=8";
C:=ClassicalMaximals("L",4,5:classes:={6},general:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,5));
FG :=  TensorProduct(F,sub<GL(2,5)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps118",gps); end if;

"Line 119, b=2, p=7, a=1, d=8, Case 1";
C:=ClassicalMaximals("S",4,7:classes:={6},normaliser:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,7));
FG :=  TensorProduct(F,sub<GL(2,7)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps119a",gps); end if;

"Line 119, b=2, p=7, a=1, d=8, Case 2";
GG := NormaliserOfExtraSpecialGroup(4,7); //solvable
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,7));
FG :=  TensorProduct(F,sub<GL(2,7)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps119b",gps); end if;

"Line 120, b=2, p=11, a=1, d=8, Case 1";
C:=ClassicalMaximals("S",4,11:classes:={6},normaliser:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,11));
FG :=  TensorProduct(F,sub<GL(2,11)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps120a",gps); end if;

"Line 120, b=2, p=11, a=1, d=8, Case 2";
GG := NormaliserOfExtraSpecialGroup(4,11); //solvable
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(2,11));
FG :=  TensorProduct(F,sub<GL(2,11)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
V := VectorSpace(GG);
gps := [];
for s in [GG] do
  if NoRegOrb(s,V) then
     ce:=s; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
  end if;
end for; //example of orders 11520 with no regular orbits
if gps ne [] then PrintFileMagma("E4q.gps120b",gps); end if;

"Line 121, b=3, p=3, a=1, d=12; Case 1";
C:=ClassicalMaximals("S",4,3:classes:={6},normaliser:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(3,3));
FG :=  TensorProduct(F,sub<GL(3,3)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps121a",gps); end if;

"Line 121, b=3, p=3, a=1, d=12; Case 2";
GG := COPlus(4,3); //solvable
F := FittingSubgroup(GG);
GG := TensorProduct(GG,GL(3,3));
FG :=  TensorProduct(F,sub<GL(3,3)|>);
K := FG;
Q, phi := quo< GG | K >;
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for; //Example of order 2304 with no regular orbit found
if gps ne [] then PrintFileMagma("E4q.gps121b",gps); end if;

"Line 122, b=4, p=3, a=1, d=16; Case 1";
C:=ClassicalMaximals("S",4,3:classes:={6},normaliser:=true,all:=false); #C;
F := FittingSubgroup(C[1]);
GG := TensorProduct(C[1],GL(4,3));
FG :=  TensorProduct(F,sub<GL(4,3)|>);
Q, phi, K := RadicalQuotient(GG);
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps122a",gps); end if;

"Line 122, b=4, p=3, a=1, d=16; Case 2";
GG := COPlus(4,3); //solvable
F := FittingSubgroup(GG);
GG := TensorProduct(GG,GL(4,3));
FG :=  TensorProduct(F,sub<GL(4,3)|>);
Q, phi, K := RadicalQuotient(GG);
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps122b",gps); end if;

BlowUpMatrix := function(A,F)
  K := BaseRing(A);
  assert F subset K;
  w := PrimitiveElement(K);
  mat := CompanionMatrix(MinimalPolynomial(w,F));
  return BlockMatrix(Nrows(A),Ncols(A),
     [x eq 0 select 0*mat else mat^Log(w,x) : x in Eltseq(A)]);
end function;

BlowUpMatrixGroup := function(G,F)
  K := BaseRing(G);
  dKG := Degree(K,F); ndeg := dKG*Degree(G);
  return sub< GL(ndeg,F) | [BlowUpMatrix(G.i,F) : i in [1..Ngens(G)]] >;
end function;

"Line 123, b=2, p=3, a=2, d=16";
C:=ClassicalMaximals("U",4,3:classes:={6},normaliser:=true,all:=false);
GG:=C[1];
F := FittingSubgroup(GG);
GG := TensorProduct(GG,GL(2,9));
FG := TensorProduct(F,sub<GL(2,9)|>);
GG := BlowUpMatrixGroup(GG,GF(3));
FG := BlowUpMatrixGroup(FG,GF(3));
//extend by outer automorphism
AG := AutomorphismGroup(GG);
AGF, FtoAG := FPGroup(AG);
OAG, AtoO := OuterFPGroup(AG);
ca, ci := CosetAction(OAG,sub<OAG|>);
newg := [];
for x in ci do if x ne ci.0 then
  out := x @@ ca @@ AtoO @ FtoAG;
  M := GModule(GG);
  MM := GModule(GG, [ g @ out : g in [GG.i : i in [1..Ngens(GG)]] ]);
  isit, iso := IsIsomorphic(M, MM);
  if isit then "induced auto";
    Append(~newg, iso);
  end if;
end if; end for;
GG:=sub<GL(16,3) | GG, newg >;
Q, phi, K := RadicalQuotient(GG);
S := MaxQPrimSolSubsRQ(Q, phi, K); #S;
V := VectorSpace(GG);
gps := [];
for s in S do "next s";
  J :=  sub< s | Centraliser(s,FG), FG >;
  CC := J eq FG select [s] else Complements(s,J,FG);
  CCRQ := [ c : c in CC | IsIrreducible(c) and IsQuasiPrimitive(c,K) eq 1 ];
  #CCRQ;
  for c in CCRQ do
    if NoRegOrb(c,V) then
      ce:=c; "Example of order",#ce,"with no regular orbit found";
      Append(~gps,ce);
    end if;
  end for;
end for;
if gps ne [] then PrintFileMagma("E4q.gps123",gps); end if;

