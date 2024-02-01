import sys
from game import Game, Move, Player
import numpy as np


class Env(Game):
    def __init__(self, state_space_size: int = 75):
        super().__init__()
        # Initialize
        self.state_space_size = state_space_size
        self.action_space, self.action_space_size = self.get_action_space()
        self.current_player_idx = 0

    def set_env(self, game: "Game") -> None:
        """Initialize the environment with the current game state"""
        self._board = game.get_board()
        self.current_player_idx = game.current_player_idx

    def get_valid_actions(self) -> np.ndarray:
        """Get the valid actions for the current player"""
        board = self.get_board()
        pos_actions = np.zeros(self.action_space_size, dtype=np.float32)
        for i in range(self.action_space_size):
            from_pos = self.action_space[i][0]
            # check if the piece can be moved by the current player
            if (
                board[from_pos[1], from_pos[0]] < 0
                or board[from_pos[1], from_pos[0]] == self.current_player_idx
            ):
                pos_actions[i] = 1
        return pos_actions

    def get_state(self) -> np.ndarray:
        """Get the current state of the board as a flattened numpy array"""
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
        if self.state_space_size == 3 * 5 * 5:
            return state.flatten()
        elif self.state_space_size == 3 * 5 * 5 + 1:
            return np.append(state.flatten(), self.current_player_idx)

    def get_action_space(self) -> tuple[dict[int, tuple[tuple[int, int], Move]], int]:
        """Initialize the action space"""
        actions = {}
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

    def reset(self) -> None:
        """Reset the environment"""
        self.__init__(self.state_space_size)
        self.current_player_idx = 0

    def get_game(self) -> "Game":
        """Get the game object"""
        game = Game()
        game._board = self.get_board()
        game.current_player_idx = self.current_player_idx
        return game

    def get_index_from_action(self, action: tuple[tuple[int, int], Move]) -> int:
        """Get the index of the action in the action space"""
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
                    if action == ((i, j), move):
                        return count
                    count += 1

    def step(self, action: int) -> tuple[bool, np.ndarray, bool]:
        """Step function for the environment

        Args:
            action (int): action value

        Returns:
            _type_: (ok, observation, winner)
        """
        # Get the action from the action space
        from_pos = self.action_space[action][0]
        slide = self.action_space[action][1]
        # Move the piece
        ok = self._Game__move(from_pos, slide, self.current_player_idx)
        if ok:
            # The move was valid
            winner = self.check_winner()
            self.current_player_idx = 1 - self.current_player_idx
            return (True, self.get_state(), winner)
        else:
            return (False, None, False)
