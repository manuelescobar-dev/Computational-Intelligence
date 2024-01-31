from model import DQNPolicy, DQNAgent
from env import Env
from tqdm import tqdm
import torch


def play_game(agent: DQNAgent, env: Env, max_timesteps=50):
    env.reset()
    observation = env.get_state()
    done = False
    timesteps = 0

    while not done and timesteps < max_timesteps:
        ok = False
        previous_observation = observation
        while not ok:
            action, action_probs = agent.get_action(previous_observation, env)
            ok, observation, reward, done = env.step(action)

        agent.store_outcome(previous_observation, action_probs, action, reward)
        timesteps += 1

    return env.check_winner()


def train(num_episodes=1000, opponent="random"):
    # Initialize environment, policy and agent
    env = Env()
    policy = DQNPolicy(env.state_space_size, env.action_space_size)
    agent = DQNAgent(policy)

    for episode in tqdm(range(num_episodes)):
        winner = play_game(agent, env)
        agent.episode_finished(episode)

        """ if (episode + 1) % 100 == 0:
            print(f"Episode {episode + 1}/{num_episodes}, Winner: {winner}") """

    # Save the model
    model_file = "model.ai"
    torch.save(policy.state_dict(), model_file)
    print("Model saved to", model_file)


if __name__ == "__main__":
    print("Training started.")
    train(100000)
    print("Training finished.")
