import random
import torch.nn as nn
import torch.nn.functional as F
import torch
import numpy as np
from collections import deque


class DQNPolicy(nn.Module):
    def __init__(self, state_space_dim, action_space_dim):
        super(DQNPolicy, self).__init__()
        self.state_space_dim = state_space_dim
        self.action_space_dim = action_space_dim

        self.hidden_layers = 64
        self.fc1 = nn.Linear(state_space_dim, 64)
        self.fc2 = nn.Linear(64, 64)
        self.fc3 = nn.Linear(64, action_space_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        return F.softmax(self.fc3(x), dim=-1)


class DQNAgent:
    def __init__(self, epsilon=0.1, gamma=0.99, lr=0.001, batch_size=64):
        self.model = DQNPolicy
        self.optimizer = torch.optim.Adam(policy.parameters(), lr=lr)
        self.epsilon = epsilon
        self.gamma = gamma
        self.batch_size = batch_size
        self.memory = deque(maxlen=100000)

    def get_action(self, state):
        if np.random.rand() <= self.epsilon:
            return np.random.randint(0, self.model.action_space_dim)
        else:
            state = torch.tensor(state, dtype=torch.float32)
            action_probabilities = self.model(state)
            action = torch.argmax(action_probabilities).item()
            return action, action_probabilities

    def store_outcome(self, state, action, reward, next_state, done):
        self.memory.append((state, action, reward, next_state, done))

    def update(self):
        batch = random.sample(self.memory, self.batch_size)
        batch_state, batch_action, batch_reward, batch_next_state, batch_done = zip(
            *batch
        )

        batch_state = torch.tensor(batch_state, dtype=torch.float32)
        batch_action = torch.tensor(batch_action, dtype=torch.long)
        batch_reward = torch.tensor(batch_reward, dtype=torch.float32)
        batch_next_state = torch.tensor(batch_next_state, dtype=torch.float32)
        batch_done = torch.tensor(batch_done, dtype=torch.float32)

        current_q_values = self.model(batch_state).gather(1, batch_action.unsqueeze(1))
        next_q_values = self.target_model(batch_next_state).max(1)[0].detach()
        target_q_values = batch_reward + (1 - batch_done) * self.gamma * next_q_values

        loss = nn.functional.smooth_l1_loss(
            current_q_values, target_q_values.unsqueeze(1)
        )
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()
