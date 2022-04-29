import glob

protocol = "tla_tcommit"

patterns = {
    "toy_consensus": "../DP_reachability_results/exploreR_outputs/ex/ex_toy_consensus/*minClauses.txt",
    "ex_lockservice": "../DP_reachability_results/exploreR_outputs/ex/ex_lockservice/*minClauses.txt",
    "ex_simpledecentralized_lock": "../DP_reachability_results/exploreR_outputs/ex/ex_simpledecentralized_lock/*minClauses.txt",
    "client_server": "../DP_reachability_results/exploreR_outputs/i4/client-server/*minClauses.txt",
    "tla_tcommit": "../DP_reachability_results/exploreR_outputs/tla/tla_tcommit/*minClauses.txt",
}

for protocol in ["toy_consensus", "ex_lockservice", "ex_simpledecentralized_lock", "client_server", "tla_tcommit"]:
    for filename in glob.glob(patterns[protocol]):
        if protocol == "toy_consensus":
            sig = filename[-21:-15]
            n, q, v = sig[1], sig[3], sig[5]
            destination = f"formulas/toy_consensus/toy_consensus_{n}-{q}-{v}.txt"
        elif protocol == "ex_lockservice":
            n = filename[-16]
            destination = f"formulas/ex_lockserv_automaton/ex_lockserv_automaton_{n}.txt"
        elif protocol == "ex_simpledecentralized_lock":
            n = filename[-16]
            destination = f"formulas/ex_simpledecentralized_lock/ex_simpledecentralized_lock_{n}.txt"
        elif protocol == "client_server":
            n = filename[-16]
            m = filename[-18]
            destination = f"formulas/client_server/client_server_{n}-{m}.txt"
        elif protocol == "tla_tcommit":
            n = filename[-16] 
            destination = f"formulas/tla_tcommit/tla_tcommit_{n}.txt"
        
        with open(destination, "w") as out_file:
            a = open(filename, "r").read().split("\n\n")
            for line in (a[1].strip().split('\n'))[1:]:
                out_file.write(" ".join(line.split()[1:]) + '\n')
    