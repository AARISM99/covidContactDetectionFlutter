import 'dart:convert';
import 'package:flutter_ble_messenger/model/contact.model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class CallApi {
  final String admin_url = 'http://192.168.0.2:8000/api/v1/';
  final String covid_maroc_url = 'https://services3.arcgis.com/hjUMsSJ87zgoicvl/arcgis/rest/services/Covid_19/FeatureServer/0/query?where=1%3D1&outFields=Cases,Deaths,Recoveries,GlobalID&outSR=4326&f=json';
  // final String _url = 'http://192.168.169.203:8000/api/v1/';


  postData(data, apiUrl) async {
    var fullUrl = admin_url + apiUrl;
    print("Full url = " + fullUrl);
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    // var fullUrl = _url + apiUrl + await _getToken();
    var fullUrl = admin_url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  sendContacts(data,apiUrl) async{
    var fullUrl = admin_url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }


  getCovidMarocApi() async {
    // var fullUrl = _url + apiUrl + await _getToken();
    var fullUrl = covid_maroc_url;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

}
