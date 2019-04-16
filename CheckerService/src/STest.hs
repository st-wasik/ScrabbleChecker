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

--           0123456789ABCDE
testList2 = "  p       z    " ++
            "  o   diabel   " ++
            "  t            " ++
            "  r     u      " ++
            " szpiczastymi  " ++
            "  e     z      " ++
            "  b przyjaciel " ++
            "  i     m    e " ++ 
            "  e  w  i    d " ++
            "             w " ++
            "   juz       o " ++
            "               " ++
            "   nogi  p     " ++
            "        za     " ++
            "         s     " 

testList3 = "               " ++
            "ze             " ++
            "p uszami       " ++
            "i              " ++
            "c    ledwo     " ++
            "z              " ++
            "               " ++
            "s              " ++
            "t w potrzebie  " ++
            "y              " ++
            "m           p  " ++
            "i juz nogi za  " ++
            "            s  " ++
            "               " ++
            "               " 

testList4 = "               " ++
            "               " ++
            "               " ++
            "     d         " ++
            "     o         " ++
            "     m         " ++
            "               " ++
            "       o       " ++
            "       k       " ++
            "      kot      " ++
            "        a      " ++
            "        m      " ++
            "        auto   " ++
            "               " ++
            "               " 

testList5 = "               " ++
            "               " ++
            "          k    " ++
            "          a    " ++
            "          r    " ++
            "    schemat    " ++
            "          o    " ++
            "       o  t    " ++
            "       k  e    " ++
            "      kotek    " ++
            "        a a    " ++
            "        m      " ++
            "        auto   " ++
            "               " ++
            "               " 

testList6 = "     a         " ++
            "               " ++
            "     b    k    " ++
            "          a    " ++
            "          r    " ++
            "    schemat    " ++
            "          o    " ++
            "       o  t    " ++
            "       k  e    " ++
            "      kotek    " ++
            "        a a    " ++
            "        m      " ++
            "        auto   " ++
            "               " ++
            "               " 
