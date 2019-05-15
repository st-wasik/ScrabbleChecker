module SAlgorithm.SPoints(wordValue) where

import SData.SChar

wordValue :: [(Int, Int)] -> SWord -> Int
wordValue usedFields word  = pointsIfNewWord
    where
        pointsIfNewWord = if (position $ word !! 0) `elem` usedFields && (position $ last word) `elem` usedFields then 0 else chars * wordExtra
        chars = sum $ map (charValue usedFields) word
        wordExtra = product $ map (charPosWordFactor usedFields) word

charValue :: [(Int, Int)] -> SChar -> Int
charValue usedFields char = charVal * charPosFactor char
    where
        charVal = charPoints char 

charPoints :: SChar -> Int
charPoints char
    | (letter char) `elem` ['a','e','i','n','o','r','s','w','z'] = 1
    | (letter char) `elem` ['c','d','k','l','m','p','t','y'] = 2
    | (letter char) `elem` ['b','g','h','j','u', '\321'] = 3 -- Ł
    | (letter char) `elem` ['f','\261','\281','\243','\347','\380'] = 5 -- Ą, Ę, Ó, Ś, Ż
    | (letter char) == '\263' = 6 --Ć
    | (letter char) == '\324' = 6 --Ń
    | (letter char) == '\378' = 6 --Ź
    | otherwise = 0

charPosFactor :: SChar -> Int
charPosFactor char 
    | (position char) `elem` [(1,4), (1,12), (3,7), (3,8), (3,9)] = 2
    | (position char) `elem` [(15,4),(15,12),(13,7),(13,8),(13,9)] = 2
    | (position char) `elem` [(4,15),(12,15),(7,13),(8,13),(9,13)] = 2
    | (position char) `elem` [(4,1),(12,1),(7,3),(8,3),(9,3)] = 2
    | (position char) `elem` [(7,7),(7,9),(9,7),(9,9)] = 2
    | (position char) `elem` [(2,6),(2,10),(6,2),(10,2),(6,14),(10,14),(14,6),(14,10)] = 3
    | (position char) `elem` [(6,6),(6,10),(10,6),(10,10)] = 3
    | otherwise = 1

charPosWordFactor :: [(Int, Int)] -> SChar -> Int
charPosWordFactor usedFields char 
    | (position char) `elem` usedFields = 1
    | (position char) `elem` [(2,2),(3,3),(4,4),(5,5)] = 2
    | (position char) `elem` [(11,11),(12,12),(13,13),(14,14)] = 2
    | (position char) `elem` [(14,2),(13,3),(12,4),(11,5)] = 2
    | (position char) `elem` [(5,11),(4,12),(3,13),(2,14)] = 2
    | (position char) `elem` [(1,1), (8,1), (15,1), (1,8), (15,8), (1,15), (8,15), (15,15)] = 3
    | otherwise = 1
