
import 'dart:convert';

class ChatDetails{
  ChatDetails();

  ChatDetailsResponseContent? Content;
  String? ChannelName;

  ChatDetails.fromJson(Map<String, dynamic> json) :
        Content = ChatDetailsResponseContent.fromJson(jsonDecode(json['content']).cast<String, dynamic>())
        , ChannelName = json['channel'] ?? ""
  ;
}

class ChatDetailsResponseContent{
  ChatDetailsResponseContent();

  String? ContentMessage;
  String? ContentSender;

  ChatDetailsResponseContent.fromJson(Map<String, dynamic> json) :
        ContentMessage = json['contentmessage']
        , ContentSender = json['contentsender']
  ;
}
