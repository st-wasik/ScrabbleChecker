module SData.SBoard where

import Data.Matrix as Mx
import SData.SChar
import Data.Tuple

fromList charList = Mx.fromList 15 15 . map sChar . zip charList $ revTuple <$> [1..15] <*> [1..15]
    where revTuple a b = swap (a,b)
          sChar (char, position) = SChar char NotSet position

empty = SData.SBoard.fromList $ repeat ' '