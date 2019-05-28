import random
import string

def main():
    test="to jest test znaków grzegorz brzęczyszczykiewicz chrząszczyrzewoszyce powiat łękołody śćół"
    n = 255-len(test)
    test2 =''.join(random.choices(string.ascii_lowercase, k=n))
    print(test + test2)


if __name__ == '__main__':
    main()