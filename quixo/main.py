from game import Game, Player
from players.sensei import Sensei
from players.random_player import RandomPlayer
from players.minimax_v1_player import MinimaxPlayerV1
from players.minimax_v3_player import MinimaxPlayerV2
from players.minimax_v3_player import MinimaxPlayerV3
from players.minimax_v3_player import MinimaxPlayerV3


def battle(player1: Player, player2: Player, games, print_results=False) -> int:
    count = 0
    for i in range(games):
        g = Game()
        winner = g.play(player1, player2)
        if winner == 0:
            count += 1
        if print_results:
            print(f"Player 0 wins {count} out of {i+1} games", end="\r")
    if print_results:
        print(f"Player 0 wins {count} out of {i+1} games")
    if type(player1) == MinimaxPlayerV3:
        del player1
    return count


if __name__ == "__main__":
    player1 = MinimaxPlayerV3(memory_size=1000000)
    # player1 = MinimaxPlayerV2()
    player2 = RandomPlayer()
    battle(player1, player2, 50, print_results=True)
