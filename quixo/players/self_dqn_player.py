from game import Game, Move, Player
import torch
from dqn.self.model import DQNPolicy, DQNAgent
from dqn.self.env import Env
import numpy as np


class DQNPlayer(Player):
    def __init__(self) -> None:
        super().__init__()
        self.env = Env()
        self.policy = DQNPolicy(self.env.state_space_size, self.env.action_space_size)
        self.agent = DQNAgent(self.policy)
        # Save the model
        print("Loading model...")
        state_dict = torch.load(
            "/Users/manuelescobar/Files/2023-2/CI/Computational-Intelligence/quixo/self/model.ai"
        )
        self.policy.load_state_dict(state_dict)

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        self.env.set_env(game)
        # print("Player", self.env.current_player_idx)
        observation = self.env.get_state()
        action, _ = self.agent.get_action(observation, self.env, evaluation=True)
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
        return np.append(state.flatten(), player)
