module STest where

import SAlgorithm.SValidator
import SData.SChar
import SData.SBoard as SB

import Data.Matrix as Mx

asLettersMx x = Mx.fromLists $ (map $ map letter) $ Mx.toLists x

ex1 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "       s       " ++
      "       i       " ++
      "       e       " ++
      "       m       " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               "

ex2 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "       s       " ++
      "       i       " ++
      "    apteka     " ++
      "       m       " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               "

ex3 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    a          " ++
      "    j          " ++
      "               " ++
      "               "

ex4 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    a          " ++
      "  maj          " ++
      "               " ++
      "               "

ex5 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akord      " ++
      "  maj          " ++
      "               " ++
      "               "

ex6 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akord      " ++
      "  maj   o      " ++
      "        m      " ++
      "               "

ex7 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "


ex8 = "               " ++
      "               " ++
      "               " ++
      "               " ++
      "               " ++
      "       o j     " ++
      "    t  s a     " ++
      "    r  i v     " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "


ex9 = "               " ++
      "               " ++
      "  a b c d e    " ++
      "               " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "
      
ex10 ="               " ++
      "   k           " ++
      "   o    qwerty " ++
      "   t           " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "

ex11 ="               " ++
      "   k           " ++
      "   o           " ++
      "   t           " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "
      
ex12 ="               " ++
      "   k           " ++
      "   oko         " ++
      "   t           " ++
      "               " ++
      "       o       " ++
      "    t  s       " ++
      "    r  i       " ++
      "    apteka     " ++
      "    m  m       " ++
      "    w          " ++
      "    akordeon   " ++
      "  maj   o      " ++
      "        m      " ++
      "               "




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
            "     b         " ++
            "     a    k    " ++
            "          a    " ++
            "          r    " ++
            "    schemat    " ++
            "          o    " ++
            "       o  t    " ++
            "       k  e    " ++
            "      koteki   " ++
            "        a a    " ++
            "        m      " ++
            "        auto   " ++
            "               " ++
            "               " 
