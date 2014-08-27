module Codex.Lib.Church.Nat (
 Nat (..),
 natToInteger,
) where

import Prelude hiding ((==), compare, pred, succ, fromEnum, toEnum, (+), (-), (*), (/), abs, signum, fromIntegeral, (/), fromRational)
import qualified Prelude as P

data Nat =
 O | S Nat
 deriving (Show, Read)

instance P.Eq Nat where
 (==) = (==)

instance P.Ord Nat where
 compare = compare

instance P.Enum Nat where
 pred = pred
 succ = succ
 fromEnum = fromEnum
 toEnum = toEnum

instance P.Num Nat where
 (+) = (+)
 (-) = (-)
 (*) = (*)
 abs = abs
 signum = signum
 fromInteger = Codex.Lib.Church.Nat.fromInteger
 negate = error "Unsupported"

instance P.Fractional Nat where
 (/) = (/)
 fromRational = fromRational

-- Eq --

(==) :: Nat -> Nat -> Bool
(==) O O = True
(==) O _ = False
(==) _ O = False
(==) (S m) (S n) = (==) m n

-- Ord --

compare :: Nat -> Nat -> Ordering
compare O (S _) = LT
compare O O = EQ
compare (S _) (S _) = EQ
compare (S _) O = GT

-- Enum --

succ :: Nat -> Nat
succ O = (S O)
succ n = S n

pred :: Nat -> Nat
pred O = O
pred (S n) = n

toEnum :: Int -> Nat
toEnum = fromInt

fromEnum :: Nat -> Int
fromEnum = natToInt

-- Num --

(+) :: Nat -> Nat -> Nat
(+) O n = n
(+) (S m) n = m + (succ n)

(-) :: Nat -> Nat -> Nat
(-) O _ = O
(-) m O = m
(-) (S m) (S n) = m - n

(*) :: Nat -> Nat -> Nat
(*) _ O = O
(*) m (S O) = m
(*) m (S n)  = m + (m * n)

-- cheating somewhat
(/) :: Nat -> Nat -> Nat
(/) _ O = error "DivByZero"
(/) O _ = O
(/) m (S O) = m
(/) m n =
 case (natToInteger m > natToInteger n) of
  True -> (m - n) / n
  _ -> m

signum :: Nat -> Nat
signum O = O
signum _ = S O

abs :: Nat -> Nat
abs = id

natToInteger :: Nat -> Integer
natToInteger O = 0
natToInteger (S m) = 1 P.+ natToInteger m

natToInt :: Nat -> Int
natToInt O = 0
natToInt (S m) = 1 P.+ natToInt m

fromInteger :: Integer -> Nat
fromInteger 0 = O
fromInteger n = S $ Codex.Lib.Church.Nat.fromInteger $ n P.- 1

fromInt :: Int -> Nat
fromInt 0 = O
fromInt n = S $ fromInt $ n P.- 1

fromRational :: Rational -> Nat
fromRational _ = O
