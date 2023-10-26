import random
import sys

sys.path.append("../../")
from lib.comparison import comparison
from lib.search import Search


class SetCovering(Search):
    """
    state: set of indices
    """

    def is_goal(self, state):
        total = 0
        length = len(self.space[0])
        for i in range(length):
            for j in state:
                if self.space[j][i]:
                    total += 1
                    break
        if total == length:
            return True
        else:
            return False

    def actions(self, state):
        """Return the actions that can be executed in the given state."""
        actions = []
        for i in range(len(self.space)):
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
        new_state.add(action)
        return new_state


def generate_random_space(set_number, problem_shape, probability, return_numpy=False):
    matrix = [
        [random.random() < probability for i in range(problem_shape)]
        for j in range(set_number)
    ]
    return matrix


space = generate_random_space(15, 15, 0.3)
m = SetCovering(space)


def h(self, node):
    total = 0
    length = len(self.space[0])
    for i in range(length):
        for j in node.state:
            if self.space[j][i]:
                total += 1
                break
    return length - total


comparison(
    m, set(), ["bfs", "dfs", "greedy", "astar"], heuristics=[(h, "Remaining True cols")]
)
