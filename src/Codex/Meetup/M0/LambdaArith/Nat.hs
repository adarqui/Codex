module Meetup.M0.LambdaArith.Nat (
 Nat (..),
 succ,
 pred,
 fact,
 fib,
) where

import Prelude hiding ((+), (-), (*), (/), compare, pred, succ, (/), abs, signum, fromIntegeral, fromRational)
import qualified Prelude as P

import Data.Ord hiding (compare)
import qualified Data.Ord as O


data Nat =
 O | S Nat
 deriving (Show, Read)


instance P.Eq Nat where
 (==) = eq

instance O.Ord Nat where
 compare = compare

instance P.Num Nat where
 (+) = (+)
 (-) = (-)
 (*) = (*)
 abs = abs
 signum = signum
 fromInteger = integerToNat
 negate = error "Unsupported"

instance P.Fractional Nat where
 (/) = (/)
 fromRational = fromRational


succ :: Nat -> Nat
succ O = (S O)
succ n = S n


pred :: Nat -> Nat
pred O = O
pred (S n) = n


(+) :: Nat -> Nat -> Nat
(+) O n = n
(+) (S n') n = (+) n' $ S n


(-) :: Nat -> Nat -> Nat
(-) O _ = O
(-) n O = n
(-) (S n'') (S n') = (-) n'' n'


(*) :: Nat -> Nat -> Nat
(*) _ O = O
(*) n (S O) = n
(*) n (S n')  = (+) n ((*) n n')


-- cheating somewhat
(/) :: Nat -> Nat -> Nat
(/) _ O = error "DivByZero"
(/) O _ = O
(/) n (S O) = n
(/) n d =
 case (natToInteger n > natToInteger d) of
  True -> (/) ((-) n d) d
  _ -> n


fact :: Nat -> Nat
fact O = (S O)
fact s@(S n') = (*) s $ fact n'


fib :: Nat -> Nat
fib O = O
fib (S O) = (S O)
fib s = fib ((-) s (succ O)) + fib ((-) s (succ (S O)))


natToInteger :: Nat -> Integer
natToInteger O = 0
natToInteger (S n') = 1 P.+ natToInteger n'


integerToNat :: Integer -> Nat
integerToNat 0 = O
integerToNat n = S $ integerToNat $ n P.- 1

fromRational :: Rational -> Nat
fromRational _ = O


signum :: Nat -> Nat
signum O = O
signum _ = S O

abs :: Nat -> Nat
abs = id


eq :: Nat -> Nat -> Bool
eq O O = True
eq O _ = False
eq _ O = False
eq (S m) (S n) = eq m n

compare :: Nat -> Nat -> Ordering
compare O (S O) = LT
compare O O = EQ
compare (S O) O = GT
