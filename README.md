# diary_app

멜로가 체질 보고 영감받은 하루 일기앱
    -   은정이가 상자에서 꺼낸 홍대의 휴대폰을 열어봤을 때 그때 그 장면
    -   ![img_1.png](img_1.png)
## 기능
-   하루 일과를 마무리하는 일기장을 작성할 수 있다.
    -   일기에는 오늘 하루를 대표하는 사진 한장과 간단한 문구를 적을 수 있다.
-   일기들은 모두 firebase 에 저장되어 로그인시 데이터가 유지되며, 희망하면 비밀번호를 통한 앱 잠금 기능을 제공한다. (예정)

### 현재까지 구현된 내용
-   앱 화면
    
    ![img.png](img.png)
    
    삭제 버튼을 누르면
    
    ![img_3.png](img_3.png)
        
-   오늘 하루를 대표하는 사진과 간단한 일기를 작성할 수 있다.
-   firebase를 사용해 구글 로그인을 할 수 있으며, 이를 통해 다른 기기에서도
    내가 작성하던 일기를 이어서 사용할 수 있다. (일기 저장시 자동으로 DB에 저장됨.)
-   게시글을 삭제하면 Cloud Firestore에 저장된 게시글의 삭제와 동시에 Firestorage속 사진도 삭제 되도록 하여 DB용량 절약


### 구현 예정인 내용
-   안드로이드로 우선작업 후 iOS에도 정상작동하도록 info.plist 수정할 예정.
-   디자인은 추후 수정할 예정으로 현재는 기능자체의 구현에 중점을 두고 있음.
-   앱 잠금 기능 구현 예정(간단한 숫자패드로)

-   ☞최종적으로 개발 완료시 구글 광고 삽입과 함께 플레이 스토어 출시 해볼 계획.