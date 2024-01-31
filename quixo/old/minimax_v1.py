from copy import deepcopy
import numpy as np
from game import Game, Move, Player
import minimax.env as env


def max_v(board, alpha, beta, depth, player):
    winner = env.get_winner(board)
    if depth == 0 or winner >= 0:
        return env.utility(winner)
    v = float("-inf")
    for action in env.get_actions(board, player):
        v = max(
            v,
            min_v(
                env.result(board, action, player),
                alpha,
                beta,
                depth - 1,
                1 - player,
            ),
        )
        alpha = max(alpha, v)
        if alpha >= beta:
            break
    return v


def min_v(board, alpha, beta, depth, player):
    winner = env.get_winner(board)
    if depth == 0 or winner >= 0:
        return env.utility(winner)
    v = float("inf")
    for action in env.get_actions(board, player):
        v = min(
            v,
            max_v(
                env.result(board, action, player),
                alpha,
                beta,
                depth - 1,
                1 - player,
            ),
        )
        beta = min(beta, v)
        if alpha >= beta:
            break
    return v


def minimax(board, depth, player):
    if player == 1:
        v = float("-inf")
        best_action = None
        for action in env.get_actions():
            new_v = min_v(
                env.result(board, action, player),
                float("-inf"),
                float("inf"),
                depth - 1,
                1 - player,
            )
            if new_v > v:
                v = new_v
                best_action = action
        return best_action

    elif player == 0:
        v = float("inf")
        best_action = None
        for action in env.get_actions(board, player):
            new_v = max_v(
                env.result(deepcopy(board), action, player),
                float("-inf"),
                float("inf"),
                depth - 1,
                1 - player,
            )
            if new_v < v:
                v = new_v
                best_action = action
        return best_action
