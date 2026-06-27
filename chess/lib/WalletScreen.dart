// import 'package:flutter/material.dart';

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wallet"),
//       ),
//       body: const Center(
//         child: Text(
//           "Wallet Screen",
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   final String myUuid = "user-101";

//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController uuidController = TextEditingController();

//   final Map<String, double> users = {
//     "user-101": 5000,
//     "user-202": 3000,
//     "user-303": 1000,
//   };

//   final List<Map<String, dynamic>> history = [];

//   double get balance => users[myUuid] ?? 0;

//   @override
//   void dispose() {
//     amountController.dispose();
//     uuidController.dispose();
//     super.dispose();
//   }

//   void showMessage(String text, bool error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//         backgroundColor: error ? Colors.red : Colors.green,
//       ),
//     );
//   }

//   void deposit() {
//     final amount = double.tryParse(amountController.text);

//     if (amount == null || amount <= 0) {
//       showMessage("Invalid amount", true);
//       return;
//     }

//     setState(() {
//       users[myUuid] = balance + amount;

//       history.insert(0, {
//         "title": "Deposit",
//         "amount": amount,
//         "color": Colors.green,
//       });
//     });

//     amountController.clear();
//     Navigator.pop(context);
//   }

//   void withdraw() {
//     final amount = double.tryParse(amountController.text);

//     if (amount == null || amount <= 0) {
//       showMessage("Invalid amount", true);
//       return;
//     }

//     if (amount > balance) {
//       showMessage("Insufficient balance", true);
//       return;
//     }

//     setState(() {
//       users[myUuid] = balance - amount;

//       history.insert(0, {
//         "title": "Withdraw",
//         "amount": amount,
//         "color": Colors.red,
//       });
//     });

//     amountController.clear();
//     Navigator.pop(context);
//   }

//   void transfer() {
//     final amount = double.tryParse(amountController.text);
//     final receiver = uuidController.text.trim();

//     if (amount == null || amount <= 0) {
//       showMessage("Invalid amount", true);
//       return;
//     }

//     if (!users.containsKey(receiver)) {
//       showMessage("Receiver not found", true);
//       return;
//     }

//     if (receiver == myUuid) {
//       showMessage("Cannot transfer to yourself", true);
//       return;
//     }

//     if (amount > balance) {
//       showMessage("Insufficient balance", true);
//       return;
//     }

//     setState(() {
//       users[myUuid] = balance - amount;
//       users[receiver] = users[receiver]! + amount;

//       history.insert(0, {
//         "title": "Transfer to $receiver",
//         "amount": amount,
//         "color": Colors.orange,
//       });
//     });

//     amountController.clear();
//     uuidController.clear();

//     Navigator.pop(context);
//   }

//   void openDialog({
//     required String title,
//     required VoidCallback action,
//     bool showUuid = false,
//   }) {
//     amountController.clear();
//     uuidController.clear();

//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (showUuid)
//                 TextField(
//                   controller: uuidController,
//                   decoration: const InputDecoration(
//                     labelText: "Receiver UUID",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               if (showUuid)
//                 const SizedBox(height: 12),
//               TextField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Amount",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: action,
//               child: const Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget buildButton({
//     required String text,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Expanded(
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon),
//         label: Text(text),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wallet"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Colors.blue, Colors.indigo],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Current Balance",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     "\$${balance.toStringAsFixed(2)}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     "UUID: $myUuid",
//                     style: const TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 buildButton(
//                   text: "Deposit",
//                   icon: Icons.add,
//                   onPressed: () {
//                     openDialog(
//                       title: "Deposit Money",
//                       action: deposit,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 buildButton(
//                   text: "Withdraw",
//                   icon: Icons.remove,
//                   onPressed: () {
//                     openDialog(
//                       title: "Withdraw Money",
//                       action: withdraw,
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   openDialog(
//                     title: "Transfer Money",
//                     action: transfer,
//                     showUuid: true,
//                   );
//                 },
//                 icon: const Icon(Icons.send),
//                 label: const Text("Transfer"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Transaction History",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: history.isEmpty
//                   ? const Center(
//                       child: Text("No Transactions"),
//                     )
//                   : ListView.builder(
//                       itemCount: history.length,
//                       itemBuilder: (context, index) {
//                         final item = history[index];

//                         return Card(
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor:
//                                   item["color"].withOpacity(0.2),
//                               child: Icon(
//                                 Icons.account_balance_wallet,
//                                 color: item["color"],
//                               ),
//                             ),
//                             title: Text(item["title"]),
//                             trailing: Text(
//                               "\$${item["amount"]}",
//                               style: TextStyle(
//                                 color: item["color"],
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Palette (matches ChessappProfile) ───────────────────────────────────────
const _bgDark      = Color(0xFF0A0D14);
const _bgCard      = Color(0xFF111827);
const _surface     = Color(0xFF1A2236);
const _border      = Color(0xFF2A3550);
const _gold        = Color(0xFFD4AF37);
const _goldLight   = Color(0xFFFFD96A);
const _accent      = Color(0xFF4F8EF7);
const _green       = Color(0xFF22C55E);
const _red         = Color(0xFFEF4444);
const _textPrimary = Color(0xFFF1F5F9);
const _textSecond  = Color(0xFF94A3B8);

// ─── Transaction model ────────────────────────────────────────────────────────
class _Tx {
  final String type;   // 'deposit' | 'withdraw' | 'sent' | 'received'
  final int amount;
  final String note;
  final DateTime at;

  const _Tx({
    required this.type,
    required this.amount,
    required this.note,
    required this.at,
  });

  factory _Tx.fromMap(Map<String, dynamic> m) => _Tx(
        type:   m['type']   as String,
        amount: m['amount'] as int,
        note:   m['note']   as String? ?? '',
        at:     DateTime.parse(m['created_at'] as String),
      );
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;

  int _balance = 0;
  bool _loading = true;
  bool _acting  = false;
  List<_Tx> _txs = [];

  late AnimationController _balanceCtrl;
  late Animation<double>   _balanceAnim;

  @override
  void initState() {
    super.initState();
    _balanceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _balanceAnim = CurvedAnimation(
      parent: _balanceCtrl,
      curve: Curves.easeOut,
    );
    _init();
  }

  @override
  void dispose() {
    _balanceCtrl.dispose();
    super.dispose();
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await Future.wait([_loadBalance(), _loadTxs()]);
    if (mounted) {
      setState(() => _loading = false);
      _balanceCtrl.forward();
    }
  }

  Future<void> _loadBalance() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final data = await _supabase
        .from('player_stats')
        .select('wallet')
        .eq('id', user.id)
        .maybeSingle();

    if (mounted && data != null) {
      setState(() => _balance = data['wallet'] as int? ?? 0);
    }
  }

  Future<void> _loadTxs() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final rows = await _supabase
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(30);

      if (mounted) {
        setState(() => _txs = (rows as List).map((r) => _Tx.fromMap(r)).toList());
      }
    } catch (_) {
      // table might not exist yet — silent fail
    }
  }

  Future<void> _logTx(String type, int amount, String note) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      await _supabase.from('transactions').insert({
        'user_id':    user.id,
        'type':       type,
        'amount':     amount,
        'note':       note,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> _setBalance(int newBal) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    await _supabase
        .from('player_stats')
        .update({'wallet': newBal}).eq('id', user.id);
    setState(() => _balance = newBal);
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  Future<void> _deposit(int amount) async {
    if (amount <= 0) return;
    setState(() => _acting = true);
    try {
      final newBal = _balance + amount;
      await _setBalance(newBal);
      await _logTx('deposit', amount, 'Deposit');
      await _loadTxs();
      _toast('₹$amount deposited successfully!', true);
    } catch (e) {
      _toast('Deposit failed: $e', false);
    }
    setState(() => _acting = false);
  }

  Future<void> _withdraw(int amount) async {
    if (amount <= 0) return;
    if (amount > _balance) {
      _toast('Insufficient balance!', false);
      return;
    }
    setState(() => _acting = true);
    try {
      final newBal = _balance - amount;
      await _setBalance(newBal);
      await _logTx('withdraw', amount, 'Withdrawal');
      await _loadTxs();
      _toast('₹$amount withdrawn successfully!', true);
    } catch (e) {
      _toast('Withdrawal failed: $e', false);
    }
    setState(() => _acting = false);
  }

  Future<void> _transfer(String toUuid, int amount) async {
    if (amount <= 0) return;
    if (amount > _balance) {
      _toast('Insufficient balance!', false);
      return;
    }

    final me = _supabase.auth.currentUser;
    if (me == null) return;
    if (toUuid == me.id) {
      _toast('Cannot transfer to yourself!', false);
      return;
    }

    setState(() => _acting = true);
    try {
      // Check recipient exists
      final recipient = await _supabase
          .from('player_stats')
          .select('wallet')
          .eq('id', toUuid)
          .maybeSingle();

      if (recipient == null) {
        _toast('Recipient not found!', false);
        setState(() => _acting = false);
        return;
      }

      final recipientBal = recipient['wallet'] as int? ?? 0;

      // Deduct from sender
      await _setBalance(_balance - amount);

      // Add to recipient
      await _supabase
          .from('player_stats')
          .update({'wallet': recipientBal + amount}).eq('id', toUuid);

      // Log for sender
      await _logTx('sent', amount, 'Transfer to ${toUuid.substring(0, 8)}…');

      // Log for recipient (best-effort)
      try {
        await _supabase.from('transactions').insert({
          'user_id':    toUuid,
          'type':       'received',
          'amount':     amount,
          'note':       'Transfer from ${me.id.substring(0, 8)}…',
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}

      await _loadTxs();
      _toast('₹$amount sent successfully!', true);
    } catch (e) {
      _toast('Transfer failed: $e', false);
    }
    setState(() => _acting = false);
  }

  // ─── Dialogs ───────────────────────────────────────────────────────────────

  void _showDepositDialog() => _showAmountDialog(
        title: 'Deposit',
        icon: '💰',
        color: _green,
        hint: 'Enter amount to deposit',
        action: (amount) => _deposit(amount),
      );

  void _showWithdrawDialog() => _showAmountDialog(
        title: 'Withdraw',
        icon: '🏧',
        color: _accent,
        hint: 'Enter amount to withdraw',
        action: (amount) => _withdraw(amount),
      );

  void _showTransferDialog() {
    final amtCtrl  = TextEditingController();
    final uuidCtrl = TextEditingController();
    final formKey  = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: _bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: _border),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: _dialogTitle('Transfer', '🔁', _gold),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                _dialogField(
                  ctrl: uuidCtrl,
                  hint: 'Recipient UUID',
                  icon: Icons.person_outline_rounded,
                  iconColor: _gold,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter UUID';
                    final clean = v.trim();
                    // UUID: 8-4-4-4-12 hex
                    final rx = RegExp(
                      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                    );
                    if (!rx.hasMatch(clean)) return 'Invalid UUID format';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _dialogField(
                  ctrl: amtCtrl,
                  hint: 'Amount (₹)',
                  icon: Icons.currency_rupee_rounded,
                  iconColor: _gold,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter amount';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Must be > 0';
                    if (n > _balance) return 'Exceeds balance';
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Balance: ₹$_balance',
                    style: const TextStyle(color: _textSecond, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: _textSecond)),
            ),
            _dialogActionBtn(
              label: 'Send',
              color: _gold,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  _transfer(
                    uuidCtrl.text.trim(),
                    int.parse(amtCtrl.text),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountDialog({
    required String title,
    required String icon,
    required Color color,
    required String hint,
    required void Function(int) action,
  }) {
    final ctrl    = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: _bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: _border),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: _dialogTitle(title, icon, color),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                _dialogField(
                  ctrl: ctrl,
                  hint: hint,
                  icon: Icons.currency_rupee_rounded,
                  iconColor: color,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter amount';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Must be > 0';
                    if (title == 'Withdraw' && n > _balance)
                      return 'Exceeds balance';
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Balance: ₹$_balance',
                    style: const TextStyle(color: _textSecond, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: _textSecond)),
            ),
            _dialogActionBtn(
              label: title,
              color: color,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  action(int.parse(ctrl.text));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Dialog helpers ────────────────────────────────────────────────────────

  Widget _dialogTitle(String title, String icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontFamily: 'Georgia',
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    required Color iconColor,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: _textPrimary, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecond, fontSize: 14),
        prefixIcon: Icon(icon, color: iconColor, size: 18),
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: iconColor.withOpacity(0.7)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _red),
        ),
        errorStyle: const TextStyle(color: _red, fontSize: 11),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _dialogActionBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: _bgDark,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _toast(String msg, bool ok) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              ok ? Icons.check_circle_rounded : Icons.error_rounded,
              color: Colors.white,
              size: 17,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
        backgroundColor: ok ? const Color(0xFF166534) : const Color(0xFF991B1B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _loading
          ? _buildLoader()
          : Stack(
              children: [
                _buildBackground(),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildBalanceCard(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                      _buildTxHeader(),
                      const SizedBox(height: 8),
                      Expanded(child: _buildTxList()),
                    ],
                  ),
                ),
                if (_acting)
                  Container(
                    color: Colors.black.withOpacity(0.55),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: _gold,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textPrimary, size: 16),
        ),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('♜', style: TextStyle(fontSize: 16, color: _gold)),
          SizedBox(width: 8),
          Text(
            'WALLET',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.5,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('♜', style: TextStyle(fontSize: 48, color: _gold)),
          SizedBox(height: 16),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: _gold, strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(painter: _ChessBgPainter()),
    );
  }

  // ─── Balance card ──────────────────────────────────────────────────────────

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C2B18), Color(0xFF0F1A2A), Color(0xFF1A1608)],
          ),
          border: Border.all(color: _gold.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: _gold.withOpacity(0.08),
              blurRadius: 32,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gold.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('♟', style: TextStyle(fontSize: 12, color: _gold)),
                      SizedBox(width: 5),
                      Text(
                        'CHESS WALLET',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _init,
                  child: const Icon(Icons.refresh_rounded,
                      color: _gold, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Balance',
              style: TextStyle(
                color: _textSecond,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            FadeTransition(
              opacity: _balanceAnim,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      '₹',
                      style: TextStyle(
                        color: _goldLight,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$_balance',
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Georgia',
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // User ID row
            Builder(builder: (context) {
              final uid = _supabase.auth.currentUser?.id ?? '';
              return GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: uid));
                  _toast('ID copied!', true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.key_rounded,
                          color: _textSecond, size: 13),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          uid.isEmpty ? '—' : uid,
                          style: const TextStyle(
                            color: _textSecond,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.copy_rounded,
                          color: _textSecond, size: 13),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── Action buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _actionBtn(
              label: 'Deposit',
              icon: '💰',
              color: _green,
              onTap: _showDepositDialog,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionBtn(
              label: 'Withdraw',
              icon: '🏧',
              color: _accent,
              onTap: _showWithdrawDialog,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionBtn(
              label: 'Transfer',
              icon: '🔁',
              color: _gold,
              onTap: _showTransferDialog,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Transaction list ──────────────────────────────────────────────────────

  Widget _buildTxHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'HISTORY',
            style: TextStyle(
              color: _textSecond,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: _border)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Text(
              '${_txs.length}',
              style: const TextStyle(
                color: _textSecond,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTxList() {
    if (_txs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('♙', style: TextStyle(fontSize: 40, color: _textSecond)),
            SizedBox(height: 12),
            Text(
              'No transactions yet',
              style: TextStyle(color: _textSecond, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Deposit to get started',
              style: TextStyle(color: _border, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      itemCount: _txs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _buildTxItem(_txs[i]),
    );
  }

  Widget _buildTxItem(_Tx tx) {
    final isCredit = tx.type == 'deposit' || tx.type == 'received';
    final color    = isCredit ? _green : _red;
    final sign     = isCredit ? '+' : '-';

    final (icon, label) = switch (tx.type) {
      'deposit'  => ('💰', 'Deposit'),
      'withdraw' => ('🏧', 'Withdrawal'),
      'sent'     => ('📤', 'Sent'),
      'received' => ('📥', 'Received'),
      _          => ('💸', tx.type),
    };

    final timeStr = _fmtTime(tx.at);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tx.note.isNotEmpty ? tx.note : timeStr,
                  style: const TextStyle(
                    color: _textSecond,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (tx.note.isNotEmpty)
                  Text(
                    timeStr,
                    style: const TextStyle(
                      color: _border,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '$sign₹${tx.amount}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final now  = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    if (diff.inDays    <  7) return '${diff.inDays}d ago';

    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─── Background Painter ────────────────────────────────────────────────────────

class _ChessBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tileSize = 44.0;
    final paint    = Paint()
      ..color = const Color(0xFF1A2236).withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if ((r + c) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
                c * tileSize, r * tileSize, tileSize, tileSize),
            paint,
          );
        }
      }
    }

    final fade = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.2,
        colors: [
          Colors.transparent,
          _bgDark.withOpacity(0.7),
          _bgDark,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), fade);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}