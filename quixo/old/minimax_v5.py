from copy import deepcopy
import os
import numpy as np
from game import Game, Move, Player


class MinimaxPlayer(Player):
    def __init__(self, filename="minimax", depth=4) -> None:
        self.depth = depth

        # CACHE
        self.filename = filename + "_d" + str(depth) + ".npy"
        # Load cache
        if os.path.exists(self.filename):
            self.cache = np.load(self.filename, allow_pickle=True)
        # Initialize cache
        else:
            # Fill cache with None
            self.cache = np.full((3 ^ 25, 2, depth), None)
            np.save(self.filename, self.cache)

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
        actions = []
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
                    actions.append(((i, j), move))

        self.actions = actions

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        board = game.get_board()
        player = game.get_current_player()
        return self.minimax(player, board)

    def possible_actions(self, board, player):
        pos_actions = []
        for i in self.actions:
            # check if the piece can be moved by the current player
            if board[i[0][1], i[0][0]] < 0 or board[i[0][1], i[0][0]] == player:
                pos_actions.append(i)
        return pos_actions

    def hash_state(self, board):
        index = 0
        factor = 1

        # Flatten the 5x5 board and convert to decimal
        for row in board:
            for cell in row:
                if cell == 0:
                    i = 1
                elif cell == 1:
                    i = 2
                else:
                    i = 0
                index += factor * i
                factor *= 3

        return index

    def max_v(self, board, alpha, beta, depth, player):
        winner = self.check_winner(board)
        if depth == 0 or winner >= 0:
            return self.utility(winner)
        v = float("-inf")
        for action in self.possible_actions(board, player):
            v = max(
                v,
                self.min_v(
                    self.result(deepcopy(board), action, player),
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

    def min_v(self, board, alpha, beta, depth, player):
        winner = self.check_winner(board)
        if depth == 0 or winner >= 0:
            return self.utility(winner)
        v = float("inf")
        for action in self.possible_actions(board, player):
            v = min(
                v,
                self.max_v(
                    self.result(deepcopy(board), action, player),
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

    def minimax(self, player, board):
        if player == 1:
            v = float("-inf")
            best_action = None
            for action in self.possible_actions(board, player):
                new_v = self.min_v(
                    self.result(deepcopy(board), action, player),
                    float("-inf"),
                    float("inf"),
                    self.depth - 1,
                    1 - player,
                )
                if new_v > v or (
                    new_v == v
                    and board[best_action[0][1], best_action[0][0]] == player
                    and board[action[0][1], action[0][0]] != player
                ):
                    v = new_v
                    best_action = action
            return best_action

        elif player == 0:
            v = float("inf")
            best_action = None
            for action in self.possible_actions(board, player):
                new_v = self.max_v(
                    self.result(deepcopy(board), action, player),
                    float("-inf"),
                    float("inf"),
                    self.depth - 1,
                    1 - player,
                )
                if new_v < v or (
                    new_v == v
                    and board[best_action[0][1], best_action[0][0]] == player
                    and board[action[0][1], action[0][0]] != player
                ):
                    v = new_v
                    best_action = action
            return best_action

    def result(self, board, action, player):
        from_pos = action[0]
        move = action[1]
        board = self.take(board, (from_pos[1], from_pos[0]), player)
        board = self.slide(board, (from_pos[1], from_pos[0]), move)
        return board

    def take(self, board, from_pos: tuple[int, int], player_id: int) -> bool:
        """Take piece"""
        # acceptable only if in border
        acceptable: bool = (
            # check if it is in the first row
            (from_pos[0] == 0 and from_pos[1] < 5)
            # check if it is in the last row
            or (from_pos[0] == 4 and from_pos[1] < 5)
            # check if it is in the first column
            or (from_pos[1] == 0 and from_pos[0] < 5)
            # check if it is in the last column
            or (from_pos[1] == 4 and from_pos[0] < 5)
            # and check if the piece can be moved by the current player
        ) and (board[from_pos] < 0 or board[from_pos] == player_id)
        if acceptable:
            board[from_pos] = player_id
        else:
            raise ValueError
        return board

    def slide(self, board, from_pos: tuple[int, int], slide: Move) -> bool:
        """Slide the other pieces"""
        # define the corners
        SIDES = [(0, 0), (0, 4), (4, 0), (4, 4)]
        # if the piece position is not in a corner
        if from_pos not in SIDES:
            # if it is at the TOP, it can be moved down, left or right
            acceptable_top: bool = from_pos[0] == 0 and (
                slide == Move.BOTTOM or slide == Move.LEFT or slide == Move.RIGHT
            )
            # if it is at the BOTTOM, it can be moved up, left or right
            acceptable_bottom: bool = from_pos[0] == 4 and (
                slide == Move.TOP or slide == Move.LEFT or slide == Move.RIGHT
            )
            # if it is on the LEFT, it can be moved up, down or right
            acceptable_left: bool = from_pos[1] == 0 and (
                slide == Move.BOTTOM or slide == Move.TOP or slide == Move.RIGHT
            )
            # if it is on the RIGHT, it can be moved up, down or left
            acceptable_right: bool = from_pos[1] == 4 and (
                slide == Move.BOTTOM or slide == Move.TOP or slide == Move.LEFT
            )
        # if the piece position is in a corner
        else:
            # if it is in the upper left corner, it can be moved to the right and down
            acceptable_top: bool = from_pos == (0, 0) and (
                slide == Move.BOTTOM or slide == Move.RIGHT
            )
            # if it is in the lower left corner, it can be moved to the right and up
            acceptable_left: bool = from_pos == (4, 0) and (
                slide == Move.TOP or slide == Move.RIGHT
            )
            # if it is in the upper right corner, it can be moved to the left and down
            acceptable_right: bool = from_pos == (0, 4) and (
                slide == Move.BOTTOM or slide == Move.LEFT
            )
            # if it is in the lower right corner, it can be moved to the left and up
            acceptable_bottom: bool = from_pos == (4, 4) and (
                slide == Move.TOP or slide == Move.LEFT
            )
        # check if the move is acceptable
        acceptable: bool = (
            acceptable_top or acceptable_bottom or acceptable_left or acceptable_right
        )
        # if it is
        if acceptable:
            # take the piece
            piece = board[from_pos]
            # if the player wants to slide it to the left
            if slide == Move.LEFT:
                # for each column starting from the column of the piece and moving to the left
                for i in range(from_pos[1], 0, -1):
                    # copy the value contained in the same row and the previous column
                    board[(from_pos[0], i)] = board[(from_pos[0], i - 1)]
                # move the piece to the left
                board[(from_pos[0], 0)] = piece
            # if the player wants to slide it to the right
            elif slide == Move.RIGHT:
                # for each column starting from the column of the piece and moving to the right
                for i in range(from_pos[1], board.shape[1] - 1, 1):
                    # copy the value contained in the same row and the following column
                    board[(from_pos[0], i)] = board[(from_pos[0], i + 1)]
                # move the piece to the right
                board[(from_pos[0], board.shape[1] - 1)] = piece
            # if the player wants to slide it upward
            elif slide == Move.TOP:
                # for each row starting from the row of the piece and going upward
                for i in range(from_pos[0], 0, -1):
                    # copy the value contained in the same column and the previous row
                    board[(i, from_pos[1])] = board[(i - 1, from_pos[1])]
                # move the piece up
                board[(0, from_pos[1])] = piece
            # if the player wants to slide it downward
            elif slide == Move.BOTTOM:
                # for each row starting from the row of the piece and going downward
                for i in range(from_pos[0], board.shape[0] - 1, 1):
                    # copy the value contained in the same column and the following row
                    board[(i, from_pos[1])] = board[(i + 1, from_pos[1])]
                # move the piece down
                board[(board.shape[0] - 1, from_pos[1])] = piece
            return board
        else:
            raise ValueError

    def check_winner(self, board) -> int:
        """Check the winner. Returns the player ID of the winner if any, otherwise returns -1"""
        # for each row
        for x in range(board.shape[0]):
            # if a player has completed an entire row
            if board[x, 0] != -1 and all(board[x, :] == board[x, 0]):
                # return the relative id
                return board[x, 0]
        # for each column
        for y in range(board.shape[1]):
            # if a player has completed an entire column
            if board[0, y] != -1 and all(board[:, y] == board[0, y]):
                # return the relative id
                return board[0, y]
        # if a player has completed the principal diagonal
        if board[0, 0] != -1 and all(
            [board[x, x] for x in range(board.shape[0])] == board[0, 0]
        ):
            # return the relative id
            return board[0, 0]
        # if a player has completed the secondary diagonal
        if board[0, -1] != -1 and all(
            [board[x, -(x + 1)] for x in range(board.shape[0])] == board[0, -1]
        ):
            # return the relative id
            return board[0, -1]
        return -1

    def utility(self, winner):
        if winner == 1:
            return 1
        elif winner == 0:
            return -1
        else:
            return 0

    def hash_state(self, board):
        index = 0
        factor = 1

        # Flatten the 5x5 board and convert to decimal
        for row in board:
            for cell in row:
                if cell == 0:
                    i = 1
                elif cell == 1:
                    i = 2
                else:
                    i = 0
                index += factor * i
                factor *= 3

        return index
