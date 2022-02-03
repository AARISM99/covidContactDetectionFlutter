import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/api/api.dart';

class StatsGrid extends StatelessWidget {

  final statistics;
  // const StatsGrid({Key key}) : super(key: key);
  const StatsGrid({@required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Total Cases', statistics['Total Cases'], Colors.orange),
                _buildStatCard('Deaths', statistics['Deaths'], Colors.red), // 105 k
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Recovered', statistics['Recovered'], Colors.green),
                // _buildStatCard('Active', statistics['Active'], Colors.lightBlue),
                _buildStatCard('Critical', statistics['Critical'], Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
