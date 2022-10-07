import 'package:crypto_price_tracker/constant/storage/favorite_storage.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../model/crypto_currency.dart';
import '../model/favorite.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteStorage _storage = FavoriteStorage();

  bool isLoading = true;
  List<CryptoCurrency> markets = [];

  Future<Favorite> fetchState(String id) {
    return _storage.fetchState(id);
  }

  Future<void> toggleState(String id) async {
    Favorite currentState = await _storage.fetchState(id);
    Favorite updatedState =
        currentState == Favorite.enabled ? Favorite.disabled : Favorite.enabled;
    _storage.save(updatedState, id);
    notifyListeners();
  }
}
