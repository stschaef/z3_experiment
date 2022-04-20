import itertools
from math import ceil, floor

NUM_NODES = 10
indices = range(1, NUM_NODES + 1)

quorum_size = floor(NUM_NODES / 2) + 1
quorums = list(itertools.combinations(indices, quorum_size))

s = "(declare-datatypes ((node 0)) (( "
t = "(declare-datatypes ((quorum 0)) (( "
for i in indices:
    s += "(node{}) ".format(i)
s += ")))"
for i, _ in enumerate(quorums):
    t += "(quorum{}) ".format(i + 1)
t += ")))"

v = """
;state predicates
(declare-fun member (node quorum) Bool)
(declare-fun vote (node value) Bool)
(declare-fun didNotVote (node) Bool)
(declare-fun decision (value) Bool)
(declare-fun chosenAt (quorum value) Bool)
"""

print(s)
print(t)
print(v)

u = "(assert\n(and\n"
for i, q in enumerate(quorums):
    u += f"    ;quorum{i + 1}: {q}\n"
    for j in indices:
        if j in set(q):
            u += f"    (member node{j} quorum{i + 1})\n"
        else:
            u += f"    (not(member node{j} quorum{i + 1}))\n"
    u += "\n"
u += "))\n"
print(u)