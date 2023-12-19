# LAB10

Interactive Interface for Tic-Tac-Toe using MinMax Adversarial Search and Reinforcement Learning.

## Description
This lab uses reinforcement learning and adversarial search to devise a tic-tac-toe player. The initial implementation is based on the tic-tac-toe implementation I did for Harvard's CS50’s Introduction to Artificial Intelligence with Python, which uses MinMax Adversarial Search. This course is available on [edX](https://www.edx.org/course/cs50s-introduction-to-artificial-intelligence-with-python) and I highly recommend it, as it provides a great introduction to AI and a free certificate. Some other resources from the course are contained in the `previous_work` folder of this repository, including Reinforcement Learning projects, which can be interesting for this course.

## Structure
- `minmax`: Contains improvements for a tic-tac-toe implementation I did for Harvard's CS50’s Introduction to Artificial Intelligence with Python, using MinMax Adversarial Search. Some improvements include caching.
- `qlearning`: Contains the tic-tac-toe implementation using Reinforcement Learning.
- `runner`: Contains the code to run the game using pygame.
- `lab10`: Contains the code to train the Q-learning agent and compares the different agents.

## Usage
1. Install the requirements: `pip install -r scripts/requirements.txt`
2. Run without flag to play against the MinMax agent: `python runner.py`
3. Run with flag -q to play against the Q-learning agent: `python runner.py -q`

## Results
The MinMax agent performs significantly better for this case.

## Future Work
- Test different hyperparameters for the Q-learning agent.
- Test different reward functions for the Q-learning agent.
- Test different reinforcement learning algorithms.