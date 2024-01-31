from players.minimax_v1_player import MinimaxPlayerV1
from copy import deepcopy


class MinimaxPlayerV2(MinimaxPlayerV1):
    def __init__(self, depth=3):
        super().__init__(depth)

    def __str__(self) -> str:
        return "Minimax Player V2"

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
