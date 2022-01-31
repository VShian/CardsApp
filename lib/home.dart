import 'package:cards/utils/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

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

  refreshCards() async {
    List<CardModel> cards = await DB().cards();
    setState(() {
      _cards = cards;
    });
    print(cards.length);
  }

  @override
  void initState() {
    refreshCards();
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
        : _cards
            .map((card) =>
                BankCard(card, unlocked, refreshCards, key: Key(card.id)))
            .toList();
  }

  void addCard(CreditCardModel card) {
    CardModel cardObject = CardModel(
      card.cardNumber,
      card.cardHolderName,
      card.cvvCode,
      card.expiryDate,
    );
    DB().insertCard(cardObject).then((value) {
      refreshCards();
    });
  }

  void showCardForm() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreditCardFormWidget(addCard);
    }));
  }

  void toggleLock() async {
    if (unlocked) {
      setState(() {
        unlocked = false;
      });
      return;
    }
    var localAuth = LocalAuthentication();

    try {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to show card details');

      if (didAuthenticate) {
        setState(() {
          unlocked = true;
        });
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        toast('Biometric authentication is not available', context);
      } else if (e.code == auth_error.passcodeNotSet) {
        toast('Passcode is not set on the device', context);
      } else if (e.code == auth_error.notEnrolled) {
        toast(
            'Biometric authentication is not enrolled on this device', context);
      } else if (e.code == auth_error.lockedOut) {
        toast('The user has been locked out of the device', context);
      } else if (e.code == auth_error.permanentlyLockedOut) {
        toast(
            'The user has been permanently locked out of the device', context);
      } else if (e.code == auth_error.otherOperatingSystem) {
        toast('Authentication is not supported on this device', context);
      } else {
        toast('Unknown error: $e', context);
      }
    }
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
