import 'package:flutter/material.dart';

void main() {
  runApp(const DuitkuApp());
}

// ============================================
// WARNA TEMA — terang & gelap
// ============================================
class AppColors {
  // Aksen utama (hijau-mint, sama di kedua tema)
  static const hijau = Color(0xFF2DBd78);
  static const merah = Color(0xFFFF5D6C);

  // Tema TERANG
  static const lightBg = Color(0xFFF5F5F5);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF1A1A1A);
  static const lightTextSoft = Color(0xFF8A8A8A);

  // Tema GELAP
  static const darkBg = Color(0xFF0F1419);
  static const darkCard = Color(0xFF1A1F26);
  static const darkText = Color(0xFFF5F5F5);
  static const darkTextSoft = Color(0xFF8A8A8A);
}

// ============================================
// MODEL KATEGORI
// ============================================
class Kategori {
  final String nama;
  final IconData icon;
  const Kategori({required this.nama, required this.icon});
}

const List<Kategori> kategoriPengeluaran = [
  Kategori(nama: 'Makanan', icon: Icons.restaurant),
  Kategori(nama: 'Transport', icon: Icons.directions_car),
  Kategori(nama: 'Belanja', icon: Icons.shopping_bag),
  Kategori(nama: 'Tagihan', icon: Icons.receipt_long),
  Kategori(nama: 'Hiburan', icon: Icons.movie),
  Kategori(nama: 'Lainnya', icon: Icons.category),
];

const List<Kategori> kategoriPemasukan = [
  Kategori(nama: 'Gaji', icon: Icons.payments),
  Kategori(nama: 'Bonus', icon: Icons.card_giftcard),
  Kategori(nama: 'Investasi', icon: Icons.trending_up),
  Kategori(nama: 'Lainnya', icon: Icons.attach_money),
];

// ============================================
// MODEL TRANSAKSI
// ============================================
class Transaksi {
  final String judul;
  final double jumlah;
  final bool isPemasukan;
  final DateTime tanggal;
  final Kategori kategori;

  Transaksi({
    required this.judul,
    required this.jumlah,
    required this.isPemasukan,
    required this.tanggal,
    required this.kategori,
  });
}

// ============================================
// MODEL BUDGET per kategori
// ============================================
class BudgetKategori {
  final String nama;
  final IconData icon;
  final double terpakai; // sudah dipakai
  final double batas;    // batas budget

  const BudgetKategori({
    required this.nama,
    required this.icon,
    required this.terpakai,
    required this.batas,
  });

  double get persen => (terpakai / batas).clamp(0.0, 1.0);
  bool get hampirHabis => persen >= 0.85;
}

// Data budget contoh
final List<BudgetKategori> budgetList = [
  const BudgetKategori(nama: 'Groceries', icon: Icons.shopping_cart, terpakai: 1200000, batas: 1500000),
  const BudgetKategori(nama: 'Food & Drink', icon: Icons.restaurant, terpakai: 920000, batas: 1000000),
  const BudgetKategori(nama: 'Transport', icon: Icons.directions_car, terpakai: 420000, batas: 800000),
  const BudgetKategori(nama: 'Hiburan', icon: Icons.movie, terpakai: 300000, batas: 600000),
];

// ============================================
// MODEL SAVING GOAL (#09)
// ============================================
class SavingGoal {
  final String nama;
  final IconData icon;
  final double terkumpul;
  final double target;
  final Color warna;

  const SavingGoal({
    required this.nama,
    required this.icon,
    required this.terkumpul,
    required this.target,
    required this.warna,
  });

  double get persen => (terkumpul / target).clamp(0.0, 1.0);
  int get persenBulat => (persen * 100).round();
}

final List<SavingGoal> savingGoals = [
  const SavingGoal(nama: 'Emergency Fund', icon: Icons.shield, terkumpul: 9000000, target: 15000000, warna: AppColors.hijau),
  const SavingGoal(nama: 'New Laptop', icon: Icons.laptop_mac, terkumpul: 12000000, target: 20000000, warna: Color(0xFF7C6FF0)),
  const SavingGoal(nama: 'Bali Trip', icon: Icons.flight, terkumpul: 3000000, target: 10000000, warna: Color(0xFF3BA9F4)),
  const SavingGoal(nama: 'New Phone', icon: Icons.phone_iphone, terkumpul: 7500000, target: 9000000, warna: Color(0xFFF5A623)),
];

// ============================================
// APP UTAMA — atur tema terang/gelap
// ============================================
class DuitkuApp extends StatefulWidget {
  const DuitkuApp({super.key});

  @override
  State<DuitkuApp> createState() => _DuitkuAppState();
}

class _DuitkuAppState extends State<DuitkuApp> {
  bool _isDark = false; // false = terang, true = gelap

  void _toggleTema() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duitku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _isDark ? AppColors.darkBg : AppColors.lightBg,
        fontFamily: 'Roboto',
        brightness: _isDark ? Brightness.dark : Brightness.light,
      ),
      home: SplashPage(isDark: _isDark, onToggleTema: _toggleTema),
    );
  }
}

// ============================================
// NAVIGASI UTAMA — bottom nav bar
// ============================================
class MainNavigation extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTema;

  const MainNavigation({super.key, required this.isDark, required this.onToggleTema});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _indexTerpilih = 0;

  // Daftar transaksi (data lokal) — dipakai bersama antar halaman
  final List<Transaksi> _transaksiList = [
    Transaksi(judul: 'Gaji', jumlah: 8200000, isPemasukan: true, tanggal: DateTime.now(), kategori: kategoriPemasukan[0]),
    Transaksi(judul: 'Kopi Tuku', jumlah: 32000, isPemasukan: false, tanggal: DateTime.now(), kategori: kategoriPengeluaran[0]),
    Transaksi(judul: 'Gojek ride', jumlah: 32000, isPemasukan: false, tanggal: DateTime.now(), kategori: kategoriPengeluaran[1]),
  ];

  void _tambahTransaksi(Transaksi trx) {
    setState(() => _transaksiList.insert(0, trx));
  }

  void _hapusTransaksi(int index) {
    setState(() => _transaksiList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bgCard = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    // Halaman yang tampil sesuai tab
    final List<Widget> halaman = [
      DashboardPage(
        isDark: isDark,
        transaksiList: _transaksiList,
        onHapus: _hapusTransaksi,
      ),
      BudgetPage(isDark: isDark),
      AnalyticsPage(isDark: isDark, transaksiList: _transaksiList),
      ProfilePage(isDark: isDark, onToggleTema: widget.onToggleTema),
    ];

    return Scaffold(
      body: halaman[_indexTerpilih],
      // Tombol tambah transaksi (tengah)
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.hijau,
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage(isDark: isDark)),
          );
          if (hasil != null && hasil is Transaksi) {
            _tambahTransaksi(hasil);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Bottom navigation
      bottomNavigationBar: BottomAppBar(
        color: bgCard,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 64,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_rounded, 'Home', textSoft),
            _navItem(1, Icons.account_balance_wallet_rounded, 'Budget', textSoft),
            const SizedBox(width: 40), // ruang buat FAB
            _navItem(2, Icons.bar_chart_rounded, 'Stats', textSoft),
            _navItem(3, Icons.person_rounded, 'Profile', textSoft),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, Color textSoft) {
    final aktif = _indexTerpilih == index;
    return InkWell(
      onTap: () => setState(() => _indexTerpilih = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: aktif ? AppColors.hijau : textSoft, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: aktif ? AppColors.hijau : textSoft, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// DASHBOARD
// ============================================
class DashboardPage extends StatelessWidget {
  final bool isDark;
  final List<Transaksi> transaksiList;
  final Function(int) onHapus;

  const DashboardPage({super.key, required this.isDark, required this.transaksiList, required this.onHapus});

  double get _saldoTotal {
    double t = 0;
    for (var x in transaksiList) {
      t += x.isPemasukan ? x.jumlah : -x.jumlah;
    }
    return t;
  }

  double get _totalPemasukan {
    double t = 0;
    for (var x in transaksiList) {
      if (x.isPemasukan) t += x.jumlah;
    }
    return t;
  }

  double get _totalPengeluaran {
    double t = 0;
    for (var x in transaksiList) {
      if (!x.isPemasukan) t += x.jumlah;
    }
    return t;
  }

  // Sapaan berdasarkan jam sekarang
  String _sapaan() {
    final jam = DateTime.now().hour;
    if (jam >= 0 && jam < 11) return 'Good morning';
    if (jam >= 11 && jam < 15) return 'Good afternoon';
    if (jam >= 15 && jam < 18) return 'Good evening';
    return 'Good night';
  }

  // Format jam sekarang: "15:42"
  String _jamSekarang() {
    final now = DateTime.now();
    final jam = now.hour.toString().padLeft(2, '0');
    final menit = now.minute.toString().padLeft(2, '0');
    return '$jam:$menit';
  }

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    return SafeArea(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
            // Header sapaan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.hijau, child: const Text('R', style: TextStyle(color: Colors.white))),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_sapaan()} • ${_jamSekarang()}', style: TextStyle(color: textSoft, fontSize: 12)),
                        Text('Rohelio', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InsightsPage(isDark: isDark, transaksiList: transaksiList))),
                      child: Icon(Icons.auto_awesome_outlined, color: text),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SavingsPage(isDark: isDark))),
                      child: Icon(Icons.savings_outlined, color: text),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.notifications_none, color: text),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kartu saldo (hijau gradient seperti desain)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2DBd78), Color(0xFF1F9D63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL BALANCE', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(_rp(_saldoTotal), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _miniStat('INCOME', _rp(_totalPemasukan), Icons.arrow_downward)),
                      const SizedBox(width: 12),
                      Expanded(child: _miniStat('EXPENSE', _rp(_totalPengeluaran), Icons.arrow_upward)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent activity header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent activity', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionHistoryPage(isDark: isDark, transaksiList: transaksiList))),
                  child: Text('See all', style: const TextStyle(color: AppColors.hijau, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List transaksi (Column biasa di dalam ListView utama)
            if (transaksiList.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text('Belum ada transaksi', style: TextStyle(color: textSoft))),
              )
            else
              ...transaksiList.asMap().entries.map((entry) {
                final index = entry.key;
                final trx = entry.value;
                return Container(
                  key: ValueKey('trx_$index'),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (trx.isPemasukan ? AppColors.hijau : AppColors.merah).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(trx.kategori.icon, color: trx.isPemasukan ? AppColors.hijau : AppColors.merah, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trx.judul, style: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(trx.kategori.nama, style: TextStyle(color: textSoft, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        '${trx.isPemasukan ? '+' : '-'}${_rp(trx.jumlah)}',
                        style: TextStyle(color: trx.isPemasukan ? AppColors.hijau : AppColors.merah, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => onHapus(index),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.delete_outline, color: textSoft, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
    );
  }

  Widget _miniStat(String label, String nilai, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.white, size: 14), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))]),
          const SizedBox(height: 4),
          Text(nilai, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ============================================
// HALAMAN TAMBAH TRANSAKSI
// ============================================
class AddTransactionPage extends StatefulWidget {
  final bool isDark;
  const AddTransactionPage({super.key, required this.isDark});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();
  bool _isPemasukan = false;
  Kategori? _kategoriDipilih;

  List<Kategori> get _kategoriTersedia => _isPemasukan ? kategoriPemasukan : kategoriPengeluaran;

  void _simpan() {
    final judul = _judulController.text;
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;
    if (judul.isEmpty || jumlah <= 0 || _kategoriDipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi judul, jumlah & pilih kategori')));
      return;
    }
    Navigator.pop(context, Transaksi(
      judul: judul, jumlah: jumlah, isPemasukan: _isPemasukan,
      tanggal: DateTime.now(), kategori: _kategoriDipilih!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text('New Transaction', style: TextStyle(color: text)),
        iconTheme: IconThemeData(color: text),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Income/Expense
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: _toggleBtn('Expense', !_isPemasukan, AppColors.merah, () => setState(() { _isPemasukan = false; _kategoriDipilih = null; }))),
                  Expanded(child: _toggleBtn('Income', _isPemasukan, AppColors.hijau, () => setState(() { _isPemasukan = true; _kategoriDipilih = null; }))),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Amount besar (hero)
            Center(child: Text('AMOUNT', style: TextStyle(color: textSoft, fontSize: 12, letterSpacing: 1))),
            const SizedBox(height: 8),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(color: text, fontSize: 36, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Rp 0',
                hintStyle: TextStyle(color: textSoft, fontSize: 36, fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 24),

            // Kategori grid
            Text('Category', style: TextStyle(color: textSoft)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: _kategoriTersedia.map((kat) {
                final dipilih = _kategoriDipilih == kat;
                return GestureDetector(
                  onTap: () => setState(() => _kategoriDipilih = kat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: dipilih ? AppColors.hijau : card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(kat.icon, size: 18, color: dipilih ? Colors.white : textSoft),
                      const SizedBox(width: 8),
                      Text(kat.nama, style: TextStyle(color: dipilih ? Colors.white : text)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Judul
            Text('Note', style: TextStyle(color: textSoft)),
            const SizedBox(height: 8),
            TextField(
              controller: _judulController,
              style: TextStyle(color: text),
              decoration: InputDecoration(
                hintText: 'e.g. Morning coffee',
                hintStyle: TextStyle(color: textSoft),
                filled: true, fillColor: card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.hijau,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Transaction', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, bool aktif, Color warna, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: aktif ? warna : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(label, style: TextStyle(color: aktif ? Colors.white : (widget.isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft), fontWeight: FontWeight.bold))),
      ),
    );
  }
}

// ============================================
// HALAMAN BUDGET (#07)
// ============================================
class BudgetPage extends StatelessWidget {
  final bool isDark;
  const BudgetPage({super.key, required this.isDark});

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  // Format singkat: 1.2jt, 800k
  String _singkat(double a) {
    if (a >= 1000000) {
      final jt = a / 1000000;
      return '${jt.toStringAsFixed(jt.truncateToDouble() == jt ? 0 : 1)}jt';
    }
    if (a >= 1000) return '${(a / 1000).toStringAsFixed(0)}k';
    return a.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    // Hitung total budget & terpakai
    double totalBatas = 0;
    double totalTerpakai = 0;
    for (var b in budgetList) {
      totalBatas += b.batas;
      totalTerpakai += b.terpakai;
    }
    final sisa = totalBatas - totalTerpakai;
    final persenTotal = (totalTerpakai / totalBatas).clamp(0.0, 1.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Budget', style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Text('June', style: TextStyle(color: text, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: textSoft),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kartu spent overview (gelap, seperti desain)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F26),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SPENT OF ${_rp(totalBatas)}', style: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_rp(totalTerpakai), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                      Text('${_rp(sisa)}\nleft to spend', textAlign: TextAlign.right, style: const TextStyle(color: AppColors.hijau, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress bar total
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: persenTotal,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(AppColors.hijau),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Edit', style: const TextStyle(color: AppColors.hijau, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),

            // List budget per kategori
            ...budgetList.map((b) {
              final warnaBar = b.hampirHabis ? AppColors.merah : AppColors.hijau;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: warnaBar.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                          child: Icon(b.icon, color: warnaBar, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(b.nama, style: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.w600))),
                        Text('${_singkat(b.terpakai)} / ${_singkat(b.batas)}', style: TextStyle(color: textSoft, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: b.persen,
                        minHeight: 6,
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                        valueColor: AlwaysStoppedAnimation(warnaBar),
                      ),
                    ),
                    if (b.hampirHabis) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: AppColors.merah, size: 14),
                          const SizedBox(width: 4),
                          Text('Almost over budget', style: const TextStyle(color: AppColors.merah, fontSize: 12)),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ============================================
// HALAMAN ANALYTICS / STATS (#08)
// ============================================
class AnalyticsPage extends StatelessWidget {
  final bool isDark;
  final List<Transaksi> transaksiList;
  const AnalyticsPage({super.key, required this.isDark, required this.transaksiList});

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    // Hitung income & expense
    double income = 0, expense = 0;
    for (var t in transaksiList) {
      if (t.isPemasukan) { income += t.jumlah; } else { expense += t.jumlah; }
    }

    // Breakdown pengeluaran per kategori
    final Map<String, double> perKategori = {};
    for (var t in transaksiList) {
      if (!t.isPemasukan) {
        perKategori[t.kategori.nama] = (perKategori[t.kategori.nama] ?? 0) + t.jumlah;
      }
    }
    final totalExpense = expense == 0 ? 1 : expense;
    final entries = perKategori.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Data dummy untuk grafik mingguan (income vs expense per minggu)
    final mingguan = [
      {'label': 'W1', 'in': 0.6, 'out': 0.4},
      {'label': 'W2', 'in': 0.8, 'out': 0.5},
      {'label': 'W3', 'in': 0.5, 'out': 0.7},
      {'label': 'W4', 'in': 0.9, 'out': 0.3},
    ];

    final warnaKategori = [AppColors.hijau, const Color(0xFF7C6FF0), const Color(0xFF3BA9F4), const Color(0xFFF5A623), AppColors.merah];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analytics', style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Toggle Week/Month/Year (statis, visual)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _periodeBtn('Week', false, textSoft, text),
                  _periodeBtn('Month', true, textSoft, text),
                  _periodeBtn('Year', false, textSoft, text),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grafik Income vs Expense (bar chart sederhana)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Income vs Expense', style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      _legend('In', AppColors.hijau, textSoft),
                      const SizedBox(width: 12),
                      _legend('Out', AppColors.merah, textSoft),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bar chart manual
                  SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: mingguan.map((m) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _bar((m['in'] as double) * 120, AppColors.hijau),
                                const SizedBox(width: 4),
                                _bar((m['out'] as double) * 120, AppColors.merah),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(m['label'] as String, style: TextStyle(color: textSoft, fontSize: 11)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Where it went - breakdown kategori
            Text('Where it went', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(20)),
              child: entries.isEmpty
                  ? Text('Belum ada pengeluaran', style: TextStyle(color: textSoft))
                  : Column(
                      children: [
                        Text('TOTAL', style: TextStyle(color: textSoft, fontSize: 11, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(_rp(expense), style: TextStyle(color: text, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ...entries.asMap().entries.map((e) {
                          final idx = e.key;
                          final nama = e.value.key;
                          final nilai = e.value.value;
                          final persen = ((nilai / totalExpense) * 100).round();
                          final warna = warnaKategori[idx % warnaKategori.length];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(width: 10, height: 10, decoration: BoxDecoration(color: warna, shape: BoxShape.circle)),
                                const SizedBox(width: 10),
                                Expanded(child: Text(nama, style: TextStyle(color: text, fontSize: 14))),
                                Text('$persen%', style: TextStyle(color: textSoft, fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodeBtn(String label, bool aktif, Color textSoft, Color text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: aktif ? AppColors.hijau : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(label, style: TextStyle(color: aktif ? Colors.white : textSoft, fontWeight: FontWeight.w600))),
      ),
    );
  }

  Widget _legend(String label, Color warna, Color textSoft) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: warna, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: textSoft, fontSize: 12)),
    ]);
  }

  Widget _bar(double tinggi, Color warna) {
    return Container(width: 12, height: tinggi, decoration: BoxDecoration(color: warna, borderRadius: BorderRadius.circular(4)));
  }
}

// ============================================
// HALAMAN SAVINGS GOALS (#09)
// ============================================
class SavingsPage extends StatelessWidget {
  final bool isDark;
  const SavingsPage({super.key, required this.isDark});

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    final utama = savingGoals.first;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Savings Goals', style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.hijau, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kartu goal utama (besar, dengan progress lingkaran)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [utama.warna, utama.warna.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Icon(utama.icon, color: Colors.white, size: 18), const SizedBox(width: 8), Text(utama.nama, style: const TextStyle(color: Colors.white, fontSize: 14))]),
                        const SizedBox(height: 12),
                        Text(_rp(utama.terkumpul), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        Text('of ${_rp(utama.target)} goal', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  // Progress lingkaran
                  SizedBox(
                    width: 64, height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(width: 64, height: 64, child: CircularProgressIndicator(value: utama.persen, strokeWidth: 6, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white))),
                        Text('${utama.persenBulat}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('All goals', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // List semua goal
            ...savingGoals.map((g) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: g.warna.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: Icon(g.icon, color: g.warna, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.nama, style: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.w600)),
                              Text('${_rp(g.terkumpul)} / ${_rp(g.target)}', style: TextStyle(color: textSoft, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('${g.persenBulat}%', style: TextStyle(color: g.warna, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: g.persen,
                        minHeight: 6,
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                        valueColor: AlwaysStoppedAnimation(g.warna),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ============================================
// HALAMAN TRANSACTION HISTORY (#06)
// ============================================
class TransactionHistoryPage extends StatefulWidget {
  final bool isDark;
  final List<Transaksi> transaksiList;
  const TransactionHistoryPage({super.key, required this.isDark, required this.transaksiList});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  String _filter = 'All'; // All / Income / Expense
  String _cari = '';

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  String _formatTanggal(DateTime t) {
    const bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${t.day} ${bulan[t.month - 1]} ${t.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    final card = widget.isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = widget.isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = widget.isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    // Filter transaksi sesuai pilihan + pencarian
    List<Transaksi> hasil = widget.transaksiList.where((t) {
      // filter tipe
      if (_filter == 'Income' && !t.isPemasukan) return false;
      if (_filter == 'Expense' && t.isPemasukan) return false;
      // filter pencarian (judul atau kategori)
      if (_cari.isNotEmpty) {
        final q = _cari.toLowerCase();
        if (!t.judul.toLowerCase().contains(q) && !t.kategori.nama.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text('Transactions', style: TextStyle(color: text)),
        iconTheme: IconThemeData(color: text),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _cari = v),
              style: TextStyle(color: text),
              decoration: InputDecoration(
                hintText: 'Search transactions',
                hintStyle: TextStyle(color: textSoft),
                prefixIcon: Icon(Icons.search, color: textSoft),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _filterPill('All', card, textSoft),
                const SizedBox(width: 8),
                _filterPill('Income', card, textSoft),
                const SizedBox(width: 8),
                _filterPill('Expense', card, textSoft),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List transaksi (dikelompokkan per tanggal)
          Expanded(
            child: hasil.isEmpty
                ? Center(child: Text('Tidak ada transaksi', style: TextStyle(color: textSoft)))
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: _buildGrouped(hasil, card, text, textSoft),
                  ),
          ),
        ],
      ),
    );
  }

  // Kelompokkan transaksi per tanggal jadi list widget
  List<Widget> _buildGrouped(List<Transaksi> data, Color card, Color text, Color textSoft) {
    // Urutkan dari terbaru
    final sorted = [...data]..sort((a, b) => b.tanggal.compareTo(a.tanggal));

    // Kelompokkan berdasar label hari
    final Map<String, List<Transaksi>> grup = {};
    for (var t in sorted) {
      final label = _labelGrup(t.tanggal);
      grup.putIfAbsent(label, () => []).add(t);
    }

    final List<Widget> widgets = [];
    grup.forEach((label, list) {
      // Hitung total hari itu (income - expense)
      double total = 0;
      for (var t in list) {
        total += t.isPemasukan ? t.jumlah : -t.jumlah;
      }
      // Header grup
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: textSoft, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            Text('${total >= 0 ? '+' : '-'}${_rp(total.abs())}',
                style: TextStyle(color: total >= 0 ? AppColors.hijau : AppColors.merah, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ));
      // Baris transaksi
      for (var t in list) {
        widgets.add(_rowTransaksi(t, card, text, textSoft));
      }
    });
    return widgets;
  }

  // Tentukan label grup: Hari Ini / Kemarin / tanggal
  String _labelGrup(DateTime t) {
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);
    final tgl = DateTime(t.year, t.month, t.day);
    final selisih = hariIni.difference(tgl).inDays;
    if (selisih == 0) return 'HARI INI';
    if (selisih == 1) return 'KEMARIN';
    return _formatTanggal(t).toUpperCase();
  }

  // Widget satu baris transaksi
  Widget _rowTransaksi(Transaksi trx, Color card, Color text, Color textSoft) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (trx.isPemasukan ? AppColors.hijau : AppColors.merah).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(trx.kategori.icon, color: trx.isPemasukan ? AppColors.hijau : AppColors.merah, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trx.judul, style: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(trx.kategori.nama, style: TextStyle(color: textSoft, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${trx.isPemasukan ? '+' : '-'}${_rp(trx.jumlah)}',
            style: TextStyle(color: trx.isPemasukan ? AppColors.hijau : AppColors.merah, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _filterPill(String label, Color card, Color textSoft) {
    final aktif = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: aktif ? AppColors.hijau : card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: aktif ? Colors.white : textSoft, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}

// ============================================
// HALAMAN INSIGHTS / AI (#10)
// Insight dihitung dari data transaksi (rule-based, bukan LLM)
// ============================================
class InsightsPage extends StatelessWidget {
  final bool isDark;
  final List<Transaksi> transaksiList;
  const InsightsPage({super.key, required this.isDark, required this.transaksiList});

  String _rp(double a) => 'Rp ${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    // Hitung data buat insight
    double income = 0, expense = 0;
    final Map<String, double> perKategori = {};
    for (var t in transaksiList) {
      if (t.isPemasukan) {
        income += t.jumlah;
      } else {
        expense += t.jumlah;
        perKategori[t.kategori.nama] = (perKategori[t.kategori.nama] ?? 0) + t.jumlah;
      }
    }
    final hemat = income - expense;

    // Kategori pengeluaran terbesar
    String kategoriTerbesar = '-';
    double nilaiTerbesar = 0;
    perKategori.forEach((k, v) {
      if (v > nilaiTerbesar) { nilaiTerbesar = v; kategoriTerbesar = k; }
    });

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: text),
        title: Row(
          children: [
            Text('Insights', style: TextStyle(color: text)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.hijau, borderRadius: BorderRadius.circular(8)),
              child: const Text('AI', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu summary (gelap, gradient)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A1F26), Color(0xFF2A2F38)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR SUMMARY', style: TextStyle(color: AppColors.hijau, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    hemat >= 0
                        ? 'Kamu berhasil hemat ${_rp(hemat)} bulan ini. Pengeluaran terbesar di $kategoriTerbesar. Pertahankan!'
                        : 'Pengeluaran melebihi pemasukan ${_rp(hemat.abs())}. Pengeluaran terbesar di $kategoriTerbesar. Yuk lebih hemat!',
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Smart recommendations', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Rekomendasi (dihasilkan dari data)
            _rekomendasi(
              Icons.lightbulb_outline,
              'Pengeluaran terbesar: $kategoriTerbesar',
              nilaiTerbesar > 0 ? 'Kamu habis ${_rp(nilaiTerbesar)} di $kategoriTerbesar. Coba kurangi 10% bulan depan.' : 'Belum ada data pengeluaran.',
              card, text, textSoft,
            ),
            const SizedBox(height: 12),
            _rekomendasi(
              Icons.savings_outlined,
              hemat >= 0 ? 'Kamu lagi on track' : 'Perlu lebih hemat',
              hemat >= 0 ? 'Sisihkan ${_rp(hemat * 0.3)} ke tabungan untuk capai goal lebih cepat.' : 'Kurangi pengeluaran non-esensial minggu ini.',
              card, text, textSoft,
            ),
            const SizedBox(height: 12),
            _rekomendasi(
              Icons.trending_up,
              'Rasio tabungan',
              income > 0 ? 'Kamu menabung ${((hemat / income) * 100).clamp(0, 100).toStringAsFixed(0)}% dari pemasukan. Target ideal 20%.' : 'Belum ada pemasukan tercatat.',
              card, text, textSoft,
            ),
            const SizedBox(height: 24),

            // Challenge gamification
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5A623).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF5A623).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF5A623), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Challenge', style: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('No-spend weekend • 2 of 4 done', style: TextStyle(color: textSoft, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rekomendasi(IconData icon, String judul, String isi, Color card, Color text, Color textSoft) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.hijau.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.hijau, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(isi, style: TextStyle(color: textSoft, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// HALAMAN PLACEHOLDER (Budget, Stats — nanti diisi)
// ============================================
class PlaceholderPage extends StatelessWidget {
  final String judul;
  final bool isDark;
  const PlaceholderPage({super.key, required this.judul, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 60, color: textSoft),
            const SizedBox(height: 16),
            Text('Halaman $judul', style: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Segera hadir', style: TextStyle(color: textSoft)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// HALAMAN PROFILE (dengan toggle dark mode)
// ============================================
class ProfilePage extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTema;
  const ProfilePage({super.key, required this.isDark, required this.onToggleTema});

  @override
  Widget build(BuildContext context) {
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSoft = isDark ? AppColors.darkTextSoft : AppColors.lightTextSoft;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // Kartu profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: AppColors.hijau, child: const Text('R', style: TextStyle(color: Colors.white, fontSize: 24))),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rohelio Marusi', style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('roheliomarusis@gmail.com', style: TextStyle(color: textSoft, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Toggle dark mode
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(Icons.dark_mode, color: textSoft),
                  const SizedBox(width: 16),
                  Expanded(child: Text('Dark mode', style: TextStyle(color: text, fontSize: 16))),
                  Switch(
                    value: isDark,
                    activeColor: AppColors.hijau,
                    onChanged: (_) => onToggleTema(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _menuItem(Icons.notifications_none, 'Notifications', card, text, textSoft),
            const SizedBox(height: 12),
            _menuItem(Icons.lock_outline, 'Security & PIN', card, text, textSoft),
            const SizedBox(height: 12),
            _menuItem(Icons.download_outlined, 'Export data', card, text, textSoft),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, Color card, Color text, Color textSoft) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: textSoft),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: TextStyle(color: text, fontSize: 16))),
          Icon(Icons.chevron_right, color: textSoft),
        ],
      ),
    );
  }
}


// ============================================
// HALAMAN SPLASH (#01)
// ============================================
class SplashPage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTema;
  const SplashPage({super.key, required this.isDark, required this.onToggleTema});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Auto pindah ke app setelah 2.5 detik
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigation(isDark: widget.isDark, onToggleTema: widget.onToggleTema),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo dompet dalam kotak hijau bercahaya
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.hijau,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.hijau.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'DuitKu',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            Text(
              'Atur duit, tenang hati',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
            ),
            const Spacer(),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.hijau),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SECURED BY 256-BIT ENCRYPTION',
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, letterSpacing: 1.5),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}