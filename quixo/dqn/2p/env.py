from game import Game, Move
import random
import numpy as np


class Env(Game):
    def __init__(self):
        super().__init__()
        self.action_space, self.action_space_size = self.get_action_space()
        self.state_space_size = 3 * 5 * 5
        self.current_player_idx = 0

    def set_env(self, game: "Game"):
        self._board = game.get_board()
        self.current_player_idx = game.current_player_idx

    def get_valid_actions(self):
        board = self.get_board()
        pos_actions = np.zeros(self.action_space_size)
        for i in range(self.action_space_size):
            from_pos = self.action_space[i][0]
            # check if the piece can be moved by the current player
            if (
                board[from_pos[1], from_pos[0]] < 0
                or board[from_pos[1], from_pos[0]] == self.current_player_idx
            ):
                pos_actions[i] = 1
        return pos_actions

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

    def reset(self):
        self.__init__()
        self.current_player_idx = 0

    """ def reward(self, player):
        winner = self.check_winner()
        if winner == player:
            return 1
        elif winner != player and winner >= 0:
            return -1
        else:
            return 0 """

    def step(self, action):
        """
        Returns:
            (ok, reward)
        """
        from_pos = self.action_space[action][0]
        slide = self.action_space[action][1]
        ok = self._Game__move(from_pos, slide, self.current_player_idx)
        if ok:
            winner = self.check_winner()
            self.current_player_idx = 1 - self.current_player_idx
            return (True, self.get_state(), winner)
        else:
            return (False, None, False)
