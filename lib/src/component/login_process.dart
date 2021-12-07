import 'package:diary_app/src/pages/diary_page.dart';
import 'package:diary_app/src/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProcess extends StatelessWidget {
  const LoginProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          Map<String, String> _userObj = {
            'displayName': snapshot.data?.displayName ?? 'displayName 오류',
            'uid': snapshot.data?.uid ?? 'uid 오류'
          };
          if (snapshot.data == null) {
            return const LoginPage();
          } else {
            return DiaryMainPage(title: '오늘 하루 일기장', userObj: _userObj);
          }
        },
      ),
    );
  }
}
