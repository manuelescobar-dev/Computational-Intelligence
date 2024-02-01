import random
from model import DQNPolicy, DQNAgent
from env import Env
from tqdm import tqdm
import torch
from battle import battle
from players.random_player import RandomPlayer
from game import Game, Move, Player
import numpy as np
import matplotlib.pyplot as plt


def self_play(agents, env: Env, max_timesteps: int = 100) -> int:
    """Play a game against itself (both players are the same agent)

    Args:
        agent (_type_): DQNAgent
        env (Env): Env
        max_timesteps (int, optional): Maximum timesteps until game is over. Defaults to 100.

    Returns:
        int: winner
    """
    # Reset the environment
    env.reset()
    agent = agents[0]

    # Get the initial observation
    observation = env.get_state()

    # Initialize the timesteps
    timesteps = 0

    # Initialize the winner
    winner = -1

    # Play the game until a winner is found or the max timesteps are reached
    while winner < 0 and timesteps < max_timesteps:
        # Initialize the flag for a valid action
        ok = False

        # Save the previous observation
        previous_observation = observation

        # Store the outcome of the previous O action with reward 0 as the game is not finished yet
        if timesteps > 1 and env.current_player_idx == 1:
            agent.store_outcome(observationO, action_probsO, actionO, 0)
        # Store the outcome of the previous X action with reward 0 as the game is not finished yet
        elif timesteps > 0 and env.current_player_idx == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 0)

        # Get the action and the action probabilities from the agent
        while not ok:
            action, action_probs = agent.get_action(previous_observation, env)
            ok, observation, winner = env.step(action)

        # Store the outcome of the previous action
        if 1 - env.current_player_idx == 0:
            observationX = observation
            action_probsX = action_probs
            actionX = action
        elif 1 - env.current_player_idx == 1:
            observationO = observation
            action_probsO = action_probs
            actionO = action

        timesteps += 1

    # Store the outcome of the last action. If max timesteps are reached, the reward is 0
    if winner >= 0:
        if winner == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 1)
            agent.store_outcome(observationO, action_probsO, actionO, -1)
        elif winner == 1:
            agent.store_outcome(observationX, action_probsX, actionX, -1)
            agent.store_outcome(observationO, action_probsO, actionO, 1)

    return winner


def multi(agents: list, env: Env, max_timesteps: int = 100) -> int:
    """Play a game against multiple agents

    Args:
        agents (_type_): The first agent is the final model, the others are the opponents.
        env (Env): Env
        max_timesteps (int, optional): Maximum timesteps until game is over. Defaults to 100.

    Returns:
        int: winner
    """
    # Reset the environment
    env.reset()
    agent = agents[0]

    # Get the initial observation
    observation = env.get_state()

    # Initialize the timesteps
    timesteps = 0

    # Initialize the winner
    winner = -1

    # Play the game until a winner is found or the max timesteps are reached
    while winner < 0 and timesteps < max_timesteps:
        # Initialize the flag for a valid action
        ok = False

        # Randomly choose an opponent
        opponent = np.random.choice(agents[1:])

        # Save the previous observation
        previous_observation = observation

        # Store the outcome of the previous X action with reward 0 as the game is not finished yet
        if timesteps > 0 and env.current_player_idx == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 0)

        while not ok:
            # Get the action and the action probabilities from the agent
            if env.current_player_idx == 0:
                # DQN plays
                action, action_probs = agent.get_action(previous_observation, env)
            else:
                # Opponent plays
                if type(opponent) == DQNAgent:
                    action, action_probs = opponent.get_action(
                        previous_observation, env, evaluation=True
                    )
                else:
                    if type(opponent) == RandomPlayer:
                        action = random.randint(0, env.action_space_size - 1)
                    else:
                        action = opponent.make_move(env.get_game())
                        action = env.get_index_from_action(action)
            ok, observation, winner = env.step(action)

        # Store the outcome of the previous action
        if 1 - env.current_player_idx == 0:
            observationX = observation
            action_probsX = action_probs
            actionX = action

        timesteps += 1

    # Store the outcome of the last action. If max timesteps are reached, the reward is 0
    if winner >= 0:
        if winner == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 1)
        elif winner == 1:
            agent.store_outcome(observationX, action_probsX, actionX, -1)

    return winner


def two_agent_play(agents, env: Env, max_timesteps: int = 100) -> int:
    """Play a game against two agents (one agent plays X, the other plays O)

    Args:
        agents (_type_): DQNAgent
        env (Env): Env
        max_timesteps (int, optional): Maximum timesteps until game is over. Defaults to 100.

    Returns:
        int: winner
    """
    # Reset the environment
    env.reset()
    # Get the initial observation
    observation = env.get_state()
    # Initialize the timesteps
    timesteps = 0

    # Initialize the winner
    winner = -1

    # Play the game until a winner is found or the max timesteps are reached
    while winner < 0 and timesteps < max_timesteps:
        # Initialize the flag for a valid action
        ok = False
        # Save the previous observation
        previous_observation = observation

        # Get the current agent
        agent = agents[env.current_player_idx]

        # Store the outcome of the previous O action with reward 0 as the game is not finished yet
        if timesteps > 1 and env.current_player_idx == 1:
            agent.store_outcome(observationO, action_probsO, actionO, 0)
        # Store the outcome of the previous X action with reward 0 as the game is not finished yet
        elif timesteps > 0 and env.current_player_idx == 0:
            agent.store_outcome(observationX, action_probsX, actionX, 0)

        # Get the action and the action probabilities from the agent
        while not ok:
            action, action_probs = agent.get_action(previous_observation, env)
            ok, observation, winner = env.step(action)

        # Store the outcome of the previous action
        if 1 - env.current_player_idx == 0:
            observationX = observation
            action_probsX = action_probs
            actionX = action
        elif 1 - env.current_player_idx == 1:
            observationO = observation
            action_probsO = action_probs
            actionO = action

        timesteps += 1

    # Store the outcome of the last action. If max timesteps are reached, the reward is 0
    if winner >= 0:
        if winner == 0:
            agents[0].store_outcome(observationX, action_probsX, actionX, 1)
            agents[1].store_outcome(observationO, action_probsO, actionO, -1)
        elif winner == 1:
            agents[0].store_outcome(observationX, action_probsX, actionX, -1)
            agents[1].store_outcome(observationO, action_probsO, actionO, 1)

    return winner


def train(
    num_episodes: int = 1000,
    plot: bool = True,
    step_size: int = 50,
    type: str = "self",
    opponents: list = [RandomPlayer()],
    validation_games: int = 100,
    validation_opponent=RandomPlayer(),
    path: str = "",
) -> None:
    """Train the DQN agent

    Args:
        num_episodes (int, optional): Number of training episodes. Defaults to 1000.
        plot (bool, optional): Plot validation. Defaults to True.
        step_size (int, optional): For plot. Defaults to 50.
        type (str, optional): ["self","two"]. Defaults to "self".
        validation_games (int, optional): Number of validation games. Defaults to 100.
        validation_opponent (_type_, optional): Opponent for validation. Defaults to RandomPlayer().
    """
    # Plot stuff
    win_history, episodes = [], []

    # Initialize environment, policy and agent
    env = Env()
    action_space_dim = env.action_space_size
    if type == "self":
        print("Agent: self")
        # It has to record the current player
        state_space_dim = 3 * 5 * 5 + 1
        policy = DQNPolicy(state_space_dim, action_space_dim)
        agent = DQNAgent(policy)
        agents = [agent]
        play = self_play
    elif type == "two":
        print("Agent: two")
        state_space_dim = 3 * 5 * 5
        policyX = DQNPolicy(state_space_dim, action_space_dim)
        agentX = DQNAgent(policyX)
        policyO = DQNPolicy(state_space_dim, action_space_dim)
        agentO = DQNAgent(policyO)
        agents = [agentX, agentO]
        play = two_agent_play
    elif type == "multi":
        print("Agent: multi")
        # It has to record the current player
        state_space_dim = 3 * 5 * 5
        policy = DQNPolicy(state_space_dim, action_space_dim)
        agent = DQNAgent(policy)
        agents = [agent]
        agents.extend(opponents)
        play = multi
    env.state_space_size = state_space_dim

    for episode in tqdm(range(num_episodes)):
        winner = play(agents, env)

        if type != "multi":
            # Update the agent
            for agent in agents:
                agent.episode_finished(episode)
        else:
            agents[0].episode_finished(episode)

        # Plot stuff
        if plot:
            if (episode + 1) % step_size == 0:
                wins = []
                if type != "multi":
                    for i in agents:
                        count = battle(
                            TestPlayer(i), validation_opponent, validation_games
                        )
                        wins.append(count)
                else:
                    count = battle(
                        TestPlayer(agents[0]), validation_opponent, validation_games
                    )
                    wins.append(count)
                win_history.append(wins)
                episodes.append(episode + 1)

    if type != "multi":
        # Save the model
        for i, agent in enumerate(agents):
            model_file = path + f"/models/model_{type}_" + str(i) + ".ai"
            torch.save(agent.policy.state_dict(), model_file)
            print("Model saved to", model_file)
    else:
        model_file = path + f"/models/model_{type}.ai"
        torch.save(agents[0].policy.state_dict(), model_file)
        print("Model saved to", model_file)

    # Plot stuff
    if plot:
        plt.figure()
        plt.plot(episodes, win_history)
        plt.legend(["Player 1", "Player 2"])
        plt.grid()
        plt.xlabel("Episodes")
        plt.ylabel("Wins")
        plt.title("Training Results")
        plt.show()


class TestPlayer(Player):
    def __init__(self, agent) -> None:
        super().__init__()
        self.env = Env(agent.policy.state_space)
        self.agent = agent

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        self.env.set_env(game)
        observation = self.env.get_state()
        action, _ = self.agent.get_action(observation, self.env, evaluation=True)
        from_pos = self.env.action_space[action][0]
        slide = self.env.action_space[action][1]
        return from_pos, slide


""" if __name__ == "__main__":
    print("Training started.")
    train(10000)
    print("Training finished.") """
