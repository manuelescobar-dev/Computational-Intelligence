from copy import deepcopy
from game import Game, Move, Player
from collections import OrderedDict
import pickle
import os
from players.minimax_v2_player import MinimaxPlayerV2


class Storage:
    def __init__(
        self,
        size,
        filename="cache.pickle",
    ) -> None:
        self.size = size
        # Check if ordered dict already exists
        self.path = filename
        self.count = 0
        if os.path.exists(self.path):
            # Step 2: Loading (Deserialization) if the file exists
            with open(self.path, "rb") as f:
                self.cache = pickle.load(f)
            print("Loaded cache (size: {})".format(len(self.cache)))
        else:
            self.cache = OrderedDict()

    def insert(self, board, value, player):
        index = self.hash_state(board, player)
        self.cache[index] = value
        self.count += 1
        if self.count == 1000:
            self.save()
            self.count = 0
        if len(self.cache) > self.size:
            self.cache.popitem(last=False)

    def get(self, board, player):
        index = self.hash_state(board, player)
        if index in self.cache:
            return self.cache[index]
        else:
            return None

    def save(self):
        with open(self.path, "wb") as f:
            pickle.dump(self.cache, f)
        # print("Saved cache (size: {})".format(len(self.cache)))

    def __del__(self):
        print("Saved cache (size: {})".format(len(self.cache)))

    def hash_state(self, board, player):
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
        index += factor * player

        return index


class MinimaxPlayerV3(MinimaxPlayerV2):
    def __str__(self) -> str:
        return "Minimax Player V3"

    def __init__(self, depth=3, memory_size=100000) -> None:
        super().__init__(depth)
        self.storage = Storage(memory_size)

    def max_v(self, board, alpha, beta, depth, player):
        winner = self.check_winner(board)
        if depth == 0 or winner >= 0:
            return self.utility(winner)
        if self.storage.get(board, player) is not None:
            v = self.storage.get(board, player)
            return v
        else:
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
                self.storage.insert(board, v, player)
                alpha = max(alpha, v)
                if alpha >= beta:
                    break
            self.storage.insert(board, v, player)
            return v

    def min_v(self, board, alpha, beta, depth, player):
        winner = self.check_winner(board)
        if depth == 0 or winner >= 0:
            return self.utility(winner)
        # Cache hit
        if self.storage.get(board, player) is not None:
            v = self.storage.get(board, player)
            return v
        # Cache miss
        else:
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
            self.storage.insert(board, v, player)
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
        # self.storage.insert(board, v, player)
        return best_action
