import 'package:crypto_price_tracker/pages/home/market_list.dart';
import 'package:crypto_price_tracker/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Current Crypto Price",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Consumer<ThemeProvider>(builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        provider.toggleTheme();
                      },
                      icon: provider.themeMode == ThemeMode.light
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                    );
                  }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TabBar(controller: _tabController, tabs: [
                Tab(
                  child: Text(
                    'All',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Tab(
                  child: Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ]),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  controller: _tabController,
                  children: [
                    MarketList(
                      type: ListType.all,
                    ),
                    MarketList(
                      type: ListType.favorites,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
