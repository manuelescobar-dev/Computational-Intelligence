import time
from prettytable import PrettyTable

informed_search = {"greedy", "astar"}


def comparison(
    problem,
    initial_state,
    goal=None,
    search_strategies=["bfs", "dfs", "greedy", "astar"],
    heuristics=[None],
):
    t = PrettyTable(["Strategy", "Solution", "Explored", "Time"])
    for i in search_strategies:
        if i in informed_search:
            for j in range(len(heuristics)):
                if type(heuristics[j]) == tuple:
                    h = heuristics[j][0]
                    name = heuristics[j][1]
                else:
                    h = heuristics[j]
                    name = str(j)
                start = time.time()
                problem.solve(initial_state, goal, i, h=h)
                end = time.time()
                t.add_row(
                    [
                        i + " | h: " + name,
                        problem.solution,
                        problem.num_explored,
                        "{:.3e}".format(end - start),
                    ]
                )
        else:
            start = time.time()
            problem.solve(initial_state, goal, i)
            end = time.time()
            t.add_row(
                [
                    i,
                    problem.solution,
                    problem.num_explored,
                    "{:.3e}".format(end - start),
                ]
            )

    print(t)
