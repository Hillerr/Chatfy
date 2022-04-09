import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/providers/auth/auth_repository.dart';

class AuthMockProvider implements AuthProvider {
  static const _defaultUser = ChatUser(
    id: '456',
    name: 'Ana',
    email: 'ana@teste',
    imageURL: 'assets/images/default-user.jpg',
  );

  static Map<String, ChatUser> _users = {_defaultUser.email: _defaultUser};

  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> singup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/default-user.jgp',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
