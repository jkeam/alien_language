#Alien Language
This is my solution for (Alien Language)[https://code.google.com/codejam/contest/90101/dashboard#s=p0]

This took me a lot longer than I wanted to solve it.  A few interesting things I ran into:

I wanted to initially use this (trie)[https://github.com/tyler/trie] but it took me way too long to try and figure out how to make their API work they way I wanted, so I finally just ended up implementing my own trie (tree.rb and node.rb) that exposed the operations I wanted.

My tries themselves are very simple.  They consists of nodes, where each node contains the letter as well as a hash of subsequent letters to subsequent node.  Because I use hashes, each insertion is a constant time operation performed every time for each unique letter in a unique sequence.  Retrieval is also a constant time operation that I need to perform at most, n times for a given unique search pattern.  Often, the comparisons are less than that because as I walk a given pattern, if I find a letter does not exist in any of my tries, I can terminate checking that pattern and any permutations that arise from that base pattern.

In order to efficiently check all of the combinations for a given input pattern, I perform a recursive depth first search that results in a search that is at worst linear with respect to the number of edges that result from all the possible combinations for that pattern.  Of course, as I said earlier, often I'm able to quit early when I find an invalid combination, allowing me to skip large number of combinations that derive from that base.

I wanted to check in my solution file for the large input, but github's size limits didn't allow me to do that.  So just clone the project and run:

```shell
bundle install
./run.sh
```

to get the solution.  I ran it against Google's validator and it was all correct.  Please leave comments if you see any ways to improve.
