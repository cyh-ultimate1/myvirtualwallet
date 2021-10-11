
import 'package:myvirtualwallet/Models/SchemaObjectBase.dart';
import 'package:decimal/decimal.dart';

class AccountTransaction extends SchemaObjectBase{
  AccountTransaction();
  double? CreditAmount;
  double? DebitAmount;
  String? SourceAccountID;
  String? DestinationAccountID;
  int? TransactionType;
  DateTime? CreatedDateTime;
  String? currentUserID;

  AccountTransaction.fromJson(Map<String, dynamic> json)
      : CreditAmount = (json['creditAmount'] == null ? 0 : json['creditAmount']).toDouble()
       , DebitAmount = (json['debitAmount'] == null ? 0 : json['debitAmount']).toDouble()
       , SourceAccountID = json['sourceAccountID']
       , DestinationAccountID = json['destinationAccountID']
       , TransactionType = json['transactionType']
       // , CreatedDateTime = json['createdDateTime']
       , currentUserID = json['currentUserID']
  ;

  double? GetAmount(){
    switch(this.TransactionType){
      case AccountTransactionType.Deposit : return this.DebitAmount;
      case AccountTransactionType.Transfer : return this.CreditAmount;
      case AccountTransactionType.Withdrawal : return this.CreditAmount;
      default : return 0;
    }
  }

}

class AccountTransactionType{
  static const int Deposit = 1;
  static const int Transfer = 2;
  static const int Withdrawal = 3;

  static String GetTypeName(int? type){
    switch(type){
      case Deposit : return "Deposit";
      case Transfer : return "Transfer";
      case Withdrawal : return "Withdrawal";
      default : return "";
    }
    return "";
  }
}