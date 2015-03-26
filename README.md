# Alien Language
This is my solution for [Alien Language](https://code.google.com/codejam/contest/90101/dashboard#s=p0).

I think the ideal solution in terms of implementation time and most likely runtime is to simply turn the request patterns into regex and search against the given words in the language.


## My Approach
My approach however involved:

1.  Populating tries that contained every word in the dictionary.

2.  Turning the test cases into a usuable format.  I turned each test case into a list holding either the given letter, or for every variable pattern, I put each allowed letter for a single position into a queue (actually Ruby Array, b/c Ruby arrays implement tons of data structure APIs). 

3.  This test case format made it easier for me to process each test case.  For the simple case of static letters, I'd take the first letter in the request, I'd grab the correct trie, and for each letter, I'd find the next matching node in the trie if it existed.  If it didn't, I knew I was done and no match existed.  If I made it to the end of the word, I knew I had a match.

4.  For the more complex case of multiple letters in the same position, I'd use depth first search and run each particular letter to the end, randomly picking a single a letter each time I had a queue (Ruby Array).  After I hit the end of a particular pattern, the function would test to see if there was a match, and return that value (1 for a match, 0 for not).  The stack frames would then unwind, where I'd recursively check every letter in the queue.  As I finished processing each queue, I'd restore the contents of that queue so that as I kept unwinding to earlier in the test case string, I'd have the entire conents of that later queue to test against.

### Notes
Implementation wise, every time I say I use the letter as a key in some hash, I actually use a Ruby symbol as those yield faster runtime, especially in lower versions of Ruby where the speed enhancements are more pronounced.  This has to do with the fact that all Ruby symbols have precomputed hashes as opposed to strings, which need to be done everytime.  Also in earlier versions of Ruby, symbols are also not garbage collected, which is perfect for me, as I don't really care about memory leaks here and actually prefer them not even being examined for GC.


## Interesting Hiccups
This took me a lot longer than I wanted to solve it.  A few interesting things I ran into:

I wanted to initially use this [trie](https://github.com/tyler/trie) but it took me way too long to try and figure out how to make their API work they way I wanted, so I finally just ended up implementing my own trie that exposed the operations I wanted.

My tries themselves are very simple.  They consists of nodes, where each node contains the letter as well as a hash of subsequent letters to subsequent node.  


## Analysis
I don't really care too much about the memory costs as long as I don't balloon over 16 gigs, which is how much is on my computer.  I'm more interested in runtime speed.

The first cost is associated with building my tries.  For every word in the dictionary, theres a constant cost of building each node.  I get a slight break if words start out the same, as I can reuse nodes from an earlier built trie.  To build a node, I need to create the object, save the value in it, and then create a new hash to store the children.  As I build up the trie and add a new node, I grab the first letter, turn it into a symbol, create a new node for the next letter, and put that all into the children map.  Then I advance myself to that node, ready to create the next letter in the trie.  All this is constant time and it's complexity is associated linearly with the size of the input.

Building up the tests cases works the same as well.  The work done for each letter are constant time operations that are all done n times, where n is the test case size (number of letters in the test case).

To test each test case, which means checking all of the combinations for a given input pattern, I perform a recursive depth first search that results in a search that is at worst linear with respect to the number of edges that result from all the possible combinations for that pattern.  Often I'm able to quit early when I find an invalid combination, allowing me to skip large number of combinations that derive from that base.


## Final Thoughts
I wanted to check in my solution file for the large input, but github's size limits didn't allow me to do that.  So just clone the project and run:

```shell
bundle install
./run.sh
```

I ran it against Google's validator and it was correct with respect to both the simple and complex test cases.  Feel free to drop me any comments!
