import itertools
import random


class Minesweeper():
    """
    Minesweeper game representation
    """

    def __init__(self, height=8, width=8, mines=8):

        # Set initial width, height, and number of mines
        self.height = height
        self.width = width
        self.mines = set()

        # Initialize an empty field with no mines
        self.board = []
        for i in range(self.height):
            row = []
            for j in range(self.width):
                row.append(False)
            self.board.append(row)

        # Add mines randomly
        while len(self.mines) != mines:
            i = random.randrange(height)
            j = random.randrange(width)
            if not self.board[i][j]:
                self.mines.add((i, j))
                self.board[i][j] = True

        # At first, player has found no mines
        self.mines_found = set()

    def print(self):
        """
        Prints a text-based representation
        of where mines are located.
        """
        for i in range(self.height):
            print("--" * self.width + "-")
            for j in range(self.width):
                if self.board[i][j]:
                    print("|X", end="")
                else:
                    print("| ", end="")
            print("|")
        print("--" * self.width + "-")

    def is_mine(self, cell):
        i, j = cell
        return self.board[i][j]

    def nearby_mines(self, cell):
        """
        Returns the number of mines that are
        within one row and column of a given cell,
        not including the cell itself.
        """

        # Keep count of nearby mines
        count = 0

        # Loop over all cells within one row and column
        for i in range(cell[0] - 1, cell[0] + 2):
            for j in range(cell[1] - 1, cell[1] + 2):

                # Ignore the cell itself
                if (i, j) == cell:
                    continue

                # Update count if cell in bounds and is mine
                if 0 <= i < self.height and 0 <= j < self.width:
                    if self.board[i][j]:
                        count += 1

        return count

    def won(self):
        """
        Checks if all mines have been flagged.
        """
        return self.mines_found == self.mines


class Sentence():
    """
    Logical statement about a Minesweeper game
    A sentence consists of a set of board cells,
    and a count of the number of those cells which are mines.
    """

    def __init__(self, cells, count):
        self.cells = set(cells)
        self.count = count

    def __eq__(self, other):
        return self.cells == other.cells and self.count == other.count

    def __str__(self):
        return f"{self.cells} = {self.count}"

    def known_mines(self):
        if len(self.cells)==self.count:
            return self.cells

    def known_safes(self):
        if self.count==0:
            return self.cells

    def mark_mine(self, cell):
        if cell in self.cells:
            self.cells.remove(cell)
            self.count = self.count - 1

    def mark_safe(self, cell):
        if cell in self.cells:
            self.cells.remove(cell)


class MinesweeperAI():
    """
    Minesweeper game player
    """

    def __init__(self, height=8, width=8):

        # Set initial height and width
        self.height = height
        self.width = width

        # Keep track of which cells have been clicked on
        self.moves_made = set()

        # Keep track of cells known to be safe or mines
        self.mines = set()
        self.safes = set()

        # List of sentences about the game known to be true
        self.knowledge = []

    def mark_mine(self, cell):
        """
        Marks a cell as a mine, and updates all knowledge
        to mark that cell as a mine as well.
        """
        self.mines.add(cell)
        for sentence in self.knowledge:
            sentence.mark_mine(cell)

    def mark_safe(self, cell):
        """
        Marks a cell as safe, and updates all knowledge
        to mark that cell as safe as well.
        """
        self.safes.add(cell)
        for sentence in self.knowledge:
            sentence.mark_safe(cell)

    def add_knowledge(self, cell, count):
        """
        Called when the Minesweeper board tells us, for a given
        safe cell, how many neighboring cells have mines in them.

        This function should:
            1) mark the cell as a move that has been made
            2) mark the cell as safe
            3) add a new sentence to the AI's knowledge base
               based on the value of `cell` and `count`
            4) mark any additional cells as safe or as mines
               if it can be concluded based on the AI's knowledge base
            5) add any new sentences to the AI's knowledge base
               if they can be inferred from existing knowledge
        """
        self.moves_made.add(cell)
        self.mark_safe(cell)
        cells=set()
        counts=count
        for i in [-1,0,1]:
            if cell[0]+i >=0 and cell[0]+i <self.height:
                for j in [-1,0,1]:
                    if cell[1]+j >=0 and cell[1]+j <self.width:
                        if (i,j) != (0,0):
                            if (cell[0]+i,cell[1]+j) not in self.moves_made:
                                if (cell[0]+i,cell[1]+j) not in self.safes:
                                    if (cell[0]+i,cell[1]+j) not in self.mines:
                                        cells.add((cell[0]+i ,cell[1]+j))
                                    elif (cell[0]+i,cell[1]+j) in self.mines:
                                        counts=counts-1
        if Sentence(cells,counts).known_safes() is not None:
            for i in Sentence(cells,counts).known_safes():
                self.mark_safe(i)
        elif Sentence(cells,counts).known_mines() is not None:
            for i in Sentence(cells,counts).known_mines():
                self.mark_mine(i)
        else:
            self.knowledge.append(Sentence(cells,counts))
        noChanges=True
        while noChanges is True:
            mines=set()
            safes=set()
            for i in self.knowledge:
                if i.known_safes() is not None:
                    safes=i.known_safes()
                    self.knowledge.remove(i)
                    break
                if i.known_mines() is not None:
                    mines=i.known_mines()
                    self.knowledge.remove(i)
                    break
            for i in safes:
                self.mark_safe(i)
            for i in mines:
                self.mark_mine(i)
            if len(safes)==0 and len(mines)==0:
                break      
        for i in self.knowledge:
            for j in self.knowledge:
                if i.cells in j.cells:
                    if Sentence(j.cells.remove(i.cells),j.count-i.count).known_safes() is not None:
                        for h in Sentence(j.cells.remove(i.cells),j.count-i.count).known_safes():
                            self.mark_safe(h)
                    elif Sentence(j.cells.remove(i.cells),j.count-i.count).known_mines() is not None:
                        for h in Sentence(j.cells.remove(i.cells),j.count-i.count).known_mines():
                            self.mark_mine(h)
                    else:
                        self.knowledge.append(Sentence(j.cells.remove(i.cells),j.count-i.count))


    def make_safe_move(self):
        for i in self.safes:
            if i not in self.moves_made:
                return i

    def make_random_move(self):
        moves = []
        for i in range(self.height-1):
            for j in range(self.width-1):
                if (i,j) not in self.mines and (i,j) not in self.moves_made:
                    moves.append((i,j))
        if len(moves)>0:
            return random.choice(moves)
        else:
            return None
