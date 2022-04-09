import 'dart:async';
import 'dart:math';

import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/models/chat_message.dart';
import 'package:chatfy/providers/chat/chat_repository.dart';

class ChatMockProvider implements ChatProvider {
  static final List<ChatMessage> _msgs = [];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller?.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final _newMsg = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    _msgs.add(_newMsg);
    _controller?.add(_msgs.reversed.toList());

    return _newMsg;
  }
}
