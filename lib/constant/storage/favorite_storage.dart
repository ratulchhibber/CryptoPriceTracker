import 'package:crypto_price_tracker/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStorage {
  Future<bool> save(Favorite state, String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> present =
        prefs.getStringList('favorite') ?? List<String>.empty(growable: true);
    state == Favorite.enabled ? present.add(id) : present.remove(id);
    return await prefs.setStringList('favorite', present);
  }

  Future<Favorite> fetchState(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> present =
        prefs.getStringList('favorite') ?? List<String>.empty();
    return present.contains(id) ? Favorite.enabled : Favorite.disabled;
  }
}
