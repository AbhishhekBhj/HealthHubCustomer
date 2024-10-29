import 'dart:convert';
import 'dart:developer';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../Model/conversation_model.dart';
import '../api_service.dart';
import '../providers/chat_provider.dart';

class MessageRepo {
  Future<bool> editMessage(
      {required int messageId, required String content}) async {
    try {
      // Show loading dialog while the message is being edited
      SmartDialog.showLoading(msg: "Editing message...");

      // Create the request body with the message ID and new content
      var body = {
        "messageId": messageId,
        "newContent": content,
      };

      // Call the API service to edit the message
      var response = await ApiService().post("/Chat/editMessage", body: body);

      // Decode the response
      var resp = jsonDecode(response.toString());

      // Check the status code from the response
      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss(); // Dismiss the loading dialog
        return true; // Edit was successful
      }

      return false; // Edit failed
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      log(e.toString() + " error");
      log(stackTrace.toString());

      SmartDialog.dismiss(); // Dismiss the loading dialog in case of an error

      rethrow; // Rethrow the exception for further handling
    }
  }

  Future<bool> deleteMessage({required int messageId}) async {
    try {
      SmartDialog.showLoading(msg: "Deleting message...");

      var body = {"messageId": messageId};

      var response = await ApiService().delete(
        "/Chat/deleteMessage/$messageId",
      );

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      log(e.toString() + " error");
      log(stackTrace.toString());

      SmartDialog.dismiss();

      rethrow;
    }
  }

  Future<Conversation> getMessages({
    required conversationId,
    required offset,
    required limit,
  }) async {
    try {
      SmartDialog.showLoading(msg: "Loading messages...");

      var response = await ApiService()
          .get("/Chat/getMessages/$conversationId/$offset/$limit");

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        try {
          var res = Conversation.fromJson(resp["data"]);
          return res;
        } catch (e, stackTrace) {
          SmartDialog.dismiss();
          log(e.toString() + " error at conversation");
          log(stackTrace.toString()); // Log the stack trace
        }
      }

      return Conversation();
    } catch (e, stackTrace) {
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

      var response =
          await ApiService().post("/Chat/connectmetoTheserver", body: body);

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        try {
          var res = Conversation.fromJson(resp["data"]);
          return res;
        } catch (e, stackTrace) {
          SmartDialog.dismiss();
          log(e.toString() + " error at conversation");
          log(stackTrace.toString()); // Log the stack trace
        }
      }

      return Conversation();
    } catch (e, stackTrace) {
      SmartDialog.dismiss();
      log(e.toString() + " error");
      log(stackTrace.toString()); // Log the stack trace
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

      log(response.toString() + "send message");

      var resp = jsonDecode(response.toString());

      if (resp["statusCode"] == 200) {
        SmartDialog.dismiss();
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      SmartDialog.dismiss();
      log(e.toString() + " error");
      log(stackTrace.toString()); // Log the stack trace
      rethrow;
    }
  }
}
