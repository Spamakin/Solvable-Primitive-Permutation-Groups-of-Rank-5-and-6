L := [
  [ [ 2, 0, 0, 0, 0, 0 ],
      [ 0, 2, 0, 0, 0, 0 ],
      [ 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 1, 0, 0 ],
      [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ],
  [ [ 1, 0, 0, 1, 0, 0 ],
      [ 0, 1, 0, 0, 1, 0 ],
      [ 0, 0, 1, 0, 0, 1 ],
      [ 0, 0, 0, 1, 0, 0 ],
      [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ],
  [ [ 1, 0, 0, 1, 0, 0 ],
      [ 0, 1, 0, 0, 1, 0 ],
      [ 0, 0, 1, 0, 0, 1 ],
      [ 1, 0, 0, 2, 0, 0 ],
      [ 0, 1, 0, 0, 2, 0 ],
      [ 0, 0, 1, 0, 0, 2 ] ],
  [ [ 2, 0, 0, 1, 0, 0 ],
      [ 0, 2, 0, 0, 1, 0 ],
      [ 0, 0, 2, 0, 0, 1 ],
      [ 1, 0, 0, 1, 0, 0 ],
      [ 0, 1, 0, 0, 1, 0 ],
      [ 0, 0, 1, 0, 0, 1 ] ],
  [ [ 2, 0, 0, 0, 0, 0 ],
      [ 0, 2, 0, 0, 0, 0 ],
      [ 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0 ],
      [ 0, 0, 0, 0, 2, 0 ],
      [ 0, 0, 0, 0, 0, 2 ] ],
  [ [ 1, 0, 1, 0, 0, 0 ],
      [ 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 0, 0 ],
      [ 0, 0, 0, 1, 0, 1 ],
      [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ],
  [ [ 1, 1, 0, 0, 0, 0 ],
      [ 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 0, 0 ],
      [ 0, 0, 0, 1, 1, 0 ],
      [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ],
  [ [ 2, 0, 0, 0, 0, 0 ],
      [ 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0 ],
      [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ],
  [ [ 1, 0, 0, 1, 0, 0 ],
      [ 0, 2, 1, 0, 2, 1 ],
      [ 0, 1, 0, 0, 1, 0 ],
      [ 1, 0, 0, 0, 0, 0 ],
      [ 0, 2, 1, 0, 0, 0 ],
      [ 0, 1, 0, 0, 0, 0 ] ],
  [ [ 0, 0, 0, 2, 0, 0 ],
      [ 0, 0, 0, 0, 0, 2 ],
      [ 0, 0, 0, 0, 1, 1 ],
      [ 1, 0, 0, 2, 0, 0 ],
      [ 0, 0, 1, 0, 0, 2 ],
      [ 0, 2, 2, 0, 1, 1 ] ],
  [ [ 0, 0, 0, 0, 2, 0 ],
      [ 0, 0, 0, 0, 0, 2 ],
      [ 0, 0, 0, 1, 0, 1 ],
      [ 0, 1, 0, 0, 2, 0 ],
      [ 0, 0, 1, 0, 0, 2 ],
      [ 2, 0, 2, 1, 0, 1 ] ] ];
G := GL(6,3);
N := sub<G | L>;

result := [];

// possibleSubgroups := MaximalSubgroups(N);
possibleSubgroups := MaximalSubgroups(N);
while #possibleSubgroups ge 1 do
	    g := possibleSubgroups[1]`subgroup;

	        if Order(g) ge 100 and IsIrreducible(g) then
			            if LMGIsPrimitive(g) then
					            if IsSoluble(g) then
							                rank := #Orbits(g);
									            if rank le 4 and rank ge 2 then
											                    "Rank = ", rank, ".Order = ", #g;
													    Generators(g), "\n";
													                possibleSubgroups := possibleSubgroups cat MaximalSubgroups(g);
															            end if;
																            else
																		                possibleSubgroups := possibleSubgroups cat MaximalSubgroups(g);
																				        end if;
																				end if;
																				    end if;
																				        possibleSubgroups := Remove(possibleSubgroups,1);
																				end while;
print(result);
