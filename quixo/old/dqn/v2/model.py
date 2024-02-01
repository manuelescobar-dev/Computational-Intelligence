import torch.nn.functional as F
import torch
import numpy as np


class Policy(torch.nn.Module):
    def __init__(self, state_space, action_space):
        super().__init__()
        # Spaces
        self.state_space = state_space
        self.action_space = action_space

        # Parameters
        self.first_layer = 64
        self.second_layer = 64

        # Layers
        self.f1 = torch.nn.Linear(self.state_space, self.first_layer)
        self.f2 = torch.nn.Linear(self.first_layer, self.second_layer)
        self.f3 = torch.nn.Linear(self.first_layer, self.action_space)
        self.init_weights()

    def init_weights(self):
        for m in self.modules():
            if type(m) is torch.nn.Linear:
                torch.nn.init.normal_(m.weight, 0, 1e-1)
                torch.nn.init.zeros_(m.bias)

    def forward(self, x):
        x = self.f1(x)
        x = F.relu(x)
        x = self.f2(x)
        x = F.relu(x)
        x = self.f3(x)
        x = F.softmax(x, dim=-1)
        return x


class Agent(object):
    def __init__(self, policy):
        self.train_device = "cuda" if torch.cuda.is_available() else "cpu"
        self.policy = policy.to(self.train_device)
        self.optimizer = torch.optim.Adam(policy.parameters(), lr=1e-2)
        self.batch_size = 1
        self.gamma = 0.98
        # self.gamma = 1
        self.observationsA = []
        self.actionsA = []
        self.rewardsA = []
        self.observationsB = []
        self.actionsB = []
        self.rewardsB = []
        torch.autograd.set_detect_anomaly(True)

    def episode_finished(self, episode_number, player):
        actions = self.actionsA if player == "A" else self.actionsB
        rewards = self.rewardsA if player == "A" else self.rewardsB
        all_actions = torch.stack(actions, dim=0).to(self.train_device).squeeze(-1)
        all_rewards = torch.stack(rewards, dim=0).to(self.train_device).squeeze(-1)
        if player == "A":
            self.observationsA, self.actionsA, self.rewardsA = [], [], []
        else:
            self.observationsB, self.actionsB, self.rewardsB = [], [], []
        discounted_rewards = discount_rewards(all_rewards, self.gamma)
        discounted_rewards = discounted_rewards - torch.mean(discounted_rewards)
        discounted_rewards = discounted_rewards / torch.std(discounted_rewards)

        # element-wise multiplication, such that for each action we have -ln(outputnetwork)*disc_reward_normalized
        weighted_probs = all_actions * discounted_rewards

        # print('all_actions:', all_actions)
        # print('discounted rewards:', discounted_rewards)
        # print('weighted probs:', weighted_probs)
        # sys.exit()

        # You want to perform gradient descent on the average loss, so to decrease the overall mean loss
        # => less probability for actions that led to below average rewards,
        # and more probability for actions that led to above average rewards.
        loss = torch.mean(weighted_probs)
        loss.backward()

        if (episode_number + 1) % self.batch_size == 0:
            self.update_policy()

    def update_policy(self):
        self.optimizer.step()
        self.optimizer.zero_grad()

    def get_action(self, observation, evaluation=False):
        """
        Returns an action, given an observation of the environment.
        """
        x = torch.from_numpy(observation).float().to(self.train_device)
        aprob = self.policy.forward(x)
        if evaluation:
            action = torch.argmax(aprob).item()
        else:
            dist = torch.distributions.Categorical(aprob)
            action = dist.sample().item()
        return action, aprob

    def store_outcome(self, observation, action_output, action_taken, player):
        dist = torch.distributions.Categorical(action_output)
        action_taken = torch.Tensor([action_taken]).to(self.train_device)
        log_action_prob = -dist.log_prob(action_taken)  # -ln(networkoutput)

        if player == "A":
            self.observationsA.append(observation)
            self.actionsA.append(log_action_prob)
        else:
            self.observationsB.append(observation)
            self.actionsB.append(log_action_prob)

    def store_reward(self, reward, player):
        if player == "A":
            self.rewardsA.append(torch.Tensor([reward]))
        else:
            self.rewardsB.append(torch.Tensor([reward]))


def discount_rewards(r, gamma):
    discounted_r = torch.zeros_like(r)
    running_add = 0
    for t in reversed(range(0, r.size(-1))):
        running_add = running_add * gamma + r[t]
        discounted_r[t] = running_add
    return discounted_r
