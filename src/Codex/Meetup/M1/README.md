Codex M1 is just around the corner. Here are the puzzles for our first meetup. At the meetup we will spend time discussing each puzzle & the various solutions provided by attendees. Then the floor will be open for sharing & discussion. If you would like to officially present a topic, notify us via pm prior to the meetup.


Sort-of markdown follows.


Codex of South Florida - M1
=========


Below you will find a set of puzzles for the first Codex Meetup (M1). Puzzles consist of several components, each of which have their own level of difficulty. Our hope is that over time, codices (codex members) will learn new concepts, improve their problem solving abilities, and most of all have fun. 


A one week maximum time to completion is very deliberate. Posting puzzles earlier in the month would undoubtedly lead to a time consuming increase in complexity. It's hard to learn comfortably with a large project & a tight deadline looming. Thus, our 1 week notice.


Our strategy is very simple:


A1. STIMULATE (1 Day): Introduce & learn new concepts during each meetup.


A2. RESEARCH (3 Weeks): Ride the recursive wave of curiosity.


A3. PROBLEM SOLVING (1 Week): Test ourselves.


A4. Our strategy is very simple


Finally, do not become discouraged if you find these puzzles too difficult. The very first step to solving any of these problems is breaking them down into smaller components. This attempt


alone is enough to open a very valuable door. Again, make an attempt at each puzzle, even if


it's only on paper or you only partially solve it.


For those capable of solving any or all of the puzzles: After you achieve a solution perhaps keep in mind the time & space complexity of your various algorithms. Also, consider abstraction, composition, readability, verbosity or conciseness, and re-use of the code which builds your solutions.



Puzzle Challenges
---------


1. Compression

--

Task: Given a fixed size chunk of data, design or utilize an existing algorithm which implements lossless compression & decompression.


Demo: Given a file of arbitrary size, demonstrate the ability to losslessly compress & decompress this data.


Hint 1: [(1,'r'),(1,'u'),(1,'n'),(1000000,' '),(1,'l'),(1,'e'),(1,'n'),(1,'g'),(1,'t­'),(1,'h'),(1000000,' '),(1,'e'),(1,'n'),(1,'c'),(1,'o'),(1,'d­'),(1,'e')] 


Hint 2: 1H1u2f1m1a1n1 1c1o1d1i1n1g


Examples
--

     :set -XOverloadedStrings
     :l Codex.Meetup.M1.Compression.Tournament
     import qualified Data.ByteString.Lazy.Char8 as BLC
     simpleCompressionTournament (BLC.take 10 $ BLC.repeat 'c')

     simpleCompressionTournament (BLC.take 10000 $ BLC.cycle "compression yay")
     [("Raw",10000),("Inflate",20000),("RLE",10000),("GZip",72),("BZip",79),("LZ4",73)]

     runCompressionTournament  (BLC.take 10000 $ BLC.cycle "compression yay")
     Result {player = 2, placement = 1, wins = 4, total = 60073}
     Result {player = 6, placement = 2, wins = 5, total = 40298}
     Result {player = 4, placement = 3, wins = 2, total = 10223}
     Result {player = 5, placement = 4, wins = 2, total = 10145}
     Result {player = 1, placement = 5, wins = 1, total = 151}
     Result {player = 3, placement = 5, wins = 1, total = 146}
     "done"


2. Numerical Abstraction
--

Task: Imagine numbers as we know them do not exist. Now imagine you were tasked with representing numbers as either: nothing or the successor of nothing. First, define this numerical representation. Next, implement some basic arithmetic operators: add, subtract, multiply, divide etc. Finally, implement the following functions: factorial, fibonacci, compare, minimum, maximum.


Bonus points: Include the predecessor of nothing in your numerical abstraction.


Demo: Show some examples of your numerical representation and functions in action.


Hint 1: pleh fo eb yam yllacificeps slaremuN hcruhC dna suluclac adbmal eht gnihcraeseR. srebmun onaep.


Hint 2: tsegnolsiohwenoehtsi,slaremunhcruhcybdet­neserpersdnarepoowtfomumixameht,yllarene­G


Examples
--

	*Codex.Lib.Church.Nat> (S O) - (S O)
	O
	*Codex.Lib.Church.Nat> (S O) + (S O)
	S (S O)
	*Codex.Lib.Church.Nat> (S O) * (S O)
	S O
	*Codex.Lib.Church.Nat> (S O) / (S O)
	S O
	*Codex.Lib.Church.Nat> (S (S O)) + (S (S O))
	S (S (S (S O)))
	*Codex.Lib.Church.Nat> (S (S O)) - (S (S O))
	O
	*Codex.Lib.Church.Nat> (S (S O)) * (S (S O))
	S (S (S (S O)))
	*Codex.Lib.Church.Nat> (S (S O)) / (S (S O))
	S (S O)

	fact (S (S (S (S (S O))))) S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

	*Codex.Meetup.M1.NumericalAbstraction.Nat> natToInteger $ fact (S (S (S (S (S O)))))
	120
	*Codex.Meetup.M1.NumericalAbstraction.Nat> natToInteger $ fact (S (S (S (S (S (S O))))))
	720


3. Whose operator is it anyway?
--

Task: Given a set of binary operators, a handful of operands restricted to a specified order (input list), and a result: Discover the operators & order of operations that when applied to the input list will yield our given result.


That is quite vague. Let us be more specific.


Our binary operators should consist of: (+, -, *, /)


Our input list should consist of integers: [Z1...ZN]


Our result will be an integer: Z


Develop an algorithm to provide solutions for our examples & beyond.


Examples:

(+,-) => 1 0 = 1

(+,-,*,/) => 1 1 = 1

(+,-,*,/) => 2 2 = 4

(+,-,*,/) => 2 8 6 2 = 2


Provide an answer for:

(+,-,*,/) => 2 1 3 3 7 4 = 1


4. We are olympians
--


Task: Someone comes to you and says: I need a program to generate the olympic rings visually. Oh, and make sure you get the dimensions & colour right.


Demo: Write a program which will visually generate the olympic rings.


5. DNA
--

Task: You are given a list of non-unique items. A list of non-unique items implies that there is at least one duplicate. Such lists may themselves or their subsequences be palindromes. Develop an algorithm to find the longest palindrome subsequence(s).


Provide an answer for:


Find the largest palindrome(s) comprised of "A, C, T, G" which build the following DNA chains:


[A, T]


[G, A, G]


[C, A, C, A, T, A T]


[T, T, G, A, T, G, G, G, T] 


[C, A, C, A, A, T, T, C, C, C, A, T, G, G, G, T, T, G, T, G, G, A, G]


Examples
--

     largest [A, T]
     []
     largest [G, A, G]
     [[G,A,G]]
     largest [C, A, C, A, T, A T]
     [[T,A,T],[A,T,A],[A,C,A],[C,A,C]]
     largest [T, T, G, A, T, G, G, G, T] 
     [[T,G,G,G,T]]
     largest [C, A, C, A, A, T, T, C, C, C, A, T, G, G, G, T, T, G, T, G, G, A, G]
     [[T,G,G,G,T]]


6. Load balancing
--

Task:

A load balancer is a device or process which attempts to distribute requests based on a small set of strategies. Requests are forwarded to target processors, processes, services, databases, files, etc. 


Let us define our simple load balancer as:

A process which receives any number of connections, upon which consults a strategy that queries the current state of the system, which then distributes said connection to a number of (most likely) pre-defined listeners.


Connections being any arbitrary form of currently open communication.


Load being a quantifiable measure of the load balancer and each of it's listeners.


Listeners being a final destination which accepts connections from our load balancer.


A few load balancing strategies are: Round Robin, Least Load, Source Based, Sticky Session, and Random.


An auto-scaling strategy may trigger when the remaining available load drops below a certain threshold.


Develop a load balancer...


Optional:

Implement the ability to auto-scale new/stale listeners.


Demo:

Show us the load. Eh.

Hint 1: Keep it simple.


Examples
--

```
load balancer commands:
 lb'new,
 lb'peek,
 lb'get'strategy,
 lb'set'strategy,
 lb'get'rot,
 lb'set'rot,
 lb'get'shards,
 lb'add'shards,
 lb'del'shards,
 lb'drain,
 lb'recv,

*Codex.Lib.LoadBalancer.List>  w <- lb'new Robin [[1],[2],[3],[4],[5],[6],[7]]
*Codex.Lib.LoadBalancer.List> lb'peek w
[[1],[2],[3],[4],[5],[6],[7],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List>  lb'add'shards w [[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List> lb'peek w
[[1],[2],[3],[4],[5],[6],[7],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List>  lb'add'shards w [[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List> lb'peek w
[[1],[2],[3],[4],[5],[6],[7],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List> lb'del'shards w [1,2,3,4,5,6,7,8]
*Codex.Lib.LoadBalancer.List> lb'peek w
[[1],[3],[4],[5],[6],[7],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9],[1],[2],[2],[9]]
*Codex.Lib.LoadBalancer.List> lb'drain w
[1,3,4,5,6,7,1,2,2,9,1,2,2,9,1,2,2,9,1,2,2,9,1,2,2,9,1,2,2,9]
*Codex.Lib.LoadBalancer.List> lb'peek w
[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
*Codex.Lib.LoadBalancer.List> lb'push w 1

<interactive>:1438:1: Not in scope: ‘lb'push’
*Codex.Lib.LoadBalancer.List> lb'send w 1
*Codex.Lib.LoadBalancer.List> lb'peek w
[[1],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
*Codex.Lib.LoadBalancer.List> lb'send w 2
*Codex.Lib.LoadBalancer.List> lb'send w 3
*Codex.Lib.LoadBalancer.List> lb'peek w
[[3],[2],[1],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]

*Codex.Lib.LoadBalancer.List Control.Monad> mapM_ (\x -> lb'send w x >> return ()) [1..1000]


*Codex.Lib.LoadBalancer.List Control.Monad> 
*Codex.Lib.LoadBalancer.List Control.Monad> 
*Codex.Lib.LoadBalancer.List Control.Monad> 
*Codex.Lib.LoadBalancer.List Control.Monad> 
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[15,40,75,100,135,160,195,220,255,280,315,340,375,400,435,460,495,520,555,580,615,640,675,700,735,760,795,820,855,880,915,940,975,1000],[16,39,76,99,136,159,196,219,256,279,316,339,376,399,436,459,496,519,556,579,616,639,676,699,736,759,796,819,856,879,916,939,976,999],[17,38,77,98,137,158,197,218,257,278,317,338,377,398,437,458,497,518,557,578,617,638,677,698,737,758,797,818,857,878,917,938,977,998],[18,37,78,97,138,157,198,217,258,277,318,337,378,397,438,457,498,517,558,577,618,637,678,697,738,757,798,817,858,877,918,937,978,997],[19,36,79,96,139,156,199,216,259,276,319,336,379,396,439,456,499,516,559,576,619,636,679,696,739,756,799,816,859,876,919,936,979,996],[20,35,80,95,140,155,200,215,260,275,320,335,380,395,440,455,500,515,560,575,620,635,680,695,740,755,800,815,860,875,920,935,980,995],[21,34,81,94,141,154,201,214,261,274,321,334,381,394,441,454,501,514,561,574,621,634,681,694,741,754,801,814,861,874,921,934,981,994],[22,33,82,93,142,153,202,213,262,273,322,333,382,393,442,453,502,513,562,573,622,633,682,693,742,753,802,813,862,873,922,933,982,993],[23,32,83,92,143,152,203,212,263,...

lb'drain w
lb'drain w
[1000,999,998,997,996,995,994,993,992,991,990,989,988,974,973,972,971,970,969,968,967,966,965,964,963,962,961,960,95
9,958,975,976,977,978,979,980,981,982,983,984,985,986,987,941,942,943,944,945,946,947,948,949,950,951,952,953,954,95
5,956,957,940,939,938,937,936,935,934,933,932,931,930,929,928,914,913,912,911,910,909,908,907,906,905,904,903,902,90
1,900,899,898,915,916,917,918,919,920,921,922,923,924,925,926,927,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,880,879,878,877,876,875,874,873,872,871,870,869,868,854,853,852,851,850,849,848,847,846,845,844,8$3,842,841,840,839,838,855,856,857,858,859,860,86...




w <- lb'new Most [[1],[2],[3]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[3,9,9,9,9,9],[1],[2]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 9
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[3,9,9,9,9,9,9,9],[1],[2]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'set'strategy w Robin
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[3,9,9,9,9,9,9,9,4],[1],[2]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[1,4],[3,9,9,9,9,9,9,9,4],[2]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[2,4],[1,4],[3,9,9,9,9,9,9,9,4]]
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'send w 4
*Codex.Lib.LoadBalancer.List Control.Monad> lb'peek w
[[1,4,4,4],[3,9,9,9,9,9,9,9,4,4,4],[2,4,4]]
```


7. Rock, Paper, Scissors
--

Task: Someone asks you to model a Rock, Paper, Scissors game that is played between two players. They then ask you to model tournament of players (single elimination bracket, best of 3, etc - you chose). They then ask you to model a global competition to find the best player in the world. The best player from each province is chosen via competition. This continues as the best players from each country are determined. The best players from each country compete to become the best player of the continent. Finally, the best players from each continent battle it out for the prestigious title of King RPS. "Simply" create a model representing this global challenge. Optionally implement some form of actual or simulated game play to find the best player in our artificial world. Just in case, you can find the rules to RPS here: 

http://en.wikipedia.org/wiki/Rock-paper-scissors

Examples
--

```
*Codex.Meetup.M1.RPS.Internal> 
*Codex.Meetup.M1.RPS.Internal> play Rock Paper
Lose
*Codex.Meetup.M1.RPS.Internal> play Paper Rock
Win
*Codex.Meetup.M1.RPS.Internal> play Paper Paper
Draw
```


Good luck & have fun.

-- Codex Team.
