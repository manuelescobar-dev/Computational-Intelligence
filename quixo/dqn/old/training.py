from env import Env
from model import DQNAgent, DQNPolicy


def train(num_episodes=1000):
    env = Env()
    policy = DQNPolicy(env.space_state_size, env.action_space_size)
    agent = DQNAgent()
    for episode in range(num_episodes):
        done = False
        state = env.get_state()
        while not done:
            action = agent.get_action(state)
            next_state, reward, done = env.step(action)

        env.reset()
