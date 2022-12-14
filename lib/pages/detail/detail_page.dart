import 'package:crypto_price_tracker/model/crypto_currency.dart';
import 'package:crypto_price_tracker/pages/detail/line_chart.dart';
import 'package:crypto_price_tracker/pages/home/market_list.dart';
import 'package:crypto_price_tracker/provider/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoDetailPage extends StatefulWidget {
  late ListType type;
  final String id;
  CryptoDetailPage({Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  State<CryptoDetailPage> createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends State<CryptoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Consumer<MarketProvider>(
          builder: (context, provider, child) {
            CryptoCurrency crypto = provider.fetchCrypto(widget.id);
            return RefreshIndicator(
              onRefresh: () async {
                await provider.fetchData(widget.type);
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(crypto.image!),
                    ),
                    title: Text(
                      "${crypto.name!} (${crypto.symbol!.toUpperCase()})",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "??? ${crypto.currentPrice!.toStringAsFixed(4)}",
                      style: const TextStyle(
                          color: Color(0xff0395eb),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Price Change (24h)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Builder(
                        builder: (context) {
                          double priceChange = crypto.priceChange24!;
                          double priceChangePercentage =
                              crypto.priceChangePercentage24!;

                          if (priceChange < 0) {
                            // negative
                            return Text(
                              "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 23),
                            );
                          } else {
                            // positive
                            return Text(
                              "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 23),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleAndDetail(
                          "Market Cap",
                          "??? ${crypto.marketCap!.toStringAsFixed(4)}",
                          CrossAxisAlignment.start),
                      titleAndDetail("Market Cap Rank",
                          "#${crypto.marketCapRank}", CrossAxisAlignment.end),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 400,
                    child: LineChart(
                      cryptoId: crypto.id ?? "",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget titleAndDetail(
      String title, String detail, CrossAxisAlignment crossAxisAlignment) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }
}
