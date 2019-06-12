module Main where

import Data.Matrix as Mx
import Data.List as List
import Data.Set as Set

import SAlgorithm.SValidator as SV
import SData.SChar as SC
import SData.SBoard as SB
import STest
import Data.Char
import System.IO
import System.IO.Strict as Strict

main :: IO ()
main = do 
    enc <- mkTextEncoding "CP1250"
    hSetEncoding stdin enc
    hSetEncoding stdout enc
    dict <- initializeDictionary
    beginNextCheck dict []

beginNextCheck :: Set [Char] -> [(Int, Int)] -> IO ()
beginNextCheck dictionary usedFields = do
    input <- getLine
    case input of
        "exit" -> putStrLn "exit"
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
    --printOut . Mx.fromLists . intersectMx . Mx.toLists $ processedMatrix
    --printOut processedMatrix
    printSCharList $ Mx.toList processedMatrix
    --printOut $ formatOutputMatrix processedMatrix
    printOutPoints $ List.filter (\(_,a)-> a > 0) points
    beginNextCheck dictionary newUsedFields

-- | Intersects existing rows with empty rows to improve readbility in terminal
intersectMx [] = []
intersectMx (x:xs) = x:(List.take 15 $ repeat $ SC.empty (0,0)): intersectMx xs

-- | Converts processed matrix to string and formats it before sending to display manager
formatOutputMatrix :: Matrix SChar -> String
formatOutputMatrix matrix = show filtered2
    where
        filtered2 = List.map (\sc@(SChar l v p) -> if l == ' ' then (SChar '_' v p) else sc) filtered
        filtered = List.map (\sc@(SChar l v p) -> if v `elem` [SingleLetter, ConnectionPoint] then SChar l Valid p else sc) allLetters
        allLetters = Mx.toList matrix

-- | Initializes directory for use
initializeDictionary :: IO (Set String)
initializeDictionary = do
    handle <- openFile "./sjp/slowa.txt" ReadMode  
    --enc <- mkTextEncoding "CP1250"
    hSetEncoding handle utf8
    dictionaryRaw <- Strict.hGetContents handle  
    hClose handle
    return . Set.fromList . filterDictionaryWords $ words dictionaryRaw

-- | Drops words that are one letter long or have two the same letters
filterDictionaryWords :: [String] -> [String]
filterDictionaryWords words = List.filter (\a -> len a && chars a) words
    where
        len word = length word > 1
        chars [c1,c2] = if c1 == c2 then False else True
        chars _ = True 

-- | Prints immediately argument to stdout
printOut :: Show a => a -> IO ()
printOut obj = do
    putStrLn . List.filter (/= '"') . show $ obj
    hFlush stdout

-- | Prints immediately argument to stdout
printOutPoints obj = do
    putStr "["
    printOutPoints' obj

printOutPoints' ((str, p):xs) = do
	putStr "("
	putStr str
	putStr ","
	putStr $ show p
	putStr ")"
	if length xs > 0 then putStr "," else putStr ""
	printOutPoints' xs
	
printOutPoints' [] = do
	putStrLn "]"
	hFlush stdout