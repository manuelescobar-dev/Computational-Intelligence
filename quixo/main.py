from game import Game, Player
from players.sensei import Sensei
from players.random_player import RandomPlayer
from players.minimax_v1_player import MinimaxPlayerV1
from players.minimax_v3_player import MinimaxPlayerV2
from players.minimax_v3_player import MinimaxPlayerV3
from battle import battle

if __name__ == "__main__":
    player1 = MinimaxPlayerV3(memory_size=1000000)
    # player1 = MinimaxPlayerV2()
    player2 = RandomPlayer()
    battle(player1, player2, 100, print_results=True)
