import 'package:diary_app/pages/diary_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiaryApplication());
}

class DiaryApplication extends StatelessWidget {
  const DiaryApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiaryMainPage(title: '오늘 하루 일기장'),
    );
  }
}

