module SAlgorithm.SValidator where

import SData.SChar
import Data.Matrix as Mx 
import Data.Tuple
import Data.List as L
import qualified Data.Set as S
import SData.SBoard as SB
import Debug.Trace as Dg

-- | Processes SBoard
--   1. Validates words with dictionary
--   2. Marks SChars with proper info about validness
--   3. Places SChars on SBoard
--   4. Updates SBoard with info about not connected words
processScrabbleBoard :: Matrix SChar -> S.Set String -> Matrix SChar
processScrabbleBoard board dictionary = withNotConnectedMx
    where
        withNotConnectedMx = updateNotConnectedWords allMx
        allMx = placeSChars singlesMx $ concat  (validWords ++ invalidWords)
        singlesMx = placeSChars SB.empty $ concat singleLetters
        (validWords, invalidWords, singleLetters) = updateSValid $ validatedWords board dictionary 

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

