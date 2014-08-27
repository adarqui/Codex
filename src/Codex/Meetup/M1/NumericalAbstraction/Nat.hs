module Codex.Meetup.M1.NumericalAbstraction.Nat (
 fact,
 fib
) where

import Codex.Lib.Church.Nat


fact :: Nat -> Nat
fact O = (S O)
fact s@(S n') = (*) s $ fact n'


fib :: Nat -> Nat
fib O = O
fib (S O) = (S O)
fib s = fib ((-) s (succ O)) + fib ((-) s (succ (S O)))
