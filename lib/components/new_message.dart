import 'package:chatfy/providers/auth/auth_repository.dart';
import 'package:chatfy/providers/chat/chat_repository.dart';
import 'package:chatfy/providers/chat/chat_repository.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _msg = '';
  final _msgController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthProvider().currentUser;

    if (user != null) {
      await ChatProvider().save(_msg, user);
      _msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _msgController,
            onChanged: (msg) => setState(() => _msg = msg),
            decoration: const InputDecoration(labelText: 'Enviar Mensagem...'),
            onSubmitted: (_) {
              if (_msg.trim().isNotEmpty) {
                _sendMessage();
              }
            },
          ),
        ),
        IconButton(
          onPressed: _msg.trim().isEmpty ? null : _sendMessage,
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
