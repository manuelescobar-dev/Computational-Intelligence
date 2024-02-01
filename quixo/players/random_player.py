import random
from game import Game, Move, Player


class RandomPlayer(Player):
    """Random Player"""

    def __init__(self, seed=0) -> None:
        """Initializes the random player

        Args:
            seed (int, optional): Random seed. Defaults to 0.
        """
        super().__init__()
        random.seed(seed)

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        """Makes a random move"""
        # Choose a random move
        from_pos = (random.randint(0, 4), random.randint(0, 4))
        move = random.choice([Move.TOP, Move.BOTTOM, Move.LEFT, Move.RIGHT])
        return from_pos, move

    def __str__(self) -> str:
        return "Random Player"

    def __repr__(self) -> str:
        return "Random Player"
