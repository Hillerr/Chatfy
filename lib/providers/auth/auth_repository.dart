import 'dart:io';

import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/providers/auth/auth_firebase_repository.dart';
import 'package:chatfy/providers/auth/auth_mock_repository.dart';

abstract class AuthProvider {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> singup(String name, String email, String password, File? image);
  Future<void> login(String email, String password);
  Future<void> logout();

  factory AuthProvider() {
    // return AuthMockProvider();
    return AuthFirebaseRepository();
  }
}
