module STest where

import SAlgorithm.SValidator
import SData.SChar
import SData.SBoard as SB

import Data.Matrix as Mx

alaMaKota = "ala ma kota kot ma ale 123 234 345 445  1234567890-=="

asLettersMx x = Mx.fromLists $ (map $ map letter) $ Mx.toLists x

x = SB.fromList $ alaMaKota ++ repeat ' '

--           0123456789ABCDE
testList =  "ewa ma kota    " ++
            "w              " ++
            "a              " ++
            "       k       " ++
            "       o       " ++
            "       t       " ++
            "      pies     " ++
            "               " ++
            "      piesek   " ++
            "           o   " ++
            "     kotek t   " ++
            "      k        " ++
            " r    o        " ++
            "   r           " ++
            "     t         "