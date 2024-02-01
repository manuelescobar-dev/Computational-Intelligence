from game import Player, Move, Game
from players.minimax_v3_player import MinimaxPlayerV3


def battle(player1: Player, player2: Player, games: int, print_results=False) -> tuple:
    """Battle arena for two players

    Args:
        player1 (Player): Player X
        player2 (Player): Player O
        games (int): Number of games to play
        print_results (bool, optional): Defaults to False.

    Returns:
        tuple: (win, loss, draw)
    """
    win, loss, draw = 0, 0, 0
    for i in range(games):
        g = Game()
        winner = g.play(player1, player2)
        if winner == 0:
            win += 1
        elif winner == 1:
            loss += 1
        elif winner == -1:
            draw += 1
        if print_results:
            print(f"Player 0 wins {win} out of {i+1} games", end="\r")
    if print_results:
        print(f"Player 0 wins {win} out of {i+1} games")
    if type(player1) == MinimaxPlayerV3:
        del player1
    return win, loss, draw
