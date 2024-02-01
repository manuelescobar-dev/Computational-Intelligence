from game import Game, Move, Player


class Sensei(Player):
    """A player that takes input from the user"""

    def __init__(self) -> None:
        super().__init__()

    def make_move(self, game: "Game") -> tuple[tuple[int, int], Move]:
        """Makes a move based on user input"""
        print("Current board:")
        game.print()
        x = input("x: ")
        y = input("y: ")
        from_pos = (int(x), int(y))
        move = input("move (top, bottom, left, right): ")
        if move == "top":
            move = Move.TOP
        elif move == "bottom":
            move = Move.BOTTOM
        elif move == "left":
            move = Move.LEFT
        elif move == "right":
            move = Move.RIGHT
        return from_pos, move
