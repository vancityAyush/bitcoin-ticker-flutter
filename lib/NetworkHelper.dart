import 'package:dio/dio.dart';

const baseUrl = "https://rest.coinapi.io/v1/exchangerate";
const apiKey = 'C7FA1113-6634-45C7-BF96-5FE4D47BE7CE';

class NetworkHelper {
  final exchangeId;
  NetworkHelper({this.exchangeId});
  dynamic getHttp(String url) async {
    try {
      print(url);
      var response = await Dio().get(url);
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<double> getData(String baseId, String exchangeId) async {
    String url = '$baseUrl/$baseId/$exchangeId?apikey=$apiKey';
    Response response = await getHttp(url);
    if (response.statusCode == 200) {
      var rate = response.data['rate'];
      return rate;
    }
    return null;
  }

  Future<String> getBTC() async {
    double btc = await getData("BTC", exchangeId);
    return btc.toStringAsFixed(3);
  }

  Future<String> getETH() async {
    double eth = await getData("ETH", exchangeId);
    return eth.toStringAsFixed(3);
  }

  Future<String> getDOGE() async {
    double doge = await getData("DOGE", exchangeId);
    return doge.toStringAsFixed(3);
  }
}
