import 'package:crypto_price_tracker/model/favorite.dart';
import 'package:crypto_price_tracker/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/crypto_currency.dart';
import '../../provider/market_provider.dart';
import '../detail/detail_page.dart';

enum ListType { all, favorites }

class MarketList extends StatefulWidget {
  late ListType type;

  MarketList({Key? key, required this.type}) : super(key: key);

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MarketProvider>(context, listen: false)
          .fetchData(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.markets.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchData(widget.type);
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
                                type: widget.type,
                              ),
                            );
                          });
                    },
                    contentPadding: const EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(crypto.image ?? ""),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(crypto.name ?? ""),
                          ),
                        ),
                        Consumer<FavoriteProvider>(
                          builder: (context, favoriteProvider, child) {
                            return IconButton(
                              onPressed: () {
                                favoriteProvider.toggleState(crypto.id ?? "");
                              },
                              icon: FutureBuilder<Favorite>(
                                future: favoriteProvider
                                    .fetchState(crypto.id ?? ""),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Text('');
                                    default:
                                      if (snapshot.hasError) {
                                        return const Text('');
                                      } else {
                                        return Icon(
                                          snapshot.requireData.icon,
                                          color: snapshot.requireData.iconColor,
                                        );
                                      }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
                                double priceChange = crypto.priceChange24 ?? 0;
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
    );
  }
}
