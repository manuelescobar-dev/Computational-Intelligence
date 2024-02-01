import torch
import torch.nn.functional as F
from env import Env


class DQNPolicy(torch.nn.Module):
    def __init__(self, state_space: int, action_space: int):
        """Initialize DQN Policy

        Args:
            state_space (int): state space dimensions
            action_space (int): action space dimensions
        """
        super().__init__()
        self.state_space = state_space
        self.action_space = action_space

        # Define network architecture
        self.hidden_layers = 64
        self.fc1 = torch.nn.Linear(state_space, self.hidden_layers)
        self.fc2 = torch.nn.Linear(self.hidden_layers, self.hidden_layers)
        self.fc3 = torch.nn.Linear(self.hidden_layers, action_space)

        # Initialize weights
        self.init_weights()

    def init_weights(self):
        """Initialize weights of the network"""
        for m in self.modules():
            if type(m) is torch.nn.Linear:
                torch.nn.init.normal_(m.weight, 0, 1e-1)
                torch.nn.init.zeros_(m.bias)

    def forward(self, x):
        """Forward pass of the network"""
        x = self.fc1(x)
        x = F.relu(x)
        x = self.fc2(x)
        x = torch.relu(x)
        x = self.fc3(x)
        return F.softmax(x, dim=-1)


class DQNAgent(object):
    def __init__(self, policy):
        # Check for Apple Silicon
        if torch.cuda.is_available():
            self.train_device = torch.device("cuda")
        else:
            self.train_device = torch.device("cpu")

        # Define parameters
        self.policy = policy.to(self.train_device)
        self.optimizer = torch.optim.Adam(policy.parameters(), lr=1e-3)
        self.batch_size = 1
        self.gamma = 0.98
        self.observations = []
        self.actions = []
        self.rewards = []

    def episode_finished(self, episode_number):
        """Update the policy based on the rewards of the episode"""
        all_actions = torch.stack(self.actions, dim=0).to(self.train_device).squeeze(-1)
        all_rewards = torch.stack(self.rewards, dim=0).to(self.train_device).squeeze(-1)

        self.observations, self.actions, self.rewards = [], [], []
        discounted_rewards = self.discount_rewards(all_rewards)
        discounted_rewards -= torch.mean(discounted_rewards)
        if torch.std(discounted_rewards) != 0:
            discounted_rewards /= torch.std(discounted_rewards)

        weighted_probs = all_actions * discounted_rewards
        loss = torch.mean(weighted_probs)
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

    def discount_rewards(self, rewards):
        """Discount rewards using gamma"""
        discounted_rewards = []
        running_reward = 0
        for r in reversed(rewards):
            running_reward = r + self.gamma * running_reward
            discounted_rewards.insert(0, running_reward)
        return torch.tensor(discounted_rewards, dtype=torch.float32).to(
            self.train_device
        )

    def get_action(self, observation, env: Env, evaluation=False):
        """Get action from the policy"""
        x = torch.from_numpy(observation).float().to(self.train_device)
        aprob = self.policy.forward(x)
        valid_probs = aprob * torch.from_numpy(env.get_valid_actions()).to(
            self.train_device
        )
        if evaluation:
            action = torch.argmax(valid_probs).item()
        else:
            dist = torch.distributions.Categorical(valid_probs)
            action = dist.sample().item()
        return action, aprob

    def store_outcome(self, observation, action_output, action_taken, reward):
        """Store the outcome of an action"""
        dist = torch.distributions.Categorical(action_output)
        action_taken = torch.Tensor([action_taken]).to(self.train_device)
        log_action_prob = -dist.log_prob(action_taken)

        self.observations.append(observation)
        self.actions.append(log_action_prob)
        self.rewards.append(torch.Tensor([reward]))
