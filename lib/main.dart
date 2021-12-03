import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const DiaryApplication());
}


Future<String> callPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
    Permission.manageExternalStorage
  ].request();

  if (statuses.values.every((element) => element.isGranted)) {
    return 'success';
  }

  return 'failed';
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
  // 오늘 하루일을 적을 form의 키값 관리를 해주는 객체
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // form 내 적힌 텍스트를 컨트롤해줄 컨트롤러
  final TextEditingController _commentController = TextEditingController();

  // 오늘 일기에 실을 사진을 관리할 File 객체 (Nullable)
  XFile? photoFile;

  // 사진을 가져와줄 ImagePicker 객체
  ImagePicker _imagePicker = ImagePicker();

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
                            var status = await Permission.camera.request();
                            if(status.isGranted) {
                              final XFile? image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                photoFile = image;
                                print(photoFile!.length());
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
                          onPressed: () {},
                          child: const Text(
                            '일기 저장하기',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

              // Text('오늘 하루')
            ],
          ),
        ));
  }


  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
