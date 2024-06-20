import 'dart:convert';
import 'dart:io';

import 'package:coincap_app/Services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
}

class _homePage extends State<HomePage>{
  late double _deviceWidth, _deviceHeight;

  HTTPService? _http;

@override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[400],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataWidgets()
          ],),
        ),
      ),
    );
  }


  Widget _selectedCoinDropdown(){
  
    List<String> _coins = ['bitcoin'];
    List<DropdownMenuItem<String>> _item = _coins.map((e)=>DropdownMenuItem(value: e, child: Text(e,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 30)))).toList();
    return DropdownButton(
      value: _coins.first,
      items: _item,                                                                                       
      onChanged: (_value) {

      },
      dropdownColor: Colors.purple[700],
      iconSize: 30,
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
      
      );
  }

  Widget _dataWidgets(){
    return FutureBuilder(
      future: _http?.get("/coins/bitcoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasData) {
          Map _data = jsonDecode(snapshot.data.toString());
          num _usdPrice = _data["market_data"]["current_price"]["usd"]; //getting price
          return Text(_usdPrice.toString(), style: TextStyle(color: Colors.white,fontSize: 25));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
        } else {
          return Text('No data', style: TextStyle(color: Colors.white,fontSize: 25));
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate){
    
  }

}
