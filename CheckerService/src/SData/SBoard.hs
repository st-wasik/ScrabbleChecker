module SData.SBoard where

import Data.Matrix as Mx
import SData.SChar
import Data.Tuple
import Debug.Trace as D
import Data.List as L

-- | Creates SBoard from Char list 
fromList :: [Char] -> Matrix SChar
fromList charList = Mx.fromList 15 15 . map sChar . zip charList' $ tuple <$> [1..15] <*> [1..15]
    where tuple a b = (a,b)
          sChar (char, position) = SChar char NotSet position
          charList' = charList ++ repeat ' '

-- | Creates empty SBoard (from ' ' list)
empty :: Matrix SChar
empty = SData.SBoard.fromList $ repeat ' '

-- | Marks words that are not connected with others or with board center
updateNotConnectedWords :: Matrix SChar -> Matrix SChar
updateNotConnectedWords matrix = result
    where
        result = foldr (\sc mx -> Mx.setElem sc (position sc) mx) matrix $ concat words
        words = map markNotConnected $ filter (\a -> length a > 1) $ allWords matrix
        markNotConnected word = if L.any (\schar -> valid schar == ConnectionPoint) word then word else map (\(SChar l _ p) -> SChar l NotConnected p) word

-- | Updated SBoard with SChars
--   Places given SChars on SBoard 
placeSChars :: Matrix SChar -> [SChar] -> Matrix SChar
placeSChars matrix [] = matrix
placeSChars matrix (sc : scs) = placeSChars newMatrix scs
    where
        newMatrix = setProperValidness sc matrix
      

-- | Sets proper validness for given SChar and places it on the SBoard
--   Takes into account already placed SChars and updates its validness
setProperValidness sc@(SChar l Valid (8,8)) matrix
        | prev == NotSet = set $ SChar l ConnectionPoint (8,8)    
        | prev == Valid = set $ SChar l ConnectionPoint (8,8)    
        | prev == SingleLetter = set $ SChar l ConnectionPoint (8,8)    
        where 
            prev = valid $ Mx.getElem 8 8 matrix
            set sc = Mx.setElem sc (position sc) matrix

setProperValidness sc@(SChar l Valid p@(p1,p2)) matrix 
        | prev == NotSet = set sc
        | prev == Valid = set (SChar l ConnectionPoint p)
        | prev == PartOfInvalid = matrix
        | prev == Invalid = set $ SChar l PartOfInvalid p
        | prev == SingleLetter = set sc
        | prev == ConnectionPoint = matrix
        where prev = valid $ Mx.getElem p1 p2 matrix
              set sc = Mx.setElem sc (position sc) matrix

setProperValidness sc@(SChar l Invalid p@(p1,p2)) matrix 
        | prev == NotSet = set sc
        | prev == Valid = set $ SChar l PartOfInvalid p
        | prev == PartOfInvalid = matrix
        | prev == Invalid = matrix 
        | prev == SingleLetter = set sc 
        | prev == ConnectionPoint = set $ SChar l PartOfInvalid p 
        where prev = valid $ Mx.getElem p1 p2 matrix
              set sc = Mx.setElem sc (position sc) matrix

setProperValidness sc@(SChar l SingleLetter p@(p1,p2)) matrix 
        | prev == NotSet = set sc
        | prev == Valid = matrix
        | prev == PartOfInvalid = matrix
        | prev == Invalid = matrix 
        | prev == SingleLetter = matrix
        | prev == ConnectionPoint = matrix
        where prev = valid $ Mx.getElem p1 p2 matrix
              set sc = Mx.setElem sc (position sc) matrix

--   Catch-all pattern
setProperValidness sc matrix = D.trace ("cannot place" ++ show sc) $ Mx.setElem sc (position sc) matrix

-- | Returns all detected words
allWords :: Matrix SChar -> [SWord]
allWords mx = concat $ hWords ++ vWords
    where hWords = map sWords . Mx.toLists $ mx
          vWords = map sWords . Mx.toLists . Mx.transpose $ mx

-- | This function is similar to Data.List.words but accept list of type SChar.
--   Returns list of words.
sWords :: [SChar] -> [SWord]
sWords list = sWords' [] list []

sWords' :: [SChar] ->  [SChar] -> [SWord] -> [SWord]
sWords' word [] result 
    | null word = result
    | otherwise = result ++ [word]

sWords' word (sChar : sChars) result 
    | letter sChar == ' ' = if null word 
        then sWords' [] sChars result 
        else sWords' [] sChars (result ++ [word])
    | otherwise = sWords' (word++[sChar]) sChars result