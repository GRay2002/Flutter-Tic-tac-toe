import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  //make a 2D list to represent the board (kinda like a matrix of 3x3 but better)
  //List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  //after analyzing the code
  List<List<String>> board = List<List<String>>.generate(
    3,
    (int index) => List<String>.filled(3, ''),
    growable: false,
  );

  //to keep track of whose turn it is
  bool isPlayer1Turn = true;
  int moves = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Make app bar purple
        backgroundColor: Colors.purple,
        //Make the title centered
        title: const Text('Tic Tac Toe',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isPlayer1Turn ? 'Player 1 (X)' : 'Player 2 (O)',
              style: TextStyle(fontSize: 28, color: Colors.purple[900], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
              //build the board using the 2D list we made earlier, and make each cell clickable.
              //The onTap function is called when the cell is clicked
              itemBuilder: (BuildContext context, int index) {
                //convert the index to row and column
                final int row = index ~/ 3;
                final int col = index % 3;
                return GestureDetector(
                  onTap: () {
                    if (board[row][col] == '' && moves < 9) {
                      setState(() {
                        board[row][col] = isPlayer1Turn ? 'X' : 'O';
                        isPlayer1Turn = !isPlayer1Turn;
                        moves++;

                        // Check for a winner
                        if (_checkWinner(row, col)) {
                          // after the move is made, check if there is a winner. If so call the winner dialog
                          _showWinnerDialog();
                        } else if (moves == 9) {
                          //if the board is full and there is no winner, it's a draw so we call the draw dialog
                          _showDrawDialog();
                        }
                      });
                    }
                  },

                  //creat the cells for the board
                  child: Container(
                    color: Colors.purple[400],
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 9,
            ),
          ],
        ),
      ),
    );
  }

  //check if there is a winner
  bool _checkWinner(int row, int col) {
    // Check row, 3 must be the same symbol to win
    if (board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
      return true;
    }

    // Check column, 3 must be the same symbol to win
    if (board[0][col] == board[1][col] && board[1][col] == board[2][col]) {
      return true;
    }

    // Check diagonals only if the move is on a diagonal cell
    // and if the move is on the main diagonal, check the main diagonal
    // else check the other diagonal
    if ((row == col || row + col == 2) &&
        ((row == col && board[0][0] == board[1][1] && board[1][1] == board[2][2]) ||
            (row + col == 2 && board[0][2] == board[1][1] && board[1][1] == board[2][0]))) {
      return true;
    }

    return false;
  }

  //show dialog when there is a winner
  void _showWinnerDialog() {
    // Show a dialog that congratulates the winner, ask for rematch
    final String winner = isPlayer1Turn ? 'Player 2 (O)' : 'Player 1 (X)';
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('$winner wins!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  //show dialog when there is a draw (no winner). Similar to the winner dialog but with different text
  void _showDrawDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text("It's a draw!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  //reset the game
  void _resetGame() {
    setState(() {
      //set all the cells to empty
      //board = List.generate(3, (_) => List.filled(3, ''));
      //after analyzing the code
      board = List<List<String>>.generate(
        3,
        (int index) => List<String>.filled(3, ''),
        growable: false,
      );
      isPlayer1Turn = true;
      moves = 0;
    });
  }
}
