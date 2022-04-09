import 'package:chatfy/models/chat_user.dart';
import 'package:chatfy/providers/auth/auth_mock_repository.dart';
import 'package:chatfy/providers/auth/auth_repository.dart';
import 'package:chatfy/providers/notification/push_notification_service.dart';
import 'package:chatfy/views/auth_page.dart';
import 'package:chatfy/views/chat_page.dart';
import 'package:chatfy/views/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    await Provider.of<PushNotificationService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthProvider().userChanges,
            builder: (context, snaphot) {
              if (snaphot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snaphot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
