import 'dart:io' show Platform;

import 'package:bitcoin_ticker/NetworkHelper.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownValue = 'USD';
  String rateBTC = '';
  String rateETH = '';
  String rateDOGE = '';
  DropdownButton getDropDown() {
    return DropdownButton<String>(
      value: dropDownValue,
      items: currenciesList
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: (value) {
        dropDownValue = value;
        updateUi();
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        dropDownValue = currenciesList[index];
        updateUi();
      },
      children: currenciesList.map<Text>((e) => Text(e)).toList(),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void updateUi() async {
    buildShowDialog(context);
    NetworkHelper networkHelper = NetworkHelper(exchangeId: dropDownValue);

    rateBTC = await networkHelper.getBTC();
    rateDOGE = await networkHelper.getDOGE();
    rateETH = await networkHelper.getETH();
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    updateUi();
  }

  Card getCard(String coin, String value) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $coin = $value $dropDownValue',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
                getCard("BTC", rateBTC),
                SizedBox(
                  height: 20,
                ),
                getCard('ETH', rateETH),
                SizedBox(
                  height: 20,
                ),
                getCard('DOGE', rateDOGE),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : getDropDown(),
          ),
        ],
      ),
    );
  }
}
