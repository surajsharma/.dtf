#TARGET 1: COUNTER WITH RESET


class Counter(object):
    """MODELS A COUNTER"""

    #class variable
    instances = 0
    
    #constructor
    def __init__(self):
        """ THE BLACK MARBLE LEVITATING AT THE END OF THE CORRIDOR """
        Counter.instances += 1
        self.reset()

    #mutator methods
    def reset(self):
        """ SUICIDE SWITCH """
        self._value = 0
    def increment(self, amount=1):
        """ AMOUNT DAFA IZAFA """
        self._value += amount
    def decrement(self, amount=1):
        """ AMOUNT DAFA GHATAUTI """
        self._value -= amount

    #accesor methods
    def getvalue(self):
        """ HOW MANY FATHOMS DEEP? """
        return self._value

    def __str__(self):
        """ THE GODDAMN NARRATIVE """
        return str(self._value)

    def __eq__(self, other):
        """ AM I YOU? """
        if self is other: return True
        """ mirror? """
        if type(self) != type(other): return False
        """ apples and oranges? """
        return self._value == other._value
        """ apples and apples """
        return self == other

       
