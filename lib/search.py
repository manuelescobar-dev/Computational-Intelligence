from collections import deque
from queue import PriorityQueue
from dataclasses import dataclass, field
from typing import Any


class Node:
    def __init__(self, state, parent, action, cost):
        self.state = state
        self.parent = parent
        self.action = action
        self.cost = cost


class StackFrontier:
    def __init__(self):
        self.frontier = deque()

    def add(self, node):
        self.frontier.append(node)

    def contains_state(self, state):
        return any(node.state == state for node in self.frontier)

    def empty(self):
        return len(self.frontier) == 0

    def remove(self):
        if self.empty():
            raise Exception("empty frontier")
        else:
            node = self.frontier.pop()
            return node


@dataclass(order=True)
class PrioritizedItem:
    priority: int
    item: Any = field(compare=False)


class PriorityFrontier:
    def __init__(self, priority_function=(lambda x: 0)):
        self.priority_function = priority_function
        self.frontier = PriorityQueue()

    def add(self, node):
        item = PrioritizedItem(self.priority_function(node), node)
        self.frontier.put(item)

    def contains_state(self, state):
        return any(node.item.state == state for node in self.frontier.queue)

    def empty(self):
        return self.frontier.empty()

    def remove(self):
        if self.empty():
            raise Exception("empty frontier")
        else:
            node = self.frontier.get().item
            return node


class BreadthFirstSearch(StackFrontier):
    def remove(self):
        if self.empty():
            raise Exception("empty frontier")
        else:
            node = self.frontier.popleft()
            return node


class DepthFirstSearch(StackFrontier):
    def remove(self):
        if self.empty():
            raise Exception("empty frontier")
        else:
            node = self.frontier.pop()
            return node


class Search:
    def __init__(self, space) -> None:
        self.space = space
        self.solution = None

    def actions(self):
        raise NotImplementedError

    def results(self):
        raise NotImplementedError

    def is_goal(self, state):
        return state == self.goal

    def solution_format(self, actions):
        return actions

    def action_cost(self, state, action):
        return 1

    def solve(self, start, goal, strategy="bfs", h=None, g=None):
        self.goal = goal
        # Keep track of number of states explored
        self.num_explored = 0

        # Initialize frontier to just the starting position
        start = Node(state=start, parent=None, action=None, cost=0)
        if strategy == "bfs":
            frontier = BreadthFirstSearch()
        elif strategy == "dfs":
            frontier = DepthFirstSearch()
        elif strategy == "ucs":
            frontier = PriorityFrontier(lambda x: x.cost)
        elif strategy == "greedy":
            if h is None:
                raise Exception("Heuristic required for greedy search")
            else:
                frontier = PriorityFrontier(lambda x: h(self, x))
        elif strategy == "astar":
            if g is not None and h is not None:
                frontier = PriorityFrontier(lambda x: g(self, x) + h(self, x))
            else:
                if h is None:
                    raise Exception("Heuristic required for greedy search")
                else:
                    frontier = PriorityFrontier(lambda x: x.cost + h(self, x))
        else:
            raise Exception(
                "Invalid strategy. Choose from bfs, dfs, ucs, greedy, astar"
            )
        frontier.add(start)

        # Initialize an empty explored set
        self.explored = set()

        # Keep looping until solution found
        while True:
            # If nothing left in frontier, then no path
            if frontier.empty():
                raise Exception("no solution")

            # Choose a node from the frontier
            node = frontier.remove()
            self.num_explored += 1

            # If node is the goal, then we have a solution
            if self.is_goal(node.state):
                self.solution_cost = node.cost
                actions = []
                while node.parent is not None:
                    actions.append(node.action)
                    node = node.parent
                actions.reverse()
                self.solution = self.solution_format(actions)
                return

            # Mark node as explored
            self.explored.add(str(node.state))

            # Add actions to frontier
            for action in self.actions(node.state):
                state = self.results(node.state, action)
                if (
                    not frontier.contains_state(state)
                    and str(state) not in self.explored
                ):
                    child = Node(
                        state=state,
                        parent=node,
                        action=action,
                        cost=node.cost + self.action_cost(node.state, action),
                    )
                    frontier.add(child)
