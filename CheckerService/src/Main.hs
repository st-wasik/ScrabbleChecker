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
    beginNextCheck dict []

beginNextCheck :: Set [Char] -> [(Int, Int)] -> IO ()
beginNextCheck dictionary usedFields = do
    input <- getLine
    case input of
        "exit" -> return ()
        "t1" -> processWords dictionary usedFields ex1 
        "t2" -> processWords dictionary usedFields ex2
        "t3" -> processWords dictionary usedFields ex3
        "t4" -> processWords dictionary usedFields ex4
        "t5" -> processWords dictionary usedFields ex5
        "t6" -> processWords dictionary usedFields ex6
        "t7" -> processWords dictionary usedFields ex7
        "t8" -> processWords dictionary usedFields ex8
        "t9" -> processWords dictionary usedFields ex9
        "t10" -> processWords dictionary usedFields ex10
        "t11" -> processWords dictionary usedFields ex11
        "t12" -> processWords dictionary usedFields ex12
        otherwise -> processWords dictionary usedFields input

processWords :: Set [Char] -> [(Int, Int)] -> String -> IO ()
processWords dictionary usedFields words  = do
    let scrabbleBoard = SB.fromList $ List.map toLower words 
    let (processedMatrix, points, newUsedFields) = processScrabbleBoard scrabbleBoard dictionary usedFields
    -- putStrLn . show . Mx.fromLists . intersectMx . Mx.toLists $ processedMatrix
    putStrLn . show $ processedMatrix
    -- putStrLn $ formatOutputMatrix processedMatrix
    putStrLn . show $ List.filter (\(_,a)-> a > 0) points
    beginNextCheck dictionary newUsedFields

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