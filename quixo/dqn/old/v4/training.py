from copy import deepcopy
from time import sleep
import torch
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from tqdm import tqdm
from env import Env
from model import Agent, Policy


# Policy training function
def train(train_episodes, silent=True, max_timesteps=50):
    env = Env()

    # Get dimensions of the state and action spaces
    state_space_dim = env.space_state_size
    action_space_dim = env.action_space_size

    # Instantiate agent and its policy
    policy = Policy(state_space_dim, action_space_dim)
    agent = Agent(policy)

    # Print some stuff
    print("State space dimensions:", state_space_dim)
    print("Action space dimensions:", action_space_dim)

    # Arrays to keep track of rewards
    reward_history, timestep_history = [], []
    average_reward_history = []

    # Run actual training
    for episode_number in tqdm(range(train_episodes)):
        reward_sum, timesteps = 0, 0
        winner = -1

        # Reset the environment and observe the initial state (it's a random initial state with small values)
        env.reset()

        a = True
        # Loop until the game is over
        while winner < 0 and timesteps < max_timesteps:
            env.current_player_idx = 1 - env.current_player_idx
            ok = False

            previous_env = env.get_state()

            while not ok:
                action, action_probabilities = agent.get_action(previous_env)
                ok, winner = env.step(action)
            if winner >= 0 and (
                (a and winner == env.current_player_idx)
                or (not a and winner != env.current_player_idx)
            ):
                agent.store_reward(1, "A")
                agent.store_reward(-1, "B")
            elif winner >= 0 and (
                (a and winner != env.current_player_idx)
                or (not a and winner == env.current_player_idx)
            ):
                agent.store_reward(1, "B")
                agent.store_reward(-1, "A")
            elif a and timesteps > 0:
                agent.store_reward(0, "B")
            elif not a and timesteps > 0:
                agent.store_reward(0, "A")

            if a:
                agent.store_outcome(previous_env, action_probabilities, action, "A")
                a = False
            else:
                agent.store_outcome(previous_env, action_probabilities, action, "B")
                a = True

            """ # Store total episode reward
            if env.current_player_idx == 0:
                reward_sum += reward_X
            else:
                reward_sum += reward_O """
            timesteps += 1

        if not silent:
            print(
                "Episode {} finished. Total reward: {:.3g} ({} timesteps)".format(
                    episode_number, reward_sum, timesteps
                )
            )

        """ # Bookkeeping (mainly for generating plots)
        reward_history.append(reward_sum)
        timestep_history.append(timesteps)
        if episode_number > 100:
            avg = np.mean(reward_history[-100:])
        else:
            avg = np.mean(reward_history)
        average_reward_history.append(avg) """
        agent.episode_finished(episode_number * 2, "A")
        agent.episode_finished(episode_number * 2 + 1, "B")

    # Store the data in a Pandas dataframe for easy visualization
    data = pd.DataFrame(
        {
            "episode": np.arange(len(reward_history)),
            "reward": reward_history,
            "mean_reward": average_reward_history,
        }
    )

    # Save the model
    model_file = "%s_params.ai"
    torch.save(policy.state_dict(), model_file)
    print("Model saved to", model_file)

    # Plot rewards
    sns.lineplot(x="episode", y="reward", data=data, color="blue", label="Reward")
    sns.lineplot(
        x="episode",
        y="mean_reward",
        data=data,
        color="orange",
        label="100-episode average",
    )
    plt.legend()
    plt.title("Reward history (%s)")
    plt.show()
    print("Training finished.")
    return data


# Entry point of the script
if __name__ == "__main__":
    train_episodes = 100
    train(train_episodes)
