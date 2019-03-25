module SData.SBoard where

import Data.Matrix as Mx
import SData.SChar
import Data.Tuple

fromList :: [Char] -> Matrix SChar
fromList charList = Mx.fromList 15 15 . map sChar . zip charList $ revTuple <$> [1..15] <*> [1..15]
    where revTuple a b = swap (a,b)
          sChar (char, position) = SChar char NotSet position

empty :: Matrix SChar
empty = SData.SBoard.fromList $ repeat ' '

updateWithSChar :: Matrix SChar -> [SChar] -> Matrix SChar
updateWithSChar matrix [] = matrix
updateWithSChar matrix (sc : scs) = updateWithSChar newMatrix scs
    where newMatrix = Mx.setElem sc pos matrix
          pos = position sc 