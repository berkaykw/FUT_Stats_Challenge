class Futbolcu {
  final String isim;
  final String takim;
  final String resimUrl;
  final int golSayisi;
  final int macSayisi;
  final double piyasaDegeri; // Milyon € cinsinden
  final int formaNumarasi;

  Futbolcu({
    required this.isim,
    required this.takim,
    required this.resimUrl,
    required this.golSayisi,
    required this.macSayisi,
    required this.piyasaDegeri,
    required this.formaNumarasi,
  });
}