"""
Tic Tac Toe Player
"""

import random
import numpy as np
import matplotlib.pyplot as plt
import copy


X = "X"
O = "O"


def initial_state():
    """
    Returns starting state of the board.
    """
    return [[None, None, None], [None, None, None], [None, None, None]]


def player(board: list):
    """
    Returns player who has the next turn on a board. X always goes first.
    """
    xcount = 0
    ocount = 0
    for i in board:
        for j in i:
            if j == X:
                xcount = xcount + 1
            elif j == O:
                ocount = ocount + 1
    if xcount > ocount:
        return O
    elif xcount == ocount:
        return X


def actions(board: list):
    """
    Returns a list of all possible actions (i, j) available on the board.
    """
    actions = []
    for i in range(3):
        for j in range(3):
            if board[i][j] is None:
                actions.append([i, j])
    return np.array(actions)


def result(board: list, action: tuple):
    """
    Returns the board that results from making move (i, j) on the board.
    """
    result = copy.deepcopy(board)
    if board[action[0]][action[1]] is not None:
        print("Error", board)
        raise ValueError
    else:
        result[action[0]][action[1]] = player(board)
    return result


def winner(board):
    """
    Determines the winner of the game, if there is one.
    """
    for i in range(3):
        # Checks for horizontal win
        if board[i][0] == board[i][1] == board[i][2] != None:
            return board[i][0]
        # Checks for vertical win
        elif board[0][i] == board[1][i] == board[2][i] != None:
            return board[0][i]
    # Checks for diagonal win
    if board[0][0] == board[1][1] == board[2][2] != None:
        return board[0][0]
    # Checks for diagonal win (other way)
    elif board[0][2] == board[1][1] == board[2][0] != None:
        return board[0][2]
    # If no winner
    else:
        return None


def terminal(board):
    """
    Determines if the board is a terminal board.
    """
    if winner(board) is not None:
        return True
    else:
        for row in board:
            for i in row:
                if i is None:
                    return False
        return True


def utility(board):
    """
    Returns 1 if X has won the game, -1 if O has won, 0 otherwise.
    """
    if terminal(board) == True:
        if winner(board) == X:
            return 1
        elif winner(board) == O:
            return -1
        else:
            return 0


def random_opponent(board):
    m = random_move(board)
    return result(board, m)


def random_move(board):
    moves = actions(board)
    # Random action
    idx = random.randint(0, moves.shape[0] - 1)
    m = moves[idx, :]  # choose random action with equal probability among all actions
    return m


def state_to_index(state):
    index = 0
    factor = 1

    # Flatten the 3x3 board and convert to decimal
    for row in state:
        for cell in row:
            if cell == X:
                i = 1
            elif cell == O:
                i = 2
            else:
                i = 0
            index += factor * i
            factor *= 3

    return index
