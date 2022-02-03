import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/View/widjets/widgets.dart';
import 'package:flutter_ble_messenger/api/api.dart';
import 'package:flutter_ble_messenger/config/palette.dart';
// import 'package:flutter_ble_messenger/controller/devices_controller.dart';
// import 'package:get/get.dart';
import 'package:flutter_ble_messenger/config/styles.dart';
import 'package:flutter_ble_messenger/data/data.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  final statistics = {
    'Total Cases': '',
    'Deaths': '',
    'Recovered': '',
    'Active': '',
    'Critical': 'N/A'
  };

  static String formatNumbers(String currentBalance) {
    try{
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      int value = int.parse(currentBalance);

      if(value < 1000){ // less than a thousand
        return value.toString();
      }else if(value >= 1000 && value < (1000*100*10)){ // less than a million
        double result = value/1000;
        return result.toStringAsFixed(2)+"k";
      }else if(value >= 1000000 && value < (1000000*10*100)){ // less than 100 million
        double result = value/1000000;
        return result.toStringAsFixed(2)+"M";
      }else if(value >= (1000000*10*100) && value < (1000000*10*100*100)){ // less than 100 billion
        double result = value/(1000000*10*100);
        return result.toStringAsFixed(2)+"B";
      }else if(value >= (1000000*10*100*100) && value < (1000000*10*100*100*100)){ // less than 100 trillion
        double result = value/(1000000*10*100*100);
        return result.toStringAsFixed(2)+"T";
      }
    }catch(e){
      print(e);
    }
  }


  getCovidMarocApi() async{
    final res = await CallApi().getCovidMarocApi();
    print("igrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    if(res.statusCode == 200){
      var totalCases = 0;
      var deaths = 0;
      var recoveries = 0;
      final table = (jsonDecode(res.body)['features'] as List);
      table.forEach((item) {
        totalCases += item['attributes']['Cases'];
        deaths += item['attributes']['Deaths'];
        recoveries += item['attributes']['Recoveries'];

      });

      print(totalCases);
      print(deaths);
      print(recoveries);

      setState(() {
        statistics['Total Cases'] = formatNumbers(totalCases.toString());
        statistics['Deaths'] = formatNumbers(deaths.toString());
        statistics['Recovered'] = formatNumbers(recoveries.toString());

      });

    }


  }

  getCovidGlobalApi() async{
    final res = await covidApi();
    var totalCases = 0;
    var deaths = 0;
    var recoveries = 0;

    totalCases = res.global.totalConfirmed;
    deaths = res.global.totalDeaths;
    recoveries = res.global.totalRecovered;

    print(totalCases);
    print(deaths);
    print(recoveries);

    setState(() {
      statistics['Total Cases'] = formatNumbers(totalCases.toString());
      statistics['Deaths'] = formatNumbers(deaths.toString());
      statistics['Recovered'] = formatNumbers(recoveries.toString());
    });

      // setState(() {
      //   print(covidApi());
      //
      // });
  }

  @override
  void initState() {
    getCovidMarocApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          _buildRegionTabBar(),
          _buildStatsTabBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(statistics: this.statistics),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            sliver: SliverToBoxAdapter(
              child: CovidBarChart(covidCases: covidUSADailyNewCases),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Statistics',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Text('My Country'),
              Text('Global'),
            ],
            onTap: (index) {
              switch(index){
                case 0:
                  getCovidMarocApi();
                  break;
                case 1:
                  getCovidGlobalApi();
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 3,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: <Widget>[
              Text('Total'),
              Text('Today'),
              Text('Yesterday'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }
}
