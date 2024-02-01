# Quixo
Quixo is a two player game.

## Rules
The game is played on a 5x5 board. Each player has 5 pieces, either X or O. The players take turns moving their pieces. A piece can be moved by sliding it in a row or column. The piece can be moved as far as possible in the chosen direction, until it reaches the edge of the board or another piece. The player who moves their pieces to form a line of 5 pieces wins the game.

The file `game.py` contains the implementation of the game.

## Usage
```
python3 main.py
```
The players must be specified in `main.py`.

### MinimaxPlayerV3
The destructor of `MinimaxPlayerV3` must be called to save the cache to disk. It is already implemented in `battle.py`. For example:
```
player = MinimaxV3Player(...)
...
del player
```

### DQNPlayer
- The DQN model are saved in `models/`.
- Training script: `training.py`.
- Model: `model.py`.
- Environment: `env.py`.
  
## Players
- `Sensei` (`sensei.py`): Human player (asks for input).
- `MinimaxPlayerV1` (`minimax_v1_player.py`): Minimax player with alpha-beta pruning and depth-limited search.
- `MinimaxPlayerV2` (`minimax_v2_player.py`): MinimaxV1 + pre-set strategy to prefer empty cells over occupied cells.
- `MinimaxPlayerV3` (`minimax_v3_player.py`): MinimaxV2 + cache.
- `RandomPlayer` (`random_player.py`): Random player.
- `DQNPlayer` (`dqn_player.py`): Deep Q-Network player.

## Performance
The performance analysis is performed on `results.ipynb`. In summary:
- Best player: `minimax_v2_player.py` or `minimax_v3_player.py`.
- Worst player: `random_player.py` and `DQNPlayers`.
