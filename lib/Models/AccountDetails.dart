
import 'package:myvirtualwallet/Models/SchemaObjectBase.dart';
import 'package:decimal/decimal.dart';

class AccountDetails extends SchemaObjectBase{
  AccountDetails(this.Balance);
  late double Balance;

  AccountDetails.fromJson(Map<String, dynamic> json)
    : Balance = json['balance'].toDouble()
  ;

}