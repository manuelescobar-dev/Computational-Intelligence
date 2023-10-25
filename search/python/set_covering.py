import random
from search import Search


class Example(Search):
    """
    state: set of indices
    """

    def is_goal(self, state, goal):
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

    def heuristic(self, state):
        total = 0
        length = len(self.space[0])
        for i in range(length):
            for j in state:
                if self.space[j][i]:
                    total += 1
                    break
        return length - total

    def actions(self, state, goal):
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


def generate_random_space(set_number, problem_size, probability):
    space = []
    for i in range(set_number):
        set = []
        for j in range(problem_size):
            set.append(random.random() < probability)
        space.append(set)
    return space


space = generate_random_space(6, 5, 0.3)
print(space)
m = Example(space)


m.solve(set(), None, "ucs")
print(m.solution)
