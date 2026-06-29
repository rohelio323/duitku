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
      home: MainNavigation(isDark: _isDark, onToggleTema: _toggleTema),
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
      PlaceholderPage(judul: 'Budget', isDark: isDark),
      PlaceholderPage(judul: 'Statistik', isDark: isDark),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Icon(Icons.notifications_none, color: text),
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
                Text('See all', style: TextStyle(color: AppColors.hijau, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),

            // List transaksi
            Expanded(
              child: transaksiList.isEmpty
                  ? Center(child: Text('Belum ada transaksi', style: TextStyle(color: textSoft)))
                  : ListView.builder(
                      itemCount: transaksiList.length,
                      itemBuilder: (context, index) {
                        final trx = transaksiList[index];
                        return Container(
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
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: textSoft, size: 20),
                                onPressed: () => onHapus(index),
                              ),
                            ],
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
