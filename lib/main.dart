import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:diary_app/component/diary_bean.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DiaryApplication());
}

class DiaryApplication extends StatelessWidget {
  const DiaryApplication({Key? key}) : super(key: key);

  // This widget is the root of your application.
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

class DiaryMainPage extends StatefulWidget {
  final String title;

  const DiaryMainPage({Key? key, required this.title}) : super(key: key);

  @override
  State<DiaryMainPage> createState() => _DiaryMainPageState();
}

class _DiaryMainPageState extends State<DiaryMainPage> {
  // 오늘 하루일을 적을 form 의 키값 관리를 해주는 객체
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // form 내 적힌 텍스트를 컨트롤해줄 컨트롤러
  final TextEditingController _commentController = TextEditingController();

  // 오늘 일기에 실을 사진의 경로를 저장할 변수
  String? _photoPath;

  List<Diary>? _diaryList; //일기장 내용 출력

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.w700),
        ))),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  Form(
                    child: TextFormField(
                      key: _formKey,
                      controller: _commentController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.note), //아이콘 넣으려다 병맛나서 삭제.
                        border: OutlineInputBorder(),
                        hintText: '오늘의 하루를 적어보세요.',
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.trim().length < 5) {
                          return '최소한 5글자는 넘도록 써주세용 루삥뽕';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () async {
                            var status = await Permission.photos.request();
                            print(status.isGranted);
                            if (status.isGranted) {
                              // 사진을 가져와줄 ImagePicker 객체
                              ImagePicker _imagePicker = ImagePicker();

                              XFile? image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery);

                              setState(() {
                                _photoPath = image!.path;
                              });
                            }
                          },
                          child: const Text(
                            '사진 업로드',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            String? _snackBarText = '';
                            if (_photoPath != null) {
                              print('텍스트 필드 값: ${_commentController.text}');
                              Diary diary = Diary(_commentController.text,
                                  _photoPath!, DateTime.now());

                              print(diary.toString());
                              setState(() {
                                // _diaryList!.add(diary);
                                addDiary(diary);

                                // _diaryList!.map((e) => print(e));
                                _photoPath = null;
                                _commentController.text = '';
                              });
                            } else if (_photoPath == null &&
                                _commentController.text.trim().length > 5) {
                              _snackBarText = '오늘 하루를 대표하는 사진을 한장 넣어주세요.';
                            } else if (_photoPath != null &&
                                _commentController.text.trim().length < 5) {
                              _snackBarText = '적어도 5자는 적어주세요... ㅜㅜ';
                            } else if (_photoPath == null &&
                                _commentController.text.trim().length < 5) {
                              _snackBarText =
                                  '뭐라도 5글자라도... 적어주세요...그리고 사진도 포함해주세요.';
                            }
                            if (_snackBarText != '') {
                              SnackBar snackBar = SnackBar(
                                content: Text(_snackBarText),
                                backgroundColor: Colors.blueAccent,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            // Android working checked, need to check if iOS works
                          },
                          child: const Text(
                            '일기 저장하기',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(child: printCurrentPhoto()),
                ],
              ),
              Container(
                child: printDiaries(_diaryList),
              )
            ],
          ),
        ));
  }

  Image? printCurrentPhoto() {
    if (_photoPath == null) {
      return null;
    } else {
      return Image.file(
        File(_photoPath!),
        width: double.infinity,
      );
    }
  }

  Widget? printDiaries(List<Diary>? diaryList) {
    if (diaryList == null) {
      return null;
    } else {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            var list = diaryList.reversed.toList();
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Card(
                  color: const Color.fromRGBO(158, 158, 158, 0.3),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.file(
                              File(list[index].photoUrl),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        list[index].content,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        DateFormat('yyyy년 MM월 dd일 kk시 mm분')
                            .format(list[index].postedAt),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: diaryList.length,
        ),
      );
    }
  }

  void addDiary(Diary diary) {
    //_diaryList 가 null 인지 확인
    int tmp = _diaryList?.length ?? 0;
    if (tmp > 0) {
      //_diaryList 가 null 이 아닌경우(정상적으로 리스트에 add 한다.)
      _diaryList!.add(diary);
    } else {
      // _diaryList 가 null 인 경우 (초기화 먼저 진행)
      _diaryList = [diary];
    }
    print('리스트 길이: ${_diaryList!.length}');
    for (int i = 0; i < _diaryList!.length; i++) {
      print(_diaryList![i]);
    }
    // _diaryList!.map((e) => print(e));
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
