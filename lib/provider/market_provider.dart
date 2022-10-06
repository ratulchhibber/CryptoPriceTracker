import 'package:flutter/material.dart';

import '../api/api.dart';
import '../model/crypto_currency.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<CryptoCurrency> markets = [];

  MarketProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> markets = await API.getMarkets();
    this.markets.clear();
    for (var market in markets) {
      CryptoCurrency newCrypto = CryptoCurrency.fromJSON(market);
      this.markets.add(newCrypto);
    }
    isLoading = false;
    notifyListeners();
  }

  CryptoCurrency fetchCrypto(String id) {
    return markets.where((element) => element.id == id).first;
  }
}
