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



2. Numerical Abstraction
--

Task: Imagine numbers as we know them do not exist. Now imagine you were tasked with representing numbers as either: nothing or the successor of nothing. First, define this numerical representation. Next, implement some basic arithmetic operators: add, subtract, multiply, divide etc. Finally, implement the following functions: factorial, fibonacci, compare, minimum, maximum.


Bonus points: Include the predecessor of nothing in your numerical abstraction.


Demo: Show some examples of your numerical representation and functions in action.


Hint 1: pleh fo eb yam yllacificeps slaremuN hcruhC dna suluclac adbmal eht gnihcraeseR. srebmun onaep.


Hint 2: tsegnolsiohwenoehtsi,slaremunhcruhcybdet­neserpersdnarepoowtfomumixameht,yllarene­G


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



7. Rock, Paper, Scissors
--

Task: Someone asks you to model a Rock, Paper, Scissors game that is played between two players. They then ask you to model tournament of players (single elimination bracket, best of 3, etc - you chose). They then ask you to model a global competition to find the best player in the world. The best player from each province is chosen via competition. This continues as the best players from each country are determined. The best players from each country compete to become the best player of the continent. Finally, the best players from each continent battle it out for the prestigious title of King RPS. "Simply" create a model representing this global challenge. Optionally implement some form of actual or simulated game play to find the best player in our artificial world. Just in case, you can find the rules to RPS here: 

http://en.wikipedia.org/wiki/Rock-paper-scissors

Good luck & have fun.

-- Codex Team.
