import random
import sys
import numpy as np

sys.path.append("../../")
from lib.comparison import comparison
from lib.search import Search


class NumpySetCovering(Search):
    """
    state: [list of indices]
    """

    def is_goal(self, state):
        total = 0
        length = self.space.shape[1]
        total = np.any(self.space[state, :], axis=0).sum()
        if total == length:
            return True
        else:
            return False

    def actions(self, state):
        """Return the actions that can be executed in the given state."""
        actions = []
        for i in range(self.space.shape[0]):
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


def h(self, node):
    total = 0
    length = self.space.shape[1]
    total = np.any(self.space[node.state, :], axis=0).sum()
    return length - total


def generate_random_space(set_number, problem_shape, probability):
    return np.array(
        [
            [random.random() < probability for i in range(problem_shape)]
            for j in range(set_number)
        ]
    )


space = generate_random_space(15, 15, 0.4)
m = NumpySetCovering(space)

comparison(
    m, [], ["bfs", "dfs", "greedy", "astar"], heuristics=[(h, "Remaining True cols")]
)
