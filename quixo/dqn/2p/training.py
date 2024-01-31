from model import DQNPolicy, DQNAgent
from env import Env
from tqdm import tqdm
import torch
from benchmarks import battle
from random_player import RandomPlayer
from game import Game, Move, Player
import numpy as np
import matplotlib.pyplot as plt


def self_play(agents, env: Env, max_timesteps=100):
    env.reset()
    observation = env.get_state()
    timesteps = 0

    winner = -1
    while winner < 0 and timesteps < max_timesteps:
        ok = False
        previous_observation = observation
        agent = agents[env.current_player_idx]

        if timesteps > 1 and env.current_player_idx == 1:
            agent.store_outcome(observationO, action_probsO, actionO, 0)
        elif timesteps > 0 and env.current_player_idx == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 0)

        while not ok:
            action, action_probs = agent.get_action(previous_observation, env)
            ok, observation, winner = env.step(action)

        if 1 - env.current_player_idx == 0:
            observationX = observation
            action_probsX = action_probs
            actionX = action
        elif 1 - env.current_player_idx == 1:
            observationO = observation
            action_probsO = action_probs
            actionO = action

        timesteps += 1

    if winner >= 0:
        if winner == 0:
            agents[0].store_outcome(observationX, action_probsX, actionX, 1)
            agents[1].store_outcome(observationO, action_probsO, actionO, -1)
        elif winner == 1:
            agents[0].store_outcome(observationX, action_probsX, actionX, -1)
            agents[1].store_outcome(observationO, action_probsO, actionO, 1)

    return winner


def train(
    num_episodes=1000,
    plot=True,
    step_size=50,
):
    # Plot stuff
    win_history, episodes = [], []

    # Initialize environment, policy and agent
    env = Env()
    state_space_dim = env.state_space_size
    action_space_dim = env.action_space_size
    policyX = DQNPolicy(state_space_dim, action_space_dim)
    agentX = DQNAgent(policyX)
    policyO = DQNPolicy(state_space_dim, action_space_dim)
    agentO = DQNAgent(policyO)
    agents = [agentX, agentO]

    for episode in tqdm(range(num_episodes)):
        winner = self_play(agents, env)
        agentX.episode_finished(episode)
        agentO.episode_finished(episode)

        if plot:
            if (episode + 1) % step_size == 0:
                wins = battle(TestPlayer(agentX), RandomPlayer(), 100)
                win_history.append(wins)
                episodes.append(episode + 1)
                # print("Episode", episode + 1, "wins:", wins)

    # Save the model
    torch.save(policyX.state_dict(), "modelX.ai")
    print("Model X saved to", "modelX.ai")

    torch.save(policyO.state_dict(), "modelO.ai")
    print("Model O saved to", "modelO.ai")

    if plot:
        # Plot
        plt.figure()
        plt.plot(episodes, win_history)
        plt.show()


class TestPlayer(Player):
    def __init__(self, agent) -> None:
        super().__init__()
        self.env = Env()
        self.agent = agent

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


if __name__ == "__main__":
    print("Training started.")
    train(10000)
    print("Training finished.")
