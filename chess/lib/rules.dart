import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';



// --- GLOBAL SETTINGS ---
class GameSettings extends ChangeNotifier {
  bool isVibrationEnabled = true;
  bool isSoundEnabled = true;
  bool isDarkMode = true;

  void toggleVibration() { isVibrationEnabled = !isVibrationEnabled; notifyListeners(); }
  void toggleSound() { isSoundEnabled = !isSoundEnabled; notifyListeners(); }
  void toggleTheme() { isDarkMode = !isDarkMode; notifyListeners(); }

  void vibrate() {
    if (isVibrationEnabled) HapticFeedback.lightImpact();
  }
  void heavyVibrate() {
    if (isVibrationEnabled) HapticFeedback.heavyImpact();
  }
}
final GameSettings globalSettings = GameSettings();

// --- CONSTANTS & DATA ---
const Color cRed = Color(0xFFE53935);
const Color cGreen = Color(0xFF43A047);
const Color cYellow = Color(0xFFFFB300);
const Color cBlue = Color(0xFF1E88E5);
final List<Color> playerColors = [cRed, cGreen, cYellow, cBlue];
final List<String> playerNames = ["Red", "Green", "Yellow", "Blue"];

// 52 Perimeter Path Coordinates on a 15x15 grid
const List<Offset> globalPath = [
  Offset(1, 6), Offset(2, 6), Offset(3, 6), Offset(4, 6), Offset(5, 6),
  Offset(6, 5), Offset(6, 4), Offset(6, 3), Offset(6, 2), Offset(6, 1), Offset(6, 0),
  Offset(7, 0), Offset(8, 0),
  Offset(8, 1), Offset(8, 2), Offset(8, 3), Offset(8, 4), Offset(8, 5),
  Offset(9, 6), Offset(10, 6), Offset(11, 6), Offset(12, 6), Offset(13, 6), Offset(14, 6),
  Offset(14, 7), Offset(14, 8),
  Offset(13, 8), Offset(12, 8), Offset(11, 8), Offset(10, 8), Offset(9, 8),
  Offset(8, 9), Offset(8, 10), Offset(8, 11), Offset(8, 12), Offset(8, 13), Offset(8, 14),
  Offset(7, 14), Offset(6, 14),
  Offset(6, 13), Offset(6, 12), Offset(6, 11), Offset(6, 10), Offset(6, 9),
  Offset(5, 8), Offset(4, 8), Offset(3, 8), Offset(2, 8), Offset(1, 8), Offset(0, 8),
  Offset(0, 7), Offset(0, 6),
];

const List<int> startOffsets = [0, 13, 26, 39];
const List<int> safeSpots = [0, 8, 13, 21, 26, 34, 39, 47];

final Map<int, List<Offset>> homePaths = {
  0: [const Offset(1, 7), const Offset(2, 7), const Offset(3, 7), const Offset(4, 7), const Offset(5, 7), const Offset(7.5, 7.5)],
  1: [const Offset(7, 1), const Offset(7, 2), const Offset(7, 3), const Offset(7, 4), const Offset(7, 5), const Offset(7.5, 7.5)],
  2: [const Offset(13, 7), const Offset(12, 7), const Offset(11, 7), const Offset(10, 7), const Offset(9, 7), const Offset(7.5, 7.5)],
  3: [const Offset(7, 13), const Offset(7, 12), const Offset(7, 11), const Offset(7, 10), const Offset(7, 9), const Offset(7.5, 7.5)],
};

final Map<int, List<Offset>> basePositions = {
  0: [const Offset(1.5, 1.5), const Offset(3.5, 1.5), const Offset(1.5, 3.5), const Offset(3.5, 3.5)],
  1: [const Offset(10.5, 1.5), const Offset(12.5, 1.5), const Offset(10.5, 3.5), const Offset(12.5, 3.5)],
  2: [const Offset(10.5, 10.5), const Offset(12.5, 10.5), const Offset(10.5, 12.5), const Offset(12.5, 12.5)],
  3: [const Offset(1.5, 10.5), const Offset(3.5, 10.5), const Offset(1.5, 12.5), const Offset(3.5, 12.5)],
};

// --- APP & THEME ---
class Ludo extends StatelessWidget {
  const Ludo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalSettings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Ultimate Ludo Game',
          debugShowCheckedModeBanner: false,
          themeMode: globalSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF0F2027),
            primaryColor: Colors.indigo,
            textTheme: Typography.material2021().white,
          ),
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color(0xFFE0E5EC),
            primaryColor: Colors.indigo,
            textTheme: Typography.material2021().black,
          ),
          home: const SplashScreen(),
        );
      }
    );
  }
}

// --- STATE MANAGEMENT ---
class LudoGameState extends ChangeNotifier {
  int currentPlayer = 0;
  List<int> activePlayers = [];
  List<bool> isAI = [false, false, false, false];
  
  int diceValue = 1;
  bool hasRolled = false;
  bool isRolling = false;
  bool isAnimating = false;
  int consecutiveSixes = 0;
  
  List<List<int>> tokens = List.generate(4, (_) => [-1, -1, -1, -1]);
  List<int> winners = [];
  bool gameOver = false;

  void initialize(int playerCount, bool vsComputer) {
    activePlayers.clear();
    winners.clear();
    gameOver = false;
    currentPlayer = 0;
    hasRolled = false;
    isRolling = false;
    isAnimating = false;
    consecutiveSixes = 0;
    tokens = List.generate(4, (_) => [-1, -1, -1, -1]);
    isAI = [false, false, false, false];

    if (playerCount == 2) {
      activePlayers = [0, 2]; 
      if (vsComputer) isAI[2] = true;
    } else if (playerCount == 3) {
      activePlayers = [0, 1, 2];
      if (vsComputer) { isAI[1] = true; isAI[2] = true; }
    } else {
      activePlayers = [0, 1, 2, 3];
      if (vsComputer) { isAI[1] = true; isAI[2] = true; isAI[3] = true; }
    }
    notifyListeners();
    _checkAITurn();
  }

  Future<void> rollDice() async {
    if (isRolling || hasRolled || isAnimating || gameOver) return;
    
    isRolling = true;
    notifyListeners();

    for (int i = 0; i < 5; i++) {
      diceValue = Random().nextInt(6) + 1;
      notifyListeners();
      globalSettings.vibrate();
      await Future.delayed(const Duration(milliseconds: 80));
    }

    diceValue = Random().nextInt(6) + 1;
    isRolling = false;
    hasRolled = true;

    if (diceValue == 6) {
      consecutiveSixes++;
      if (consecutiveSixes == 3) {
        globalSettings.heavyVibrate();
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 800));
        nextTurn();
        return;
      }
    } else {
      consecutiveSixes = 0;
    }
    
    notifyListeners();
    _checkAutoMoveOrSkip();
  }

  void _checkAutoMoveOrSkip() {
    List<int> validMoves = _getValidMoves(currentPlayer, diceValue);
    if (validMoves.isEmpty) {
      Future.delayed(const Duration(milliseconds: 800), () => nextTurn());
    } else if (isAI[currentPlayer]) {
      _executeAI(validMoves);
    }
  }

  List<int> _getValidMoves(int player, int dice) {
    List<int> valid = [];
    for (int i = 0; i < 4; i++) {
      if (_canMove(player, i, dice)) valid.add(i);
    }
    return valid;
  }

  bool _canMove(int player, int tokenIndex, int dice) {
    int pos = tokens[player][tokenIndex];
    if (pos == 56) return false;
    if (pos == -1) return dice == 6;
    if (pos + dice > 56) return false;
    return true;
  }

  Future<void> moveToken(int player, int tokenIndex) async {
    if (isAnimating || !hasRolled || player != currentPlayer) return;
    if (!_canMove(player, tokenIndex, diceValue)) return;

    isAnimating = true;
    notifyListeners();

    int startPos = tokens[player][tokenIndex];
    if (startPos == -1) {
      tokens[player][tokenIndex] = 0;
      globalSettings.vibrate();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      for (int i = 0; i < diceValue; i++) {
        tokens[player][tokenIndex]++;
        globalSettings.vibrate();
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    await _handlePostMove(player, tokenIndex);
  }

  Future<void> _handlePostMove(int player, int tokenIndex) async {
    int currentPos = tokens[player][tokenIndex];
    bool killed = false;
    bool reachedHome = false;

    if (currentPos == 56) {
      reachedHome = true;
      globalSettings.heavyVibrate();
      if (_hasPlayerWon(player)) {
        if (!winners.contains(player)) winners.add(player);
        if (winners.length == activePlayers.length - 1) {
          gameOver = true;
          notifyListeners();
          return;
        }
      }
    } else if (currentPos >= 0 && currentPos <= 50) {
      int globalPos = (currentPos + startOffsets[player]) % 52;
      if (!safeSpots.contains(globalPos)) {
        for (int p in activePlayers) {
          if (p != player) {
            for (int t = 0; t < 4; t++) {
              int pPos = tokens[p][t];
              if (pPos >= 0 && pPos <= 50) {
                int pGlobal = (pPos + startOffsets[p]) % 52;
                if (pGlobal == globalPos) {
                  tokens[p][t] = -1;
                  killed = true;
                  globalSettings.heavyVibrate();
                }
              }
            }
          }
        }
      }
    }

    isAnimating = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));

    if (diceValue == 6 || killed || reachedHome) {
      hasRolled = false;
      notifyListeners();
      if (isAI[currentPlayer]) _checkAITurn();
    } else {
      nextTurn();
    }
  }

  void nextTurn() {
    hasRolled = false;
    consecutiveSixes = 0;
    
    do {
      int idx = activePlayers.indexOf(currentPlayer);
      currentPlayer = activePlayers[(idx + 1) % activePlayers.length];
    } while (winners.contains(currentPlayer));

    notifyListeners();
    _checkAITurn();
  }

  bool _hasPlayerWon(int player) => tokens[player].every((pos) => pos == 56);

  Future<void> _checkAITurn() async {
    if (!isAI[currentPlayer] || gameOver) return;
    await Future.delayed(const Duration(milliseconds: 800));
    await rollDice();
  }

  Future<void> _executeAI(List<int> validMoves) async {
    await Future.delayed(const Duration(milliseconds: 800));
    int bestToken = validMoves.first;
    int maxScore = -1;

    for (int t in validMoves) {
      int score = _evaluateMove(currentPlayer, t, diceValue);
      if (score > maxScore) {
        maxScore = score;
        bestToken = t;
      }
    }
    await moveToken(currentPlayer, bestToken);
  }

  int _evaluateMove(int player, int tokenIndex, int dice) {
    int current = tokens[player][tokenIndex];
    int next = current == -1 ? 0 : current + dice;

    if (next == 56) return 1000;
    if (current == -1) return 300;

    if (next >= 0 && next <= 50) {
      int globalNext = (next + startOffsets[player]) % 52;
      if (!safeSpots.contains(globalNext)) {
        for (int p in activePlayers) {
          if (p != player) {
            for (int t = 0; t < 4; t++) {
              int pPos = tokens[p][t];
              if (pPos >= 0 && pPos <= 50) {
                if ((pPos + startOffsets[p]) % 52 == globalNext) return 500;
              }
            }
          }
        }
      }
    }
    return next;
  }
}

// --- REUSABLE GLASSMORPHISM WIDGET ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? colorOverride;

  const GlassContainer({
    super.key, 
    required this.child, 
    this.borderRadius = 20, 
    this.padding = const EdgeInsets.all(16),
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = colorOverride ?? (isDark ? Colors.white : Colors.black);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: baseColor.withOpacity(isDark ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: baseColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 1)
            ]
          ),
          child: child,
        ),
      ),
    );
  }
}

// --- SCREENS ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF312E81)], 
            begin: Alignment.topLeft, end: Alignment.bottomRight
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)]
                  ),
                  child: Icon(Icons.casino, size: 100, color: Colors.amber.shade400),
                ),
                const SizedBox(height: 30),
                const Text("ULTIMATE LUDO", 
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3, shadows: [Shadow(color: Colors.black54, blurRadius: 10)])
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
              ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
              : [const Color(0xFFe0c3fc), const Color(0xFF8ec5fc)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 20, right: 20,
                child: IconButton(
                  icon: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black87, size: 30),
                  onPressed: () => _showSettings(context),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("GAME MODES", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
                      const SizedBox(height: 50),
                      _buildModeBtn(context, "Local Multiplayer", Icons.people, () => _showPlayerSelect(context, false)),
                      const SizedBox(height: 20),
                      _buildModeBtn(context, "vs Computer", Icons.smart_toy, () => _showPlayerSelect(context, true)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeBtn(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: 280, height: 70,
        child: GlassContainer(
          borderRadius: 35,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              ListenableBuilder(
                listenable: globalSettings,
                builder: (context, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(title: const Text("Vibration"), value: globalSettings.isVibrationEnabled, onChanged: (v) => globalSettings.toggleVibration()),
                      SwitchListTile(title: const Text("Sound Effects"), value: globalSettings.isSoundEnabled, onChanged: (v) => globalSettings.toggleSound()),
                      SwitchListTile(title: const Text("Dark Mode"), value: globalSettings.isDarkMode, onChanged: (v) => globalSettings.toggleTheme()),
                    ],
                  );
                }
              )
            ],
          ),
        ),
      )
    );
  }

  void _showPlayerSelect(BuildContext context, bool vsComputer) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(16.0), child: Text("Select Players", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            ListTile(leading: const Icon(Icons.looks_two, color: cRed), title: const Text("2 Players (Red vs Yellow)", style: TextStyle(fontWeight: FontWeight.bold)), onTap: () => _startGame(context, 2, vsComputer)),
            ListTile(leading: const Icon(Icons.looks_3, color: cGreen), title: const Text("3 Players", style: TextStyle(fontWeight: FontWeight.bold)), onTap: () => _startGame(context, 3, vsComputer)),
            ListTile(leading: const Icon(Icons.looks_4, color: cBlue), title: const Text("4 Players", style: TextStyle(fontWeight: FontWeight.bold)), onTap: () => _startGame(context, 4, vsComputer)),
          ],
        ),
      )
    ));
  }

  void _startGame(BuildContext context, int count, bool vsComputer) {
    Navigator.pop(context); 
    final state = LudoGameState()..initialize(count, vsComputer);
    Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(gameState: state)));
  }
}

// --- MAIN GAME UI ---
class GameScreen extends StatefulWidget {
  final LudoGameState gameState;
  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    widget.gameState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onStateChange);
    widget.gameState.dispose();
    super.dispose();
  }

  void _onStateChange() {
    setState(() {}); 
    if (widget.gameState.gameOver) _showWinnerDialog();
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Stack(
        children: [
          const ConfettiWidget(), 
          AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Game Over!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: playerColors[widget.gameState.winners.first].withOpacity(0.2)),
                    child: Icon(Icons.emoji_events, color: playerColors[widget.gameState.winners.first], size: 80),
                  ),
                  const SizedBox(height: 20),
                  Text("${playerNames[widget.gameState.winners.first]} Wins!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: playerColors[widget.gameState.winners.first])),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: playerColors[widget.gameState.winners.first],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    onPressed: () {
                      Navigator.pop(context); 
                      Navigator.pop(context); 
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ultimate Ludo", style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettings(context)),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
              ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
              : [const Color(0xFFe0c3fc), const Color(0xFF8ec5fc)],
            begin: Alignment.topLeft, end: Alignment.bottomRight
          ),
        ),
        // Strict safe layout builder to fix overflows
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine layout based on raw aspect ratio (Landscape vs Portrait)
              final bool isLandscape = constraints.maxWidth > constraints.maxHeight;

              if (isLandscape) {
                // Wide screen layout (Web/PC)
                return Row(
                  children: [
                    Expanded(flex: 2, child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _buildPlayerPanel(0, state), _buildPlayerPanel(3, state) ])),
                    Expanded(flex: 5, child: Center(child: _buildBoard(state))),
                    Expanded(flex: 2, child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _buildPlayerPanel(1, state), _buildPlayerPanel(2, state) ])),
                  ],
                );
              } else {
                // Tall screen layout (Mobile)
                return Column(
                  children: [
                    Expanded(flex: 2, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _buildPlayerPanel(0, state), _buildPlayerPanel(1, state) ])),
                    Expanded(flex: 6, child: Center(child: _buildBoard(state))),
                    Expanded(flex: 2, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _buildPlayerPanel(3, state), _buildPlayerPanel(2, state) ])),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              ListenableBuilder(
                listenable: globalSettings,
                builder: (context, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(title: const Text("Vibration"), value: globalSettings.isVibrationEnabled, onChanged: (v) => globalSettings.toggleVibration()),
                      SwitchListTile(title: const Text("Sound Effects"), value: globalSettings.isSoundEnabled, onChanged: (v) => globalSettings.toggleSound()),
                    ],
                  );
                }
              )
            ],
          ),
        ),
      )
    );
  }

  // FIXED PLAYER PANEL: Scales perfectly inside any bounds.
  Widget _buildPlayerPanel(int playerIndex, LudoGameState state) {
    bool isActive = state.activePlayers.contains(playerIndex);
    bool isTurn = state.currentPlayer == playerIndex;

    if (!isActive) return const Expanded(child: SizedBox());

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FittedBox(
          fit: BoxFit.scaleDown, // Ensures the entire panel scales down if constrained
          child: GlassContainer(
            colorOverride: playerColors[playerIndex],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.isAI[playerIndex]) const Icon(Icons.smart_toy, size: 16),
                    if (state.isAI[playerIndex]) const SizedBox(width: 4),
                    Text(playerNames[playerIndex], style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTurn ? 20 : 16)),
                  ],
                ),
                const SizedBox(height: 10),
                if (isTurn) GestureDetector(
                  onTap: () {
                    if(!state.isAI[playerIndex]) state.rollDice();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.rotationZ(state.isRolling ? pi * 2 : 0),
                    alignment: Alignment.center,
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade200], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: playerColors[playerIndex].withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(2,2))
                      ],
                    ),
                    child: state.isRolling 
                      ? CircularProgressIndicator(strokeWidth: 3, color: playerColors[playerIndex])
                      : _buildDiceFace(state.hasRolled ? state.diceValue : 6, playerColors[playerIndex], size: 60),
                  ),
                )
                else if (state.winners.contains(playerIndex))
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 60)
                else
                   Opacity(opacity: 0.4, child: _buildDiceFace(1, Colors.grey, size: 60)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiceFace(int value, Color color, {double size = 55}) {
    List<Offset> dots = [];
    double d = size / 4;
    switch (value) {
      case 1: dots = [Offset(d*2, d*2)]; break;
      case 2: dots = [Offset(d, d), Offset(d*3, d*3)]; break;
      case 3: dots = [Offset(d, d), Offset(d*2, d*2), Offset(d*3, d*3)]; break;
      case 4: dots = [Offset(d, d), Offset(d*3, d), Offset(d, d*3), Offset(d*3, d*3)]; break;
      case 5: dots = [Offset(d, d), Offset(d*3, d), Offset(d*2, d*2), Offset(d, d*3), Offset(d*3, d*3)]; break;
      case 6: dots = [Offset(d, d), Offset(d*3, d), Offset(d, d*2), Offset(d*3, d*2), Offset(d, d*3), Offset(d*3, d*3)]; break;
    }
    
    return CustomPaint(
      size: Size(size, size),
      painter: DicePainter(dots, size/7, color),
    );
  }

  // FIXED BOARD: Uses strict max size based on constraints so it never bleeds out
  Widget _buildBoard(LudoGameState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the absolute maximum safe square size
          final double boardSize = min(constraints.maxWidth, constraints.maxHeight);
          
          return Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(boardSize, boardSize),
                    painter: LudoBoardPainter(state),
                  ),
                  _buildTokens(state, boardSize),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  // --- RENDERING TOKENS ---
  Widget _buildTokens(LudoGameState state, double boardSize) {
    double cellSize = boardSize / 15;
    List<Widget> tokenWidgets = [];
    Map<String, List<Map<String, dynamic>>> cellGroups = {};

    for (int p in state.activePlayers) {
      for (int t = 0; t < 4; t++) {
        int pos = state.tokens[p][t];
        Offset gridOffset;
        if (pos == -1) {
          gridOffset = basePositions[p]![t];
        } else if (pos >= 0 && pos <= 50) {
          gridOffset = globalPath[(pos + startOffsets[p]) % 52];
        } else {
          int homeIdx = pos - 51;
          if (homeIdx > 5) homeIdx = 5; 
          gridOffset = homePaths[p]![homeIdx];
        }

        String key = '${gridOffset.dx}_${gridOffset.dy}';
        cellGroups.putIfAbsent(key, () => []).add({'p': p, 't': t, 'pos': pos});
      }
    }

    cellGroups.forEach((key, list) {
      int count = list.length;
      for (int i = 0; i < count; i++) {
        var item = list[i];
        int p = item['p'];
        int t = item['t'];
        int pos = item['pos'];

        Offset gridOffset;
        if (pos == -1) gridOffset = basePositions[p]![t];
        else if (pos >= 0 && pos <= 50) gridOffset = globalPath[(pos + startOffsets[p]) % 52];
        else gridOffset = homePaths[p]![min(pos - 51, 5)];

        double left = gridOffset.dx * cellSize;
        double top = gridOffset.dy * cellSize;

        if (count > 1 && pos != -1 && pos != 56) {
          double shiftX = (i % 2 == 0) ? -cellSize * 0.15 : cellSize * 0.15;
          double shiftY = (i < 2) ? -cellSize * 0.15 : cellSize * 0.15;
          left += shiftX;
          top += shiftY;
        }

        double tSize = cellSize * (count > 1 && pos != -1 ? 0.65 : 0.75);
        left += (cellSize - tSize) / 2;
        top += (cellSize - tSize) / 2;

        bool canMoveThis = !state.isAI[p] && state.currentPlayer == p && !state.isAnimating && state.hasRolled && state._canMove(p, t, state.diceValue);

        tokenWidgets.add(
          AnimatedPositioned(
            key: ValueKey('token_${p}_$t'),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutBack,
            left: left,
            top: top,
            width: tSize,
            height: tSize,
            child: GestureDetector(
              onTap: canMoveThis ? () => state.moveToken(p, t) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4, offset: const Offset(2, 3)),
                    if (canMoveThis) BoxShadow(color: Colors.white, blurRadius: 10, spreadRadius: 3),
                  ],
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.8), playerColors[p], playerColors[p].withAlpha(200)],
                    center: const Alignment(-0.3, -0.3),
                    radius: 0.8,
                  )
                ),
                child: canMoveThis 
                  ? const Center(child: Icon(Icons.arrow_upward, size: 14, color: Colors.white)) 
                  : Center(child: Container(width: tSize*0.3, height: tSize*0.3, decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle))),
              ),
            ),
          )
        );
      }
    });

    return Stack(children: tokenWidgets);
  }
}

// --- PAINTERS ---
class DicePainter extends CustomPainter {
  final List<Offset> dots;
  final double radius;
  final Color dotColor;
  DicePainter(this.dots, this.radius, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (var dot in dots) {
      canvas.drawCircle(dot, radius, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LudoBoardPainter extends CustomPainter {
  final LudoGameState state;
  LudoBoardPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    double cs = size.width / 15;
    
    // Draw Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFF8F9FA));

    // Draw 4 Bases
    _drawBase(canvas, 0, 0, cs, cRed);
    _drawBase(canvas, 9 * cs, 0, cs, cGreen);
    _drawBase(canvas, 9 * cs, 9 * cs, cs, cYellow);
    _drawBase(canvas, 0, 9 * cs, cs, cBlue);

    // Draw Center Triangles
    Path pRed = Path()..moveTo(6*cs, 6*cs)..lineTo(7.5*cs, 7.5*cs)..lineTo(6*cs, 9*cs)..close();
    Path pGreen = Path()..moveTo(6*cs, 6*cs)..lineTo(9*cs, 6*cs)..lineTo(7.5*cs, 7.5*cs)..close();
    Path pYellow = Path()..moveTo(9*cs, 6*cs)..lineTo(9*cs, 9*cs)..lineTo(7.5*cs, 7.5*cs)..close();
    Path pBlue = Path()..moveTo(6*cs, 9*cs)..lineTo(7.5*cs, 7.5*cs)..lineTo(9*cs, 9*cs)..close();
    
    canvas.drawPath(pRed, Paint()..color = cRed);
    canvas.drawPath(pGreen, Paint()..color = cGreen);
    canvas.drawPath(pYellow, Paint()..color = cYellow);
    canvas.drawPath(pBlue, Paint()..color = cBlue);
    
    // Draw Path Grid
    Paint cellPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < globalPath.length; i++) {
      Offset pos = globalPath[i];
      Rect cellRect = Rect.fromLTWH(pos.dx * cs, pos.dy * cs, cs, cs);
      
      if (startOffsets.contains(i)) {
        int colorIdx = startOffsets.indexOf(i);
        Color c = playerColors[colorIdx];
        canvas.drawRect(cellRect, Paint()..color = c.withOpacity(0.6));
        _drawArrow(canvas, cellRect, colorIdx);
      } else if (safeSpots.contains(i)) {
        canvas.drawRect(cellRect, Paint()..color = Colors.grey.shade300);
        _drawStar(canvas, cellRect.center, cs * 0.35, Colors.grey.shade600);
      } else {
        canvas.drawRect(cellRect, Paint()..color = Colors.white);
      }
      
      canvas.drawRect(cellRect, cellPaint);
    }

    // Home Stretches
    for (int p = 0; p < 4; p++) {
      for (int i = 0; i < 5; i++) {
        Offset pos = homePaths[p]![i];
        Rect cellRect = Rect.fromLTWH(pos.dx * cs, pos.dy * cs, cs, cs);
        canvas.drawRect(cellRect, Paint()..color = playerColors[p].withOpacity(0.4));
        canvas.drawRect(cellRect, cellPaint);
      }
    }
  }

  void _drawBase(Canvas canvas, double x, double y, double cs, Color color) {
    Rect outerRect = Rect.fromLTWH(x, y, 6 * cs, 6 * cs);
    Paint outerPaint = Paint()
      ..shader = LinearGradient(colors: [color.withOpacity(0.8), color], begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(outerRect);
    canvas.drawRect(outerRect, outerPaint);
    
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + cs, y + cs, 4 * cs, 4 * cs), const Radius.circular(10)), Paint()..color = Colors.white);
    
    Paint spotPaint = Paint()..color = color.withOpacity(0.2);
    Paint borderPaint = Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 2;
    
    List<Offset> spots = [
      Offset(x + 2*cs, y + 2*cs), Offset(x + 4*cs, y + 2*cs),
      Offset(x + 2*cs, y + 4*cs), Offset(x + 4*cs, y + 4*cs)
    ];

    for (var spot in spots) {
      canvas.drawCircle(spot, cs*0.7, spotPaint);
      canvas.drawCircle(spot, cs*0.7, borderPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    Paint paint = Paint()..color = color;
    Path path = Path();
    int points = 5;
    double angle = -pi / 2;
    double step = pi / points;
    
    for (int i = 0; i < points * 2; i++) {
      double r = (i % 2 == 0) ? radius : radius / 2.5;
      double dx = center.dx + r * cos(angle);
      double dy = center.dy + r * sin(angle);
      if (i == 0) path.moveTo(dx, dy); else path.lineTo(dx, dy);
      angle += step;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawArrow(Canvas canvas, Rect rect, int playerIndex) {
    Path path = Path();
    double cx = rect.center.dx;
    double cy = rect.center.dy;
    double w = rect.width;
    Paint paint = Paint()..color = Colors.white.withOpacity(0.8);

    if (playerIndex == 0) { // Red
      path.moveTo(cx - w*0.2, cy - w*0.3); path.lineTo(cx + w*0.3, cy); path.lineTo(cx - w*0.2, cy + w*0.3);
    } else if (playerIndex == 1) { // Green
      path.moveTo(cx - w*0.3, cy - w*0.2); path.lineTo(cx, cy + w*0.3); path.lineTo(cx + w*0.3, cy - w*0.2);
    } else if (playerIndex == 2) { // Yellow
      path.moveTo(cx + w*0.2, cy - w*0.3); path.lineTo(cx - w*0.3, cy); path.lineTo(cx + w*0.2, cy + w*0.3);
    } else if (playerIndex == 3) { // Blue
      path.moveTo(cx - w*0.3, cy + w*0.2); path.lineTo(cx, cy - w*0.3); path.lineTo(cx + w*0.3, cy + w*0.2);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LudoBoardPainter oldDelegate) => true;
}


// --- CUSTOM CONFETTI CELEBRATION ---
class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({super.key});
  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..addListener(() {
      _updateParticles();
      setState(() {});
    })..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 150; i++) {
        particles.add(Particle(
          x: rng.nextDouble() * size.width,
          y: rng.nextDouble() * size.height - size.height,
          vx: rng.nextDouble() * 4 - 2,
          vy: rng.nextDouble() * 4 + 2,
          color: playerColors[rng.nextInt(playerColors.length)],
          size: rng.nextDouble() * 8 + 4,
          angle: rng.nextDouble() * pi * 2,
          spin: rng.nextDouble() * 0.2 - 0.1,
        ));
      }
    }
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;
    for (var p in particles) {
      p.x += p.vx;
      p.y += p.vy;
      p.angle += p.spin;
      if (p.y > size.height) {
        p.y = -20;
        p.x = rng.nextDouble() * size.width;
      }
    }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: ConfettiPainter(particles),
    );
  }
}

class Particle {
  double x, y, vx, vy, size, angle, spin;
  Color color;
  Particle({required this.x, required this.y, required this.vx, required this.vy, required this.color, required this.size, required this.angle, required this.spin});
}

class ConfettiPainter extends CustomPainter {
  final List<Particle> particles;
  ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.angle);
      final paint = Paint()..color = p.color;
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6), paint);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}