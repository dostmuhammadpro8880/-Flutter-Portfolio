

import 'package:flutter/material.dart';

class ChessBoardScreen extends StatelessWidget {
  const ChessBoardScreen({super.key});

  final List<String> pieces = const [
    '♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜',
    '♟', '♟', '♟', '♟', '♟', '♟', '♟', '♟',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙',
    '♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Flutter Chess Board"),
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

              bool isWhite = (row + col) % 2 == 0;

              return Container(
                decoration: BoxDecoration(
                  color: isWhite
                      ? Colors.brown.shade200
                      : Colors.brown.shade700,
                ),
                child: Center(
                  child: Text(
                    pieces[index],
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
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