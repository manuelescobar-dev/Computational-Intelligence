import random
from search import Search
import numpy as np


class Example(Search):
    """
    state: set of indices
    """

    def is_goal(self, state):
        total = 0
        length = self.space.shape[1]
        total = np.any(self.space[state, :], axis=0).sum()
        if total == length:
            return True
        else:
            return False

    def h(self, node):
        total = 0
        length = self.space.shape[1]
        total = np.any(self.space[node.state, :], axis=0).sum()
        return length - total

    def actions(self, state):
        """Return the actions that can be executed in the given state."""
        actions = []
        for i in range(self.space.shape[1]):
            if i not in state:
                actions.append(i)
        return actions

    """ def solution_format(self, actions):
        result = []
        for i in actions:
            result.append(self.space[i])
        return result """

    def results(self, state, action):
        """Return the state that results from executing the given
        action in the given state."""
        new_state = state.copy()
        new_state.append(action)
        return new_state


def generate_random_space(set_number, problem_shape, probability):
    return np.array(
        [
            [random.random() < probability for i in range(problem_shape)]
            for j in range(set_number)
        ]
    )


space = generate_random_space(20, 20, 0.4)
print(space)
m = Example(space)

m.solve([], None, "bfs")
print("BFS -->", "Explored:", m.num_explored, " | Solution:", m.solution)

m.solve([], None, "dfs")
print("DFS -->", "Explored:", m.num_explored, " | Solution:", m.solution)

m.solve([], None, "ucs")
print("UCS -->", "Explored:", m.num_explored, " | Solution:", m.solution)

m.solve([], None, "greedy")
print("Greedy -->", "Explored:", m.num_explored, " | Solution:", m.solution)

m.solve([], None, "astar")
print("A* -->", "Explored:", m.num_explored, " | Solution:", m.solution)
