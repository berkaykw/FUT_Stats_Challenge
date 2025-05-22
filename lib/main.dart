import 'package:flutter/material.dart';
import 'package:fut_tahmin/screens/Baslangic_Ekrani.dart';

void main() {
  runApp(const FutbolcuApp());
}

class FutbolcuApp extends StatelessWidget {
  const FutbolcuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futbolcu Karşılaştırma Oyunu',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const BaslangicEkrani(),
    );
  }
}