from distutils.command.build import build
from typing import List
import glob
import logiclib
import re

protocols = [
    # "toy_consensus",
    "ex_lockserv_automaton",
    "ex_simpledecentralized_lock",
    "client_server", 
    "tla_tcommit"
]

quantifier = {
    "\\exists": "(exists ",
    "\\forall": "(forall ",
}

sorts = {
    "toy_consensus": ["node", "value", "quorum"],
    "ex_lockserv_automaton": ["Node"],
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
        return ""

    # unpack singleton
    if len(parsed) == 1:
        return build_smt(parsed[0], prot, ind_lvl)
        
    # function application
    if len(parsed) == 2 and parsed[0] != "~" and type(parsed[1]) == list:
        arg_string = " ".join(parsed[1])
        return ind_lvl * 4 * " " + f"({parsed[0]} {arg_string})"

    # negation
    if len(parsed) == 2 and parsed[0] == "~":
        return ind_lvl * 4 * " " + f"(not {build_smt(parsed[1], prot, 0)})"

    # quantification
    if type(parsed[0]) == str and parsed[0] in quantifier.keys():
        return ind_lvl * 4 * " " + f"{quantifier[parsed[0]]} (({parsed[1]} {get_sort(parsed[1], prot)}))\n" +  build_smt(parsed[2], prot, ind_lvl + 1) + f"\n{build_smt(')', prot, ind_lvl)}"
    
    # and, or, equals
    if type(parsed[1]) == str and parsed[1] in operators.keys():
        return ind_lvl * 4 * " " + f"({operators[parsed[1]]}\n{build_smt(parsed[0], prot, ind_lvl + 1)}\n{build_smt(parsed[2:], prot, ind_lvl + 1)}\n{build_smt(')', prot, ind_lvl)}"

def preprocess_string(s):
    s = s.replace("start_nodeIS", "start_node")
    s = s.replace("_", "").replace("()", "")
    return s

def restore_formatting(s):
    s = s.replace("unlockmsg", "unlock_msg")
    s = s.replace("grantmsg", "grant_msg")
    s = s.replace("holdslock", "holds_lock")
    s = s.replace("lockmsg", "lock_msg")
    s = s.replace("haslock", "has_lock")
    s = s.replace("startnode", "start_node")
    return s

for protocol in protocols:
    for filename in glob.glob(f"formulas/{protocol}/*.txt"):
        destination = filename[:-4] + ".smt"
        with open(destination, "w") as out_file:
            out_file.write("(and\n")
            for line in open(filename):
                line = preprocess_string(line)
                parsed = logiclib.pyparsing_parse(line)
                answer = restore_formatting(build_smt(parsed, protocol, 0))
                out_file.write(answer + "\n")
            out_file.write(")\n")
            