import 'dart:convert';
import 'dart:developer';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../Model/conversation_model.dart';
import '../api_service.dart';
import '../providers/chat_provider.dart';

class MessageRepo {

  Future<bool> deleteMessage({required int messageId}) async{
    try{

      SmartDialog.showLoading(msg: "Deleting message...");

      var body = {
        "messageId": messageId
      };

      var response = await ApiService().delete("/Chat/deleteMessage/$messageId", );

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        return true;
      }

      return false;

    }
    catch(e, stackTrace){
      log(e.toString() + " error");
      log(stackTrace.toString()); 

      SmartDialog.dismiss();
      
      rethrow;
    }
  }


  Future<Conversation> getLast10Messages({
    required int senderId,
    required int receiverId,
  }) async {
    try {
      SmartDialog.showLoading(msg: "Loading messages...");

      var body = {
        "senderId": 6,
        "receiverId": 7,
        "createdAt": "2024-10-15T03:33:23.843Z",
        "lastConversationAt": "2024-10-15T03:33:23.843Z"
      };

      var response = await ApiService().post("/Chat/connectmetoTheserver", body: body);

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        try {
          var res = Conversation.fromJson(resp["data"]);
          return res;
        } catch (e, stackTrace) {
          SmartDialog.dismiss();
          log(e.toString() + " error at conversation");
          log(stackTrace.toString());  // Log the stack trace
        }
      }

      return Conversation();

    } catch (e, stackTrace) {
      SmartDialog.dismiss();
      log(e.toString() + " error");
      log(stackTrace.toString());  // Log the stack trace
      rethrow;
    }
  }

  Future<bool> sendMessage({
    required int conversationId,

    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    try {
      SmartDialog.showLoading(msg: "Sending message...");

      var body = {
  "conversationId": conversationId,
  "senderId": senderId,
  "receiverId": receiverId,
  "content": message, // Change "message" to "content"
  "sentAt": DateTime.now().toIso8601String(),
  "isRead": true,
};


      var response = await ApiService().post("/Chat/sendMessage", body: body);

      log(response.toString()+"send message");

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        return true;
      }

      return false;

    } catch (e, stackTrace) {
      SmartDialog.dismiss();
      log(e.toString() + " error");
      log(stackTrace.toString());  // Log the stack trace
      rethrow;
    }
  }

  
}
