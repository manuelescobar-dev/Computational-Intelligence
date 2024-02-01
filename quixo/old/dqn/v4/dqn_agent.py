import random

import torch
from game import Game, Move, Player
from model import Agent, Policy
import numpy as np


class DqnPlayer(Player):
    def __init__(self, filename) -> None:
        super().__init__()
        actions = {}
        # ACTIONS
        moves = [Move.TOP, Move.BOTTOM, Move.LEFT, Move.RIGHT]
        cells = [
            (0, 0),
            (0, 1),
            (0, 2),
            (0, 3),
            (0, 4),
            (4, 0),
            (4, 1),
            (4, 2),
            (4, 3),
            (4, 4),
            (1, 0),
            (2, 0),
            (3, 0),
            (1, 4),
            (2, 4),
            (3, 4),
        ]
        count = 0
        for cell in cells:
            for move in moves:
                i = cell[0]
                j = cell[1]
                if not (
                    (i == 0 and move == Move.LEFT)
                    or (i == 4 and move == Move.RIGHT)
                    or (j == 0 and move == Move.TOP)
                    or (j == 4 and move == Move.BOTTOM)
                ):
                    actions[count] = ((i, j), move)
                    count += 1
        self.action_space = actions

        print("Loading model from", filename, "...")
        state_dict = torch.load(filename)
        # Instantiate agent and its policy
        policy = Policy(44, 76)
        agent = Agent(policy)
        policy.load_state_dict(state_dict)

    def get_state(board, player):
        state = np.zeros((3, 5, 5))
        for i in range(5):
            for j in range(5):
                cell = board[i][j]
                if cell == 0:
                    state[0, i, j] = 1
                elif cell == 1:
                    state[1, i, j] = 1
                elif cell == -1:
                    state[2, i, j] = 1
        return np.append(state.flatten())

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        board = game.get_board()
        state = self.get_state(board, self.player_idx)
        action, _ = self.agent.get_action(state, evaluation=True)
        from_pos, slide = self.action_space[action]
        return from_pos, slide
