module SData.SChar where

import Data.Matrix as Mx
import Data.Tuple
import Data.Char as C

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
     show NotSet  = " "
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
     show s = concat ["", filter (/='\'') . show . C.toUpper $ letter s, "", show $ valid s, ""]
     --show s = concat ["",show $ letter s, " ", show $ valid s, " ", show $ position s, ""]
     --show s = concat [show $ letter s, show $ position s]


type SWord = [SChar]


empty :: (Int, Int) -> SChar
empty position = SChar ' ' NotSet position

word :: SWord -> String
word = map letter