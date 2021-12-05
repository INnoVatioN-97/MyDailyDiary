class Diary{
  String content;     // 일기장 내용
  String photoUrl;    // 일기장 첨부사진
  DateTime postedAt;  // 게시날짜

  Diary(this.content, this.photoUrl, this.postedAt);

  @override
  String toString() {
    return '내용: $content 사진: $photoUrl 게시날짜: $postedAt';
  }
}