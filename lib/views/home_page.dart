import 'dart:convert';
import 'dart:io';

import 'package:coincap_app/Services/http_services.dart';
import 'package:coincap_app/Views/details_page.dart';
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
  String? _selectedCoin =  "bitcoin";
  HTTPService? _http;

@override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }


  final Map<String, String> _coinMap = {
    'BITCOIN': 'bitcoin',
    'ETHEREUM': 'ethereum',
    'TETHER': 'tether',
    'CARDANO': 'cardano',
    'RIPPLE': 'ripple'
  };

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 150, 230),
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
  
    List<DropdownMenuItem<String>> _item = _coinMap.keys.map((e)=>DropdownMenuItem(value: e, child: Text(e,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 30)))).toList();
    return DropdownButton(
      value: _selectedCoin!.toUpperCase(),
      items: _item,           
      dropdownColor: Color.fromARGB(255, 30, 150, 230),                                                                            
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _coinMap[_value];
        });
      },
      
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
      future: _http?.get("/coins/$_selectedCoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasData) {
          Map _data = jsonDecode(snapshot.data.toString());
          Map _exchangeRate = _data["market_data"]["current_price"];
          num _usdPrice = _data["market_data"]["current_price"]["usd"]; //getting price
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          String _image = _data["image"]["large"];
          String _description = _data["description"]["en"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(child: _coinImageWidget(_image),
              onDoubleTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(rates: _exchangeRate,coin: _selectedCoin.toString())));
              },),
              _currentPriceWidget(_usdPrice),
              _percentageChangeWidget(_change24h),
              _coinDescriptionWidget(_description)
            ]
          ); 
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
        } else {
          return Text('No data', style: TextStyle(color: Colors.white,fontSize: 25));
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate){
    return Text(_rate.toStringAsFixed(2),
    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold));
  }

  Widget _percentageChangeWidget(num _change){
    return Text("Change in 24h: ${_change.toString()} %",
    style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500));
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      width: _deviceWidth * 0.3,
      height: _deviceHeight * 0.2,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(_imgURL))
      ),
    );
  }

  Widget _coinDescriptionWidget(String _descrip){
    return Container(
      width: _deviceWidth * 0.85,
      height: _deviceHeight * 0.38,
      child: SingleChildScrollView(
        child: Text(_descrip.isNotEmpty? _descrip:"There is no Description",
        style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400))),
    );
  }

}
