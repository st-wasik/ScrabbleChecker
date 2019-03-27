module SData.SBoard where

import Data.Matrix as Mx
import SData.SChar
import Data.Tuple

fromList :: [Char] -> Matrix SChar
fromList charList = Mx.fromList 15 15 . map sChar . zip charList' $ tuple <$> [1..15] <*> [1..15]
    where tuple a b = (a,b)
          sChar (char, position) = SChar char NotSet position
          charList' = charList ++ repeat ' '

empty :: Matrix SChar
empty = SData.SBoard.fromList $ repeat ' '

updateWithSChar :: Matrix SChar -> [SChar] -> Matrix SChar
updateWithSChar matrix [] = matrix
updateWithSChar matrix (sc : scs) = updateWithSChar newMatrix scs
    where newMatrix = Mx.setElem sc pos matrix
          pos = position sc 


updateWithSChar' :: Matrix SChar -> [SChar] -> Matrix SChar
updateWithSChar' matrix [] = matrix
updateWithSChar' matrix (sc : scs) = updateWithSChar' newMatrix scs
    where
        newMatrix = setProperValidness sc matrix
        pos = position sc

--setProperValidness (SChar l v p) matrix 
setProperValidness sc@(SChar l Valid p@(p1,p2)) matrix 
        | prev == NotSet = set sc
        | prev == Valid = matrix 
        | prev == PartOfInvalid = matrix
        | prev == Invalid = set $ SChar l PartOfInvalid p
        | prev == SingleLetter = set sc
        where prev = valid $ Mx.getElem p1 p2 matrix
              set sc = Mx.setElem sc (position sc) matrix

setProperValidness sc@(SChar l Invalid p@(p1,p2)) matrix 
        | prev == NotSet = set sc
        | prev == Valid = set $ SChar l PartOfInvalid p
        | prev == PartOfInvalid = matrix
        | prev == Invalid = matrix 
        | prev == SingleLetter = set sc 
        where prev = valid $ Mx.getElem p1 p2 matrix
              set sc = Mx.setElem sc (position sc) matrix