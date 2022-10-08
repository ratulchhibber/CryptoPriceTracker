import 'package:crypto_price_tracker/api/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/market_chart.dart';
import '../../provider/market_provider.dart';

class LineChart extends StatefulWidget {
  final String cryptoId;

  const LineChart({Key? key, required this.cryptoId}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<List<PriceData>>(
          future: provider.fetchMarketChart(widget.cryptoId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('');
              default:
                if (snapshot.hasError) {
                  return const Text('');
                } else {
                  return SafeArea(
                      child: Scaffold(
                    body: SfCartesianChart(
                      title: ChartTitle(text: ''),
                      tooltipBehavior: _tooltipBehavior,
                      series: <ChartSeries>[
                        StackedLineSeries<PriceData, String>(
                          dataSource: snapshot.requireData,
                          xValueMapper: (PriceData exp, _) =>
                              DateFormat('d MMM').format(exp.date),
                          yValueMapper: (PriceData exp, _) => exp.price,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          ),
                          name: '',
                        ),
                      ],
                      primaryXAxis: CategoryAxis(),
                    ),
                  ));
                }
            }
          },
        );
      },
    );
  }
}
