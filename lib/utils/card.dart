import 'package:cards/constants.dart';
import 'package:cards/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';

class BankCard extends StatefulWidget {
  final CardModel _card;
  final bool unlocked;
  final Function refreshCards;

  BankCard(this._card, this.unlocked, this.refreshCards, {Key key})
      : super(key: key);

  @override
  BankCardState createState() => BankCardState();
}

class BankCardState extends State<BankCard> {
  bool isCvvFocused = false;

  void onDelete() {
    DB().deleteCard(widget._card.id).then((_) {
      widget.refreshCards();
      print('delete success');
    }).catchError((error) {
      print('delete error');
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: ValueKey(widget._card.id),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (BuildContext context) {
                onDelete();
              },
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: GestureDetector(
            onTap: () {
              setState(() {
                isCvvFocused = !isCvvFocused;
              });
            },
            child: GestureDetector(
                child: CreditCardWidget(
                    cardNumber: widget._card.number.toString(),
                    expiryDate: widget._card.expiration,
                    cardHolderName: widget._card.holder,
                    cvvCode: widget._card.cvv,
                    showBackView: isCvvFocused,
                    onCreditCardWidgetChange: (creditCardBrand) {},
                    cardBgColor: THEME_COLOR,
                    isHolderNameVisible: widget.unlocked,
                    obscureCardNumber: !widget.unlocked,
                    obscureCardCvv: !widget.unlocked,
                    isSwipeGestureEnabled: false
                    // animationDuration: Duration(milliseconds: 1000)
                    ),
                onLongPress: () {
                  // copy card number
                  if (!widget.unlocked) {
                    return;
                  }
                  final clipboardText = isCvvFocused
                      ? widget._card.cvv
                      : widget._card.number.toString().replaceAll(' ', '');
                  Clipboard.setData(ClipboardData(text: clipboardText))
                      .then((_) {
                    // toast
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(milliseconds: 1000),
                    ));
                  });
                })));
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Card"),
        backgroundColor: THEME_COLOR,
      ),
      body: Center(
        child: Column(children: <Widget>[
          CreditCardWidget(
            cardNumber: card.cardNumber,
            expiryDate: card.expiryDate,
            cardHolderName: card.cardHolderName,
            cvvCode: card.cvvCode,
            showBackView: card.isCvvFocused,
            onCreditCardWidgetChange: (creditCardBrand) {},
            cardBgColor: THEME_COLOR,
            isHolderNameVisible: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CreditCardForm(
                formKey: formKey,
                obscureCvv: false,
                obscureNumber: false,
                cardNumber: card.cardNumber,
                cvvCode: card.cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: card.cardHolderName,
                expiryDate: card.expiryDate,
                themeColor: THEME_COLOR,
                textColor: Colors.black,
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: InputDecoration(
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              widget.addCardFunction(card);
              Navigator.pop(context);
            },
            child: Text("Add", style: TextStyle(color: THEME_COLOR)),
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
