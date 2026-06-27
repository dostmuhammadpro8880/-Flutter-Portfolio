
import 'package:flutter/material.dart';

class ChessBoardScreen extends StatefulWidget {
  const ChessBoardScreen({super.key});

  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  List<String> board = [
    '♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜',
    '♟', '♟', '♟', '♟', '♟', '♟', '♟', '♟',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙',
    '♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖',
  ];

  int? selectedIndex;
  bool whiteTurn = true;

  bool isWhitePiece(String piece) {
    return ['♙', '♖', '♘', '♗', '♕', '♔'].contains(piece);
  }

  bool isBlackPiece(String piece) {
    return ['♟', '♜', '♞', '♝', '♛', '♚'].contains(piece);
  }

  void onTileTap(int index) {
    String piece = board[index];

    if (selectedIndex == null) {
      if (piece.isEmpty) return;

      if (whiteTurn && isWhitePiece(piece)) {
        setState(() {
          selectedIndex = index;
        });
      } else if (!whiteTurn && isBlackPiece(piece)) {
        setState(() {
          selectedIndex = index;
        });
      }
    } else {
      setState(() {
        board[index] = board[selectedIndex!];
        board[selectedIndex!] = '';
        selectedIndex = null;
        whiteTurn = !whiteTurn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          whiteTurn ? "Player 1 Turn" : "Player 2 Turn",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 64,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;

              bool isWhiteTile = (row + col) % 2 == 0;
              bool isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => onTileTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green
                        : isWhiteTile
                            ? Colors.brown.shade200
                            : Colors.brown.shade700,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}