import 'package:diary_app/pages/diary_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // 로그인 form 의 키값 관리를 해주는 객체
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // form 내 적힌 아이디, 비밀번호를 컨트롤해줄 컨트롤러들
    final TextEditingController _idController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '아이디',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.trim().length < 2) {
                          return '제대로 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '비밀번호',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.trim().length < 2) {
                          return '제대로 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                          // Navigator.replace(context, MaterialPageRoute(builder: (context) => const DiaryMainPage(title: '오늘 하루 일기장')),);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DiaryMainPage(title: '오늘 하루 일기장')));
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                          // Navigator.replace(context, MaterialPageRoute(builder: (context) => const DiaryMainPage(title: '오늘 하루 일기장')),);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DiaryMainPage(title: '오늘 하루 일기장')));
                        },
                        icon: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                        label: const Text(
                          '구글 로그인',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                          // Navigator.replace(context, MaterialPageRoute(builder: (context) => const DiaryMainPage(title: '오늘 하루 일기장')),);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DiaryMainPage(title: '오늘 하루 일기장')));
                        },
                        icon: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                        label: const Text(
                          '깃허브 로그인',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
