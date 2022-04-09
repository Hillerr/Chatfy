import 'dart:async';
import 'dart:io';

import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/providers/auth/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseRepository implements AuthProvider {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi(
    (controller) async {
      final authChanges = FirebaseAuth.instance.authStateChanges();
      await for (var user in authChanges) {
        _currentUser = user == null ? null : _toChatUser(user);
        controller.add(_currentUser);
      }
    },
  );

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
    final auth = FirebaseAuth.instance;

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;

    // 1.Upload da foto do usuário
    final imageName = '${credential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);

    // 2. Atualizar os atributos do usuário
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageURL);

    // 3. Salvar usuário no banco de dados (opcional)
    _currentUser = _toChatUser(credential.user!, name, imageURL);
    await _saveChatUser(_currentUser!);
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
    });
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageURL]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: imageURL ?? user.photoURL ?? 'assets/images/default-user.jpg',
    );
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) {
      return null;
    }

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }
}