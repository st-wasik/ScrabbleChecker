module Main where

import Data.Matrix as Mx
import Data.List as List
import Data.Set as Set

-- Scrabble Char data type
data SChar = SChar {
                        letter :: Char
                   ,    valid :: Bool
                   }

main :: IO ()
main = do 
    dictionaryRaw <- readFile "./sjp/slowa.txt"
    beginWordsCheck . Set.fromList $ words dictionaryRaw

beginWordsCheck :: Set [Char] -> IO ()
beginWordsCheck dictionary = do
    input <- getLine
    if input == "exit" 
        then return ()
        else do
            let sCharList = List.map (\c -> SChar c False) input 
            let wordsMatrix = Mx.fromList 15 15 sCharList



            let x = Set.member "123" dictionary
            return ()

processWordsMatrix matrix dictionary = ""










check dict = do
    x <- getLine
    putStrLn . show $ Set.member x dict
    if x == "exit" then return () else check dict

getNextMatrix = do
    rawData <- getLine
    if rawData == "exit" then return () else do
        let matrix = Mx.fromList 15 15 (read rawData :: [Char]) 
        putStrLn . show $ getWords matrix

getWords :: Matrix Char -> [String]
getWords matrix = concat $ verticalWords ++ horizontalWords
    where verticalWords = List.map List.words $ Mx.toLists matrix 
          horizontalWords = List.map List.words . Mx.toLists $ Mx.transpose matrix 


getValidWords _words dictionary = List.filter (\e -> elem e dictionary) _words



    
