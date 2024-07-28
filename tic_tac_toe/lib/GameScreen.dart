import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const GameScreen({required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = 'X';
    _winner = "";
    _gameOver = false;
  }

  void resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _currentPlayer = 'X';
      _winner = "";
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;

      if (_checkWinner(row, col)) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It is a Tie";
      }

      if (!_gameOver) {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }

      if (_gameOver) {
        _showGameOverDialog();
      }
    });
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) return true;
    // Check column
    if (_board.every((r) => r[col] == _currentPlayer)) return true;
    // Check diagonal
    if (_board[0][0] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][2] == _currentPlayer) return true;
    if (_board[0][2] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][0] == _currentPlayer) return true;
    return false;
  }

  void _showGameOverDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      btnOkText: "Play Again",
      title: _winner == "X"
          ? "${widget.player1} Won!"
          : _winner == "O"
              ? "${widget.player2} Won!"
              : "It is a Tie",
      btnOkOnPress: () {
        resetGame();
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Turn: ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentPlayer == "X"
                      ? "${widget.player1} ($_currentPlayer)"
                      : "${widget.player2} ($_currentPlayer)",
                  style: TextStyle(
                    fontSize: 25,
                    color: _currentPlayer == "X"
                        ? Color(0xFFE25041)
                        : Color(0xFF1CBD9E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => _makeMove(row, col),
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 72, 92, 101),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _board[row][col],
                            style: TextStyle(
                              color: _board[row][col] == "X"
                                  ? Color(0xFFE25041)
                                  : Color(0xFF1CBD9E),
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onHover: (value) => Color.fromARGB(0, 242, 107, 73),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Text(
                        "Restart Game",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 170,
            )
          ],
        ),
      ),
    );
  }
}
