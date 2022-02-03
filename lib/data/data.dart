import 'dart:convert';

import 'package:covid19/covid19.dart';

covidApi() async {
  var covid = Covid19Client();
  var data = await covid.getDayOne(country: "Morocco");

  print("-------------- data ---------------");
  print(data[0].countryCode);


  // print('Global new confirmed coronavirus cases: ${summary.global.newConfirmed}');
  // print('Global new deaths coronavirus cases: ${summary.global.newDeaths}');
  // print('Global new recovered coronavirus cases: ${summary.global.newRecovered}');
  // print('Global total confirmed coronavirus cases: ${summary.global.totalConfirmed}');
  // print('Global total deaths coronavirus cases: ${summary.global.totalDeaths}');
  // print('Global total recovered coronavirus cases: ${summary.global.totalRecovered}');

  return await covid.getSummary();

//  final global_new_confirmed = summary.global.newConfirmed;

  covid.close();
}

final prevention = [
  {'assets/images/distance.png': 'Avoid close\ncontact'},
  {'assets/images/wash_hands.png': 'Clean your\nhands often'},
  {'assets/images/mask.png': 'Wear a\nfacemask'},
];

final covidUSADailyNewCases = [12.17, 11.15, 10.02, 11.21, 13.83, 14.16, 14.30];
