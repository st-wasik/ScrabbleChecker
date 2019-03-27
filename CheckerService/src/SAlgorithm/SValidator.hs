module SAlgorithm.SValidator where

import SData.SChar
import Data.Matrix as Mx 
import Data.Tuple
import Data.List as L
import qualified Data.Set as S
import SData.SBoard as SB
import Debug.Trace as Dg

processScrabbleBoard :: Matrix SChar -> S.Set String -> Matrix SChar
processScrabbleBoard board dictionary = validatedMatrix
    where
        --matrixToReturn = updateWithSChar board $ concat partOfInvalid
        --partOfInvalid = updatePartOfInvalid . allPartOfInvalid . allWords $ traceShow validatedMatrix validatedMatrix
        validatedMatrix = updateWithSChar' placedSinglesMx . concat $ valid ++ invalid
        placedSinglesMx = foldr (\sc@(SChar l v p@(p1,p2)) mx -> Mx.setElem sc (position sc) mx) SB.empty $ concat single
        xx@(valid, invalid, single) = updateSValid checked
        checked = validatedWords board dictionary 

-- -- | Updates letters validness for words containing invalid letters.
-- updatePartOfInvalid :: [SWord] -> [SWord]
-- updatePartOfInvalid words = map mapPart words
--     where mapPart = map updateIfValid
--           updateIfValid (SChar c Valid p) = SChar c PartOfInvalid p 
--           updateIfValid schar = schar

-- -- | Returns words that contains any invalid letter.
-- allPartOfInvalid :: [SWord] -> [SWord]
-- allPartOfInvalid words = L.filter anyInvalid words
--     where anyInvalid = any (\(SChar _ v _) -> v == Invalid)

-- | Takes triple of validated words lists.
--   Updates ScrabbleBoard characters with info about validness.
updateSValid :: ([SWord], [SWord], [SWord]) -> ([SWord], [SWord], [SWord])
updateSValid (valid, invalid, single) = (newValid, newInvalid, newSingle)
    where newValid = map (map $ updateValid Valid) valid
          newInvalid = map (map $ updateValid Invalid) invalid
          newSingle = map (map $ updateValid SingleLetter) single
          updateValid status (SChar c _ pos) = SChar c status pos

-- | Return triple of words lists (Valid, Invalid, SingleLetters) validated using dictionary.  
validatedWords :: Matrix SChar -> S.Set String -> ([SWord], [SWord], [SWord])
validatedWords mx dict = (newValid, newInvalid, single)
    where 
        newValid = valid
        (newInvalid, single) = L.partition (\a -> L.length a > 1) invalid
        (valid, invalid) = L.partition (\a -> S.member (word a) dict) $ allWords mx

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
    | letter sChar == ' ' = if null word then sWords' [] sChars result else sWords' [] sChars (result ++ [word])
    | otherwise = sWords' (word++[sChar]) sChars result