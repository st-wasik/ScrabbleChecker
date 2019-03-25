module Main where

import Data.Matrix as Mx
import Data.List as List
import Data.Set as Set

import SAlgorithm.SValidator
import SData.SChar
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
            -- test 
            putStrLn . show $ validWords x dictionary

initializeDictionary :: IO (Set String)
initializeDictionary = do
    dictionaryRaw <- readFile "./sjp/slowa.txt"
    return $ Set.fromList $ words dictionaryRaw
