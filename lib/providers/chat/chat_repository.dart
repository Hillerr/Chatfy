import 'package:chatfy/models/chat_message.dart';
import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/providers/chat/chat_firebase_repository.dart';
import 'package:chatfy/providers/chat/chat_mock_repository.dart';

abstract class ChatProvider {
  Stream<List<ChatMessage>> messagesStream();
  Future<ChatMessage?> save(String text, ChatUser user);

  factory ChatProvider() {
    return ChatFirebaseRepository();
  }
}
