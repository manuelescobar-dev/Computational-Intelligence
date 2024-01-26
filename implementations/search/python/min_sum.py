import sys

sys.path.append("../../")
from lib.comparison import comparison
from lib.search import Search


class MinSum(Search):
    """
    state: set of indices
    """

    def is_goal(self, state):
        return sum([self.space[i] for i in state]) == self.goal

    def actions(self, state):
        """Return the actions that can be executed in the given state."""
        actions = []
        for i in range(len(self.space)):
            if i not in state:
                if sum([self.space[i] for i in state]) + self.space[i] <= self.goal:
                    actions.append(i)
        return actions

    def solution_format(self, actions):
        result = []
        for i in actions:
            result.append(self.space[i])
        return result

    def results(self, state, action):
        """Return the state that results from executing the given
        action in the given state."""
        new_state = state.copy()
        new_state.add(action)
        return new_state


space = [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3]
problem = MinSum(space)
initial_state = set()
goal = 27

comparison(problem, initial_state, goal=goal, search_strategies=["dfs", "bfs"])
