module SData.SChar where

import Data.Matrix as Mx
import Data.Tuple
import Data.Char as C
import System.IO
import Data.List as List

-- Scrabble data type

data SValid = Valid | Invalid | NotSet | PartOfInvalid | SingleLetter | ConnectionPoint | NotConnected deriving(Eq)

shortShow = True 

-- instance Show SValid where 
--      show Valid   = if shortShow then "√" else "Valid"
--      show Invalid = if shortShow then "×" else "Invalid"
--      show NotSet  = if shortShow then "" else "NotSet"
--      show PartOfInvalid = if shortShow then "⊗" else "PartOfInvalid"
--      show SingleLetter = if shortShow then "^" else "SingleLetter"
--      show ConnectionPoint = if shortShow then "+" else "ConnectionPoint"
--      show NotConnected = if shortShow then "-" else "NotConnected"

instance Show SValid where 
     show Valid   = "v"
     show Invalid = "i"
     show NotSet  = "_"
     show PartOfInvalid = "p" 
     show SingleLetter = "s"
     show ConnectionPoint = "c"
     show NotConnected = "n" 


data SChar = SChar {
                        letter :: Char
                   ,    valid :: SValid
                   ,    position :: (Int, Int)
                   } 

instance Show SChar where
     show s = concat ["", show . C.toUpper $ letter s , " ", show $ valid s, ""]
     --show s = concat ["",show $ letter s, " ", show $ valid s, " ", show $ position s, ""]
     --show s = concat [show $ letter s, show $ position s]

type SWord = [SChar]


empty :: (Int, Int) -> SChar
empty position = SChar ' ' NotSet position

word :: SWord -> String
word = map letter


-- | Prints formated SChar list
printSCharList :: [SChar] -> IO ()
printSCharList list = do
     let formattedList = List.map (\sc@(SChar l v p) -> if v == ConnectionPoint then SChar l Valid p else sc) list
     let formattedList2 = List.map (\sc@(SChar l v p) -> if v == SingleLetter then SChar l Invalid p else sc) formattedList
     putStr "["
     printSCharList' formattedList2
     putStrLn "]"
     hFlush stdout

printSCharList' [] = return ()

printSCharList' [sc] = do
     let letter_ = (C.toUpper $ (letter sc))
         in if letter_ == ' '
            then putStr $ '_': ""
            else putStr $ letter_ : ""
     putStr . show $ valid sc
     return ()

printSCharList' (sc:scs) = do
     let letter_ = (C.toUpper $ (letter sc))
         in if letter_ == ' '
            then putStr $ '_': ""
            else putStr $ letter_ : ""
     putStr . show $ valid sc
     putStr ","
     printSCharList' scs