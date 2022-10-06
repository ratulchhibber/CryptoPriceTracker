import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/crypto_currency.dart';
import '../../provider/market_provider.dart';
import '../detail_page.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key? key}) : super(key: key);

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<MarketProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.markets.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await provider.fetchData();
              },
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: provider.markets.length,
                  itemBuilder: (context, index) {
                    CryptoCurrency crypto = provider.markets[index];
                    return ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height *
                                    0.85,
                                child: CryptoDetailPage(
                                  id: crypto.id ?? "",
                                ),
                              );
                            });
                      },
                      contentPadding: const EdgeInsets.all(0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(crypto.image ?? ""),
                      ),
                      title: Text(crypto.name ?? ""),
                      subtitle: Text((crypto.symbol ?? "").toUpperCase()),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${crypto.currentPrice?.toStringAsFixed(4) ?? ""}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "24h ",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              ),
                              Builder(
                                builder: (context) {
                                  double priceChange =
                                      crypto.priceChange24 ?? 0;
                                  double priceChangePercentage =
                                      crypto.priceChangePercentage24 ?? 0;
                                  return Text(
                                    "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                                    style: TextStyle(
                                        color: priceChangePercentage > 0
                                            ? Colors.green
                                            : Colors.red),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return const Text("data not found");
          }
        },
      ),
    );
  }
}
