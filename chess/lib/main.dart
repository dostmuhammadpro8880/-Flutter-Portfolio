// // // import 'dart:math';

// // // import 'package:chessp/2chessBoard_With%20Pieces.dart';
// // // import 'package:chessp/chess_with_claude.dart';
// // // import 'package:chessp/rules.dart';
// // // import 'package:flutter/material.dart';

// // // void main() {
// // //   runApp(const MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Flutter Demo',
// // //       theme: ThemeData(
// // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // //       ),
// // //       // home: ChessBoardScreen(),
// // //       // home: Ludo()
// // //       home: ChessApp(),
// // //     );
// // //   }
// // // }



// // ============================================================
// // CHESS WITH CLAUDE — Complete Flutter Chess App
// // main.dart — Single-file architecture for portability
// // ============================================================
// // Sections:
// //  1. Imports & Main
// //  2. Models (Piece, Move, GameState)
// //  3. Chess Logic Engine
// //  4. AI Engine (Minimax + Alpha-Beta)
// //  5. State Management (Riverpod Providers)
// //  6. Themes & Design Tokens
// //  7. Screens (Splash, Home, Game, Settings, Stats, About)
// //  8. Widgets (Board, Pieces, Dialogs, etc.)
// // ============================================================

// import 'dart:async';
// import 'dart:math';
// import 'dart:convert';

// import 'package:chessp/ChessApp_firends.dart';
// import 'package:chessp/chessApp_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // ============================================================
// // 1. MAIN ENTRY POINT
// // ============================================================

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://byqfjiuwtgzoaznwormj.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cWZqaXV3dGd6b2F6bndvcm1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMzgwNDUsImV4cCI6MjA5MzcxNDA0NX0.7ChKomzgPQwuCwhDObV4OZhp8tezKP0LYa1IUGjfsz0',
//   );
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//   ));
//   runApp(const ProviderScope(child: ChessApp()));
// }

// // ============================================================
// // 2. MODELS
// // ============================================================

// enum PieceType { king, queen, rook, bishop, knight, pawn }
// enum PieceColor { white, black }
// enum GameMode { pvp, pvc }
// enum AIDifficulty { easy, medium, hard }
// enum GameResult { inProgress, whiteWins, blackWins, draw }
// enum GameEndReason { none, checkmate, stalemate, timeout, resignation, agreedDraw }
// enum BoardTheme { classic, walnut, marble, emerald, midnight }

// class ChessPiece {
//   final PieceType type;
//   final PieceColor color;
//   bool hasMoved;

//   ChessPiece({
//     required this.type,
//     required this.color,
//     this.hasMoved = false,
//   });

//   ChessPiece copy() => ChessPiece(
//         type: type,
//         color: color,
//         hasMoved: hasMoved,
//       );

//   String get symbol {
//     const symbols = {
//       PieceType.king: ['♔', '♚'],
//       PieceType.queen: ['♕', '♛'],
//       PieceType.rook: ['♖', '♜'],
//       PieceType.bishop: ['♗', '♝'],
//       PieceType.knight: ['♘', '♞'],
//       PieceType.pawn: ['♙', '♟'],
//     };
//     return symbols[type]![color == PieceColor.white ? 0 : 1];
//   }

//   String get algebraicName {
//     const names = {
//       PieceType.king: 'K',
//       PieceType.queen: 'Q',
//       PieceType.rook: 'R',
//       PieceType.bishop: 'B',
//       PieceType.knight: 'N',
//       PieceType.pawn: '',
//     };
//     return names[type]!;
//   }

//   int get value {
//     const values = {
//       PieceType.pawn: 100,
//       PieceType.knight: 320,
//       PieceType.bishop: 330,
//       PieceType.rook: 500,
//       PieceType.queen: 900,
//       PieceType.king: 20000,
//     };
//     return values[type]!;
//   }

//   @override
//   String toString() => '${color.name[0].toUpperCase()}${type.name}';
// }

// class Position {
//   final int row;
//   final int col;

//   const Position(this.row, this.col);

//   bool get isValid => row >= 0 && row < 8 && col >= 0 && col < 8;

//   @override
//   bool operator ==(Object other) =>
//       other is Position && other.row == row && other.col == col;

//   @override
//   int get hashCode => row * 8 + col;

//   String get algebraic =>
//       '${String.fromCharCode(97 + col)}${8 - row}';

//   @override
//   String toString() => algebraic;
// }

// class ChessMove {
//   final Position from;
//   final Position to;
//   final ChessPiece piece;
//   final ChessPiece? captured;
//   final bool isCastling;
//   final bool isEnPassant;
//   final PieceType? promotionPiece;
//   final Position? enPassantCapturePos;
//   final bool isCheck;
//   final bool isCheckmate;

//   const ChessMove({
//     required this.from,
//     required this.to,
//     required this.piece,
//     this.captured,
//     this.isCastling = false,
//     this.isEnPassant = false,
//     this.promotionPiece,
//     this.enPassantCapturePos,
//     this.isCheck = false,
//     this.isCheckmate = false,
//   });

//   String get pgn {
//     if (isCastling) {
//       return (to.col - from.col > 0) ? 'O-O' : 'O-O-O';
//     }
//     String notation = piece.algebraicName;
//     if (captured != null || isEnPassant) notation += 'x';
//     notation += to.algebraic;
//     if (promotionPiece != null) {
//       final promo = ChessPiece(type: promotionPiece!, color: piece.color);
//       notation += '=${promo.algebraicName}';
//     }
//     if (isCheckmate) {
//       notation += '#';
//     } else if (isCheck) {
//       notation += '+';
//     }
//     return notation;
//   }
// }

// class GameStats {
//   final int wins;
//   final int losses;
//   final int draws;
//   final int totalGames;

//   const GameStats({
//     this.wins = 0,
//     this.losses = 0,
//     this.draws = 0,
//     this.totalGames = 0,
//   });

//   GameStats copyWith({int? wins, int? losses, int? draws, int? totalGames}) =>
//       GameStats(
//         wins: wins ?? this.wins,
//         losses: losses ?? this.losses,
//         draws: draws ?? this.draws,
//         totalGames: totalGames ?? this.totalGames,
//       );

//   Map<String, dynamic> toJson() => {
//         'wins': wins,
//         'losses': losses,
//         'draws': draws,
//         'totalGames': totalGames,
//       };

//   factory GameStats.fromJson(Map<String, dynamic> j) => GameStats(
//         wins: j['wins'] ?? 0,
//         losses: j['losses'] ?? 0,
//         draws: j['draws'] ?? 0,
//         totalGames: j['totalGames'] ?? 0,
//       );
// }

// // ============================================================
// // 3. CHESS LOGIC ENGINE
// // ============================================================

// class ChessEngine {
//   // Returns a deep copy of the board
//   static List<List<ChessPiece?>> copyBoard(List<List<ChessPiece?>> board) {
//     return List.generate(
//       8,
//       (r) => List.generate(8, (c) => board[r][c]?.copy()),
//     );
//   }

//   // Initial board setup
//   static List<List<ChessPiece?>> initialBoard() {
//     final board = List.generate(8, (_) => List<ChessPiece?>.filled(8, null));

//     // Back rank setup
//     final backRank = [
//       PieceType.rook,
//       PieceType.knight,
//       PieceType.bishop,
//       PieceType.queen,
//       PieceType.king,
//       PieceType.bishop,
//       PieceType.knight,
//       PieceType.rook,
//     ];

//     for (int c = 0; c < 8; c++) {
//       board[0][c] = ChessPiece(type: backRank[c], color: PieceColor.black);
//       board[1][c] = ChessPiece(type: PieceType.pawn, color: PieceColor.black);
//       board[6][c] = ChessPiece(type: PieceType.pawn, color: PieceColor.white);
//       board[7][c] = ChessPiece(type: backRank[c], color: PieceColor.white);
//     }
//     return board;
//   }

//   // Get pseudo-legal moves (ignoring check)
//   static List<Position> pseudoLegalMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     Position? enPassantTarget,
//   ) {
//     final piece = board[pos.row][pos.col];
//     if (piece == null) return [];

//     final moves = <Position>[];

//     switch (piece.type) {
//       case PieceType.pawn:
//         _pawnMoves(board, pos, piece, enPassantTarget, moves);
//         break;
//       case PieceType.knight:
//         _knightMoves(board, pos, piece, moves);
//         break;
//       case PieceType.bishop:
//         _slidingMoves(board, pos, piece, moves,
//             [[-1, -1], [-1, 1], [1, -1], [1, 1]]);
//         break;
//       case PieceType.rook:
//         _slidingMoves(board, pos, piece, moves,
//             [[-1, 0], [1, 0], [0, -1], [0, 1]]);
//         break;
//       case PieceType.queen:
//         _slidingMoves(board, pos, piece, moves, [
//           [-1, -1], [-1, 1], [1, -1], [1, 1],
//           [-1, 0], [1, 0], [0, -1], [0, 1],
//         ]);
//         break;
//       case PieceType.king:
//         _kingMoves(board, pos, piece, moves);
//         break;
//     }

//     return moves;
//   }

//   static void _pawnMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     ChessPiece piece,
//     Position? enPassantTarget,
//     List<Position> moves,
//   ) {
//     final dir = piece.color == PieceColor.white ? -1 : 1;
//     final startRow = piece.color == PieceColor.white ? 6 : 1;

//     // Forward 1
//     final fwd1 = Position(pos.row + dir, pos.col);
//     if (fwd1.isValid && board[fwd1.row][fwd1.col] == null) {
//       moves.add(fwd1);
//       // Forward 2 from start
//       if (pos.row == startRow) {
//         final fwd2 = Position(pos.row + dir * 2, pos.col);
//         if (fwd2.isValid && board[fwd2.row][fwd2.col] == null) {
//           moves.add(fwd2);
//         }
//       }
//     }

//     // Captures
//     for (final dc in [-1, 1]) {
//       final cap = Position(pos.row + dir, pos.col + dc);
//       if (cap.isValid) {
//         final target = board[cap.row][cap.col];
//         if (target != null && target.color != piece.color) {
//           moves.add(cap);
//         }
//         // En passant
//         if (enPassantTarget != null && cap == enPassantTarget) {
//           moves.add(cap);
//         }
//       }
//     }
//   }

//   static void _knightMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     ChessPiece piece,
//     List<Position> moves,
//   ) {
//     const offsets = [
//       [-2, -1], [-2, 1], [-1, -2], [-1, 2],
//       [1, -2], [1, 2], [2, -1], [2, 1],
//     ];
//     for (final off in offsets) {
//       final np = Position(pos.row + off[0], pos.col + off[1]);
//       if (np.isValid) {
//         final target = board[np.row][np.col];
//         if (target == null || target.color != piece.color) {
//           moves.add(np);
//         }
//       }
//     }
//   }

//   static void _slidingMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     ChessPiece piece,
//     List<Position> moves,
//     List<List<int>> dirs,
//   ) {
//     for (final dir in dirs) {
//       var r = pos.row + dir[0];
//       var c = pos.col + dir[1];
//       while (r >= 0 && r < 8 && c >= 0 && c < 8) {
//         final target = board[r][c];
//         if (target == null) {
//           moves.add(Position(r, c));
//         } else {
//           if (target.color != piece.color) moves.add(Position(r, c));
//           break;
//         }
//         r += dir[0];
//         c += dir[1];
//       }
//     }
//   }

//   static void _kingMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     ChessPiece piece,
//     List<Position> moves,
//   ) {
//     const offsets = [
//       [-1, -1], [-1, 0], [-1, 1],
//       [0, -1],           [0, 1],
//       [1, -1],  [1, 0],  [1, 1],
//     ];
//     for (final off in offsets) {
//       final np = Position(pos.row + off[0], pos.col + off[1]);
//       if (np.isValid) {
//         final target = board[np.row][np.col];
//         if (target == null || target.color != piece.color) {
//           moves.add(np);
//         }
//       }
//     }
//   }

//   // Check if a position is attacked by a given color.
//   // This intentionally differs from pseudoLegalMoves: pawns attack diagonally
//   // even when they cannot move diagonally, and they never attack forward.
//   static bool isAttacked(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     PieceColor byColor,
//   ) {
//     for (int r = 0; r < 8; r++) {
//       for (int c = 0; c < 8; c++) {
//         final piece = board[r][c];
//         if (piece == null || piece.color != byColor) continue;
//         final from = Position(r, c);
//         if (attacksSquare(board, from, pos)) return true;
//       }
//     }
//     return false;
//   }

//   static bool attacksSquare(
//     List<List<ChessPiece?>> board,
//     Position from,
//     Position target,
//   ) {
//     final piece = board[from.row][from.col];
//     if (piece == null || from == target) return false;

//     final dr = target.row - from.row;
//     final dc = target.col - from.col;

//     switch (piece.type) {
//       case PieceType.pawn:
//         final dir = piece.color == PieceColor.white ? -1 : 1;
//         return dr == dir && dc.abs() == 1;
//       case PieceType.knight:
//         return (dr.abs() == 2 && dc.abs() == 1) ||
//             (dr.abs() == 1 && dc.abs() == 2);
//       case PieceType.bishop:
//         return _rayAttacks(board, from, target, const [
//           [-1, -1],
//           [-1, 1],
//           [1, -1],
//           [1, 1],
//         ]);
//       case PieceType.rook:
//         return _rayAttacks(board, from, target, const [
//           [-1, 0],
//           [1, 0],
//           [0, -1],
//           [0, 1],
//         ]);
//       case PieceType.queen:
//         return _rayAttacks(board, from, target, const [
//           [-1, -1],
//           [-1, 1],
//           [1, -1],
//           [1, 1],
//           [-1, 0],
//           [1, 0],
//           [0, -1],
//           [0, 1],
//         ]);
//       case PieceType.king:
//         return dr.abs() <= 1 && dc.abs() <= 1;
//     }
//   }

//   static bool _rayAttacks(
//     List<List<ChessPiece?>> board,
//     Position from,
//     Position target,
//     List<List<int>> directions,
//   ) {
//     for (final dir in directions) {
//       var r = from.row + dir[0];
//       var c = from.col + dir[1];
//       while (r >= 0 && r < 8 && c >= 0 && c < 8) {
//         final pos = Position(r, c);
//         if (pos == target) return true;
//         if (board[r][c] != null) break;
//         r += dir[0];
//         c += dir[1];
//       }
//     }
//     return false;
//   }

//   // Find king position
//   static Position? findKing(List<List<ChessPiece?>> board, PieceColor color) {
//     for (int r = 0; r < 8; r++) {
//       for (int c = 0; c < 8; c++) {
//         final piece = board[r][c];
//         if (piece != null &&
//             piece.type == PieceType.king &&
//             piece.color == color) {
//           return Position(r, c);
//         }
//       }
//     }
//     return null;
//   }

//   // Is the king of given color in check?
//   static bool isInCheck(List<List<ChessPiece?>> board, PieceColor color) {
//     final kingPos = findKing(board, color);
//     if (kingPos == null) return false;
//     final opponent =
//         color == PieceColor.white ? PieceColor.black : PieceColor.white;
//     return isAttacked(board, kingPos, opponent);
//   }

//   // Apply a move and return new board state
//   static List<List<ChessPiece?>> applyMove(
//     List<List<ChessPiece?>> board,
//     Position from,
//     Position to,
//     Position? enPassantTarget, {
//     PieceType? promotionPiece,
//   }) {
//     final newBoard = copyBoard(board);
//     final piece = newBoard[from.row][from.col]!;

//     // En passant capture
//     if (piece.type == PieceType.pawn &&
//         enPassantTarget != null &&
//         to == enPassantTarget) {
//       final captureRow = from.row;
//       newBoard[captureRow][to.col] = null;
//     }

//     // Castling — move the rook too
//     if (piece.type == PieceType.king && (to.col - from.col).abs() == 2) {
//       final isKingside = to.col > from.col;
//       final rookCol = isKingside ? 7 : 0;
//       final newRookCol = isKingside ? to.col - 1 : to.col + 1;
//       final rook = newBoard[from.row][rookCol];
//       newBoard[from.row][rookCol] = null;
//       newBoard[from.row][newRookCol] = rook?..hasMoved = true;
//     }

//     // Promotion
//     if (piece.type == PieceType.pawn &&
//         (to.row == 0 || to.row == 7) &&
//         promotionPiece != null) {
//       newBoard[to.row][to.col] =
//           ChessPiece(type: promotionPiece, color: piece.color, hasMoved: true);
//     } else {
//       newBoard[to.row][to.col] = piece..hasMoved = true;
//     }

//     newBoard[from.row][from.col] = null;
//     return newBoard;
//   }

//   // Get legal moves (that don't leave king in check)
//   static List<Position> legalMoves(
//     List<List<ChessPiece?>> board,
//     Position pos,
//     Position? enPassantTarget,
//     bool canCastle,
//   ) {
//     final piece = board[pos.row][pos.col];
//     if (piece == null) return [];

//     var pseudo = pseudoLegalMoves(board, pos, enPassantTarget);

//     // Filter moves that leave king in check
//     pseudo = pseudo.where((to) {
//       final newBoard = applyMove(board, pos, to, enPassantTarget);
//       return !isInCheck(newBoard, piece.color);
//     }).toList();

//     // Castling
//     if (canCastle && piece.type == PieceType.king && !piece.hasMoved) {
//       _addCastlingMoves(board, pos, piece, pseudo);
//     }

//     return pseudo;
//   }

//   static void _addCastlingMoves(
//     List<List<ChessPiece?>> board,
//     Position kingPos,
//     ChessPiece king,
//     List<Position> moves,
//   ) {
//     final opponent =
//         king.color == PieceColor.white ? PieceColor.black : PieceColor.white;
//     final row = kingPos.row;

//     // Cannot castle while in check
//     if (isAttacked(board, kingPos, opponent)) return;

//     // Kingside
//     final kRook = board[row][7];
//     if (kRook != null &&
//         kRook.color == king.color &&
//         kRook.type == PieceType.rook &&
//         !kRook.hasMoved &&
//         board[row][5] == null &&
//         board[row][6] == null &&
//         !isAttacked(board, Position(row, 5), opponent) &&
//         !isAttacked(board, Position(row, 6), opponent)) {
//       moves.add(Position(row, 6));
//     }

//     // Queenside
//     final qRook = board[row][0];
//     if (qRook != null &&
//         qRook.color == king.color &&
//         qRook.type == PieceType.rook &&
//         !qRook.hasMoved &&
//         board[row][1] == null &&
//         board[row][2] == null &&
//         board[row][3] == null &&
//         !isAttacked(board, Position(row, 3), opponent) &&
//         !isAttacked(board, Position(row, 2), opponent)) {
//       moves.add(Position(row, 2));
//     }
//   }

//   // Get all legal moves for a color
//   static List<ChessMove> allLegalMoves(
//     List<List<ChessPiece?>> board,
//     PieceColor color,
//     Position? enPassantTarget,
//   ) {
//     final allMoves = <ChessMove>[];

//     for (int r = 0; r < 8; r++) {
//       for (int c = 0; c < 8; c++) {
//         final piece = board[r][c];
//         if (piece == null || piece.color != color) continue;
//         final from = Position(r, c);
//         final legals = legalMoves(board, from, enPassantTarget, true);
//         for (final to in legals) {
//           final captured = board[to.row][to.col];
//           final isCastling = piece.type == PieceType.king &&
//               (to.col - from.col).abs() == 2;
//           final isEnPassant = piece.type == PieceType.pawn &&
//               enPassantTarget != null &&
//               to == enPassantTarget;

//           // For pawns reaching last rank, generate promotions
//           if (piece.type == PieceType.pawn &&
//               (to.row == 0 || to.row == 7)) {
//             for (final promo in [
//               PieceType.queen,
//               PieceType.rook,
//               PieceType.bishop,
//               PieceType.knight,
//             ]) {
//               allMoves.add(ChessMove(
//                 from: from,
//                 to: to,
//                 piece: piece,
//                 captured: captured,
//                 isCastling: isCastling,
//                 isEnPassant: isEnPassant,
//                 promotionPiece: promo,
//               ));
//             }
//           } else {
//             allMoves.add(ChessMove(
//               from: from,
//               to: to,
//               piece: piece,
//               captured: captured,
//               isCastling: isCastling,
//               isEnPassant: isEnPassant,
//             ));
//           }
//         }
//       }
//     }
//     return allMoves;
//   }

//   // Get new en passant target after a pawn double move
//   static Position? newEnPassantTarget(
//     Position from,
//     Position to,
//     ChessPiece piece,
//   ) {
//     if (piece.type == PieceType.pawn && (to.row - from.row).abs() == 2) {
//       return Position((from.row + to.row) ~/ 2, from.col);
//     }
//     return null;
//   }
// }

// // ============================================================
// // 4. AI ENGINE — MINIMAX WITH ALPHA-BETA PRUNING
// // ============================================================

// class ChessAI {
//   static const _pieceSquareTables = <PieceType, List<List<int>>>{
//     PieceType.pawn: [
//       [ 0,  0,  0,  0,  0,  0,  0,  0],
//       [50, 50, 50, 50, 50, 50, 50, 50],
//       [10, 10, 20, 30, 30, 20, 10, 10],
//       [ 5,  5, 10, 25, 25, 10,  5,  5],
//       [ 0,  0,  0, 20, 20,  0,  0,  0],
//       [ 5, -5,-10,  0,  0,-10, -5,  5],
//       [ 5, 10, 10,-20,-20, 10, 10,  5],
//       [ 0,  0,  0,  0,  0,  0,  0,  0],
//     ],
//     PieceType.knight: [
//       [-50,-40,-30,-30,-30,-30,-40,-50],
//       [-40,-20,  0,  0,  0,  0,-20,-40],
//       [-30,  0, 10, 15, 15, 10,  0,-30],
//       [-30,  5, 15, 20, 20, 15,  5,-30],
//       [-30,  0, 15, 20, 20, 15,  0,-30],
//       [-30,  5, 10, 15, 15, 10,  5,-30],
//       [-40,-20,  0,  5,  5,  0,-20,-40],
//       [-50,-40,-30,-30,-30,-30,-40,-50],
//     ],
//     PieceType.bishop: [
//       [-20,-10,-10,-10,-10,-10,-10,-20],
//       [-10,  0,  0,  0,  0,  0,  0,-10],
//       [-10,  0,  5, 10, 10,  5,  0,-10],
//       [-10,  5,  5, 10, 10,  5,  5,-10],
//       [-10,  0, 10, 10, 10, 10,  0,-10],
//       [-10, 10, 10, 10, 10, 10, 10,-10],
//       [-10,  5,  0,  0,  0,  0,  5,-10],
//       [-20,-10,-10,-10,-10,-10,-10,-20],
//     ],
//     PieceType.rook: [
//       [ 0,  0,  0,  0,  0,  0,  0,  0],
//       [ 5, 10, 10, 10, 10, 10, 10,  5],
//       [-5,  0,  0,  0,  0,  0,  0, -5],
//       [-5,  0,  0,  0,  0,  0,  0, -5],
//       [-5,  0,  0,  0,  0,  0,  0, -5],
//       [-5,  0,  0,  0,  0,  0,  0, -5],
//       [-5,  0,  0,  0,  0,  0,  0, -5],
//       [ 0,  0,  0,  5,  5,  0,  0,  0],
//     ],
//     PieceType.queen: [
//       [-20,-10,-10, -5, -5,-10,-10,-20],
//       [-10,  0,  0,  0,  0,  0,  0,-10],
//       [-10,  0,  5,  5,  5,  5,  0,-10],
//       [ -5,  0,  5,  5,  5,  5,  0, -5],
//       [  0,  0,  5,  5,  5,  5,  0, -5],
//       [-10,  5,  5,  5,  5,  5,  0,-10],
//       [-10,  0,  5,  0,  0,  0,  0,-10],
//       [-20,-10,-10, -5, -5,-10,-10,-20],
//     ],
//     PieceType.king: [
//       [-30,-40,-40,-50,-50,-40,-40,-30],
//       [-30,-40,-40,-50,-50,-40,-40,-30],
//       [-30,-40,-40,-50,-50,-40,-40,-30],
//       [-30,-40,-40,-50,-50,-40,-40,-30],
//       [-20,-30,-30,-40,-40,-30,-30,-20],
//       [-10,-20,-20,-20,-20,-20,-20,-10],
//       [ 20, 20,  0,  0,  0,  0, 20, 20],
//       [ 20, 30, 10,  0,  0, 10, 30, 20],
//     ],
//   };

//   static int _pieceSquareValue(ChessPiece piece, Position pos) {
//     final table = _pieceSquareTables[piece.type];
//     if (table == null) return 0;
//     final row = piece.color == PieceColor.white ? pos.row : 7 - pos.row;
//     return table[row][pos.col];
//   }

//   static int evaluate(List<List<ChessPiece?>> board) {
//     int score = 0;
//     for (int r = 0; r < 8; r++) {
//       for (int c = 0; c < 8; c++) {
//         final piece = board[r][c];
//         if (piece == null) continue;
//         final pos = Position(r, c);
//         final val = piece.value + _pieceSquareValue(piece, pos);
//         score += piece.color == PieceColor.white ? val : -val;
//       }
//     }
//     return score;
//   }

//   static int minimax(
//     List<List<ChessPiece?>> board,
//     int depth,
//     int alpha,
//     int beta,
//     bool isMaximizing,
//     PieceColor currentColor,
//     Position? enPassantTarget,
//   ) {
//     final moves =
//         ChessEngine.allLegalMoves(board, currentColor, enPassantTarget);

//     if (depth == 0 || moves.isEmpty) {
//       if (moves.isEmpty) {
//         if (ChessEngine.isInCheck(board, currentColor)) {
//           return isMaximizing ? -99999 : 99999;
//         }
//         return 0; // Stalemate
//       }
//       return evaluate(board);
//     }

//     final opponent = currentColor == PieceColor.white
//         ? PieceColor.black
//         : PieceColor.white;

//     if (isMaximizing) {
//       int maxEval = -999999;
//       for (final move in moves) {
//         final newBoard = ChessEngine.applyMove(
//           board, move.from, move.to, enPassantTarget,
//           promotionPiece: move.promotionPiece ?? PieceType.queen,
//         );
//         final newEP = ChessEngine.newEnPassantTarget(
//             move.from, move.to, move.piece);
//         final eval = minimax(
//             newBoard, depth - 1, alpha, beta, false, opponent, newEP);
//         maxEval = max(maxEval, eval);
//         alpha = max(alpha, eval);
//         if (beta <= alpha) break;
//       }
//       return maxEval;
//     } else {
//       int minEval = 999999;
//       for (final move in moves) {
//         final newBoard = ChessEngine.applyMove(
//           board, move.from, move.to, enPassantTarget,
//           promotionPiece: move.promotionPiece ?? PieceType.queen,
//         );
//         final newEP = ChessEngine.newEnPassantTarget(
//             move.from, move.to, move.piece);
//         final eval = minimax(
//             newBoard, depth - 1, alpha, beta, true, opponent, newEP);
//         minEval = min(minEval, eval);
//         beta = min(beta, eval);
//         if (beta <= alpha) break;
//       }
//       return minEval;
//     }
//   }

//   static ChessMove? getBestMove(
//     List<List<ChessPiece?>> board,
//     PieceColor aiColor,
//     AIDifficulty difficulty,
//     Position? enPassantTarget,
//   ) {
//     final depthMap = {
//       AIDifficulty.easy: 1,
//       AIDifficulty.medium: 3,
//       AIDifficulty.hard: 4,
//     };
//     final depth = depthMap[difficulty]!;

//     final moves = ChessEngine.allLegalMoves(board, aiColor, enPassantTarget);
//     if (moves.isEmpty) return null;

//     // Easy: pick a random move sometimes
//     if (difficulty == AIDifficulty.easy && Random().nextDouble() < 0.4) {
//       return moves[Random().nextInt(moves.length)];
//     }

//     ChessMove? bestMove;
//     int bestScore = aiColor == PieceColor.white ? -999999 : 999999;
//     final isMaximizing = aiColor == PieceColor.white;
//     final opponent = aiColor == PieceColor.white
//         ? PieceColor.black
//         : PieceColor.white;

//     // Shuffle for variety at equal scores
//     final shuffled = List<ChessMove>.from(moves)..shuffle();

//     for (final move in shuffled) {
//       final newBoard = ChessEngine.applyMove(
//         board, move.from, move.to, enPassantTarget,
//         promotionPiece: move.promotionPiece ?? PieceType.queen,
//       );
//       final newEP =
//           ChessEngine.newEnPassantTarget(move.from, move.to, move.piece);
//       final score = minimax(
//         newBoard,
//         depth - 1,
//         -999999,
//         999999,
//         !isMaximizing,
//         opponent,
//         newEP,
//       );

//       if (isMaximizing ? score > bestScore : score < bestScore) {
//         bestScore = score;
//         bestMove = move;
//       }
//     }

//     return bestMove ?? moves.first;
//   }
// }

// // ============================================================
// // 5. STATE MANAGEMENT (RIVERPOD)
// // ============================================================

// // Game state immutable snapshot
// class GameState {
//   final List<List<ChessPiece?>> board;
//   final PieceColor currentTurn;
//   final Position? selectedPos;
//   final List<Position> legalMoves;
//   final List<ChessMove> moveHistory;
//   final Position? lastMoveFrom;
//   final Position? lastMoveTo;
//   final Position? enPassantTarget;
//   final GameResult result;
//   final GameEndReason endReason;
//   final bool isCheck;
//   final List<ChessPiece> capturedByWhite;
//   final List<ChessPiece> capturedByBlack;
//   final GameMode gameMode;
//   final AIDifficulty aiDifficulty;
//   final PieceColor playerColor;
//   final bool isAIThinking;
//   final int whiteTimeSeconds;
//   final int blackTimeSeconds;
//   final bool timerEnabled;
//   final bool promotionPending;
//   final Position? promotionPos;

//   const GameState({
//     required this.board,
//     this.currentTurn = PieceColor.white,
//     this.selectedPos,
//     this.legalMoves = const [],
//     this.moveHistory = const [],
//     this.lastMoveFrom,
//     this.lastMoveTo,
//     this.enPassantTarget,
//     this.result = GameResult.inProgress,
//     this.endReason = GameEndReason.none,
//     this.isCheck = false,
//     this.capturedByWhite = const [],
//     this.capturedByBlack = const [],
//     this.gameMode = GameMode.pvp,
//     this.aiDifficulty = AIDifficulty.medium,
//     this.playerColor = PieceColor.white,
//     this.isAIThinking = false,
//     this.whiteTimeSeconds = 600,
//     this.blackTimeSeconds = 600,
//     this.timerEnabled = true,
//     this.promotionPending = false,
//     this.promotionPos,
//   });

//   GameState copyWith({
//     List<List<ChessPiece?>>? board,
//     PieceColor? currentTurn,
//     Position? selectedPos,
//     bool clearSelected = false,
//     List<Position>? legalMoves,
//     List<ChessMove>? moveHistory,
//     Position? lastMoveFrom,
//     Position? lastMoveTo,
//     bool clearLastMove = false,
//     bool clearEnPassant = false,
//     Position? enPassantTarget,
//     GameResult? result,
//     GameEndReason? endReason,
//     bool? isCheck,
//     List<ChessPiece>? capturedByWhite,
//     List<ChessPiece>? capturedByBlack,
//     GameMode? gameMode,
//     AIDifficulty? aiDifficulty,
//     PieceColor? playerColor,
//     bool? isAIThinking,
//     int? whiteTimeSeconds,
//     int? blackTimeSeconds,
//     bool? timerEnabled,
//     bool? promotionPending,
//     Position? promotionPos,
//     bool clearPromotionPos = false,
//   }) =>
//       GameState(
//         board: board ?? this.board,
//         currentTurn: currentTurn ?? this.currentTurn,
//         selectedPos: clearSelected ? null : (selectedPos ?? this.selectedPos),
//         legalMoves: legalMoves ?? this.legalMoves,
//         moveHistory: moveHistory ?? this.moveHistory,
//         lastMoveFrom:
//             clearLastMove ? null : (lastMoveFrom ?? this.lastMoveFrom),
//         lastMoveTo: clearLastMove ? null : (lastMoveTo ?? this.lastMoveTo),
//         enPassantTarget:
//             clearEnPassant ? null : (enPassantTarget ?? this.enPassantTarget),
//         result: result ?? this.result,
//         endReason: endReason ?? this.endReason,
//         isCheck: isCheck ?? this.isCheck,
//         capturedByWhite: capturedByWhite ?? this.capturedByWhite,
//         capturedByBlack: capturedByBlack ?? this.capturedByBlack,
//         gameMode: gameMode ?? this.gameMode,
//         aiDifficulty: aiDifficulty ?? this.aiDifficulty,
//         playerColor: playerColor ?? this.playerColor,
//         isAIThinking: isAIThinking ?? this.isAIThinking,
//         whiteTimeSeconds: whiteTimeSeconds ?? this.whiteTimeSeconds,
//         blackTimeSeconds: blackTimeSeconds ?? this.blackTimeSeconds,
//         timerEnabled: timerEnabled ?? this.timerEnabled,
//         promotionPending: promotionPending ?? this.promotionPending,
//         promotionPos:
//             clearPromotionPos ? null : (promotionPos ?? this.promotionPos),
//       );
// }

// class GameNotifier extends StateNotifier<GameState> {
//   Timer? _timer;

//   GameNotifier()
//       : super(GameState(board: ChessEngine.initialBoard()));

//   void newGame({
//     required GameMode mode,
//     required AIDifficulty difficulty,
//     required PieceColor playerColor,
//     bool timerEnabled = true,
//     int timeSeconds = 600,
//   }) {
//     _timer?.cancel();
//     state = GameState(
//       board: ChessEngine.initialBoard(),
//       gameMode: mode,
//       aiDifficulty: difficulty,
//       playerColor: playerColor,
//       timerEnabled: timerEnabled,
//       whiteTimeSeconds: timeSeconds,
//       blackTimeSeconds: timeSeconds,
//     );
//     if (timerEnabled) _startTimer();

//     // If AI plays white, make first move
//     if (mode == GameMode.pvc && playerColor == PieceColor.black) {
//       Future.delayed(const Duration(milliseconds: 500), () => _aiMove());
//     }
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (state.result != GameResult.inProgress) {
//         _timer?.cancel();
//         return;
//       }
//       if (state.currentTurn == PieceColor.white) {
//         final newTime = state.whiteTimeSeconds - 1;
//         if (newTime <= 0) {
//           state = state.copyWith(
//             whiteTimeSeconds: 0,
//             result: GameResult.blackWins,
//             endReason: GameEndReason.timeout,
//           );
//           _timer?.cancel();
//         } else {
//           state = state.copyWith(whiteTimeSeconds: newTime);
//         }
//       } else {
//         final newTime = state.blackTimeSeconds - 1;
//         if (newTime <= 0) {
//           state = state.copyWith(
//             blackTimeSeconds: 0,
//             result: GameResult.whiteWins,
//             endReason: GameEndReason.timeout,
//           );
//           _timer?.cancel();
//         } else {
//           state = state.copyWith(blackTimeSeconds: newTime);
//         }
//       }
//     });
//   }

//   void selectSquare(Position pos) {
//     if (state.result != GameResult.inProgress) return;
//     if (state.isAIThinking) return;
//     if (state.promotionPending) return;

//     // AI's turn in PvC — ignore taps
//     if (state.gameMode == GameMode.pvc &&
//         state.currentTurn != state.playerColor) return;

//     final piece = state.board[pos.row][pos.col];

//     // If a piece is already selected, try to move
//     if (state.selectedPos != null) {
//       if (state.legalMoves.contains(pos)) {
//         _executeMove(state.selectedPos!, pos);
//         return;
//       }
//       // Select a different piece of same color
//       if (piece != null && piece.color == state.currentTurn) {
//         final moves = ChessEngine.legalMoves(
//             state.board, pos, state.enPassantTarget, true);
//         state = state.copyWith(
//           selectedPos: pos,
//           legalMoves: moves,
//         );
//         return;
//       }
//       // Deselect
//       state = state.copyWith(clearSelected: true, legalMoves: []);
//       return;
//     }

//     // Select a piece
//     if (piece != null && piece.color == state.currentTurn) {
//       final moves = ChessEngine.legalMoves(
//           state.board, pos, state.enPassantTarget, true);
//       state = state.copyWith(selectedPos: pos, legalMoves: moves);
//     }
//   }

//   void _executeMove(Position from, Position to, {PieceType? promotion}) {
//     final piece = state.board[from.row][from.col]!;
//     final captured = state.board[to.row][to.col];

//     final isEnPassant = piece.type == PieceType.pawn &&
//         state.enPassantTarget != null &&
//         to == state.enPassantTarget;

//     ChessPiece? epCaptured;
//     if (isEnPassant) {
//       epCaptured = state.board[from.row][to.col];
//     }

//     final isCastling = piece.type == PieceType.king &&
//         (to.col - from.col).abs() == 2;

//     // Check if pawn promotion needed
//     final isPromotion =
//         piece.type == PieceType.pawn && (to.row == 0 || to.row == 7);
//     if (isPromotion && promotion == null) {
//       // If AI or auto-promotion, use queen; else show dialog
//       state = state.copyWith(
//         selectedPos: to,
//         legalMoves: [],
//         promotionPending: true,
//         promotionPos: to,
//       );
//       // Store pending from position — we'll complete after dialog
//       _pendingPromotionFrom = from;
//       _pendingPromotionTo = to;
//       return;
//     }

//     final newBoard = ChessEngine.applyMove(
//       state.board,
//       from,
//       to,
//       state.enPassantTarget,
//       promotionPiece: promotion ?? (isPromotion ? PieceType.queen : null),
//     );

//     final newEP = ChessEngine.newEnPassantTarget(from, to, piece);
//     final opponent = state.currentTurn == PieceColor.white
//         ? PieceColor.black
//         : PieceColor.white;

//     final opponentInCheck = ChessEngine.isInCheck(newBoard, opponent);
//     final opponentMoves =
//         ChessEngine.allLegalMoves(newBoard, opponent, newEP);
//     final isCheckmate = opponentInCheck && opponentMoves.isEmpty;
//     final isStalemate = !opponentInCheck && opponentMoves.isEmpty;

//     // Build move record
//     final move = ChessMove(
//       from: from,
//       to: to,
//       piece: piece,
//       captured: isEnPassant ? epCaptured : captured,
//       isCastling: isCastling,
//       isEnPassant: isEnPassant,
//       promotionPiece: promotion,
//       isCheck: opponentInCheck,
//       isCheckmate: isCheckmate,
//     );

//     // Update captured lists
//     final newCapturedByWhite = List<ChessPiece>.from(state.capturedByWhite);
//     final newCapturedByBlack = List<ChessPiece>.from(state.capturedByBlack);
//     final capturedPiece = isEnPassant ? epCaptured : captured;
//     if (capturedPiece != null) {
//       if (state.currentTurn == PieceColor.white) {
//         newCapturedByWhite.add(capturedPiece);
//       } else {
//         newCapturedByBlack.add(capturedPiece);
//       }
//     }

//     GameResult result = GameResult.inProgress;
//     if (isCheckmate) {
//       result = state.currentTurn == PieceColor.white
//           ? GameResult.whiteWins
//           : GameResult.blackWins;
//     } else if (isStalemate) {
//       result = GameResult.draw;
//     }

//     state = state.copyWith(
//       board: newBoard,
//       currentTurn: opponent,
//       clearSelected: true,
//       legalMoves: [],
//       lastMoveFrom: from,
//       lastMoveTo: to,
//       enPassantTarget: newEP,
//       moveHistory: [...state.moveHistory, move],
//       result: result,
//       isCheck: opponentInCheck && !isCheckmate,
//       capturedByWhite: newCapturedByWhite,
//       capturedByBlack: newCapturedByBlack,
//       promotionPending: false,
//     );

//     if (result == GameResult.inProgress &&
//         state.gameMode == GameMode.pvc &&
//         state.currentTurn != state.playerColor) {
//       Future.delayed(const Duration(milliseconds: 400), () => _aiMove());
//     }

//     if (result != GameResult.inProgress) {
//       _timer?.cancel();
//     }
//   }

//   Position? _pendingPromotionFrom;
//   Position? _pendingPromotionTo;

//   void completePromotion(PieceType piece) {
//     if (_pendingPromotionFrom != null && _pendingPromotionTo != null) {
//       _executeMove(_pendingPromotionFrom!, _pendingPromotionTo!,
//           promotion: piece);
//       _pendingPromotionFrom = null;
//       _pendingPromotionTo = null;
//     }
//   }

//   void _aiMove() async {
//     if (state.result != GameResult.inProgress) return;
//     state = state.copyWith(isAIThinking: true);

//     // Run in a future to avoid blocking UI
//     await Future.delayed(const Duration(milliseconds: 100));

//     final move = ChessAI.getBestMove(
//       state.board,
//       state.currentTurn,
//       state.aiDifficulty,
//       state.enPassantTarget,
//     );

//     if (move != null) {
//       state = state.copyWith(isAIThinking: false);
//       _executeMove(move.from, move.to,
//           promotion: move.promotionPiece ?? PieceType.queen);
//     } else {
//       state = state.copyWith(isAIThinking: false);
//     }
//   }

//   void undoMove() {
//     if (state.moveHistory.isEmpty) return;
//     if (state.isAIThinking) return;

//     // Rebuild from scratch for undo — simpler approach
//     final moves = List<ChessMove>.from(state.moveHistory);

//     // In PvC, undo two moves (AI's + player's)
//     int undoCount =
//         state.gameMode == GameMode.pvc && moves.length >= 2 ? 2 : 1;

//     for (int i = 0; i < undoCount && moves.isNotEmpty; i++) {
//       moves.removeLast();
//     }

//     // Replay all moves
//     var board = ChessEngine.initialBoard();
//     Position? enPassantTarget;
//     final capturedByWhite = <ChessPiece>[];
//     final capturedByBlack = <ChessPiece>[];

//     for (final move in moves) {
//       if (move.captured != null) {
//         if (move.piece.color == PieceColor.white) {
//           capturedByWhite.add(move.captured!);
//         } else {
//           capturedByBlack.add(move.captured!);
//         }
//       }
//       board = ChessEngine.applyMove(
//         board, move.from, move.to, enPassantTarget,
//         promotionPiece: move.promotionPiece,
//       );
//       enPassantTarget =
//           ChessEngine.newEnPassantTarget(move.from, move.to, move.piece);
//     }

//     final currentTurn = moves.length.isEven ? PieceColor.white : PieceColor.black;
//     final lastMove = moves.isNotEmpty ? moves.last : null;

//     state = state.copyWith(
//       board: board,
//       currentTurn: currentTurn,
//       clearSelected: true,
//       legalMoves: [],
//       lastMoveFrom: lastMove?.from,
//       lastMoveTo: lastMove?.to,
//       enPassantTarget: enPassantTarget,
//       moveHistory: moves,
//       result: GameResult.inProgress,
//       isCheck: ChessEngine.isInCheck(board, currentTurn),
//       capturedByWhite: capturedByWhite,
//       capturedByBlack: capturedByBlack,
//       promotionPending: false,
//     );
//   }

//   String getPGN() {
//     final buffer = StringBuffer();
//     final moves = state.moveHistory;
//     for (int i = 0; i < moves.length; i++) {
//       if (i % 2 == 0) buffer.write('${(i ~/ 2) + 1}. ');
//       buffer.write(moves[i].pgn);
//       buffer.write(' ');
//     }
//     return buffer.toString().trim();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }

// final gameProvider = StateNotifierProvider<GameNotifier, GameState>(
//   (ref) => GameNotifier(),
// );

// // Settings Provider
// class AppSettings {
//   final bool isDarkMode;
//   final BoardTheme boardTheme;
//   final bool soundEnabled;
//   final bool timerEnabled;
//   final int timerSeconds;
//   final AIDifficulty defaultDifficulty;

//   const AppSettings({
//     this.isDarkMode = true,
//     this.boardTheme = BoardTheme.classic,
//     this.soundEnabled = true,
//     this.timerEnabled = true,
//     this.timerSeconds = 600,
//     this.defaultDifficulty = AIDifficulty.medium,
//   });

//   AppSettings copyWith({
//     bool? isDarkMode,
//     BoardTheme? boardTheme,
//     bool? soundEnabled,
//     bool? timerEnabled,
//     int? timerSeconds,
//     AIDifficulty? defaultDifficulty,
//   }) =>
//       AppSettings(
//         isDarkMode: isDarkMode ?? this.isDarkMode,
//         boardTheme: boardTheme ?? this.boardTheme,
//         soundEnabled: soundEnabled ?? this.soundEnabled,
//         timerEnabled: timerEnabled ?? this.timerEnabled,
//         timerSeconds: timerSeconds ?? this.timerSeconds,
//         defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
//       );

//   Map<String, dynamic> toJson() => {
//         'isDarkMode': isDarkMode,
//         'boardTheme': boardTheme.index,
//         'soundEnabled': soundEnabled,
//         'timerEnabled': timerEnabled,
//         'timerSeconds': timerSeconds,
//         'defaultDifficulty': defaultDifficulty.index,
//       };

//   factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
//         isDarkMode: j['isDarkMode'] ?? true,
//         boardTheme: BoardTheme.values[j['boardTheme'] ?? 0],
//         soundEnabled: j['soundEnabled'] ?? true,
//         timerEnabled: j['timerEnabled'] ?? true,
//         timerSeconds: j['timerSeconds'] ?? 600,
//         defaultDifficulty:
//             AIDifficulty.values[j['defaultDifficulty'] ?? 1],
//       );
// }

// class SettingsNotifier extends StateNotifier<AppSettings> {
//   SettingsNotifier() : super(const AppSettings()) {
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final json = prefs.getString('settings');
//       if (json != null) {
//         state = AppSettings.fromJson(jsonDecode(json));
//       }
//     } catch (_) {}
//   }

//   Future<void> _save() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('settings', jsonEncode(state.toJson()));
//     } catch (_) {}
//   }

//   void setDarkMode(bool v) {
//     state = state.copyWith(isDarkMode: v);
//     _save();
//   }

//   void setBoardTheme(BoardTheme t) {
//     state = state.copyWith(boardTheme: t);
//     _save();
//   }

//   void setSoundEnabled(bool v) {
//     state = state.copyWith(soundEnabled: v);
//     _save();
//   }

//   void setTimerEnabled(bool v) {
//     state = state.copyWith(timerEnabled: v);
//     _save();
//   }

//   void setTimerSeconds(int s) {
//     state = state.copyWith(timerSeconds: s);
//     _save();
//   }

//   void setDefaultDifficulty(AIDifficulty d) {
//     state = state.copyWith(defaultDifficulty: d);
//     _save();
//   }
// }

// final settingsProvider =
//     StateNotifierProvider<SettingsNotifier, AppSettings>(
//   (ref) => SettingsNotifier(),
// );

// // Stats Provider
// class StatsNotifier extends StateNotifier<GameStats> {
//   StatsNotifier() : super(const GameStats()) {
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final json = prefs.getString('stats');
//       if (json != null) state = GameStats.fromJson(jsonDecode(json));
//     } catch (_) {}
//   }

//   Future<void> _save() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('stats', jsonEncode(state.toJson()));
//     } catch (_) {}
//   }

//   void recordResult(GameResult result, PieceColor playerColor) {
//     if (result == GameResult.inProgress) return;
//     GameStats updated = state.copyWith(totalGames: state.totalGames + 1);
//     if (result == GameResult.draw) {
//       updated = updated.copyWith(draws: updated.draws + 1);
//     } else if ((result == GameResult.whiteWins &&
//             playerColor == PieceColor.white) ||
//         (result == GameResult.blackWins &&
//             playerColor == PieceColor.black)) {
//       updated = updated.copyWith(wins: updated.wins + 1);
//     } else {
//       updated = updated.copyWith(losses: updated.losses + 1);
//     }
//     state = updated;
//     _save();
//   }
// }

// final statsProvider =
//     StateNotifierProvider<StatsNotifier, GameStats>(
//   (ref) => StatsNotifier(),
// );

// // ============================================================
// // 6. THEMES & DESIGN TOKENS
// // ============================================================

// class ChessTheme {
//   // Board colors per theme
//   static const _boardThemes = {
//     BoardTheme.classic: [Color(0xFFF0D9B5), Color(0xFFB58863)],
//     BoardTheme.walnut: [Color(0xFFDEB887), Color(0xFF8B4513)],
//     BoardTheme.marble: [Color(0xFFE8E8E8), Color(0xFF708090)],
//     BoardTheme.emerald: [Color(0xFFADEFAD), Color(0xFF2E7D32)],
//     BoardTheme.midnight: [Color(0xFF4A5568), Color(0xFF1A202C)],
//   };

//   static Color lightSquare(BoardTheme t) => _boardThemes[t]![0];
//   static Color darkSquare(BoardTheme t) => _boardThemes[t]![1];

//   static ThemeData dark(BoardTheme boardTheme) {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: const ColorScheme.dark(
//         primary: Color(0xFFFFD700),
//         secondary: Color(0xFFB8860B),
//         surface: Color(0xFF1A1A2E),
//         background: Color(0xFF0F0F1A),
//         onPrimary: Color(0xFF0F0F1A),
//         onSurface: Color(0xFFE0E0E0),
//       ),
//       scaffoldBackgroundColor: const Color(0xFF0F0F1A),
//       textTheme: GoogleFonts.playfairDisplayTextTheme(
//         ThemeData.dark().textTheme,
//       ).copyWith(
//         bodyMedium: GoogleFonts.inter(color: const Color(0xFFE0E0E0)),
//         bodySmall: GoogleFonts.inter(color: const Color(0xFFB0B0B0)),
//       ),
// cardTheme: CardThemeData(
//   color: const Color(0xFF1E1E32),
//   elevation: 8,
//   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFFFD700),
//           foregroundColor: const Color(0xFF0F0F1A),
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           textStyle: GoogleFonts.playfairDisplay(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }

//   static ThemeData light(BoardTheme boardTheme) {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: const ColorScheme.light(
//         primary: Color(0xFF8B4513),
//         secondary: Color(0xFFB58863),
//         surface: Color(0xFFFAF7F0),
//         background: Color(0xFFF5F0E8),
//         onPrimary: Color(0xFFFFFFF0),
//         onSurface: Color(0xFF2C1810),
//       ),
//       scaffoldBackgroundColor: const Color(0xFFF5F0E8),
//       textTheme: GoogleFonts.playfairDisplayTextTheme(
//         ThemeData.light().textTheme,
//       ).copyWith(
//         bodyMedium: GoogleFonts.inter(color: const Color(0xFF2C1810)),
//         bodySmall: GoogleFonts.inter(color: const Color(0xFF5C3D2E)),
//       ),
//  cardTheme: CardThemeData(
//   color: const Color.fromARGB(255, 119, 119, 217),
//   elevation: 8,
//   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF8B4513),
//           foregroundColor: const Color(0xFFFFFFF0),
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           textStyle: GoogleFonts.playfairDisplay(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // 7. APP WIDGET
// // ============================================================

// // class ChessApp extends ConsumerWidget {
// //   const ChessApp({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final settings = ref.watch(settingsProvider);
// //     return MaterialApp(
// //       title: 'Chess with Claude',
// //       debugShowCheckedModeBanner: false,
// //       theme: settings.isDarkMode
// //           ? ChessTheme.dark(settings.boardTheme)
// //           : ChessTheme.light(settings.boardTheme),
// //       initialRoute: '/',
// //       routes: {
// //         '/': (_) => const SplashScreen(),
// //         '/home': (_) => const HomeScreen(),
// //         '/game': (_) => const GameScreen(),
// //         '/settings': (_) => const SettingsScreen(),
// //         '/stats': (_) => const StatsScreen(),
// //         '/about': (_) => const AboutScreen(),
// //       },
// //     );
// //   }
// // }

// class ChessApp extends ConsumerWidget {
//   const ChessApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final settings = ref.watch(settingsProvider);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Chess App',
//       theme: ThemeData(
//         brightness:
//             settings.isDarkMode ? Brightness.dark : Brightness.light,
//         useMaterial3: true,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (_) => const SplashScreen(),
//         '/home': (_) => const HomeScreen(),
//         '/game': (_) => const GameScreen(),
//         '/settings': (_) => const SettingsScreen(),
//         '/stats': (_) => const StatsScreen(),
//         '/about': (_) => const AboutScreen(),
//       },
//     );
//   }
// }
// // ============================================================
// // 8. SCREENS
// // ============================================================

// // --- SPLASH SCREEN ---



// final supabase = Supabase.instance.client;


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _goNext();
//   }

//   Future<void> _goNext() async {
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     final session = supabase.auth.currentSession;

//     if (session != null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const HomeScreen(),
//         ),
//       );
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const AuthScreen(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/i.jpg"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           color: Colors.black.withOpacity(0.4),
//           child: const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Icon(
//                 //   Icons.lock_outline,
//                 //   size: 90,
//                 //   color: Colors.white,
//                 // ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Welcome to ChessP",
//                   style: TextStyle(
//                     fontSize: 34,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool isLogin = true;
//   bool obscurePassword = true;
//   bool obscureConfirmPassword = true;
//   bool loading = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showMessage("Please fill all fields");
//       return;
//     }

//     setState(() {
//       loading = true;
//     });

//     try {
//       await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (!mounted) return;

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const HomeScreen(),
//         ),
//       );
//     } on AuthException catch (e) {
//       _showMessage(e.message);
//     } catch (_) {
//       _showMessage("Something went wrong");
//     } finally {
//       if (mounted) {
//         setState(() {
//           loading = false;
//         });
//       }
//     }
//   }

//   Future<void> _signup() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//     final confirmPassword = confirmPasswordController.text.trim();

//     if (email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       _showMessage("Please fill all fields");
//       return;
//     }

//     if (password != confirmPassword) {
//       _showMessage("Passwords do not match");
//       return;
//     }

//     if (password.length < 6) {
//       _showMessage("Password must be at least 6 characters");
//       return;
//     }

//     setState(() {
//       loading = true;
//     });

//     try {
//       final res = await supabase.auth.signUp(
//         email: email,
//         password: password,
//       );

//       if (!mounted) return;

//       if (res.session != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (_) => const HomeScreen(),
//           ),
//         );
//       } else {
//         _showMessage(
//           "Signup successful. Check your email.",
//         );
//       }
//     } on AuthException catch (e) {
//       _showMessage(e.message);
//     } catch (_) {
//       _showMessage("Something went wrong");
//     } finally {
//       if (mounted) {
//         setState(() {
//           loading = false;
//         });
//       }
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
// return Scaffold(
//   body: Container(
//     width: double.infinity,

//     // =========================
//     // BACKGROUND GRADIENT + IMAGE
//     // =========================
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [
//           Color(0xFF0F2027),
//           Color(0xFF203A43),
//           Color(0xFF2C5364),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),

//     child: Stack(
//       children: [

//         // Background image overlay
//         Opacity(
//           opacity: 0.25,
//           child: Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/i.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),

//         // =========================
//         // MAIN CONTENT
//         // =========================
//         Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),

//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 400),

//               child: Card(
//                 elevation: 20,
//                 color: Colors.white.withOpacity(0.15),
//                 shadowColor: Colors.black45,

//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(28),
//                 ),

//                 child: Padding(
//                   padding: const EdgeInsets.all(26),

//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [

//                       // =========================
//                       // TITLE
//                       // =========================
//                       Text(
//                         isLogin ? "Welcome Back" : "Create Account",
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       Text(
//                         isLogin
//                             ? "Login to continue your chess journey"
//                             : "Sign up and start playing",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.7),
//                           fontSize: 14,
//                         ),
//                       ),

//                       const SizedBox(height: 30),

//                       // =========================
//                       // EMAIL FIELD
//                       // =========================
//                       _buildInput(
//                         controller: emailController,
//                         icon: Icons.email_outlined,
//                         label: "Email",
//                         obscure: false,
//                       ),

//                       const SizedBox(height: 16),

//                       // =========================
//                       // PASSWORD FIELD
//                       // =========================
//                       _buildInput(
//                         controller: passwordController,
//                         icon: Icons.lock_outline,
//                         label: "Password",
//                         obscure: obscurePassword,
//                         suffix: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               obscurePassword = !obscurePassword;
//                             });
//                           },
//                           icon: Icon(
//                             obscurePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // =========================
//                       // CONFIRM PASSWORD
//                       // =========================
//                       if (!isLogin)
//                         _buildInput(
//                           controller: confirmPasswordController,
//                           icon: Icons.lock_reset_outlined,
//                           label: "Confirm Password",
//                           obscure: obscureConfirmPassword,
//                           suffix: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 obscureConfirmPassword =
//                                     !obscureConfirmPassword;
//                               });
//                             },
//                             icon: Icon(
//                               obscureConfirmPassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),

//                       if (!isLogin)
//                         const SizedBox(height: 16),

//                       // =========================
//                       // BUTTON
//                       // =========================
//                       SizedBox(
//                         width: double.infinity,
//                         height: 52,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           onPressed: loading
//                               ? null
//                               : (isLogin ? _login : _signup),
//                           child: loading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : Text(
//                                   isLogin ? "Login" : "Sign Up",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 18),

//                       // =========================
//                       // SWITCH LOGIN/SIGNUP
//                       // =========================
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             isLogin = !isLogin;
//                             confirmPasswordController.clear();
//                           });
//                         },
//                         child: Text(
//                           isLogin
//                               ? "Don't have an account? Sign Up"
//                               : "Already have an account? Login",
//                           style: const TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );

//  }
//  Widget _buildInput({
//   required TextEditingController controller,
//   required IconData icon,
//   required String label,
//   required bool obscure,
//   Widget? suffix,
// }) {
//   return TextField(
//     controller: controller,
//     obscureText: obscure,
//     style: const TextStyle(color: Colors.white),

//     decoration: InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),

//       prefixIcon: Icon(icon, color: Colors.white70),
//       suffixIcon: suffix,

//       filled: true,
//       fillColor: Colors.white.withOpacity(0.08),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: Colors.white.withOpacity(0.2),
//         ),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.white),
//       ),
//     ),
//   );
// }
// }


// // --- HOME SCREEN ---
// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cs = Theme.of(context).colorScheme;
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background pattern
//           Positioned.fill(
//             child: CustomPaint(painter: _ChessBoardBackgroundPainter(cs)),
//           ),
//           // Content
//           SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '♔ Chess',
//                         style: GoogleFonts.playfairDisplay(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w900,
//                           color: cs.primary,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           _IconBtn(
//                             icon: Icons.person,
//                             onTap: () =>
//                                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ChessappProfile()))
                                                        
//                                 // Navigator.pushNamed(context, '/stats'),
//                           ),
//                           const SizedBox(width: 8),
//                           _IconBtn(
//                             icon: Icons.settings,
//                             onTap: () =>

//                             // Navigator.push(
// //   context,
// //   MaterialPageRoute(
// //     builder: (context) => ChessappProfile(),
// //   ),
// // ),
//                                 Navigator.pushNamed(context, '/settings'),
//                           ),
//                           const SizedBox(width: 8),
//                           // _IconBtn(
//                           //   icon: Icons.info_outline,
//                           //   onTap: () =>
//                           //       Navigator.pushNamed(context, '/about'),
//                           // ),
//                                        _IconBtn(
//                             icon: Icons.person,
//                             onTap: () =>
//                                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>GameFriendsApp()))
                                                        
//                                 // Navigator.pushNamed(context, '/stats'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         // Hero piece
//                         Container(
//                           width: size.width * 0.45,
//                           height: size.width * 0.45,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: RadialGradient(
//                               colors: [
//                                 cs.primary.withOpacity(0.3),
//                                 cs.primary.withOpacity(0),
//                               ],
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               '♛',
//                               style: TextStyle(
//                                 fontSize: size.width * 0.3,
//                                 color: cs.primary,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),
//                         // Game mode buttons
//                         _HomeModeCard(
//                           title: 'Player vs Player',
//                           subtitle: 'Two players, one board',
//                           icon: '♟♟',
//                           onTap: () => _showGameSetup(
//                               context, ref, GameMode.pvp),
//                         ),
//                         const SizedBox(height: 16),
//                         _HomeModeCard(
//                           title: 'vs Computer',
//                           subtitle: 'Challenge the AI engine',
//                           icon: '♟⚙',
//                           onTap: () => _showGameSetup(
//                               context, ref, GameMode.pvc),
//                         ),
//                         const SizedBox(height: 32),
//                         // Quick stats
//                         Consumer(
//                           builder: (_, ref, __) {
//                             final stats = ref.watch(statsProvider);
//                             return _StatsRow(stats: stats);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showGameSetup(BuildContext ctx, WidgetRef ref, GameMode mode) {
//     showModalBottomSheet(
//       context: ctx,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _GameSetupSheet(mode: mode),
//     );
//   }
// }

// class _ChessBoardBackgroundPainter extends CustomPainter {
//   final ColorScheme cs;
//   _ChessBoardBackgroundPainter(this.cs);

//   @override
//   void paint(Canvas canvas, Size size) {
//     const cellSize = 48.0;
//     final paint = Paint();
//     for (int r = 0; r < (size.height / cellSize).ceil() + 1; r++) {
//       for (int c = 0; c < (size.width / cellSize).ceil() + 1; c++) {
//         paint.color = (r + c).isEven
//             ? cs.primary.withOpacity(0.04)
//             : cs.primary.withOpacity(0.01);
//         canvas.drawRect(
//           Rect.fromLTWH(
//               c * cellSize, r * cellSize, cellSize, cellSize),
//           paint,
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }

// class _IconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;

//   const _IconBtn({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: cs.surface,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: cs.primary.withOpacity(0.2)),
//         ),
//         child: Icon(icon, size: 20, color: cs.onSurface),
//       ),
//     );
//   }
// }

// class _HomeModeCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String icon;
//   final VoidCallback onTap;

//   const _HomeModeCard({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: cs.surface,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: cs.primary.withOpacity(0.15)),
//           boxShadow: [
//             BoxShadow(
//               color: cs.primary.withOpacity(0.05),
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             Text(icon, style: const TextStyle(fontSize: 36)),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: cs.onSurface,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: GoogleFonts.inter(
//                       fontSize: 13,
//                       color: cs.onSurface.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios,
//                 size: 16, color: cs.primary),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StatsRow extends StatelessWidget {
//   final GameStats stats;
//   const _StatsRow({required this.stats});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: cs.primary.withOpacity(0.15)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _StatItem(label: 'Wins', value: stats.wins.toString(),
//               color: Colors.green),
//           _StatItem(label: 'Draws', value: stats.draws.toString(),
//               color: Colors.orange),
//           _StatItem(label: 'Losses', value: stats.losses.toString(),
//               color: Colors.red),
//           _StatItem(label: 'Games', value: stats.totalGames.toString(),
//               color: cs.primary),
//         ],
//       ),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const _StatItem(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(value,
//             style: GoogleFonts.playfairDisplay(
//                 fontSize: 24, fontWeight: FontWeight.w700, color: color)),
//         Text(label,
//             style: GoogleFonts.inter(
//                 fontSize: 11,
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                 letterSpacing: 1)),
//       ],
//     );
//   }
// }

// // Game Setup Bottom Sheet
// class _GameSetupSheet extends ConsumerStatefulWidget {
//   final GameMode mode;
//   const _GameSetupSheet({required this.mode});

//   @override
//   ConsumerState<_GameSetupSheet> createState() => _GameSetupSheetState();
// }

// class _GameSetupSheetState extends ConsumerState<_GameSetupSheet> {
//   AIDifficulty _difficulty = AIDifficulty.medium;
//   PieceColor _playerColor = PieceColor.white;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final settings = ref.watch(settingsProvider);

//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: cs.onSurface.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             widget.mode == GameMode.pvp
//                 ? 'Player vs Player'
//                 : 'vs Computer',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: cs.onSurface,
//             ),
//           ),
//           const SizedBox(height: 24),
//           if (widget.mode == GameMode.pvc) ...[
//             Text('Difficulty',
//                 style: GoogleFonts.inter(
//                     fontSize: 12,
//                     letterSpacing: 2,
//                     color: cs.onSurface.withOpacity(0.5))),
//             const SizedBox(height: 12),
//             Row(
//               children: AIDifficulty.values.map((d) {
//                 final isSelected = _difficulty == d;
//                 return Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: GestureDetector(
//                       onTap: () => setState(() => _difficulty = d),
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? cs.primary
//                               : cs.surface,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? cs.primary
//                                 : cs.onSurface.withOpacity(0.2),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             d.name[0].toUpperCase() + d.name.substring(1),
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w600,
//                               color: isSelected
//                                   ? cs.onPrimary
//                                   : cs.onSurface,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 24),
//             Text('Play as',
//                 style: GoogleFonts.inter(
//                     fontSize: 12,
//                     letterSpacing: 2,
//                     color: cs.onSurface.withOpacity(0.5))),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 _ColorChoice(
//                   label: '♔ White',
//                   selected: _playerColor == PieceColor.white,
//                   onTap: () =>
//                       setState(() => _playerColor = PieceColor.white),
//                 ),
//                 const SizedBox(width: 12),
//                 _ColorChoice(
//                   label: '♚ Black',
//                   selected: _playerColor == PieceColor.black,
//                   onTap: () =>
//                       setState(() => _playerColor = PieceColor.black),
//                 ),
//               ],
//             ),
//           ],
//           const SizedBox(height: 32),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 ref.read(gameProvider.notifier).newGame(
//                       mode: widget.mode,
//                       difficulty: _difficulty,
//                       playerColor: _playerColor,
//                       timerEnabled: settings.timerEnabled,
//                     );
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/game');
//               },
//               child: const Text('Start Game'),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }

// class _ColorChoice extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _ColorChoice(
//       {required this.label,
//       required this.selected,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           decoration: BoxDecoration(
//             color: selected ? cs.primary : cs.surface,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: selected ? cs.primary : cs.onSurface.withOpacity(0.2),
//             ),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: GoogleFonts.inter(
//                 fontWeight: FontWeight.w700,
//                 color: selected ? cs.onPrimary : cs.onSurface,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- GAME SCREEN ---
// class GameScreen extends ConsumerStatefulWidget {
//   const GameScreen({super.key});

//   @override
//   ConsumerState<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends ConsumerState<GameScreen> {
//   bool _resultHandled = false;

//   @override
//   Widget build(BuildContext context) {
//     final game = ref.watch(gameProvider);
//     final settings = ref.watch(settingsProvider);

//     // Show game over dialog
//     if (game.result != GameResult.inProgress && !_resultHandled) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!_resultHandled) {
//           _resultHandled = true;
//           _showGameOver(context, game, ref);
//         }
//       });
//     }
//     if (game.result == GameResult.inProgress) _resultHandled = false;

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _GameTopBar(game: game),
//             // Black timer
//             if (game.timerEnabled)
//               _TimerBar(
//                 seconds: game.blackTimeSeconds,
//                 isActive: game.currentTurn == PieceColor.black,
//                 color: PieceColor.black,
//               ),
//             // Captured by white
//             _CapturedPiecesBar(
//               pieces: game.capturedByWhite,
//               label: 'White captured',
//             ),
//             // Board
//             Expanded(
//               child: Center(
//                 child: _ChessBoardWidget(
//                   game: game,
//                   boardTheme: settings.boardTheme,
//                 ),
//               ),
//             ),
//             // Captured by black
//             _CapturedPiecesBar(
//               pieces: game.capturedByBlack,
//               label: 'Black captured',
//             ),
//             // White timer
//             if (game.timerEnabled)
//               _TimerBar(
//                 seconds: game.whiteTimeSeconds,
//                 isActive: game.currentTurn == PieceColor.white,
//                 color: PieceColor.white,
//               ),
//             _GameBottomBar(game: game),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showGameOver(
//       BuildContext context, GameState game, WidgetRef ref) {
//     // Record stats
//     ref
//         .read(statsProvider.notifier)
//         .recordResult(game.result, game.playerColor);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => _GameOverDialog(game: game),
//     );
//   }
// }

// class _GameTopBar extends ConsumerWidget {
//   final GameState game;
//   const _GameTopBar({required this.game});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cs = Theme.of(context).colorScheme;
//     String turnText = '';
//     if (game.result == GameResult.inProgress) {
//       final who = game.currentTurn == PieceColor.white ? 'White' : 'Black';
//       turnText = game.isAIThinking
//           ? '🤔 AI thinking...'
//           : '$who to move${game.isCheck ? ' — CHECK!' : ''}';
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_back, color: cs.onBackground),
//             onPressed: () => Navigator.pop(context),
//           ),
//           Expanded(
//             child: Text(
//               turnText,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: game.isCheck ? Colors.red : cs.onBackground,
//               ),
//             ),
//           ),
//           IconButton(
//             icon:
//                 Icon(Icons.menu_book_outlined, color: cs.onBackground),
//             onPressed: () => _showMoveHistory(context, game),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMoveHistory(BuildContext context, GameState game) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => _MoveHistorySheet(moves: game.moveHistory),
//     );
//   }
// }

// class _MoveHistorySheet extends StatelessWidget {
//   final List<ChessMove> moves;
//   const _MoveHistorySheet({required this.moves});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       color: cs.surface,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text('Move History',
//               style: GoogleFonts.playfairDisplay(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: cs.onSurface)),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: (moves.length / 2).ceil(),
//               itemBuilder: (_, i) {
//                 final w = i * 2 < moves.length ? moves[i * 2].pgn : '';
//                 final b =
//                     i * 2 + 1 < moves.length ? moves[i * 2 + 1].pgn : '';
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                           width: 32,
//                           child: Text('${i + 1}.',
//                               style: GoogleFonts.inter(
//                                   color: cs.onSurface.withOpacity(0.5)))),
//                       Expanded(
//                           child: Text(w,
//                               style: GoogleFonts.robotoMono(
//                                   color: cs.onSurface))),
//                       Expanded(
//                           child: Text(b,
//                               style: GoogleFonts.robotoMono(
//                                   color: cs.onSurface))),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TimerBar extends StatelessWidget {
//   final int seconds;
//   final bool isActive;
//   final PieceColor color;

//   const _TimerBar(
//       {required this.seconds,
//       required this.isActive,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final mins = seconds ~/ 60;
//     final secs = seconds % 60;
//     final label = color == PieceColor.white ? '♔ White' : '♚ Black';
//     final isLow = seconds < 60;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isActive
//             ? (isLow ? Colors.red.withOpacity(0.2) : cs.primary.withOpacity(0.15))
//             : cs.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isActive ? cs.primary : Colors.transparent,
//           width: 1.5,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: GoogleFonts.inter(
//                   color: cs.onSurface, fontWeight: FontWeight.w600)),
//           Text(
//             '$mins:${secs.toString().padLeft(2, '0')}',
//             style: GoogleFonts.robotoMono(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: isLow ? Colors.red : cs.onSurface,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CapturedPiecesBar extends StatelessWidget {
//   final List<ChessPiece> pieces;
//   final String label;

//   const _CapturedPiecesBar(
//       {required this.pieces, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     if (pieces.isEmpty) return const SizedBox(height: 8);
//     final cs = Theme.of(context).colorScheme;

//     // Sort by value descending
//     final sorted = List<ChessPiece>.from(pieces)
//       ..sort((a, b) => b.value.compareTo(a.value));

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
//       child: Row(
//         children: [
//           Text(
//             sorted.map((p) => p.symbol).join(' '),
//             style: TextStyle(
//                 fontSize: 14, color: cs.onBackground.withOpacity(0.7)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GameBottomBar extends ConsumerWidget {
//   final GameState game;
//   const _GameBottomBar({required this.game});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cs = Theme.of(context).colorScheme;
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _BottomBtn(
//             icon: Icons.undo,
//             label: 'Undo',
//             onTap: () => ref.read(gameProvider.notifier).undoMove(),
//           ),
//           _BottomBtn(
//             icon: Icons.refresh,
//             label: 'Restart',
//             onTap: () => _confirmRestart(context, ref),
//           ),
//           _BottomBtn(
//             icon: Icons.share,
//             label: 'PGN',
//             onTap: () {
//               final pgn = ref.read(gameProvider.notifier).getPGN();
//               _showPGN(context, pgn);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmRestart(BuildContext ctx, WidgetRef ref) {
//     showDialog(
//       context: ctx,
//       builder: (_) => AlertDialog(
//         title: const Text('Restart Game?'),
//         content: const Text('Are you sure you want to restart?'),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               final g = ref.read(gameProvider);
//               ref.read(gameProvider.notifier).newGame(
//                     mode: g.gameMode,
//                     difficulty: g.aiDifficulty,
//                     playerColor: g.playerColor,
//                     timerEnabled: g.timerEnabled,
//                   );
//             },
//             child: const Text('Restart'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPGN(BuildContext ctx, String pgn) {
//     showDialog(
//       context: ctx,
//       builder: (_) => AlertDialog(
//         title: const Text('PGN Export'),
//         content: SelectableText(
//             pgn.isEmpty ? '(No moves yet)' : pgn,
//             style: GoogleFonts.robotoMono(fontSize: 13)),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Close')),
//         ],
//       ),
//     );
//   }
// }

// class _BottomBtn extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _BottomBtn(
//       {required this.icon, required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: cs.surface,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: cs.primary.withOpacity(0.2)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 20, color: cs.primary),
//             const SizedBox(height: 4),
//             Text(label,
//                 style: GoogleFonts.inter(
//                     fontSize: 11,
//                     color: cs.onSurface,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- CHESS BOARD WIDGET ---
// class _ChessBoardWidget extends ConsumerWidget {
//   final GameState game;
//   final BoardTheme boardTheme;

//   const _ChessBoardWidget({required this.game, required this.boardTheme});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     final boardSize = size.width - 32;
//     final cellSize = boardSize / 8;

//     return Stack(
//       children: [
//         // Board
//         Container(
//           width: boardSize,
//           height: boardSize,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.4),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               )
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 8),
//               itemCount: 64,
//               itemBuilder: (_, index) {
//                 final row = index ~/ 8;
//                 final col = index % 8;
//                 final pos = Position(row, col);
//                 return _ChessSquare(
//                   pos: pos,
//                   game: game,
//                   boardTheme: boardTheme,
//                   cellSize: cellSize,
//                 );
//               },
//             ),
//           ),
//         ),
//         // Coordinates
//         ...List.generate(8, (i) {
//           final file =
//               String.fromCharCode(97 + i); // a-h
//           final rank = (8 - i).toString();
//           return [
//             Positioned(
//               left: i * cellSize + cellSize - 10,
//               bottom: 2,
//               child: Text(file,
//                   style: TextStyle(
//                       fontSize: 9,
//                       color: (i.isEven
//                               ? ChessTheme.lightSquare(boardTheme)
//                               : ChessTheme.darkSquare(boardTheme))
//                           .withOpacity(0.7))),
//             ),
//             Positioned(
//               top: i * cellSize + 2,
//               left: 2,
//               child: Text(rank,
//                   style: TextStyle(
//                       fontSize: 9,
//                       color: (i.isEven
//                               ? ChessTheme.lightSquare(boardTheme)
//                               : ChessTheme.darkSquare(boardTheme))
//                           .withOpacity(0.7))),
//             ),
//           ];
//         }).expand((x) => x),

//         // Promotion dialog overlay
//         if (game.promotionPending && game.promotionPos != null)
//           Positioned.fill(
//             child: _PromotionDialog(
//               color: game.currentTurn == PieceColor.white
//                   ? PieceColor.black
//                   : PieceColor.white,
//               onSelect: (type) =>
//                   ref.read(gameProvider.notifier).completePromotion(type),
//             ),
//           ),

//         // AI Thinking overlay
//         if (game.isAIThinking)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black26,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _ChessSquare extends ConsumerWidget {
//   final Position pos;
//   final GameState game;
//   final BoardTheme boardTheme;
//   final double cellSize;

//   const _ChessSquare({
//     required this.pos,
//     required this.game,
//     required this.boardTheme,
//     required this.cellSize,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isLight = (pos.row + pos.col).isEven;
//     final piece = game.board[pos.row][pos.col];
//     final isSelected = game.selectedPos == pos;
//     final isLegalMove = game.legalMoves.contains(pos);
//     final isLastMoveFrom = game.lastMoveFrom == pos;
//     final isLastMoveTo = game.lastMoveTo == pos;
//     final isKingInCheck = piece != null &&
//         piece.type == PieceType.king &&
//         piece.color == game.currentTurn &&
//         game.isCheck;

//     Color squareColor =
//         isLight ? ChessTheme.lightSquare(boardTheme) : ChessTheme.darkSquare(boardTheme);

//     if (isSelected) {
//       squareColor =
//           Color.lerp(squareColor, Colors.yellow, 0.55)!;
//     } else if (isLastMoveFrom || isLastMoveTo) {
//       squareColor = Color.lerp(squareColor, Colors.yellow, 0.35)!;
//     }
//     if (isKingInCheck) {
//       squareColor = Color.lerp(squareColor, Colors.red, 0.5)!;
//     }

//     return GestureDetector(
//       onTap: () => ref.read(gameProvider.notifier).selectSquare(pos),
//       child: Container(
//         color: squareColor,
//         child: Stack(
//           children: [
//             // Legal move indicator
//             if (isLegalMove)
//               Center(
//                 child: piece != null
//                     ? Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.green.withOpacity(0.7),
//                             width: 3,
//                           ),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       )
//                     : Container(
//                         width: cellSize * 0.28,
//                         height: cellSize * 0.28,
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.45),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//               ),
//             // Piece
//             if (piece != null)
//               Center(
//                 child: AnimatedScale(
//                   scale: isSelected ? 1.1 : 1.0,
//                   duration: const Duration(milliseconds: 150),
//                   child: Text(
//                     piece.symbol,
//                     style: TextStyle(
//                       fontSize: cellSize * 0.72,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.3),
//                           offset: const Offset(1, 2),
//                           blurRadius: 3,
//                         )
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PromotionDialog extends StatelessWidget {
//   final PieceColor color;
//   final ValueChanged<PieceType> onSelect;

//   const _PromotionDialog({required this.color, required this.onSelect});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final pieces = [
//       PieceType.queen,
//       PieceType.rook,
//       PieceType.bishop,
//       PieceType.knight,
//     ];
//     return Container(
//       color: Colors.black54,
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: cs.surface,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Promote Pawn',
//                   style: GoogleFonts.playfairDisplay(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: cs.onSurface)),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: pieces.map((type) {
//                   final piece =
//                       ChessPiece(type: type, color: color);
//                   return GestureDetector(
//                     onTap: () => onSelect(type),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: cs.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: cs.primary.withOpacity(0.3)),
//                       ),
//                       child: Text(piece.symbol,
//                           style: const TextStyle(fontSize: 40)),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GameOverDialog extends ConsumerWidget {
//   final GameState game;
//   const _GameOverDialog({required this.game});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cs = Theme.of(context).colorScheme;

//     String title, subtitle, emoji;
//     if (game.result == GameResult.whiteWins) {
//       title = 'White Wins!';
//       subtitle = 'Checkmate — White is victorious';
//       emoji = '♔';
//     } else if (game.result == GameResult.blackWins) {
//       title = 'Black Wins!';
//       subtitle = 'Checkmate — Black is victorious';
//       emoji = '♚';
//     } else {
//       title = 'Draw!';
//       subtitle = 'The game ends in a draw';
//       emoji = '🤝';
//     }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: Padding(
//         padding: const EdgeInsets.all(28),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(emoji, style: const TextStyle(fontSize: 64)),
//             const SizedBox(height: 12),
//             Text(title,
//                 style: GoogleFonts.playfairDisplay(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w900,
//                     color: cs.primary)),
//             const SizedBox(height: 8),
//             Text(subtitle,
//                 style: GoogleFonts.inter(
//                     color: cs.onSurface.withOpacity(0.7)),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 12),
//             Text(
//               'Moves: ${game.moveHistory.length}',
//               style: GoogleFonts.robotoMono(
//                   color: cs.onSurface.withOpacity(0.5)),
//             ),
//             const SizedBox(height: 28),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   ref.read(gameProvider.notifier).newGame(
//                         mode: game.gameMode,
//                         difficulty: game.aiDifficulty,
//                         playerColor: game.playerColor,
//                         timerEnabled: game.timerEnabled,
//                       );
//                 },
//                 child: const Text('Play Again'),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: const Text('Back to Menu'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- SETTINGS SCREEN ---
// class SettingsScreen extends ConsumerWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final settings = ref.watch(settingsProvider);
//     final notifier = ref.read(settingsProvider.notifier);
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings',
//             style: GoogleFonts.playfairDisplay(
//                 fontWeight: FontWeight.w700)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _SettingsSection(title: 'APPEARANCE', children: [
//             _ToggleTile(
//               title: 'Dark Mode',
//               subtitle: 'Switch between dark and light theme',
//               value: settings.isDarkMode,
//               onChanged: notifier.setDarkMode,
//             ),
//           ]),
//           const SizedBox(height: 16),
//           _SettingsSection(title: 'BOARD THEME', children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: BoardTheme.values.map((t) {
//                   final isSelected = settings.boardTheme == t;
//                   return GestureDetector(
//                     onTap: () => notifier.setBoardTheme(t),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 56,
//                           height: 56,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: isSelected
//                                   ? cs.primary
//                                   : Colors.transparent,
//                               width: 2,
//                             ),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: GridView.builder(
//                               physics:
//                                   const NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 4),
//                               itemCount: 16,
//                               itemBuilder: (_, i) => Container(
//                                 color: (i ~/ 4 + i % 4).isEven
//                                     ? ChessTheme.lightSquare(t)
//                                     : ChessTheme.darkSquare(t),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           t.name[0].toUpperCase() + t.name.substring(1),
//                           style: GoogleFonts.inter(
//                               fontSize: 11,
//                               color: isSelected
//                                   ? cs.primary
//                                   : cs.onSurface.withOpacity(0.7)),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ]),
//           const SizedBox(height: 16),
//           _SettingsSection(title: 'GAME', children: [
//             _ToggleTile(
//               title: 'Game Timer',
//               subtitle: 'Enable countdown timer for each player',
//               value: settings.timerEnabled,
//               onChanged: notifier.setTimerEnabled,
//             ),
//             _ToggleTile(
//               title: 'Sound Effects',
//               subtitle: 'Play sounds for moves and captures',
//               value: settings.soundEnabled,
//               onChanged: notifier.setSoundEnabled,
//             ),
//           ]),
//           const SizedBox(height: 16),
//           _SettingsSection(title: 'AI', children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Default Difficulty',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w600,
//                           color: cs.onSurface)),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: AIDifficulty.values.map((d) {
//                       final isSelected =
//                           settings.defaultDifficulty == d;
//                       return Expanded(
//                         child: Padding(
//                           padding:
//                               const EdgeInsets.symmetric(horizontal: 4),
//                           child: GestureDetector(
//                             onTap: () =>
//                                 notifier.setDefaultDifficulty(d),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? cs.primary
//                                     : cs.surface,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? cs.primary
//                                       : cs.onSurface.withOpacity(0.2),
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   d.name[0].toUpperCase() +
//                                       d.name.substring(1),
//                                   style: GoogleFonts.inter(
//                                     fontWeight: FontWeight.w600,
//                                     color: isSelected
//                                         ? cs.onPrimary
//                                         : cs.onSurface,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }

// class _SettingsSection extends StatelessWidget {
//   final String title;
//   final List<Widget> children;

//   const _SettingsSection(
//       {required this.title, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             title,
//             style: GoogleFonts.inter(
//                 fontSize: 11,
//                 letterSpacing: 2,
//                 fontWeight: FontWeight.w600,
//                 color: cs.primary),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: cs.surface,
//             borderRadius: BorderRadius.circular(16),
//             border:
//                 Border.all(color: cs.primary.withOpacity(0.1)),
//           ),
//           child: Column(children: children),
//         ),
//       ],
//     );
//   }
// }

// class _ToggleTile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const _ToggleTile({
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return ListTile(
//       title: Text(title,
//           style: GoogleFonts.inter(
//               fontWeight: FontWeight.w600, color: cs.onSurface)),
//       subtitle: Text(subtitle,
//           style: GoogleFonts.inter(
//               fontSize: 12,
//               color: cs.onSurface.withOpacity(0.6))),
//       trailing: Switch.adaptive(
//         value: value,
//         onChanged: onChanged,
//         activeColor: cs.primary,
//       ),
//     );
//   }
// }

// // --- STATS SCREEN ---
// class StatsScreen extends ConsumerWidget {
//   const StatsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final stats = ref.watch(statsProvider);
//     final cs = Theme.of(context).colorScheme;

//     final winRate = stats.totalGames > 0
//         ? (stats.wins / stats.totalGames * 100).toStringAsFixed(1)
//         : '0.0';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Statistics',
//             style: GoogleFonts.playfairDisplay(
//                 fontWeight: FontWeight.w700)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Big stat card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [cs.primary, cs.secondary],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Column(
//                 children: [
//                   Text('Win Rate',
//                       style: GoogleFonts.inter(
//                           color: cs.onPrimary.withOpacity(0.8),
//                           fontSize: 14,
//                           letterSpacing: 2)),
//                   const SizedBox(height: 8),
//                   Text('$winRate%',
//                       style: GoogleFonts.playfairDisplay(
//                           color: cs.onPrimary,
//                           fontSize: 56,
//                           fontWeight: FontWeight.w900)),
//                   Text('${stats.totalGames} games played',
//                       style: GoogleFonts.inter(
//                           color: cs.onPrimary.withOpacity(0.8))),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Breakdown
//             Row(
//               children: [
//                 Expanded(
//                   child: _StatCard(
//                     label: 'Wins',
//                     value: stats.wins,
//                     color: Colors.green,
//                     icon: '🏆',
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _StatCard(
//                     label: 'Draws',
//                     value: stats.draws,
//                     color: Colors.orange,
//                     icon: '🤝',
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _StatCard(
//                     label: 'Losses',
//                     value: stats.losses,
//                     color: Colors.red,
//                     icon: '💔',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             // Progress bar
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: cs.surface,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Performance',
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w700,
//                           color: cs.onSurface)),
//                   const SizedBox(height: 16),
//                   if (stats.totalGames > 0) ...[
//                     _ProgressBar(
//                         label: 'Wins',
//                         value: stats.wins / stats.totalGames,
//                         color: Colors.green),
//                     const SizedBox(height: 8),
//                     _ProgressBar(
//                         label: 'Draws',
//                         value: stats.draws / stats.totalGames,
//                         color: Colors.orange),
//                     const SizedBox(height: 8),
//                     _ProgressBar(
//                         label: 'Losses',
//                         value: stats.losses / stats.totalGames,
//                         color: Colors.red),
//                   ] else
//                     Text('No games played yet',
//                         style: GoogleFonts.inter(
//                             color: cs.onSurface.withOpacity(0.5))),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String label;
//   final int value;
//   final Color color;
//   final String icon;

//   const _StatCard(
//       {required this.label,
//       required this.value,
//       required this.color,
//       required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Text(icon, style: const TextStyle(fontSize: 28)),
//           const SizedBox(height: 8),
//           Text(value.toString(),
//               style: GoogleFonts.playfairDisplay(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                   color: color)),
//           Text(label,
//               style: GoogleFonts.inter(
//                   fontSize: 12,
//                   color: cs.onSurface.withOpacity(0.6))),
//         ],
//       ),
//     );
//   }
// }

// class _ProgressBar extends StatelessWidget {
//   final String label;
//   final double value;
//   final Color color;

//   const _ProgressBar(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Row(
//       children: [
//         SizedBox(
//             width: 52,
//             child: Text(label,
//                 style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: cs.onSurface.withOpacity(0.7)))),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: value,
//               backgroundColor: cs.onSurface.withOpacity(0.1),
//               valueColor: AlwaysStoppedAnimation(color),
//               minHeight: 8,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           '${(value * 100).toStringAsFixed(0)}%',
//           style: GoogleFonts.robotoMono(
//               fontSize: 11, color: cs.onSurface.withOpacity(0.6)),
//         ),
//       ],
//     );
//   }
// }

// // --- ABOUT SCREEN ---
// class AboutScreen extends StatelessWidget {
//   const AboutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About',
//             style: GoogleFonts.playfairDisplay(
//                 fontWeight: FontWeight.w700)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Text('♔', style: TextStyle(fontSize: 72, color: cs.primary)),
//             const SizedBox(height: 16),
//             Text('Chess with Claude',
//                 style: GoogleFonts.playfairDisplay(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w900,
//                     color: cs.onBackground),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 8),
//             Text('Version 1.0.0',
//                 style: GoogleFonts.inter(
//                     color: cs.onBackground.withOpacity(0.5),
//                     letterSpacing: 2)),
//             const SizedBox(height: 32),
//             _AboutCard(
//               title: 'Features',
//               content:
//                   '• Full chess rules with all special moves\n• Minimax AI with Alpha-Beta pruning\n• Easy, Medium, and Hard difficulties\n• Game timer for both players\n• Move history with PGN export\n• Multiple board themes\n• Dark and Light mode\n• Game statistics tracking\n• Undo move support\n• Pawn promotion dialog',
//             ),
//             const SizedBox(height: 16),
//             _AboutCard(
//               title: 'How to Play',
//               content:
//                   'Tap a piece to select it. Green dots show legal moves. Tap a highlighted square to move. Special moves like castling and en passant are handled automatically.',
//             ),
//             const SizedBox(height: 16),
//             _AboutCard(
//               title: 'AI Engine',
//               content:
//                   'The AI uses the Minimax algorithm with Alpha-Beta pruning and position evaluation tables. Hard mode searches 4 moves deep, Medium searches 3, and Easy uses shallow search with randomness.',
//             ),
//             const SizedBox(height: 32),
//             Text(
//               'Built with Flutter & Dart\nPowered by Claude AI',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.inter(
//                   color: cs.onBackground.withOpacity(0.4),
//                   fontSize: 13),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AboutCard extends StatelessWidget {
//   final String title;
//   final String content;

//   const _AboutCard({required this.title, required this.content});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: cs.primary.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: GoogleFonts.playfairDisplay(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: cs.primary)),
//           const SizedBox(height: 12),
//           Text(content,
//               style: GoogleFonts.inter(
//                   color: cs.onSurface.withOpacity(0.8),
//                   height: 1.6)),
//         ],
//       ),
//     );
//   }
// }
// // ============================================================
// // END OF FILE
// // ============================================================



import 'dart:async';
import 'package:chess/chess.dart' as chess_lib;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

// ─── ENTRY POINT ────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://byqfjiuwtgzoaznwormj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cWZqaXV3dGd6b2F6bndvcm1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMzgwNDUsImV4cCI6MjA5MzcxNDA0NX0.7ChKomzgPQwuCwhDObV4OZhp8tezKP0LYa1IUGjfsz0',
  );
  runApp(const ChessApp());
}

final supabase = Supabase.instance.client;

// ─── APP ────────────────────────────────────────────────────────────────────

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chessp Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7C4DFF),
        ),
      ),
      home: supabase.auth.currentSession != null
          ? const LobbyScreen()
          : const AuthScreen(),
    );
  }
}

// ─── AUTH SCREEN ─────────────────────────────────────────────────────────────

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LobbyScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _signUp() async {
    setState(() => _loading = true);
    try {
      await supabase.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check email to confirm!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('♟ Chessp',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00E5FF))),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                decoration: _inputDeco('Email'),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: _inputDeco('Password'),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              if (_loading)
                const CircularProgressIndicator(color: Color(0xFF00E5FF))
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _signUp,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00E5FF),
                        side: const BorderSide(color: Color(0xFF00E5FF)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF333355)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00E5FF)),
        ),
      );
}

// ─── LOBBY SCREEN ────────────────────────────────────────────────────────────

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  List<Map<String, dynamic>> _openGames = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadOpenGames();
  }

  Future<void> _loadOpenGames() async {
    final games = await supabase
        .from('chess_games')
        .select()
        .eq('status', 'waiting')
        .neq('player_white', supabase.auth.currentUser!.id);

    setState(() => _openGames = List<Map<String, dynamic>>.from(games));
  }

  Future<void> _createGame() async {
    setState(() => _loading = true);
    final gameId = const Uuid().v4();
    await supabase.from('chess_games').insert({
      'id': gameId,
      'player_white': supabase.auth.currentUser!.id,
      'board_state':
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'current_turn': 'white',
      'status': 'waiting',
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnlineGameScreen(gameId: gameId, myColor: 'white'),
        ),
      );
    }
    setState(() => _loading = false);
  }

  Future<void> _joinGame(String gameId) async {
    await supabase.from('chess_games').update({
      'player_black': supabase.auth.currentUser!.id,
      'status': 'active',
    }).eq('id', gameId);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnlineGameScreen(gameId: gameId, myColor: 'black'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('♟ Chessp Online',
            style: TextStyle(color: Color(0xFF00E5FF))),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () async {
              await supabase.auth.signOut();
              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create Game Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _createGame,
                icon: const Icon(Icons.add),
                label: const Text('Create New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Open Games',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF00E5FF)),
                  onPressed: _loadOpenGames,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _openGames.isEmpty
                  ? const Center(
                      child: Text('No open games. Create one!',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _openGames.length,
                      itemBuilder: (ctx, i) {
                        final game = _openGames[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF7C4DFF).withOpacity(0.4)),
                          ),
                          child: ListTile(
                            leading: const Text('♔',
                                style: TextStyle(fontSize: 28)),
                            title: Text(
                                'Game ${game['id'].toString().substring(0, 8)}...',
                                style: const TextStyle(color: Colors.white)),
                            subtitle: const Text('Waiting for opponent',
                                style: TextStyle(color: Colors.grey)),
                            trailing: ElevatedButton(
                              onPressed: () => _joinGame(game['id']),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C4DFF)),
                              child: const Text('Join'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ONLINE GAME SCREEN ──────────────────────────────────────────────────────

class OnlineGameScreen extends StatefulWidget {
  final String gameId;
  final String myColor; // 'white' or 'black'

  const OnlineGameScreen(
      {super.key, required this.gameId, required this.myColor});

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  late chess_lib.Chess _chess;
  RealtimeChannel? _channel;
  String? _selectedSquare;
  List<String> _legalMoveSquares = [];
  String _status = 'Waiting for opponent...';
  String _currentTurn = 'white';
  bool _gameActive = false;
  Map<String, dynamic>? _lastMove;

  @override
  void initState() {
    super.initState();
    _chess = chess_lib.Chess();
    _subscribeToGame();
    _loadCurrentState();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  // ── Subscribe to Realtime changes ──────────────────────────────────────────
  void _subscribeToGame() {
    _channel = supabase
        .channel('game-${widget.gameId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chess_games',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: widget.gameId,
          ),
          callback: (payload) {
            // This fires on BOTH players' screens when board updates
            final newData = payload.newRecord;
            _applyGameState(newData);
          },
        )
        .subscribe();
  }

  // ── Load initial state ─────────────────────────────────────────────────────
  Future<void> _loadCurrentState() async {
    final data = await supabase
        .from('chess_games')
        .select()
        .eq('id', widget.gameId)
        .single();
    _applyGameState(data);
  }

  // ── Apply game state from DB ───────────────────────────────────────────────
  void _applyGameState(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      _chess = chess_lib.Chess.fromFEN(data['board_state']);
      _currentTurn = data['current_turn'] ?? 'white';
      _gameActive = data['status'] == 'active';
      _lastMove = data['last_move'];
      _selectedSquare = null;
      _legalMoveSquares = [];

      if (data['status'] == 'waiting') {
        _status = 'Waiting for opponent to join...';
      } else if (data['status'] == 'finished') {
        _status = 'Game Over! Winner: ${data['winner'] ?? 'Draw'}';
      } else if (_chess.in_checkmate) {
        _status = 'Checkmate!';
      } else if (_chess.in_check) {
        _status = '${_currentTurn.toUpperCase()} is in Check!';
      } else {
        _status = _currentTurn == widget.myColor
            ? 'Your turn'
            : "Opponent's turn";
      }
    });
  }

  // ── Handle square tap ─────────────────────────────────────────────────────
  void _onSquareTap(String square) {
    if (!_gameActive) return;
    if (_currentTurn != widget.myColor) return; // Not your turn

    final piece = _chess.get(square);

    if (_selectedSquare == null) {
      // Select a piece
      if (piece == null) return;
      final pieceColor = piece.color == chess_lib.Color.WHITE ? 'white' : 'black';
      if (pieceColor != widget.myColor) return;

      final moves = _chess.generate_moves().where((m) => m.fromAlgebraic == square).toList();
      setState(() {
        _selectedSquare = square;
        _legalMoveSquares = moves.map((m) => m.toAlgebraic).toList();
      });
    } else {
      if (_legalMoveSquares.contains(square)) {
        // Make the move
        _makeMove(_selectedSquare!, square);
      } else {
        // Reselect
        setState(() {
          _selectedSquare = null;
          _legalMoveSquares = [];
        });
        if (piece != null) _onSquareTap(square);
      }
    }
  }

  // ── Send move to Supabase ─────────────────────────────────────────────────
  Future<void> _makeMove(String from, String to) async {
    final move = _chess.move({'from': from, 'to': to});
    if (move == null) return;

    final newFen = _chess.fen;
    final nextTurn = _currentTurn == 'white' ? 'black' : 'white';

    String newStatus = 'active';
    String? winner;
    if (_chess.in_checkmate) {
      newStatus = 'finished';
      winner = widget.myColor;
    } else if (_chess.in_draw) {
      newStatus = 'finished';
      winner = 'draw';
    }

    // Update DB → Supabase Realtime will push to opponent automatically
    await supabase.from('chess_games').update({
      'board_state': newFen,
      'current_turn': nextTurn,
      'status': newStatus,
      if (winner != null) 'winner': winner,
      'last_move': {'from': from, 'to': to},
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', widget.gameId);
  }

  // ── Build board ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final boardSize = MediaQuery.of(context).size.width - 32;
    final squareSize = boardSize / 8;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          widget.myColor == 'white' ? '♔ Playing as White' : '♚ Playing as Black',
          style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 16),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _currentTurn == widget.myColor
                  ? const Color(0xFF00E5FF).withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _currentTurn == widget.myColor
                    ? const Color(0xFF00E5FF)
                    : Colors.grey,
              ),
            ),
            child: Text(
              _currentTurn == widget.myColor ? 'YOUR TURN' : 'WAITING',
              style: TextStyle(
                color: _currentTurn == widget.myColor
                    ? const Color(0xFF00E5FF)
                    : Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFF1A1A2E),
            child: Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),

          const SizedBox(height: 16),

          // Opponent label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _playerLabel(
                widget.myColor == 'white' ? '♚ Opponent (Black)' : '♔ Opponent (White)',
                _currentTurn != widget.myColor && _gameActive),
          ),

          const SizedBox(height: 8),

          // Chess Board
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: boardSize,
              height: boardSize,
              child: _buildBoard(squareSize),
            ),
          ),

          const SizedBox(height: 8),

          // Your label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _playerLabel(
                widget.myColor == 'white' ? '♔ You (White)' : '♚ You (Black)',
                _currentTurn == widget.myColor && _gameActive),
          ),

          const SizedBox(height: 16),

          // Last move info
          if (_lastMove != null)
            Text(
              'Last move: ${_lastMove!['from']} → ${_lastMove!['to']}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
        ],
      ),
    );
  }

  Widget _playerLabel(String name, bool isActive) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF00E5FF) : Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Text(name,
            style: TextStyle(
              color: isActive ? const Color(0xFF00E5FF) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            )),
      ],
    );
  }

  Widget _buildBoard(double squareSize) {
    // Flip board if playing as black
    final ranks = widget.myColor == 'white'
        ? List.generate(8, (i) => 7 - i)
        : List.generate(8, (i) => i);
    final files = widget.myColor == 'white'
        ? List.generate(8, (i) => i)
        : List.generate(8, (i) => 7 - i);

    return Column(
      children: ranks.map((rank) {
        return Row(
          children: files.map((file) {
            final squareName =
                '${String.fromCharCode(97 + file)}${rank + 1}';
            final isLight = (rank + file) % 2 == 1;
            final isSelected = _selectedSquare == squareName;
            final isLegalTarget = _legalMoveSquares.contains(squareName);
            final isLastMoveSquare = _lastMove != null &&
                (_lastMove!['from'] == squareName ||
                    _lastMove!['to'] == squareName);

            Color bgColor;
            if (isSelected) {
              bgColor = const Color(0xFF00E5FF).withOpacity(0.6);
            } else if (isLastMoveSquare) {
              bgColor = const Color(0xFF7C4DFF).withOpacity(0.5);
            } else if (isLight) {
              bgColor = const Color(0xFFECDEB8);
            } else {
              bgColor = const Color(0xFF8B6348);
            }

            final piece = _chess.get(squareName);

            return GestureDetector(
              onTap: () => _onSquareTap(squareName),
              child: Container(
                width: squareSize,
                height: squareSize,
                color: bgColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (piece != null)
                      Text(
                        _pieceToUnicode(piece),
                        style: TextStyle(
                          fontSize: squareSize * 0.72,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    if (isLegalTarget)
                      Container(
                        width: squareSize * 0.3,
                        height: squareSize * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  String _pieceToUnicode(chess_lib.Piece piece) {
    final map = {
      chess_lib.PieceType.KING: const ['♚', '♔'],
      chess_lib.PieceType.QUEEN: const ['♛', '♕'],
      chess_lib.PieceType.ROOK: const ['♜', '♖'],
      chess_lib.PieceType.BISHOP: const ['♝', '♗'],
      chess_lib.PieceType.KNIGHT: const ['♞', '♘'],
      chess_lib.PieceType.PAWN: const ['♟', '♙'],
    };
    return piece.color == chess_lib.Color.BLACK
        ? map[piece.type]![0]
        : map[piece.type]![1];
  }
}