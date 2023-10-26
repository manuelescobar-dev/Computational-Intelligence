from functools import reduce
import numpy as np

PROBLEM_SIZE = 4
SPACE = np.array(
    [
        [True, False, False, False],
        [False, True, True, False],
        [True, True, False, True],
    ]
)


def distance(state):
    return PROBLEM_SIZE - sum(
        reduce(
            np.logical_or,
            SPACE[state, :],
            np.array([False] * PROBLEM_SIZE),
        )
    )


n = np.array([0, 1, 2])
print(str(n))
