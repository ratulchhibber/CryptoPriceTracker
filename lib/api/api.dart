import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static Future<List<dynamic>> getMarkets() async {
    try {
      Uri requestUri = Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&page=1&sparkline=false");
      var response = await http.get(requestUri);
      var decodedResponse = jsonDecode(response.body);
      List<dynamic> markets = decodedResponse as List<dynamic>;
      return markets;
    } catch (error) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getMarketChart(String id) async {
    try {
      Uri requestUri = Uri.parse(
          "https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=inr&days=14&interval=daily");
      var response = await http.get(requestUri);
      var decodedResponse = jsonDecode(response.body);
      Map<String, dynamic> markets = decodedResponse as Map<String, dynamic>;
      return markets;
    } catch (error) {
      return {};
    }
  }
}
