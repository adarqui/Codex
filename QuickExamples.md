Notes
=====


compression tournament:
--
     :set -XOverloadedStrings
     runCompressionTournament "helloooo"

compression: gzip, bzip, lz4, raw, inflate
--
     compress "string"
     decompress "string"
     compressFile "/path/to/file"
     decompressFile "/path/to/file.gz"

     :set -XOverloadedStrings
     import qualified Codex.Meetup.M1.Compression.Raw as Raw
     import qualified Codex.Meetup.M1.Compression.Inflate as Inflate
     import qualified Codex.Meetup.M1.Compression.RLE as RLE
     import qualified Codex.Meetup.M1.Compression.GZip as GZip
     import qualified Codex.Meetup.M1.Compression.BZip as BZip
     import qualified Codex.Meetup.M1.Compression.LZ4 as LZ4

     GZip.compress "hi"
     BZip.compress "hi"
     Raw.compress "hi"
     Inflate.compress "hi"
     RLE.compress "hi"

GZip.compress "hi"
Right "\US\139\b\NUL\NUL\NUL\NUL\NUL\NUL\ETX\203\200\EOT\NUL\172*\147\216\STX\NUL\NUL\NUL"
BZip.compress "hi"
Right "BZh91AY&SY\154\137\180\"\NUL\NUL\NUL\SOH\NUL\NUL` \NUL!\NUL\130\177w$S\133\t\t\168\155B "
Right "\STX\NUL\NUL\NUL\ETX\NUL\NUL\NUL hi"
Raw.compress "hi"
Right "hi"
Inflate.compress "hi"
Right "hihi"
RLE.compress "hi"
Left "wrecked"


compression tournament:
--
     runCompressionTournament $ B.take 1000 $ B.repeat 'c'
     simpleCompressionTournament $ B.take 1000 $ B.repeat 'c'

simple compression tournament:
--
     :set -XOverloadedStrings
     :l Codex.Meetup.M1.Compression.Tournament
     import qualified Data.ByteString.Lazy.Char8 as BLC
     simpleCompressionTournament (BLC.take 10 $ BLC.repeat 'c')

...
     [("Raw",10),("Inflate",20),("RLE",10),("GZip",23),("BZip",39),("LZ4",19)]


DNA sequences:
     everything [C,C,C,C,C,A,C,A,A,A,A,G,A,G,A]
     largest [C,C,C,C,C,A,C,A,A,A,A,G,A,G,A]
     smallest [C,C,C,C,C,A,C,A,A,A,A,G,A,G,A]
     lessThan 3 [C,C,C,C,C,A,C,A,A,A,A,G,A,G,A]
     greaterThan 3 [C,C,C,C,C,A,C,A,A,A,A,G,A,G,A]


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


names:
 parseMales "/tmp/males.txt"
 parseFemales "/tmp/females.txt"


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


load balancer: list
 w <- lb'new Random [[1,2,3],[4,5,6],[5,6,7,8,9,10],[1]]
 lb'peek w
 lb'set'strategy w Most
 lb'get'strategy w
 lb'get'shards w
 lb'get'rot w
 lb'set'rot 100

load balancer: most test
 w <- lb'new Most [[1,2,3],[4,5,6],[5,6,7,8,9],[1],[0]]
 lb'recv w

^^ do little demo's for each

load balancer: robin
 w <- lb'new Robin [[1],[2],[3],[4],[5]]
 lb'send w 9
 lb'send w 9
 lb'send w 9
 lb'send w 9
 lb'send w 9
 lb'send w 0
 lb'peek w

load balancer: shards
 w <- lb'new Robin [[1],[2],[3],[4],[5],[6],[7]]
 lb'add'shards w [[1],[2],[2],[9]]
 lb'del'shards w [1,2,3,4,5,6,7,8,9]

load balancer: drain
 w <- lb'new Robin [[1],[2],[3],[4],[5],[6],[7]]
 lb'drain w



echo server:
--
     let serv <- runEchoServer
     .. somewhere else: nc localhost 7
     destroyEchoServer serv


hang server:
--
     let serv <- runHangServer <port>
     .. somewhere else: nc localhost <port>
     destroyEchoServer serv 


tcp client:
--
     forM_ [1..100] (\x -> runTCPClient "localhost" (PortNumber 65503) $ \_ -> do putStrLn "hi")
     forM_ [1..100] (\x -> runTCPClient "localhost" (PortNumber 65504) $ \h -> do hSetBuffering h LineBuffering >> hGetLine h >>= \l -> putStrLn l)


tcp stresser:
--
     stressTCPServer 10 100 10 $ do runTCPClient "localhost" (PortNumber 65503) $ \_ -> do putStrLn "hi"
     stressTCPServer 1 1 1 $ do runTCPHangClient "localhost" (PortNumber 65503)
