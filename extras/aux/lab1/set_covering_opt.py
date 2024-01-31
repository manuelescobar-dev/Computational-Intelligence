import sys
import random

sys.path.append("../../")
from lib.optimization import Optimization


class SetCovering(Optimization):
    def get_neighbors(self, state):
        n = []
        """Return the actions that can be executed in the given state."""
        for i in state:
            new_state = state.copy()
            new_state.remove(i)
            if self.is_state_valid(new_state):
                n.append(new_state)
        return n

    def get_cost(self, state):
        return len(state)

    def is_state_valid(self, state):
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


def generate_random_space(set_number, problem_shape, probability, return_numpy=False):
    matrix = [
        [random.random() < probability for i in range(problem_shape)]
        for j in range(set_number)
    ]
    return matrix


SUBSETS_NUMBER = 1000
SUBSETS_SIZE = 5
PROBABILITY = 0.3
space = generate_random_space(SUBSETS_NUMBER, SUBSETS_SIZE, PROBABILITY)
initial_state = [i for i in range(SUBSETS_NUMBER)]
m = SetCovering(space)
m.hill_climb(initial_state, maximum=1000, log=True)
print(m.solution)
m.random_restart(initial_state, maximum=10, log=False)
print(m.solution)
