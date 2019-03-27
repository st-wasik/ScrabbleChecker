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
    if input == "exit" 
        then return ()
        else do
            let scrabbleBoard = SB.fromList input
            putStrLn . show $ processScrabbleBoard scrabbleBoard dictionary
            -- count points
            beginWordsCheck dictionary


initializeDictionary :: IO (Set String)
initializeDictionary = do
    dictionaryRaw <- readFile "./sjp/slowa.txt"
    return . Set.fromList . filterDictionaryWords $ words dictionaryRaw

filterDictionaryWords :: [String] -> [String]
filterDictionaryWords words = List.filter (\a -> len a && chars a) words
    where
        len word = length word > 1
        chars [c1,c2] = if c1 == c2 then False else True
        chars _ = True 