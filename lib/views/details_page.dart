import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget{
  final Map rates;
  final String coin;

  const DetailsPage({required this.rates,required this.coin});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 150, 230),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 30, 150, 230) ,
          title: Text("Exchange Rate for $coin"),
        ),
        body: _listView(),
      ),
    );
  }

  Widget _listView(){
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return ListView.builder(
      itemCount: _currencies.length,
      itemBuilder: (_context,_index){
        String _currency = _currencies[_index].toString().toUpperCase();
        String _exchangeRate = _exchangeRates[_index].toString();
        return ListTile(
          title: Text("$_currency -> $_exchangeRate",
          style:TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
          ),
        );
      },
    );
  }
}