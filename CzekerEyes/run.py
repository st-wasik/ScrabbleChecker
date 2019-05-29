import random
import string
import time
import sys

begin = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "  scrabble     " + \
      "               " + \
      "      czeker   " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               "

ex1 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "       s       " + \
      "       i       " + \
      "       e       " + \
      "       m       " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               "

ex2 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "       s       " + \
      "       i       " + \
      "    apteka     " + \
      "       m       " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               "

ex3 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    a          " + \
      "    j          " + \
      "               " + \
      "               "

ex4 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    a          " + \
      "  maj          " + \
      "               " + \
      "               "

ex5 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akord      " + \
      "  maj          " + \
      "               " + \
      "               "

ex6 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akord      " + \
      "  maj   o      " + \
      "        m      " + \
      "               "

ex7 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o      " + \
      "        m      " + \
      "               "


ex8 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o j     " + \
      "    t  s a     " + \
      "    r  i v     " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o      " + \
      "        m      " + \
      "               "
  
ex9 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "       o       " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o      " + \
      "        m      " + \
      "               "	  
	  
ex10 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o      " + \
      "        m      " + \
      "               "	  	 

ex11 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o      " + \
      "       ćma     " + \
      "               "	  	 

ex12 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o  ó   " + \
      "       ćma ż   " + \
      "               "	  	 

ex13 = "               " + \
      "               " + \
      "               " + \
      "               " + \
      "               " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o  ó   " + \
      "       ćma żółć" + \
      "               "	  	 

ex14 = "               " + \
      "      p        " + \
      "      a        " + \
      "      j        " + \
      "      ą        " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o  ó   " + \
      "       ćma żółć" + \
      "               "	  
	  
ex15 = "               " + \
      "      p        " + \
      "     maź       " + \
      "      j        " + \
      "      ą        " + \
      "      koń      " + \
      "    t  s       " + \
      "    r  i       " + \
      "    apteka     " + \
      "    m  m       " + \
      "    w          " + \
      "    akordeon   " + \
      "  maj   o  ó   " + \
      "       ćma żółć" + \
      "               "	  


def main():
	test="to jest test znaków grzegorz brzęczyszczykiewicz chrząszczyrzewoszyce powiat łękołody śćół"
	n = 255-len(test)
	test2 =''.join(random.choices(string.ascii_lowercase, k=n))
	print(begin)
	sys.stdout.flush()
	
	time.sleep(20)
	print(ex1)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex2)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex3)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex4)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex5)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex6)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex7)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex8)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex9)
	sys.stdout.flush()

	time.sleep(1.5)
	print(ex10)
	sys.stdout.flush()

	time.sleep(1.5)
	print(ex11)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex12)
	sys.stdout.flush()
	
	time.sleep(1.5)
	print(ex13)
	sys.stdout.flush()

	time.sleep(1.5)
	print(ex14)
	sys.stdout.flush()

	time.sleep(1.5)
	print(ex15)
	sys.stdout.flush()
	
	time.sleep(5)
	print("exit")
	sys.stdout.flush()
	  
if __name__ == '__main__':
    main()