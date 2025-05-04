import 'package:flutter/material.dart';
// mengimpor package google font
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Proyek UTS';
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      title: appTitle,
      // Halaman utama berisi widget AppBarScaffold yang di dalamnya memanggil widget Home()
      home: AppBarScaffold(child: Home()),
    );
  }
}

// Class Home untuk menampilkan halaman utama pada saat aplikasi dijalankan.
// Class ini menggunakan StatefulWidget untuk melakukan handle data form input.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controller untuk mengelola input form.
  final TextEditingController _inputController = TextEditingController();

  // Fungsi untuk menangani submit form.
  // Fungsi ini menggunakan async await untuk menunggu hasil dari navigasi.
  // Kemudian di akhir fungsi akan dilakukan reset form.
  void _handleSubmit() async {
    // Menyimpan data input form ke dalam variabel nama.
    // Fungsi trim() digunakan untuk membersihkan whitespace di awal dan akhir string.
    final nama = _inputController.text.trim();

    // Melakukan pengecekan apakah terdapat data input.
    // Jika ada, lakukan navigasi ke widget ValidResponse().
    // Jika tidak ada, lakukan navigasi ke widget InvalidResponse().
    if (nama.isNotEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ValidResponse(nama: nama)),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InvalidResponse()),
      );
    }

    // Mengosongkan form input.
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarScaffold(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          // Widget ditampilkan dalam layout Column
          // Di dalamnya tersusun widget sebagai berikut:
          // 1. HeadingText (Widget kustom): menampilkan teks "Hai, siapa nama kamu?"
          // 2. TextField: menampilkan form input untuk nama
          // 3. ActionButton (Widget kustom): menampilkan tombol submit
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeadingText(text: 'Hai, siapa nama kamu?'),
              SizedBox(height: 10),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama kamu',
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: GoogleFonts.outfit(fontSize: 14),
                ),
                style: GoogleFonts.outfit(fontSize: 14),
              ),
              SizedBox(height: 20),
              ActionButton(onPressed: _handleSubmit, text: 'Kirim'),
            ],
          ),
        ),
      ),
    );
  }
}

// Class ini menampilkan halaman valid respons ketika form input memiliki nilai.
class ValidResponse extends StatelessWidget {
  const ValidResponse({super.key, required this.nama});
  final String nama;

  @override
  Widget build(BuildContext context) {
    // ResponsePage adalah widget kustom.
    // Penjelasan tentang widget ada pada class ResponsePage.
    return ResponsePage(heading: '👋 Halo $nama! Senang bertemu dengan mu.');
  }
}

// Class ini menampilkan halaman invalid respons ketika form input tidak memiliki nilai.
class InvalidResponse extends StatelessWidget {
  const InvalidResponse({super.key});

  @override
  Widget build(BuildContext context) {
    // ResponsePage adalah widget kustom.
    // Penjelasan tentang widget ada pada class ResponsePage.
    return ResponsePage(heading: 'Hai ! Kamu belum memberi tahu namamu 😅');
  }
}

// Class AppBarScaffold untuk menampilkan AppBar.
// Class ini merupakan widget kustom untuk menampilkan AppBar
// dengan properti-properti yang sudah ditentukan,
// sehingga dapat dipanggil di banyak halaman
// tanpa perlu mengulang properti-propertinya.
class AppBarScaffold extends StatelessWidget {
  const AppBarScaffold({super.key, required this.child});
  // Properti child untuk menampung widget yang akan ditampilkan di dalam body.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyek UTS'),
        titleTextStyle: GoogleFonts.outfit(fontSize: 16, color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.grey.shade200,
      body: child,
    );
  }
}

// Class ResponsePage untuk menampilkan halaman respon input form.
// Class ini berisi kumpulan widget-widget pada halaman respon,
// dan akan digunakan pada class ValidResponse dan InvalidResponse.
class ResponsePage extends StatelessWidget {
  const ResponsePage({super.key, required this.heading});
  final String heading;

  @override
  Widget build(BuildContext context) {
    return AppBarScaffold(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          // Widget ditampilkan dalam layout Column
          // Di dalamnya tersusun widget sebagai berikut:
          // 1. HeadingText (Widget kustom): menampilkan teks sesuai dengan parameter heading
          // 2. ActionButton (Widget kustom): menampilkan tombol kembali
          // Ketika tombol ini ditekan, akan kembali ke halaman sebelumnya
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeadingText(text: heading),
              SizedBox(height: 20),
              ActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Kembali',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Class HeadingText untuk menampilkan teks dengan pre-defined property.
// Class ini membutuhkan parameter text.
// Parameter text adalah teks yang akan ditampilkan pada HeadingText.
class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// Class ActionButton untuk menampilkan tombol dengan pre-defined property.
// Class ini membutuhkan parameter onPressed dan text.
// Parameter onPressed adalah fungsi yang akan dipanggil ketika tombol ditekan.
// Parameter text adalah teks yang akan ditampilkan pada tombol.
class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        textStyle: GoogleFonts.outfit(),
      ),
      child: Text(text),
    );
  }
}
