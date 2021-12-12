class Diary{
  String? creator;     // 작성자
  String content;     // 일기장 내용
  String photoUrl;    // 일기장 첨부사진
  DateTime postedAt;  // 게시날짜


  Diary({required this.content, required this.photoUrl, required this.postedAt});

  // 개발용
  @override
  String toString() {
    return '작성자: $creator 내용: $content 사진: $photoUrl 게시날짜: $postedAt';
  }
}