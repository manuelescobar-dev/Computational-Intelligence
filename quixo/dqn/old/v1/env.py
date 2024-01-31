from game import Move, Game
import random
import numpy as np


class Env(Game):
    def __init__(self) -> None:
        super().__init__()
        self.action_space, self.action_space_size = self.get_action_space()
        self.space_state_size = 75

    def reset(self):
        self.__init__()
        self.current_player_idx = random.randint(0, 1)

    def reward(self, winner, player):
        if winner == player:
            return 1
        elif winner == 1 - player:
            return -1
        else:
            return 0

    def get_state(self):
        state = np.zeros((3, 5, 5))
        board = self.get_board()
        for i in range(5):
            for j in range(5):
                cell = board[i][j]
                if cell == 0:
                    state[0, i, j] = 1
                elif cell == 1:
                    state[1, i, j] = 1
                elif cell == -1:
                    state[2, i, j] = 1
        return state.flatten()

    def step(self, action):
        from_pos, slide = self.get_move(action)
        ok = self._Game__move(from_pos, slide, self.current_player_idx)
        winner = self.check_winner()
        return ok, self.reward(winner, self.current_player_idx), winner

    def get_move(self, action):
        return self.action_space[action][0], self.action_space[action][1]

    def get_action_space(self):
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
        return actions, count
