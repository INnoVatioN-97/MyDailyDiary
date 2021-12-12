import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // var status = await Permission.request();
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 form 의 키값 관리를 해주는 객체
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // form 내 적힌 아이디, 비밀번비를 컨트롤해줄 컨트롤러들
    final TextEditingController _idController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    const TextStyle buttonText = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,

    );

    return Scaffold(
      backgroundColor: Color(0xfff),
      appBar: AppBar(
        title: const Text('로그인 페이지'),
      ),
      body: Padding(

        padding: const EdgeInsets.all(20.0),
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset('asset/images/google_icon.png',
                          width: 30, height: 30, fit: BoxFit.cover),
                      label: const Text(
                        '구글 로그인',
                        style: buttonText,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: signInWithFacebook,
                      icon: Image.asset('asset/images/facebook_icon.png',
                          width: 35, height: 35, fit: BoxFit.cover),
                      label: const Text(
                        '페이스북 로그인',
                        style: buttonText,
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff3b5998))),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
