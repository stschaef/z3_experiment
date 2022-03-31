import itertools
import pprint
pp = pprint.PrettyPrinter(indent=4)
print=pp.pprint

fields = [
    "grant_msg(n0)", "grant_msg(n1)","grant_msg(n2)","held()",
    "holds_lock(n0)","holds_lock(n1)","holds_lock(n2)",
    "lock_msg(n0)","lock_msg(n1)","lock_msg(n2)",
    "unlock_msg(n0)","unlock_msg(n1)","unlock_msg(n2)"
]

eq_class_hex = {
    "A": 0x0,
    "B": 0x20,
    "C": 0x30,
    "D": 0x1200,
    "E": 0x38,
    "F": 0x1210,
    "G": 0x1220,
    "H": 0x300,
    "I": 0x1218,
    "J": 0x1230,
    "K": 0x310,
    "L": 0x320,
    "M": 0x204,
    "N": 0x1238,
    "O": 0x318,
    "P": 0x330,
    "Q": 0x214,
    "R": 0x224,
    "S": 0x338,
    "T": 0x21c,
    "U": 0x234,
    "V": 0x23c
}

eq_class_bin = {key: format(val, '0>13b') for key, val in eq_class_hex.items()}

def grant_msg(n, eq_class):
    return eq_class_bin[eq_class][0 + n] == "1"

def held(eq_class):
    return eq_class_bin[eq_class][3] == "1"

def hold_msg(n, eq_class):
    return eq_class_bin[eq_class][4 + n] == "1"

def lock_msg(n, eq_class):
    return eq_class_bin[eq_class][7 + n] == "1"

def unlock_msg(n, eq_class):
    return eq_class_bin[eq_class][10 + n] == "1"



num = 3
state_predicates = [grant_msg, hold_msg, lock_msg, unlock_msg]
counts = {}
for L in range(0, 5):
    for subset in itertools.combinations(state_predicates, L):
        count = 0
        for i in range(num): 
            a = True
            for f in subset:
                # print(f(i, 'A'))
                a = a and f(i, 'A')
            if a:
                count += 1
        counts[subset] = count
print(counts)



        
        


