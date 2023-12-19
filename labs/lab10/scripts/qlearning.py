import numpy as np
from matplotlib import pyplot as plt
from scripts.tictactoe import *
import random

np.random.seed(123)


def get_action(board, q_values, epsilon, test=False):
    """
    Given a state, return an action according to the q_grid, using epsilon-greedy exploration strategy.
    """
    state = state_to_index(board)
    moves = actions(board)

    if test:  # TEST -> greedy policy
        idx = np.argmax(
            q_values[state, moves[:, 0], moves[:, 1]]
        )  # greedy w.r.t. q_grid
        action_chosen = moves[idx, :]

    else:  # TRAINING -> epsilon-greedy policy
        if np.random.rand() < epsilon:
            # Random action
            idx = random.randint(0, moves.shape[0] - 1)
            action_chosen = moves[
                idx, :
            ]  # choose random action with equal probability among all actions

        else:
            # Greedy action
            idx = np.argmax(
                q_values[state, moves[:, 0], moves[:, 1]]
            )  # greedy w.r.t. q_grid
            action_chosen = moves[idx, :]

    return action_chosen


def update_q_value(
    old_state, action, new_state, reward, done, q_array, gamma=0.98, alpha=0.1
):
    old_index = state_to_index(old_state)
    new_index = state_to_index(new_state)

    # Target value used for updating our current Q-function estimate at Q(old_state, action)
    if done:
        target_value = reward  # If the episode is finished, the target value is simply the current reward.
    else:
        max_q_value_new_state = np.max(q_array[new_index, action[0], action[1]])
        target_value = reward + gamma * max_q_value_new_state  # Q-learning update rule

    current_q = q_array[old_index, action[0], action[1]]

    # Update Q value
    q_array[old_index, action[0], action[1]] = current_q + alpha * (
        target_value - current_q
    )

    return


# NOT USED
def action_to_index(action):
    index = action[0] + action[1] * 3

    return index


# NOT USED
def index_to_action(index):
    action = (index % 3, index // 3)

    return action


def reward(board, player):
    """
    Returns the reward for the current board.
    """
    if winner(board) == player:
        return 1
    elif winner(board) is None:
        return 0
    else:
        return -1


def train(
    episodes,
    gamma=0.98,
    alpha=0.1,
    constant_eps=0.2,
    GLIE=True,
    plot=True,
    filename="q_values.npy",
    final_GLIE_eps=0.1,
    initial_q_value=0,
    opponent=random_opponent,
):
    # Initialize Q-value array. 19683 possible states, 9 possible actions
    if initial_q_value != 0:
        q_grid = np.full(
            (19683, 3, 3),
            initial_q_value,
            dtype=np.float64,
        )
    else:
        q_grid = np.zeros((19683, 3, 3), dtype=np.float64)

    # Training loop
    ep_rewards, ep_avg_reward = [], []

    # Define epsilon
    if GLIE:
        b = int((final_GLIE_eps * episodes) / (1 - final_GLIE_eps))

    # Define initial plot
    plot_step = episodes // 100

    for ep in range(episodes):
        # Reset Environment for new episode
        player, done, acc_reward = np.random.choice([X, O]), False, 0

        if player == X:
            board = initial_state()
        else:
            board = opponent(initial_state())

        if GLIE:
            epsilon = b / (b + ep)  # GLIE schedule
        else:
            epsilon = constant_eps  # constant epsilon

        # Training loop for one episode
        while not done:
            action = get_action(board, q_grid, epsilon)  # get action
            new_board = result(board, action)  # perform action
            done = terminal(new_board)
            if not done:
                new_board = opponent(new_board)  # opponent plays
                done = terminal(new_board)

            r = reward(new_board, player)  # get reward
            acc_reward += r  # accumulate reward

            # Update Q-value
            update_q_value(board, action, new_board, r, done, q_grid, gamma, alpha)

            # Update state
            board = new_board

        # Print results at end of episode
        ep_rewards.append(acc_reward)
        if ep % (plot_step) == 0:
            avg = np.mean(ep_rewards)
            ep_avg_reward.append(avg)
            print("Episode {}, average reward: {:.2f}".format(ep, avg))
            ep_rewards = []
            print("Epsilon:", epsilon)

    if plot:
        plt.figure()
        plt.grid()
        plt.xlabel("Episodes [x100]")
        plt.ylabel("Accumulated reward")
        plt.title("Q-learning")
        plt.plot(ep_avg_reward, "b")
        plt.show()

    # Save the Q-value array
    print("Saving Q-values to file...")
    np.save(filename, q_grid)


def play(board, filename="scripts/q_values.npy"):
    q_grid = np.load(filename)
    action = get_action(board, q_grid, 0, test=True)
    return action
