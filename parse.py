from distutils.command.build import build
from typing import List
import logiclib

protocols = ["toy_consensus",
             "ex_lockservice",
             "ex_simpledecentralized_lock",
             "client_server", 
             "tla_tcommit"]

quantifier = {
    "\\exists": "(exists ",
    "\\forall": "(forall ",
}

sorts = {
    "toy_consensus": ["node", "value", "quorum"],
    "ex_lockservice": ["Node"],
    "ex_simpledecentralized_lock": ["Node"],
    "client_server": ["Client", "Server"],
    "tla_tcommit": ["RM"]
}

operators = {
    "==": "=",
    "&": "and",
    "|": "or"
}

def get_sort(term, prot):
    if len(sorts[prot]) == 1:
        return sorts[prot][0]
    if prot == "client_server":
        if term[0] == "C":
            return "Client"
        return "Server"
    if prot == "toy_consensus":
        if term[0] == "q":
            return "quorum"
        if term[0] == "N":
            return "node"
        return "value"

def build_smt(parsed, prot, ind_lvl):
    if type(parsed) != list:
        return ind_lvl * 4 * " " + parsed
    if len(parsed) == 0:
        return ind_lvl * 4 * " " + ""
    if len(parsed) == 1:
        ind_lvl * 4 * " " + parsed[0]

    # function application
    if len(parsed) == 2 and type(parsed[1]) == list:
        arg_string = " ".join(parsed[1])
        return ind_lvl * 4 * " " + f"({parsed[0]} {arg_string})"

    # negation
    if len(parsed) == 2:
        return ind_lvl * 4 * " " + f"(not {build_smt(parsed[1], prot, ind_lvl)})"

    # quantification
    if type(parsed[0]) == str and parsed[0] in quantifier.keys():
        return ind_lvl * 4 * " " + f"{quantifier[parsed[0]]} (({parsed[1]} {get_sort(parsed[1], prot)}))\n" +  build_smt(parsed[2], prot, ind_lvl + 1) + f"\n{build_smt(')', prot, ind_lvl)}"
    
    # and, or, equals
    if type(parsed[1]) == str and parsed[1] in operators.keys():
        return ind_lvl * 4 * " " + f"({operators[parsed[1]]}\n{build_smt(parsed[0], prot, ind_lvl + 1)}\n{build_smt(parsed[2], prot, ind_lvl + 1)}\n{build_smt(')', prot, ind_lvl)}"
 
for line in open("formulas/client_server/client_server_3-3.txt"):
    # print("formulas/client_server/client_server_1-2.txt"[:-4])
    print("\n\n", line)
    parsed = logiclib.pyparsing_parse(line)
    print(build_smt(parsed, "client_server", 0))