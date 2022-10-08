import 'package:crypto_price_tracker/model/favorite.dart';

class MarketPrice {
  MarketPrice({required this.prices});

  List<List<double>> prices;

  factory MarketPrice.fromJson(Map<String, dynamic> map) {
    return MarketPrice(
      prices: List<List<double>>.from(
          map["prices"].map((x) => List<double>.from(x.map(
                (x) => x.toDouble(),
              )))),
    );
  }
}

class PriceData {
  PriceData(this.date, this.price);
  final DateTime date;
  final double price;
}
