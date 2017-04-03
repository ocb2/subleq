{-# LANGUAGE NoMonomorphismRestriction #-}
module Subleq where

import Control.Monad (liftM2)
import Data.List (genericIndex, genericLength, genericDrop, genericTake)
import Numeric (showHex)
import System.IO (hPutStrLn, withFile, IOMode(..))

interpret memory = iterate (uncurry step) (0, memory)

-- computes a single step of the computation
step :: Integer -> [Integer] -> (Integer, [Integer])
step pc memory =
    let r = (dereference memory (pc + 1)) - (dereference memory pc)
        memory' = write r (reference memory (pc + 1)) memory
    in if (r <= 0)
        then (reference memory (pc + 2), memory')
        else (pc + 3, memory')

write :: Integer -> Integer -> [Integer] -> [Integer]
write value address memory =
    (genericTake address memory) ++
    [value] ++
    (genericDrop (address + 1) memory)

reference :: [Integer] -> Integer -> Integer
reference = genericIndex

dereference :: [Integer] -> Integer -> Integer
dereference = liftM2 (.) genericIndex genericIndex

-- writes in a format that Verilog can understand, you still have to pad with zeros though
writeToFile :: FilePath -> [Integer] -> IO ()
writeToFile path memory = withFile path WriteMode (\handle ->
    hPutStrLn handle (concatMap (\l -> showHex l "\n") memory))

-- tests

program1 = zero_cell2 ++ negate_into ++ [72,33]
 where zero_cell2 = [cell3,cell3,3]
       negate_into = [cell2,cell3,0]
       cell2 = genericLength program1 - 2
       cell3 = genericLength program1 - 1

program2 x y = negate_into ++ sub ++ [x, y, 0]
 where sub = [cell3, cell2, 0]
       negate_into = [cell1, cell3, 3]
       cell1 = genericLength (program2 x y) - 3
       cell2 = genericLength (program2 x y) - 2
       cell3 = genericLength (program2 x y) - 1