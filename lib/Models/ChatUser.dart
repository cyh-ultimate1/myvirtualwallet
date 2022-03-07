

class ChatUser{
  ChatUser();

  String? Name;

  ChatUser.fromJson(Map<String, dynamic> json) :
        Name = json['Name']
  ;

}