import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/src/component/diary_bean.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DiaryMainPage extends StatefulWidget {
  final String title;
  final Map<String, String> userObj;

  const DiaryMainPage({Key? key, required this.title, required this.userObj})
      : super(key: key);

  @override
  State<DiaryMainPage> createState() => _DiaryMainPageState();
}

class _DiaryMainPageState extends State<DiaryMainPage> {
  // 오늘 하루일을 적을 form 의 키값 관리를 해주는 객체
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // form 내 적힌 텍스트를 컨트롤해줄 컨트롤러
  final TextEditingController _commentController = TextEditingController();

  // 게시글 삭제시 컨펌 창을 위한 GlobalKey 생성
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 오늘 일기에 실을 사진의 경로를 저장할 변수
  String _photoPath = '';

  List<Diary> _diaryList = []; //일기장 내용 출력

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f2f6),
      key: scaffoldKey,
      appBar: AppBar(
          title: Center(
              child: Text(
        '${widget.userObj['displayName']}의 ${widget.title}',
        style: const TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.w700),
      ))),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(
              children: [
                printCurrentPhoto(),
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
                                source: ImageSource.gallery,
                                maxHeight: 320,
                                maxWidth: 320);
                            print('my phone');
                            print(
                                'width: ${MediaQuery.of(context).size.width}\n'
                                'height: ${MediaQuery.of(context).size.height}');

                            // print('my photo');
                            // print('width: ${image.}\nheight: ${MediaQuery.of(context).size.height}');
                            if (image!.path.isNotEmpty) {
                              setState(() {
                                _photoPath = image.path;
                              });
                            }
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
                          if (_photoPath != '') {
                            print('텍스트 필드 값: ${_commentController.text}');
                            Diary diary = Diary(
                                content: _commentController.text,
                                photoUrl: _photoPath,
                                postedAt: DateTime.now());

                            print(diary.toString());
                            setState(() {
                              // _diaryList.add(diary);
                              addDiary(diary);

                              // _diaryList.map((e) => print(e));
                              _photoPath = '';
                              _commentController.text = '';
                            });
                          } else if (_photoPath == '' &&
                              _commentController.text.trim().length > 5) {
                            _snackBarText = '오늘 하루를 대표하는 사진을 한장 넣어주세요.';
                          } else if (_photoPath != '' &&
                              _commentController.text.trim().length < 5) {
                            _snackBarText = '적어도 5자는 적어주세요... ㅜㅜ';
                          } else if (_photoPath == '' &&
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
              ],
            ),
            Expanded(
              child: printDiaries(),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃')),
          ],
        ),
      ),
    );
  }

  Widget printCurrentPhoto() {
    if (_photoPath == '') {
      return Container();
    } else {
      Image image = Image.file(
        File(_photoPath),
        width: double.infinity,
      );
      return SizedBox(
          width: MediaQuery.of(context).size.width - 40, child: image);
    }
  }

  Widget printDiaries() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_diaries')
            .doc(widget.userObj['uid']!)
            .collection('diary')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                var list = snapshot.data!.docs.toList().reversed;
                // _diaryList = null;
                for (var element in list) {
                  // print(element.data());
                  Diary diary = Diary(
                      postedAt: element['postedAt'].toDate(),
                      content: element['content'],
                      photoUrl: element['photoUrl']);
                  //_diaryList 가 null 인지 확인
                  int tmp = _diaryList.length;
                  if (tmp > 0) {
                    //_diaryList 가 null 이 아닌경우(정상적으로 리스트에 add 한다.)
                    _diaryList.add(diary);
                  } else {
                    // _diaryList 가 null 인 경우 (초기화 먼저 진행)
                    _diaryList = [diary];
                  }
                }
                // print('list: $list');
                if (list.isEmpty) {
                  return const CircularProgressIndicator();
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Card(
                      color: const Color(0xffced6e0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Image.network(
                                _diaryList[index].photoUrl,
                              ),
                            ),
                          ),
                          Text(
                            _diaryList[index].content,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            DateFormat('yyyy년 MM월 dd일 kk시 mm분')
                                .format(_diaryList[index].postedAt),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          ElevatedButton.icon(
                              onPressed: () async {
                                SnackBar snackBar = SnackBar(
                                  content: const Text('이 게시글을 삭제하겠습니까?'),
                                  backgroundColor: Colors.blueAccent,
                                  action: SnackBarAction(
                                    label: "삭제하기",
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      print(generateDocName(
                                          _diaryList[index].postedAt));

                                      deleteDiary(widget.userObj['uid']!,
                                          _diaryList[index].postedAt);
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('삭제하기')),
                        ],
                      ),
                    ),
                  );
                }
              },
              itemCount: snapshot.data!.docs.length,
            );
          }
        });
    // }
  }

  void addDiary(Diary diary) async {
    await uploadImageToStorage(diary);
  }

  Future<void> uploadImageToStorage(Diary diary) async {
    String creator = widget.userObj['uid']!;
    String imageName = generateDocName(diary.postedAt);
    final ref = FirebaseStorage.instance
        .ref()
        .child("diaryPhotos")
        .child(creator)
        .child(imageName + '.jpg');
    await ref.putFile(File(diary.photoUrl));

    final downURL = await ref.getDownloadURL();
    diary.photoUrl = downURL;
    uploadDiaryToFireStore(diary);
  }

  void uploadDiaryToFireStore(Diary diary) async {
    await FirebaseFirestore.instance
        .collection('user_diaries')
        .doc(widget.userObj['uid']!)
        .collection('diary')
        .doc(generateDocName(diary.postedAt))
        .set({
      'content': diary.content,
      'photoUrl': diary.photoUrl,
      'postedAt': diary.postedAt
    });
    setState(() {
      _diaryList = []; //_diaryList 를 무효화시켜 다시 렌더링
    });
  }

  String generateDocName(DateTime time) {
    final generatedDocName =
        '${time.year}-${time.month}-${time.day}-${time.hour}-${time.minute}-${time.second}-${time.millisecond}';
    // final generatedDocName =  time.toString().substring(0, time.toString().length-4);
    // print(generatedDocName.hashCode);
    return generatedDocName;
  }

  void deleteDiary(String creator, DateTime time) async {
    await FirebaseFirestore.instance
        .collection('user_diaries')
        .doc(creator)
        .collection('diary')
        .doc(generateDocName(time))
        .delete()
        .then((value) async => await FirebaseStorage.instance
            .ref()
            .child("diaryPhotos")
            .child(creator)
            .child(generateDocName(time) + '.jpg')
            .delete()
            .then((value) => print('photo Deleted.'))
            .catchError((error) => print("Failed to delete photo: $error")))
        .catchError((error) => print("Failed to delete post: $error"));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 1),
      content: Text('삭제 되었습니다.'),
      backgroundColor: Colors.blueAccent,
    ));
// test
    setState(() {
      _diaryList = []; //_diaryList 를 무효화시켜 다시 렌더링
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
}
