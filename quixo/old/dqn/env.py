from game import Game, Move
import numpy as np


class Env(Game):
    def __init__(self):
        # Initialize game parameters
        super().__init__()
        self.action_space, self.action_space_size = self.get_action_space()
        self.state_space_size = 3 * 5 * 5 + 1
        self.current_player_idx = 0

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
        return np.append(state.flatten(), self.current_player_idx)

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
        # Reset the game state
        self.__init__()

    def step(self, action):
        from_pos = self.action_space[action][0]
        slide = self.action_space[action][1]
        ok = self._Game__move(from_pos, slide, self.current_player_idx)
        winner = self.check_winner()
        if winner >= 0:
            self.done = True
            self.winner = winner
        else:
            self.current_player_idx = 1 - self.current_player_idx

    def get_move(self, action):
        return self.action_space[action][0], self.action_space[action][1]

    def step(self, action):
        # Execute player's action
        if self.board[action] == " ":
            self.board[action] = self.player
            if self.check_winner():
                self.done = True
                self.winner = self.player
            elif " " not in self.board:
                self.done = True
            else:
                self.player = "O" if self.player == "X" else "X"

    def check_winner(self):
        # Check if there is a winner
        lines = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6],
        ]
        for line in lines:
            if self.board[line[0]] == self.board[line[1]] == self.board[line[2]] != " ":
                return True
        return False

    def get_state(self):
        # Get current game state
        state = [1 if cell == "X" else -1 if cell == "O" else 0 for cell in self.board]
        state.append(1 if self.player == "X" else -1)
        return np.array([state])


# Main function
if __name__ == "__main__":
    env = TicTacToe()
    state_size = 27
    action_size = 9
    agent = DQNAgent(state_size, action_size)
    batch_size = 32
    episo
