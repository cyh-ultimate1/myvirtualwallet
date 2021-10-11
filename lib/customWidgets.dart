

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myvirtualwallet/Models/AccountTransaction.dart';
import 'package:myvirtualwallet/constants.dart';

class customWidgets{
  static Widget errorDialog(title, text) =>
      AlertDialog(
          title: Text(title),
          content: Text(text)
      );

  static SizedBox emptyHorizontalSpace({
    double customHeight = 20,
  }){
    return SizedBox(
      height: customHeight,
    );
  }

  static Widget elevatedButtonHomepageWithIcon(String btnText, IconData? iconData, Function() f){
    return SizedBox(
        width: 200,
        child: ElevatedButton.icon(
          label: Text(btnText.toUpperCase()),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: GlobalConstants.APPPRIMARYCOLOUR,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.5)
              )
          ),
          icon: Icon(iconData),
          onPressed: f,
        )
    );
  }

  static Widget elevatedButtonCustomized(String btnText, Function() f){
    return SizedBox(
        width: 200,
        child: ElevatedButton(
          child: Text(btnText.toUpperCase()),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: GlobalConstants.APPPRIMARYCOLOUR,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.5)
              )
          ),
          onPressed: f,
        )
    );
  }

  static Widget bottomNavigationBar(int selectedIndex){
    int _selectedIndex = selectedIndex;
    void _onItemTapped(int index) {
        _selectedIndex = index;
    }
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Deposit',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  static Widget? transactionTypeIcon(int? type){
    if(type == AccountTransactionType.Deposit){
      return Icon(Icons.add_box_rounded);
    }
    else if(type == AccountTransactionType.Transfer){
      return Icon(Icons.send_to_mobile);
    }
    else if(type == AccountTransactionType.Withdrawal){
      return Icon(Icons.do_disturb_on_outlined);
    }
    return null;
  }

  static Widget okButton(Function f){
    return ElevatedButton(
      child: Text("OK"),
      onPressed: () async => f,
    );
  }
}