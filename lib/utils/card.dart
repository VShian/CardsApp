import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_form.dart';

class BankCard extends StatefulWidget {
  final CreditCardModel _card;

  BankCard(this._card, {Key key}) : super(key: key);

  @override
  BankCardState createState() => BankCardState();
}

class BankCardState extends State<BankCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget._card.isCvvFocused = !widget._card.isCvvFocused;
          });
        },
        child: CreditCardWidget(
          cardNumber: widget._card.cardNumber.toString(),
          expiryDate: widget._card.expiryDate,
          cardHolderName: widget._card.cardHolderName,
          cvvCode: widget._card.cvvCode,
          showBackView: widget._card.isCvvFocused,
          // animationDuration: Duration(milliseconds: 1000)));
        ));
  }
}

class CreditCardFormWidget extends StatefulWidget {
  final Function addCardFunction;

  CreditCardFormWidget(this.addCardFunction, {Key key}) : super(key: key);

  @override
  CreditCardFormWidgetState createState() => CreditCardFormWidgetState();
}

class CreditCardFormWidgetState extends State<CreditCardFormWidget> {
  CreditCardModel card = CreditCardModel('', '', '', '', false);

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Card"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          CreditCardWidget(
            cardNumber: card.cardNumber,
            expiryDate: card.expiryDate,
            cardHolderName: card.cardHolderName,
            cvvCode: card.cvvCode,
            showBackView: card.isCvvFocused,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CreditCardForm(
                onCreditCardModelChange: onCreditCardModelChange,
              ),
            ),
          ),
          OutlineButton(
            onPressed: () {
              widget.addCardFunction(card);
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ]),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel updatedCard) {
    setState(() {
      updatedCard.cardHolderName = updatedCard.cardHolderName.toUpperCase();
      card = updatedCard;
    });
  }
}
