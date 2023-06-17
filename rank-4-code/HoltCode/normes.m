IsQuasiPrimitive := function(G)
  N := NormalSubgroups(G);
  return forall(t){t: t in N | #Constituents(GModule(t`subgroup)) eq 1};
end function;

PermutationMatrix := function(perm,F)
  //Why is this not an internal function!!!
  //perm permutation, F = field.
  local ps, d, V, W;
  ps := ElementToSequence(perm);
  d := #ps;
  V := RMatrixSpace(F,d,d);
  W := VectorSpace(F,d);
  return V![ W.(ps[i]) : i in [1..d] ];
end function;

PermInducingAut := function(R,phi)
//Given automorphism phi of regular permutation group R, and an automorphism
//phi of R, return unique permutation fixing 1, normalising R and
//inducing phi on R
  local d;
  d := Degree(R);
  perm :=[1];
  for i in [2..d] do
    isc,g := IsConjugate(R,1,i);
    perm[i] := 1^(phi(g));
  end for;
  return Sym(d)!perm;
end function;

MakeDeterminantOne := function(mat)
//If possible multiply matrix mat by scalar matrix to make determinant 1
 local d, K, det, isp, r;
 d := Nrows(mat); K := BaseRing(mat);
 det := Determinant(mat);
 if det eq K!1 then return mat; end if;
 isp,r := IsPower(det^-1,d);
 if isp then return mat * ScalarMatrix(K,d,r);
 else return mat;
 end if;
end function;


NormaliserOfExtraSpecialGroup:= function(r,q)
/* Construct complete normaliser of extraspecial group as subgroup of
 * GL(r,q). r must be a prime power p^n with p | q-1.
 * Extraspecial group has order p^(2n+1) and exponent p for p odd,
 * and is of + type - central product of dihedrals - for p=2.
 */
  local fac, p, n, gl, z, w, esg, d, M, mat, insl, slm1, slm2, slm3, exp, rno,
        dp, R, phi;
  if r le 2 then error
     "Degree must be at least 3 in NormaliserOfExtraSpecialGroup";
  end if;

  insl := true;
  fac := Factorisation(r);
  if #fac ne 1 then error
     "First argument must be a prime power in NormaliserOfExtraSpecialGroup";
  end if;
  p := fac[1][1]; n := fac[1][2];
  if (q-1) mod p ne 0 then error
     "Divisibility condition not satisfied in NormaliserOfExtraSpecialGroup";
  end if;
  z := PrimitiveElement(GF(q));  w := z^((q-1) div p);
    // w is a primitive p-th root of 1
  gl := GL(r,q);
  // first make generators of extraspecial group
  esg := [gl|];

  //diagonal generators:
  for i in [0..n-1] do
    d := [];
    for j in [1..p^(n-1-i)] do
      for k in [0..p-1] do
        for l in [1..p^i] do Append(~d,w^k); end for;
      end for;
    end for;
    Append(~esg, DiagonalMatrix(GF(q),d));
  end for;

  //permutation matrix generators
  M := func< r,p | r mod p eq 0 select p else r mod p >;
    
  dp := []; // we will collect the permutations for use later.
  for i in [0..n-1] do
    perm := [];
    for j in [1..p^(n-1-i)] do
      for l in [1..p^(i+1)] do
         perm[(j-1)*p^(i+1) + l] := (j-1)*p^(i+1) + M(l+p^i,p^(i+1));
      end for;
    end for;
    Append(~dp,perm);
    Append(~esg, PermutationMatrix(perm,GF(q)) );
  end for;

  //esg now generates extraspecial group of order p^(2n+1).

  //Now normaliser gens.
  esn := [gl|];
  //First diagonals.
  for i in [0..n-1] do
    d := [];
    for j in [1..p^(n-1-i)] do
      exp := 0;
      for k in [0..p-1] do
        exp +:= k;
        for l in [1..p^i] do Append(~d,w^exp); end for;
      end for;
    end for;
    
    slm1 := MakeDeterminantOne(DiagonalMatrix(GF(q),d));
    if Determinant(slm1) ne w^0 then
      if r ne 3 then error "Bug A"; end if;
      insl := false;
    end if;
    Append(~esn, slm1);
  end for;

  slm2:=[];
  for i in [0..n-1] do
    mat := MatrixAlgebra(GF(q),p^(i+1))!0;
    rno := 0;
    for k in [0..p-1] do
      for j in [1..p^i] do
         rno +:= 1;
         for l in [0..p-1] do
           mat[rno][j+l*p^i] := w^(k*l);
         end for;
      end for;
    end for;
    mat := DirectSum([mat : j in [1..p^(n-1-i)]]);
    slm2[i+1] := MakeDeterminantOne(mat);
    if r eq 3 and not insl then Append(~esn,slm1^-1*slm2[i+1]*slm1); end if;
    if Determinant(slm2[i+1]) ne w^0 then
      if r ne 4 then error "Bug B"; end if;
      if insl then
        insl := false;
        Append(~esn, slm2[i+1]);
      else Append(~esn, slm2[i]^-1*slm2[i+1]);
      end if;
    else Append(~esn, slm2[i+1]);
    end if;
  end for;

  //Finally some permutation matrices that normalise it.
  R := sub< Sym(r) | dp >;
  for i in [2..n] do
    phi := hom< R->R | [R.1*R.i] cat [R.j : j in [2..n]] >;
    slm3 :=
        MakeDeterminantOne(PermutationMatrix(PermInducingAut(R,phi),GF(q)));
    Append(~esn,slm3);
    if  insl and Determinant(slm3) ne w^0 then
      // q  = 3 or 7 mod 8
      if r ne 4 then error "Bug C"; end if;
      Append(~esn, slm3^-1*slm2[1]*slm3);
      Append(~esn, slm3^-1*slm2[2]*slm3);
    end if;
    if not insl then
      // q = 5 mod 8
      Append(~esn, MakeDeterminantOne(slm2[1]*slm3));
    end if; 

  end for;

  return sub< gl | esg cat esn, ScalarMatrix(r,PrimitiveElement(GF(q))) >;

end function;

NormaliserOfSymplecticGroup:= function(r,q)
/* Construct complete normaliser of group of symplectic type as subgroup of
 * GL(r,q). r must be a prime power 2^n with 4 | q-1.
 * Symplectic group has order 2^(2n+2) and exponent 4.
 */
  local fac, p, n, gl, z, w, w4, esg, d, M, mat, exp, rno, dp, R, phi,
        insl, slmk, slmk2, slm, got;

  if r le 2 then error
     "Degree must be at least 3 in NormaliserOfSymplecticGroup";
  end if;
  fac := Factorisation(r);
  if #fac ne 1 then error
     "First argument must be a prime power in NormaliserOfSymplecticGroup";
  end if;
  p := fac[1][1]; n := fac[1][2];
  if p ne 2 then error "Prime must be 2 in NormaliserOfSymplecticGroup";
  end if;
  if (q-1) mod 4 ne 0 then error
     "Divisibility condition not satisfied in  NormaliserOfSymplecticGroup";
  end if;
  z := PrimitiveElement(GF(q));  w := z^((q-1) div p);
    // w is a primitive p-th root of 1
  gl := GL(r,q);
  // first make generators of extraspecial group
  esg := [gl|];

  insl := true;
  //diagonal generators:
  for i in [0..n-1] do
    d := [];
    for j in [1..p^(n-1-i)] do
      for k in [0..p-1] do
        for l in [1..p^i] do Append(~d,w^k); end for;
      end for;
    end for;
    Append(~esg, DiagonalMatrix(GF(q),d));
  end for;

  //permutation matrix generators
  M := func< r,p | r mod p eq 0 select p else r mod p >;
    
  dp := []; // we will collect the permutations for use later.
  for i in [0..n-1] do
    perm := [];
    for j in [1..p^(n-1-i)] do
      for l in [1..p^(i+1)] do
         perm[(j-1)*p^(i+1) + l] := (j-1)*p^(i+1) + M(l+p^i,p^(i+1));
      end for;
    end for;
    Append(~dp,perm);
    Append(~esg, PermutationMatrix(perm,GF(q)) );
  end for;

  //We also take a scalar of order 4, although this seems to be there anyway!
  w4 := z^((q-1) div 4);
  Append(~esg, DiagonalMatrix(GF(q),[w4: i in [1..r]]));

  //esg now generates symplectic type group of order p^(2n+2).

  //Now normaliser gens.
  esn := [gl|];
  //diagonals different for symplectic
  for i in [0..n-1] do
    d := [];
    for j in [1..p^(n-1-i)] do
      exp := 0;
      for k in [0..p-1] do
        exp +:= k;
        for l in [1..p^i] do Append(~d,w4^exp); end for;
      end for;
    end for;
    slm := MakeDeterminantOne(DiagonalMatrix(GF(q),d));
    if Determinant(slm) ne   w^0 then
      if r ne 4 then error "Bug B"; end if;
      if insl then
        insl := false;
        Append(~esn, slm);
        slmk := slm;
      else Append(~esn, slmk^-1*slm);
      end if;
    else Append(~esn, slm);
    end if;
  end for;

  got := false;
  for i in [0..n-1] do
    mat := MatrixAlgebra(GF(q),p^(i+1))!0;
    rno := 0;
    for k in [0..p-1] do
      for j in [1..p^i] do
         rno +:= 1;
         for l in [0..p-1] do
           mat[rno][j+l*p^i] := w^(k*l);
         end for;
      end for;
    end for;
    mat := DirectSum([mat : j in [1..p^(n-1-i)]]);
    slm := MakeDeterminantOne(mat);
    if Determinant(slm) ne  w^0 then
      if r ne 4 then error "Bug C"; end if;
      if not got then
        got := true;
        slmk2 := slm;
        Append(~esn, slm);
      else Append(~esn, slmk2^-1*slm);
      end if;
    else Append(~esn, slm);
    end if;
  end for;

  //Finally some permutation matrices that normalise it.
  R := sub< Sym(r) | dp >;
  for i in [2..n] do
    phi := hom< R->R | [R.1*R.i] cat [R.j : j in [2..n]] >;
    slm :=
         MakeDeterminantOne(PermutationMatrix(PermInducingAut(R,phi),GF(q)));
    if Determinant(slm) ne  w^0 then
      if r ne 4 then error "Bug D"; end if;
      Append(~esn, slmk^-1*slm);
    else Append(~esn, slm);
    end if;
  end for;

  return sub< gl | esg cat esn, ScalarMatrix(r,PrimitiveElement(GF(q))) >;

end function;


NormaliserOfExtraSpecialGroupMinus := function(r,q)
/* Construct complete normaliser of minus-type extraspecial group as subgroup
 * of GL(r,q), where r = 2^n.
 */
  local fac, p, n, gl, w, a, b, esg, d, M, mat, exp, rno, dp, R, phi,
        mat1, mat2, slm, insl, slmk;
  fac := Factorisation(r);
  if #fac ne 1 or fac[1][1] ne 2 or q mod 2 ne 1 then error
   "First argument must be a power of 2 in NormaliserOfExtraSpecialGroupMinus";
  end if;
  n := fac[1][2];

  insl := true;
  gl := GL(r,q);
  w := GF(q)!(-1);
  // first make generators of extraspecial group
  // need two squares summing to -1.
  a:= 0;
  for i in [1..q-1] do
     bool, b:= IsSquare(GF(q)!(-1 - i^2));
     if bool then
         a:= GF(q)!i;
         break;
     end if;
  end for;

  esg := [gl|];
  mat := GL(2,q)![a,b,b,-a]; //Det(mat) = 1
  Append(~esg,DirectSum([mat : j in [1..2^(n-1)]]));

  //diagonal generators (n >= 1):
  for i in [1..n-1] do
    d := [];
    for j in [1..2^(n-1-i)] do
      for k in [0..1] do
        for l in [1..2^i] do Append(~d,w^k); end for;
      end for;
    end for;
    Append(~esg, DiagonalMatrix(GF(q),d));
  end for;

  //permutation matrix generators
  M := func< r,p | r mod p eq 0 select p else r mod p >;
    
  dp := []; // we will collect the permutations for use later.
  for i in [0..n-1] do
    perm := [];
    for j in [1..2^(n-1-i)] do
      for l in [1..2^(i+1)] do
         perm[(j-1)*2^(i+1) + l] := (j-1)*2^(i+1) + M(l+2^i,2^(i+1));
      end for;
    end for;
    Append(~dp,perm);
    if i eq 0 then
      Append(~esg, PermutationMatrix(perm,GF(q)) *
                     DiagonalMatrix(GF(q),&cat[[1,-1] : i in [1..2^(n-1)]])  );
      //determinant = 1
    else
      Append(~esg, PermutationMatrix(perm,GF(q)) );
    end if;
  end for;

  //esg now generates extraspecial group of order p^(2n+1).

  //Now normaliser gens.
  esn := [gl|];
  //first those for first component.
  mat1 := GL(2,q)![1,1,-1,1]; //Det(mat1) = 2
  slm := MakeDeterminantOne(DirectSum([mat1 : j in [1..2^(n-1)]]));
  if Determinant(slm) ne w^0 then
    if r gt 4 then error "Bug A"; end if;
    insl := false;
    slmk := slm;
  end if;
  Append(~esn,slm);
  mat2 := GL(2,q)![1+a+b,1-a+b,-1-a+b,1-a-b]; //Det(mat2) = 4
  slm := MakeDeterminantOne(DirectSum([mat2 : j in [1..2^(n-1)]]));
  if Determinant(slm) ne w^0 then error "Bug B"; end if;
  Append(~esn,slm);

  for i in [1..n-1] do
    mat := MatrixAlgebra(GF(q),2^(i+1))!0;
    rno := 0;
    for k in [0..1] do
      for j in [1..2^i] do
         rno +:= 1;
         for l in [0..1] do
           mat[rno][j+l*2^i] := w^(k*l);
         end for;
      end for;
    end for;
    slm := MakeDeterminantOne(DirectSum([mat : j in [1..2^(n-1-i)]]));
    if Determinant(slm) ne w^0 then
      Append(~esn,slmk^-1*slm);
    else Append(~esn,slm);
    end if;
  end for;

  if n gt 1 then
    //One to mix up the first and second Q8 and D8
    mat := MatrixAlgebra(GF(q),4)![1,0,1,0,0,1,0,1,0,1,0,-1,-1,0,1,0];
    //Det(mat)=4
    slm := MakeDeterminantOne(DirectSum([mat : j in [1..2^(n-2)]]));
    if Determinant(slm) ne w^0 then
      Append(~esn,slmk^-1*slm);
    else Append(~esn,slm);
    end if;

    //Finally some permutation matrices that normalise it.
    R := sub< Sym(r) | dp >;
    for i in [3..n] do
      phi := hom< R->R | [R.1, R.2*R.i] cat [R.j : j in [3..n]] >;
      slm := MakeDeterminantOne(
              PermutationMatrix(PermInducingAut(R,phi),GF(q)) );
      if Determinant(slm) ne w^0 then error "Bug C"; end if;
      Append(~esn,slm);
    end for;
  end if;

  return sub< gl | esg cat esn, ScalarMatrix(r,PrimitiveElement(GF(q))) >;

end function;
