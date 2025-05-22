import 'package:flutter/material.dart';
import 'package:fut_tahmin/screens/Baslangic_Ekrani.dart';
import 'package:fut_tahmin/services/score_manager.dart';
import 'oyun_ekrani.dart';

class SonucEkrani extends StatefulWidget {
  final int skor;

  const SonucEkrani({Key? key, required this.skor}) : super(key: key);

  @override
  State<SonucEkrani> createState() => _SonucEkraniState();
}

class _SonucEkraniState extends State<SonucEkrani> {
  int maxSkor = 0;

  @override
  void initState() {
    super.initState();
    ScoreManager().saveMaxScore(widget.skor);
    ScoreManager().getMaxScore().then((value) {
      setState(() {
        maxSkor = value;
      });
    });
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "OYUN BİTTİ",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Skorunuz:",
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.skor}",
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _skorMesajiGetir(widget.skor),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OyunEkrani(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "TEKRAR OYNA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaslangicEkrani(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "ANA MENÜ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text(
                "Maksimum Skor: $maxSkor",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _skorMesajiGetir(int skor) {
    if (skor == 0) {
      return "Daha iyisini yapabilirsin! Tekrar dene!";
    } else if (skor < 5) {
      return "İyi bir başlangıç! Biraz daha pratik yapmalısın.";
    } else if (skor < 10) {
      return "Güzel! Futbolcular hakkında bilgin giderek artıyor.";
    } else if (skor < 15) {
      return "Harika! Gerçek bir futbol bilgini gibisin!";
    } else {
      return "İnanılmaz! Sen bir futbol efsanesisin!";
    }
  }
}
