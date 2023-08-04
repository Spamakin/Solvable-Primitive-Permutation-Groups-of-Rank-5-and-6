# Primitive Solvable Permutation Groups of Rank 5 and 6

### Tour of the Repository

Running [`bounds.py`](bounds.py) will generate the list of possible parameters as described in Algorithm 2.11. 

The `GAP` files [`find_rank_6_b1.g`](find_rank_6_b1.g) and [`find_rank_6_b2.g`](find_rank_6_b2.g) contain implementations of Algorithm 3.1 in the case of both `b = 1` and `b > 1`. The file [`e6.g`](e6.g) contains an implementation of the decomposition described in Lemma 3.2. These can be run as such in any commandline:
``` sh
gap -q < find_rank_6_b1.g
```
However, before running these make sure to edit the variable `OutputDirr` to point to where the resulting files of groups should be saved. All of these files were generated using `GAP 4.11.1` and `GAP 4.12.2`. Memory usage can be a concern on less powerful systems with some sets of parameters taking over 48 GB of RAM.

The file [`summary_stats.g`](summary_stats.g) provides useful enumeration code for working with all of the groups generated. Again before using it, change the variable `FolderPath` to point to where the generated groups are saved.

Notes + code for Examples 4.1, 4.2 and 4.3 can be found in [`examples.md`](examples.md).
