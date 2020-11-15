import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

import 'utils/card.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final String title = 'Cards';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _cards = [];

  List<Widget> _getListCards() {
    return _cards.isEmpty
        ? <Widget>[
            Center(
                child: ListTile(
                    title: Text("No cards found"),
                    subtitle: Text(
                        "Try adding one by clicking 'Add Card' button below")))
          ]
        : _cards.map((card) => BankCard(card)).toList();
  }

  void addCard(CreditCardModel card) {
    setState(() {
      _cards.add(card);
    });
  }

  void showCardForm() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreditCardFormWidget(addCard);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: _getListCards(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCardForm,
        icon: Icon(Icons.add),
        label: Text("ADD CARD"),
        foregroundColor: THEME_COLOR,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
