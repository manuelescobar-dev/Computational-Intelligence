from game import Game, Move, Player
import torch
from model import DQNPolicy, DQNAgent
from env import Env
import numpy as np


class DQNPlayer(Player):
    def __init__(self, player="X", filename="/models") -> None:
        super().__init__()
        # Initialize environment, policy and agent
        self.player = player
        if player == "X":
            self.state_space = 75
        elif player == "O":
            self.state_space = 75
        elif player == "self":
            self.state_space = 76
        elif player == "multi":
            self.state_space = 75
        self.env = Env(state_space_size=self.state_space)
        self.policy = DQNPolicy(self.env.state_space_size, self.env.action_space_size)
        self.agent = DQNAgent(self.policy)

        # Load the model
        print("Loading model...")
        state_dict = torch.load(filename + "/model_" + player + ".ai")
        self.policy.load_state_dict(state_dict)

    def __str__(self) -> str:
        return "DQN Player_" + self.player

    def __repr__(self) -> str:
        return "DQN Player_" + self.player

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        self.env.set_env(game)
        observation = self.env.get_state()
        action, _ = self.agent.get_action(observation, self.env, evaluation=False)
        from_pos = self.env.action_space[action][0]
        slide = self.env.action_space[action][1]
        return from_pos, slide

    def get_state(self, game: "Game"):
        state = np.zeros((3, 5, 5))
        board = game.get_board()
        player = game.current_player_idx
        for i in range(5):
            for j in range(5):
                cell = board[i][j]
                if cell == 0:
                    state[0, i, j] = 1
                elif cell == 1:
                    state[1, i, j] = 1
                elif cell == -1:
                    state[2, i, j] = 1
        if self.state_space == 75:
            return state.flatten()
        elif self.state_space == 76:
            state = np.append(state.flatten(), player)
