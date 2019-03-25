module SAlgorithm.SValidator(validWords, allWords, sWords) where

import SData.SChar
import Data.Matrix as Mx 
import Data.Tuple
import Data.List as L
import qualified Data.Set as S

updatePartOfInvalid :: [SWord] -> [SWord]
updatePartOfInvalid words = map mapPart words
    where mapPart = map updateIfValid
          updateIfValid (SChar c Valid p) = SChar c PartOfInvalid p 
          updateIfValid schar = schar
    
allPartOfInvalid :: [SWord] -> [SWord]
allPartOfInvalid words = L.filter anyInvalid words
    where anyInvalid = any (\(SChar _ v _) -> v == Invalid)

updateSValid :: ([SWord], [SWord]) -> ([SWord], [SWord])
updateSValid (valid, invalid) = (newValid, newInvalid)
    where newValid = map (map $ updateValid Valid) valid
          newInvalid = map (map $ updateValid Invalid) invalid
          updateValid status (SChar c _ pos) = SChar c status pos

allValidatedWords :: Matrix SChar -> S.Set String -> ([SWord], [SWord])
allValidatedWords mx dict = L.partition (\a -> S.member (word a) dict) $ allWords mx

validWords :: Matrix SChar -> S.Set String -> [SWord]
validWords mx dictionary = L.filter (\a -> S.member (word a) dictionary ) $ allWords mx

allWords :: Matrix SChar -> [SWord]
allWords mx = concat $ hWords ++ vWords
    where hWords = map sWords . Mx.toLists $ mx
          vWords = map sWords . Mx.toLists . Mx.transpose $ mx

sWords :: [SChar] -> [SWord]
sWords list = sWords' [] list []

sWords' :: [SChar] ->  [SChar] -> [SWord] -> [SWord]
sWords' word [] result 
    | null word = result
    | otherwise = result ++ [word]

sWords' word (sChar : sChars) result 
    | letter sChar == ' ' = if null word then sWords' [] sChars result else sWords' [] sChars (result ++ [word])
    | otherwise = sWords' (word++[sChar]) sChars result