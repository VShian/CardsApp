import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

import 'utils/card.dart';
import 'utils/storage.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final String title = 'Cards';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _cards = [];
  bool unlocked = false;

  init() async {
    List<CardModel> cards = await DB().cards();
    setState(() {
      _cards = cards;
    });
    print(cards.length);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Widget> _getListCards() {
    return _cards.isEmpty
        ? <Widget>[
            Center(
                child: ListTile(
                    title: Text("No cards found"),
                    subtitle: Text(
                        "Try adding one by clicking 'Add Card' button below")))
          ]
        : _cards.map((card) => BankCard(card, unlocked)).toList();
  }

  void addCard(CreditCardModel card) {
    CardModel cardObject = CardModel(
      card.cardNumber,
      card.cardHolderName,
      card.cvvCode,
      card.expiryDate,
    );
    DB().insertCard(cardObject).then((value) {
      init();
    });
  }

  void showCardForm() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreditCardFormWidget(addCard);
    }));
  }

  void toggleLock() {
    setState(() {
      unlocked = !unlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: THEME_COLOR,
        actions: <Widget>[
          IconButton(
            icon: unlocked
                ? Icon(Icons.lock_open_outlined)
                : Icon(Icons.lock_outlined),
            onPressed: toggleLock,
          )
        ],
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
