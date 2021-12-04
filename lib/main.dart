import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const DiaryApplication());
}

// Future<String> callPermissions() async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.camera,
//     Permission.storage,
//     Permission.manageExternalStorage
//   ].request();
//
//   if (statuses.values.every((element) => element.isGranted)) {
//     return 'success';
//   }
//
//   return 'failed';
// }

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
                            String? _snackBarText;
                            print('텍스트 필드 값: ${_commentController.text}');
                            if (_photoPath != null) {
                              setState(() {
                                _photoPath = null;
                                _commentController.text = '';
                              });
                            } else if(_photoPath == null && _commentController.text.trim().length>5){
                              _snackBarText = '오늘 하루를 대표하는 사진을 한장 넣어주세요.';
                            }else if(_photoPath != null && _commentController.text.trim().length<5){
                              _snackBarText = '적어도 5자는 적어주세요... ㅜㅜ';
                            }else if(_photoPath == null && _commentController.text.trim().length<5){
                              _snackBarText = '뭐라도... 적어주세요... 글자 최소5글자에 사진을 포함해주세요.';
                            }
                            if(_snackBarText != null) {
                              SnackBar snackBar = SnackBar(
                                content: Text(_snackBarText!),
                                backgroundColor: Colors.blueAccent,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text(
                            '일기 저장하기',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Expanded(
                  // flex: 1,
                  Container(child: printCurrentPhoto()),
                  // ),
                ],
              ),

              // Text('오늘 하루')
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

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
