import torch
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from tqdm import tqdm
from env import Env
from model import Agent, Policy


# Policy training function
def train(train_episodes, silent=True, max_timesteps=1000):
    env = Env()

    # Get dimensions of the state and action spaces
    state_space_dim = env.space_state_size
    action_space_dim = env.action_space_size

    # Instantiate agent and its policy
    policy_X = Policy(state_space=state_space_dim, action_space=action_space_dim)
    agent_X = Agent(policy_X)
    policy_O = Policy(state_space=state_space_dim, action_space=action_space_dim)
    agent_O = Agent(policy_O)
    players = [agent_X, agent_O]

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
        reward_X, reward_O = None, None
        previous_env_X, previous_env_O = None, None

        # Reset the environment and observe the initial state (it's a random initial state with small values)
        env.reset()

        # Loop until the game is over
        while winner < 0 and timesteps < max_timesteps:
            env.current_player_idx = 1 - env.current_player_idx
            ok = False

            agent = players[env.current_player_idx]

            if env.current_player_idx == 0:
                if previous_env_X is not None:
                    if reward_X is not None:
                        # Store action's outcome (so that the agent can improve its policy)
                        agent.store_outcome(
                            previous_env_X, action_probabilities_X, action_X, reward_O
                        )
                    else:
                        # Store action's outcome (so that the agent can improve its policy)
                        agent.store_outcome(
                            previous_env_X, action_probabilities_X, action_X, 0
                        )

                previous_env_X = env.get_state()

                while not ok:
                    action_X, action_probabilities_X = agent.get_action(previous_env_X)
                    ok, reward_X, winner = env.step(action_X)
            else:
                if previous_env_O is not None:
                    if reward_O is not None:
                        # Store action's outcome (so that the agent can improve its policy)
                        agent.store_outcome(
                            previous_env_O, action_probabilities_O, action_O, reward_X
                        )
                    else:
                        # Store action's outcome (so that the agent can improve its policy)
                        agent.store_outcome(
                            previous_env_O, action_probabilities_O, action_O, 0
                        )

                previous_env_O = env.get_state()

                while not ok:
                    action_O, action_probabilities_O = agent.get_action(previous_env_O)
                    ok, reward_O, winner = env.step(action_O)

            # Store total episode reward
            if env.current_player_idx == 0:
                reward_sum += reward_X
            else:
                reward_sum += reward_O
            timesteps += 1

        if not silent:
            print(
                "Episode {} finished. Total reward: {:.3g} ({} timesteps)".format(
                    episode_number, reward_sum, timesteps
                )
            )

        # Bookkeeping (mainly for generating plots)
        reward_history.append(reward_sum)
        timestep_history.append(timesteps)
        if episode_number > 100:
            avg = np.mean(reward_history[-100:])
        else:
            avg = np.mean(reward_history)
        average_reward_history.append(avg)

        if winner == 0:
            agent.store_outcome(previous_env_X, action_probabilities_X, action_X, -1)
        elif winner == 1:
            agent.store_outcome(previous_env_O, action_probabilities_O, action_O, -1)
        # Let the agent do its magic (update the policy)
        for agent in players:
            agent.episode_finished(episode_number)

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
    train_episodes = 1000
    train(train_episodes)
