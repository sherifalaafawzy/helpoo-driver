// ignore_for_file: unused_local_variable

import 'dart:convert';

class ClickActionHandler {
  static handle(payload) async {
    var messageData = jsonDecode(payload);
    if (messageData['type'] != null && messageData['id'] != null) {
      String type = messageData['type'];
      int id = int.tryParse(messageData['id']) ?? -1;
      switch (type) {
        case 'service-request':
         break;
        default:
      }
    }
  }
}
