module Main where

import Data.Matrix as Mx
import Data.List as List
import Data.Set as Set

import SAlgorithm.SValidator as SV
import SData.SChar as SC
import SData.SBoard as SB
import STest
import Data.Char

main :: IO ()
main = do 
    dict <- initializeDictionary
    beginNextCheck dict

beginNextCheck :: Set [Char] -> IO ()
beginNextCheck dictionary = do
    input <- getLine
    case input of
        "exit" -> return ()
        "t1" -> processWords dictionary testList
        "t2" -> processWords dictionary testList2
        "t3" -> processWords dictionary testList3
        "t4" -> processWords dictionary testList4
        "t5" -> processWords dictionary testList5
        "t6" -> processWords dictionary testList6
        otherwise -> processWords dictionary input

processWords :: Set [Char] -> String -> IO ()
processWords dictionary words = do
    let scrabbleBoard = SB.fromList $ List.map toLower words 
    let (processedMatrix, points) = processScrabbleBoard scrabbleBoard dictionary
    -- putStrLn . show . Mx.fromLists . intersectMx . Mx.toLists $ processedMatrix
    putStrLn . show $ processedMatrix
    --putStrLn $ formatOutputMatrix processedMatrix
    putStrLn . show $ points
    beginNextCheck dictionary

-- | Intersects existing rows with empty rows to improve readbility in terminal
intersectMx [] = []
intersectMx (x:xs) = x:(List.take 15 $ repeat $ SC.empty (0,0)): intersectMx xs

-- | Converts processed matrix to string and formats it before sending to display manager
formatOutputMatrix :: Matrix SChar -> String
formatOutputMatrix matrix = show filtered
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