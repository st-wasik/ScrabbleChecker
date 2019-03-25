module SData.SChar where

import Data.Matrix as Mx
import Data.Tuple

-- Scrabble data type

data SValid = Valid | Invalid | NotSet | PartOfInvalid deriving(Eq)

instance Show SValid where 
     show Valid   = "Valid"
     show Invalid = "Invalid"
     show NotSet  = "NotSet"
     show PartOfInvalid = "PartOfInvalid"


data SChar = SChar {
                        letter :: Char
                   ,    valid :: SValid
                   ,    position :: (Int, Int)
                   } 

instance Show SChar where
     show s = concat ["",show $ letter s, " ", show $ valid s, " ", show $ position s, ""]


type SWord = [SChar]


empty :: (Int, Int) -> SChar
empty position = SChar ' ' NotSet position

word :: SWord -> String
word = map letter