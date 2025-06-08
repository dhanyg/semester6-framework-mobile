import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// Tahap request data API ke https://api-harilibur.vercel.app/api
// Tautan tersebut berisi data hari libur di Indonesia.
Future<List<HariLibur>> ambilData() async {
  final response = await http.get(
    Uri.parse('https://api-harilibur.vercel.app/api'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => HariLibur.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mengambil data.');
  }
}

// Mendefinisikan model dan factory untuk membuat obyek Hari Libur.
// Model ini merepresentasikan data yang akan kita ambil dan dipakai dari response API nanti.
class HariLibur {
  final String date;
  final String name;
  final bool isNational;

  const HariLibur({
    required this.date,
    required this.name,
    required this.isNational,
  });

  factory HariLibur.fromJson(Map<String, dynamic> json) {
    return HariLibur(
      date: json['holiday_date'],
      name: json['holiday_name'],
      isNational: json['is_national_holiday'],
    );
  }
}

void main() {
  initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<HariLibur>> hariLibur;

  // Proses ambil data API pada saat inisialisasi sebelum widget dirender.
  @override
  void initState() {
    super.initState();
    hariLibur = ambilData();
  }

  // Menampilkan komponen UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Hari Libur',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'KapanLibur?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          // FutureBuilder digunakan karena UI yang akan dibangun membutuhkan data dari proses async ambilData().
          child: FutureBuilder<List<HariLibur>>(
            future: hariLibur,
            builder: (context, snapshot) {
              // Penngecekan status dari Future. Apabila data sudah didapat maka tampilkan widget ListView.
              // ListView berisi widget Card yang di dalamnya berisi widget ListTile.
              if (snapshot.hasData) {
                final listLibur = snapshot.data!.reversed.toList();
                return ListView.builder(
                  itemCount: listLibur.length,
                  itemBuilder: (context, index) {
                    final libur = listLibur[index];
                    return Card(
                      child: ListTile(
                        // Di sini dilakukan parsing data tanggal dari tipe String ke tipe DateTime 
                        // dengan format bulan dalam bahasa Indonesia.
                        // Digunakan fungsi kustom padTanggal() untuk memformat tanggal yang didapat dari API
                        // agar sesuai dengan format penulisan tanggal 2 digit.
                        title: Text(
                          DateFormat(
                            'd MMMM yyyy',
                            'id_ID',
                          ).format(DateTime.parse(padTanggal(libur.date))),
                          style: GoogleFonts.interTight(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          libur.name,
                          style: GoogleFonts.interTight(fontSize: 14),
                        ),
                        trailing:
                            libur.isNational
                                ? Icon(Icons.flag, color: Colors.red)
                                : Icon(Icons.event_note),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

// Fungsi kustom untuk mengubah format tanggal menjadi 2 digit.
String padTanggal(String tanggal) {
  final parts = tanggal.split('-');
  if (parts.length == 3) {
    final year = parts[0];
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');
    return '$year-$month-$day';
  }
  return tanggal;
}
