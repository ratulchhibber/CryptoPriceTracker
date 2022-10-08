import 'package:crypto_price_tracker/constant/storage/favorite_storage.dart';
import 'package:crypto_price_tracker/model/favorite.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../model/crypto_currency.dart';
import '../model/market_chart.dart';
import '../pages/home/market_list.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<CryptoCurrency> markets = [];
  List<PriceData> priceDataList = [];

  Future<void> fetchData(ListType type) async {
    List<dynamic> markets = await API.getMarkets();
    this.markets.clear();
    for (var market in markets) {
      CryptoCurrency newCrypto = CryptoCurrency.fromJSON(market);
      newCrypto.isFavorite =
          await FavoriteStorage().fetchState(newCrypto.id ?? "");
      this.markets.add(newCrypto);
    }

    if (type == ListType.favorites) {
      List<CryptoCurrency> temp = this
          .markets
          .where((element) => element.isFavorite == Favorite.enabled)
          .toList();
      this.markets = temp;
    }
    isLoading = false;
    notifyListeners();
  }

  CryptoCurrency fetchCrypto(String id) {
    return markets.where((element) => element.id == id).first;
  }

  Future<List<PriceData>> fetchMarketChart(String id) async {
    Map<String, dynamic> prices = await API.getMarketChart(id);
    MarketPrice marketPrice = MarketPrice.fromJson(prices);
    priceDataList.clear();
    for (var price in marketPrice.prices) {
      PriceData model = PriceData(
        DateTime.fromMillisecondsSinceEpoch(price[0].toInt()),
        price[1],
      );
      priceDataList.add(model);
    }
    return priceDataList;
  }
}
