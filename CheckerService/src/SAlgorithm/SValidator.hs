module SAlgorithm.SValidator where

import SData.SChar
import Data.Matrix as Mx 
import Data.Tuple
import Data.List as L
import qualified Data.Set as S
import SData.SBoard as SB
import Debug.Trace as Dg
import SAlgorithm.SPoints

-- | Processes SBoard
--   1. Validates word with dictionary
--   2. Mark SChars with proper info about validness
--   3. Place SChars on SBoard
--   4. Update SBoard with info about not connected words
--   5. Count points if all words are valid
processScrabbleBoard :: Matrix SChar -> S.Set String -> (Matrix SChar, [(String, Int)])
processScrabbleBoard board dictionary = (withNotConnectedMx, points)
    where
        points = calculatePoints withNotConnectedMx validWords
        withNotConnectedMx = updateNotConnectedWords allMx
        allMx = placeSChars validMx $ concat invalidWords
        validMx = placeSChars singlesMx $ concat validWords 
        singlesMx = placeSChars SB.empty $ concat singleLetters
        (validWords, invalidWords, singleLetters) = updateSValid $ validatedWords board dictionary 

calculatePoints :: Matrix SChar -> [SWord] -> [(String, Int)]
calculatePoints wordsMx words = if invalidLettersCount > 0 then [] else countedPoints
    where 
        invalidLettersCount = foldr (\c acc -> if isInvalid c then acc+1 else acc) 0 $ Mx.toList wordsMx
        countedPoints = zip (map (map letter) words) (map wordValue words)
        isInvalid c
            | valid c == SingleLetter = True
            | valid c == NotConnected = True
            | valid c == Invalid = True
            | otherwise = False

-- | Takes triple of validated words lists.
--   Updates SChars with info about validness.
updateSValid :: ([SWord], [SWord], [SWord]) -> ([SWord], [SWord], [SWord])
updateSValid (validWords, invalidWords, singleLetters) = (newValid, newInvalid, newSingle)
    where 
        newValid = map (map $ updateValid Valid) validWords
        newInvalid = map (map $ updateValid Invalid) $ invalidWords
        newSingle = map (map $ updateValid SingleLetter) singleLetters
        updateValid status (SChar c _ pos) = SChar c status pos

-- | Return triple of words lists (Valid, Invalid, SingleLetters) validated using dictionary.  
validatedWords :: Matrix SChar -> S.Set String -> ([SWord], [SWord], [SWord])
validatedWords mx dict = (newValid, newInvalid, single)
    where 
        newValid = valid
        (newInvalid, single) = L.partition (\a -> L.length a > 1) invalid
        (valid, invalid) = L.partition (\a -> S.member (word a) dict) $ allWords mx


