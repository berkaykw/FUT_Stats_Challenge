import 'package:flutter/material.dart';
import 'dart:math';
import '../models/futbolcu.dart';
import '../data/futbolcu_veritabani.dart';
import 'sonuc_ekrani.dart';

class OyunEkrani extends StatefulWidget {
  const OyunEkrani({Key? key}) : super(key: key);

  @override
  State<OyunEkrani> createState() => _OyunEkraniState();
}

class _OyunEkraniState extends State<OyunEkrani> with SingleTickerProviderStateMixin {
  int skor = 0;
  late Futbolcu soldakiFutbolcu;
  late Futbolcu sagdakiFutbolcu;
  late String karsilastirilanOzellik;
  bool oyunDevamEdiyor = true;
  late AnimationController _animasyonController;
  late Animation<double> _animasyon;
  bool karsilastirmaYapildi = false;

  
  final List<String> ozellikler = [
    'golSayisi',
    'macSayisi',
    'piyasaDegeri',
    'formaNumarasi'
  ];
  
  final Map<String, String> ozellikAdlari = {
    'golSayisi': 'Gol Sayısı',
    'macSayisi': 'Maç Sayısı',
    'piyasaDegeri': 'Piyasa Değeri (€)',
    'formaNumarasi': 'Forma Numarası'
  };

  @override
  void initState() {
    super.initState();
    _animasyonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _animasyon = CurvedAnimation(
      parent: _animasyonController,
      curve: Curves.easeInOut,
    );
    
    _yeniFutbolculariGetir();
  }

  @override
  void dispose() {
    _animasyonController.dispose();
    super.dispose();
  }

  void _yeniFutbolculariGetir() {
    // Tüm futbolcuları karıştır ve farklı iki futbolcu seç
    List<Futbolcu> karisikListe = List.from(FutbolcuVeritabani.tumFutbolcular)..shuffle();
    
    soldakiFutbolcu = karisikListe.first;
    sagdakiFutbolcu = karisikListe[1];
    
    // Karşılaştırılacak özelliği rastgele seç
    karsilastirilanOzellik = ozellikler[Random().nextInt(ozellikler.length)];
    
    karsilastirmaYapildi = false;
    _animasyonController.reset();
  }

  void _karsilastirmaYap(bool soldakiDahaYuksek) {
    if (karsilastirmaYapildi) return;
    
    setState(() {
      karsilastirmaYapildi = true;
    });
    
    bool dogruTahmin = false;
    
    // Özelliğe göre karşılaştırma yap
    switch (karsilastirilanOzellik) {
      case 'golSayisi':
        dogruTahmin = (soldakiDahaYuksek && soldakiFutbolcu.golSayisi >= sagdakiFutbolcu.golSayisi) ||
                     (!soldakiDahaYuksek && soldakiFutbolcu.golSayisi < sagdakiFutbolcu.golSayisi);
        break;
      case 'macSayisi':
        dogruTahmin = (soldakiDahaYuksek && soldakiFutbolcu.macSayisi >= sagdakiFutbolcu.macSayisi) ||
                     (!soldakiDahaYuksek && soldakiFutbolcu.macSayisi < sagdakiFutbolcu.macSayisi);
        break;
      case 'piyasaDegeri':
        dogruTahmin = (soldakiDahaYuksek && soldakiFutbolcu.piyasaDegeri >= sagdakiFutbolcu.piyasaDegeri) ||
                     (!soldakiDahaYuksek && soldakiFutbolcu.piyasaDegeri < sagdakiFutbolcu.piyasaDegeri);
        break;
      case 'formaNumarasi':
        dogruTahmin = (soldakiDahaYuksek && soldakiFutbolcu.formaNumarasi >= sagdakiFutbolcu.formaNumarasi) ||
                     (!soldakiDahaYuksek && soldakiFutbolcu.formaNumarasi < sagdakiFutbolcu.formaNumarasi);
        break;
      default:
        break;
    }
    
    _animasyonController.forward().then((_) {
      if (dogruTahmin) {
        setState(() {
          skor++;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _yeniFutbolculariGetir();
            });
          }
        });
      } else {
        setState(() {
          oyunDevamEdiyor = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SonucEkrani(skor: skor),
              ),
            );
          }
        });
      }
    });
  }

  String _degerGoster(Futbolcu futbolcu, String ozellik) {
    switch (ozellik) {
      case 'golSayisi':
        return futbolcu.golSayisi.toString();
      case 'macSayisi':
        return futbolcu.macSayisi.toString();
      case 'piyasaDegeri':
        return '${futbolcu.piyasaDegeri.toStringAsFixed(1)} M';
      case 'formaNumarasi':
        return futbolcu.formaNumarasi.toString();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.lightGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst bilgi çubuğu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Skor: $skor',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Karşılaştırma başlığı
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Hangi futbolcunun ${ozellikAdlari[karsilastirilanOzellik]} daha yüksek?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Ana karşılaştırma alanı
              Expanded(
                child: Row(
                  children: [
                    // Soldaki futbolcu
                    Expanded(
                      child: _futbolcuKarti(
                        soldakiFutbolcu,
                        karsilastirmaYapildi,
                        () => _karsilastirmaYap(true),
                        true,
                      ),
                    ),
                    
                    // Orta VS işareti
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Sağdaki futbolcu
                    Expanded(
                      child: _futbolcuKarti(
                        sagdakiFutbolcu,
                        karsilastirmaYapildi,
                        () => _karsilastirmaYap(false),
                        false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _futbolcuKarti(Futbolcu futbolcu, bool degerGoster, VoidCallback onTap, bool solTaraf) {
    return GestureDetector(
      onTap: oyunDevamEdiyor ? onTap : null,
      child: AnimatedOpacity(
        opacity: oyunDevamEdiyor ? 1.0 : 0.7,
        duration: const Duration(milliseconds: 300),
        child: Card(
          color: Colors.black,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Futbolcu resmi
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: AssetImage(futbolcu.resimUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.8),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              futbolcu.isim,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              futbolcu.takim,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // İstatistik alanı
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ozellikAdlari[karsilastirilanOzellik] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animasyon,
                        builder: (context, child) {
                          return Opacity(
                            opacity: karsilastirmaYapildi ? _animasyon.value : 0.0,
                            child: Text(
                              _degerGoster(futbolcu, karsilastirilanOzellik),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen,
                              ),
                            ),
                          );
                        },
                      ),
                      if (!karsilastirmaYapildi)
                        const Text(
                          '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
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
}