import os
from scripts.tictactoe import *


def maxv(board):
    if terminal(board):
        return utility(board), None
    v = float("-inf")
    for action in actions(board):
        rv = minv(result(board, action))[0]
        if rv > v:
            v = rv
            a = action
    return v, a


def minv(board):
    if terminal(board):
        return utility(board), None
    v = float("inf")
    for action in actions(board):
        rv = maxv(result(board, action))[0]
        if rv < v:
            v = rv
            a = action
    return v, a


def play(board, use_cache=True, filename="scripts/minmax.npy"):
    """
    Returns the optimal action for the current player on the board.
    """
    # Game is over
    if terminal(board) == True:
        return None
    else:
        if use_cache:
            # If cache exists, load it
            if os.path.exists(filename):
                cache = np.load(filename, allow_pickle=True)
                if cache[state_to_index(board), 0] is not None:
                    return cache[state_to_index(board)]
            else:
                cache = np.full((19683, 2), None)
                print(cache)

        # If X is the current player (max)
        if player(board) == X:
            action = maxv(board)[1]

        # If O is the current player (min)
        elif player(board) == O:
            action = minv(board)[1]

        if use_cache:
            cache[state_to_index(board)] = action
            np.save(filename, cache)

        return action


def resulting_board(board):
    """
    Returns the board that results from making move (i, j) on the board.
    """
    return result(board, play(board))
