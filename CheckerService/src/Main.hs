module Main where

import Data.Matrix as Mx
import Data.List as List
import Data.Set as Set

import SAlgorithm.SValidator as SV
import SData.SChar as SC
import SData.SBoard as SB
import STest

main :: IO ()
main = do 
    dict <- initializeDictionary
    beginWordsCheck dict

beginWordsCheck :: Set [Char] -> IO ()
beginWordsCheck dictionary = do
    input <- getLine
    case input of
        "exit" -> return ()
        _ -> do
            let scrabbleBoard = SB.fromList testList4 
            let processedMatrix = processScrabbleBoard scrabbleBoard dictionary
            -- putStrLn . show . Mx.fromLists . intersectMx . Mx.toLists $ processedMatrix
            putStrLn . show $ processedMatrix
            putStrLn $ formatOutput processedMatrix
            -- count points
            beginWordsCheck dictionary

-- | Intersects matrix's rows with empty rows to improve readbility in terminal
intersectMx [] = []
intersectMx (x:xs) = x:(List.take 15 $ repeat $ SC.empty (0,0)): intersectMx xs

-- | Converts processed matrix to string and formats it before sending to display manager
formatOutput :: Matrix SChar -> String
formatOutput matrix = show filtered
    where
        filtered = List.map (\sc@(SChar l v p) -> if v `elem` [SingleLetter, ConnectionPoint] then SChar l Valid p else sc) allLetters
        allLetters = Mx.toList matrix

-- | Initializes directory for use
initializeDictionary :: IO (Set String)
initializeDictionary = do
    dictionaryRaw <- readFile "./sjp/slowa.txt"
    return . Set.fromList . filterDictionaryWords $ words dictionaryRaw

-- | Drops words that are one letter long or have two the same letters
filterDictionaryWords :: [String] -> [String]
filterDictionaryWords words = List.filter (\a -> len a && chars a) words
    where
        len word = length word > 1
        chars [c1,c2] = if c1 == c2 then False else True
        chars _ = True 