from copy import deepcopy
from game import Game, Move, Player
from collections import OrderedDict
import pickle
import os
from players.minimax_v2_player import MinimaxPlayerV2
import numpy as np


class Storage:
    """Storage class for minimax player v3 cache"""

    def __init__(
        self,
        size: int,
        filename="cache.pickle",
    ) -> None:
        """Initializes the storage class. Loads the cache if it exists.

        Args:
            size (int): Size of the cache in number of entries.
            filename (str, optional): Path to cache file. Defaults to "cache.pickle".
        """
        self.size = size

        # Check if ordered dict already exists
        self.path = filename
        if os.path.exists(self.path):
            # Load cache
            with open(self.path, "rb") as f:
                self.cache = pickle.load(f)
            print("Loaded cache (size: {})".format(len(self.cache)))
        else:
            # Create new cache
            self.cache = OrderedDict()

    def insert(self, board: np.ndarray, value, player: int) -> None:
        """Inserts a value into the cache

        Args:
            board (np.ndarray): Board
            value (_type_): Value of state
            player (int): Player ID
        """
        # Compute index
        index = self.hash_state(board, player)
        # Insert into cache
        self.cache[index] = value
        # Remove oldest entry if cache is full
        if len(self.cache) > self.size:
            self.cache.popitem(last=False)

    def get(self, board: np.ndarray, player: int):
        """Gets a value from the cache

        Args:
            board (np.ndarray): Board
            player (int): Player ID

        Returns:
            Value of state if it exists in the cache, else None
        """
        # Compute index
        index = self.hash_state(board, player)
        # Return value if it exists in the cache
        if index in self.cache:
            return self.cache[index]
        else:
            return None

    def save(self):
        """Saves the cache to disk"""
        with open(self.path, "wb") as f:
            pickle.dump(self.cache, f)
        # print("Saved cache (size: {})".format(len(self.cache)))

    def __del__(self):
        """Destructor. Saves the cache to disk"""
        print("Saved cache (size: {})".format(len(self.cache)))

    def hash_state(self, board: np.ndarray, player: int) -> int:
        """Hashes a board state

        Args:
            board (np.ndarray): Board
            player (int): Player ID

        Returns:
            int: Index of board state in cache
        """
        index = 0
        factor = 1

        # Compute index
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
        # Add player. Two players may have the same board, so we need to add the player to the index.
        index += factor * player

        return index


class MinimaxPlayerV3(MinimaxPlayerV2):
    def __str__(self) -> str:
        return "Minimax Player V3"

    def __init__(self, depth: int = 3, memory_size: int = 100000) -> None:
        """Initializes the minimax player.

        Args:
            depth (int, optional): Depth-limit. Defaults to 3.
            memory_size (int, optional): Memory size in number of entries. Defaults to 100000.
        """
        super().__init__(depth)
        # Initialize cache
        self.storage = Storage(memory_size)

    def max_v(self, board, alpha, beta, depth, player):
        """Max value function"""
        # Check if terminal state
        winner = self.check_winner(board)
        if depth == 0 or winner >= 0:
            return self.utility(winner)
        # Cache hit
        if self.storage.get(board, player) is not None:
            v = self.storage.get(board, player)
            return v
        # Cache miss
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
            # Store value in cache
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
            # Store value in cache
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
        # Store value in cache
        self.storage.insert(board, v, player)
        return best_action
