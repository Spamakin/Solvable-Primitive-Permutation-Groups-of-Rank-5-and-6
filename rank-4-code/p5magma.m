L := [ [ [2, 0, 3, 0 ], [ 0,2, 0, 3 ],
      [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ]
     ],
  [ [ 4, 0, 0, 0 ], [ 0, 4, 0, 0 ],
      [ 0, 0, 4, 0 ], [ 0, 0, 0, 4 ]
     ],
  [ [ 3, 0, 0, 0 ], [ 0, 3, 0, 0 ],
      [ 0, 0, 3, 0 ], [ 0, 0, 0, 3 ]
     ],
  [ [ 0, 0, 3, 0 ], [ 0, 0, 0, 3 ],
      [ 3, 0, 4, 0 ], [ 0, 3, 0, 4 ]
     ],
  [ [ 3, 4, 1, 3 ], [ 0, 1, 0, 2 ],
      [ 0, 0, 1, 3 ], [ 0, 0, 0, 2 ] ],
  [ [ 3,2, 3, 2 ], [ 1, 0, 1, 0 ],
      [ 4, 1, 0, 0 ], [ 3, 0, 0, 0 ]
     ] ];
G := GL(4,5);
N := sub<G | L>;
Order(N);

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

// possibleSubgroups := MaximalSubgroups(N);
possibleSubgroups := [* *];

    if IsSoluble(N) and ( IsPrimitive(N) eq true) then
            rank := #Orbits(N);
            if rank le 4 and rank ge 2 then
                print("\n we have a group!");
                print(rank);
                print(Order(N));
            else
                possibleSubgroups := Reverse(MaximalSubgroups(N));
            end if;
    else
        possibleSubgroups := Reverse(MaximalSubgroups(N));
    end if;

while #possibleSubgroups ge 1 do
    g := possibleSubgroups[1]`subgroup;
    
    primitiveBool := false;
    if Type(IsPrimitive(g)) ne Type("unknown") then
	    primitiveBool := IsPrimitive(g);
    end if;

    if IsSoluble(g) and primitiveBool then
            rank := #Orbits(g);
            if rank le 4 and rank ge 2 then
                print("\n we have a group!");
                print(rank);
                print(Order(g));
            else
                possibleSubgroups := Reverse(possibleSubgroups cat MaximalSubgroups(g));
            end if;
    else
        possibleSubgroups := Reverse(possibleSubgroups cat MaximalSubgroups(g));
    end if;
    possibleSubgroups := Remove(possibleSubgroups,#possibleSubgroups);
end while;

