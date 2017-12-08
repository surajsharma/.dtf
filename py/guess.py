#!/usr/bin/env python
""" 
# GUESS THE NUMBER!
# NOW WITH EXTRA:
    - Tough Mode
    - Exception Checking
    - Infinity Mode
# (C) Suraj Sharma 2017
# -----------------------------------------------------
"""

import random

def main():
    """THE MAIN FUNCTION"""
    tough = False
    small = input_number("Small Number: ")
    big = input_number("Big Number: ")
    if small >= big:
        print("Try again, smaller number shouldn't be larger (or equal to the bigger.")
        main()
    guessit = random.randint(small, big)
    tries = guessing(guessit, 2, tough)


def h_mode(ntry):
    """ make it hard? """
    if ntry % 5 == 0:
        act = input("Activate hard mode: (y/n)? ")
        return bool(act == 'y')
    else:
        return False

def guessloop(p, ntry, guess, guessed):
    usernum = input_number(str(p))
    if usernum == guess:
        guessed = True
        return guessed
    else:
        if h_mode(ntry):
            guessing(guess, tough=True)
        elif usernum < guess: 
            print(ntry, " > Too Low")
            return guessed
        else:
            print(ntry, " > Too high")
            return guessed
 
def guessing(guess, default=2, tough=False):
    """loop until guessed, return tries"""
    guessed = False
    ntry = 0
    p = "Take a wild guess: "
    while guessed is False:
        if tough is True:
            while ntry <= default:
                ntry += 1
                p= str(default-ntry)+ " tries left, guess: "
                guessed = guessloop(p, ntry, guess, guessed)
            return guessed
        else:
            ntry += 1
            guessed = guessloop(p,ntry, guess, guessed)
    return checkwin(ntry, guessed)

def checkwin(ntry, guessed):
    if guessed is True:
        print("Congratulations, you guessed it in ", ntry, " tries!")
    else:
        print("Sorry, you lost after ", ntry, "tries!")
    return guessed

def input_number(prompt):
    """INPUT TWO NUMBERS, ALL EXCEPTIONS CHECKED"""
    num = int(input(prompt))
    try:
        int(num)
        return num
    except ValueError:
        print("Error in number format!")
        return input_number(prompt)
    except SyntaxError:
        print("Syntax Error")
        return input_number(prompt)

if __name__ == "__main__":
    main()
