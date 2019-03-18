module Main where

import Data.Matrix as Mx
import Data.List as Ls  

main :: IO ()
main = do 
    dictionary <- readFile "./sjp/slowa.txt"
    return ()

getNextMatrix = do
    rawData <- getLine
    if rawData == "exit" then return () else do
        let matrix = Mx.fromList 15 15 (read rawData :: [Char]) 
        putStrLn . show $ getWords matrix

getWords :: Matrix Char -> [String]
getWords matrix = concat $ verticalWords ++ horizontalWords
    where verticalWords = map Ls.words $ Mx.toLists matrix 
          horizontalWords = map Ls.words . Mx.toLists $ Mx.transpose matrix 


getValidWords _words dictionary = filter (\e -> elem e dictionary) _words



    
