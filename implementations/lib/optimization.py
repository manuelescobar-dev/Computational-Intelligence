import random


class Optimization:
    def __init__(self, space) -> None:
        self.space = space
        self.solution = None

    def is_state_valid(self, state):
        return True

    def get_cost(self, state):
        raise NotImplementedError

    def get_neighbors(self, state):
        raise NotImplementedError

    def hill_climb(self, initial_state, state_num=1, maximum=None, log=False):
        """Performs hill-climbing to find a solution."""
        if not self.is_state_valid(initial_state):
            raise Exception("Problem not solvable")

        count = 0

        self.solution = initial_state
        if log:
            print("Initial state: cost", self.get_cost(self.solution))

        # Continue until we reach maximum number of iterations
        while maximum is None or count < maximum:
            count += 1
            best_neighbors = []
            best_neighbor_cost = None

            if state_num == 1:
                for neighbor in self.get_neighbors(self.solution):
                    # Check if neighbor is best so far
                    cost = self.get_cost(neighbor)
                    if best_neighbor_cost is None or cost < best_neighbor_cost:
                        best_neighbor_cost = cost
                        best_neighbors = [neighbor]
                    elif best_neighbor_cost == cost:
                        best_neighbors.append(neighbor)
            else:
                for state in self.solution:
                    for neighbor in self.get_neighbors(state):
                        # Check if neighbor is best so far
                        cost = self.get_cost(neighbor)
                        if best_neighbor_cost is None or cost < best_neighbor_cost:
                            best_neighbor_cost = cost
                            best_neighbors = [neighbor]
                        elif best_neighbor_cost == cost:
                            best_neighbors.append(neighbor)

            # None of the neighbors are better than the current state
            if best_neighbor_cost is None:
                return self.solution
            if best_neighbor_cost >= self.get_cost(self.solution):
                return self.solution

            # Move to a highest-valued neighbor
            else:
                if log:
                    print(f"Found better neighbor: cost {best_neighbor_cost}")
                self.solution = random.choice(best_neighbors)

    def random_restart(self, initial_state, maximum, log=False):
        """Repeats hill-climbing multiple times."""
        best_state = None
        best_cost = None

        # Repeat hill-climbing a fixed number of times
        for i in range(maximum):
            states = self.hill_climb(initial_state)
            cost = self.get_cost(states)
            if best_cost is None or cost < best_cost:
                best_cost = cost
                best_state = states
                if log:
                    print(f"{i}: Found new best state: cost {cost}")
            else:
                if log:
                    print(f"{i}: Found state: cost {cost}")

        self.solution = best_state
