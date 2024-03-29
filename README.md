# iOS05 - Segno

# 🎼 프로젝트 소개

> 다시 이곳의 추억에서부터, **세뇨** (**Segno**)
> 

## 세뇨는 어떤 앱인가요?

- “추억을 최대한 구체적으로 재현하는 앱”을 목표로, 쓰는 순간 보고 듣고 느낀 것을 모두 기록할 수 있는 일기 앱입니다.
- **본 것**을 사진으로 기록하고, **들은 음악**의 데이터를 기록하며, **느낀 것**을 글로써 기록합니다.
- 이후 나중에 다시 꺼내 볼 때 찍어 두었던 사진과 함께, 기록해 두었던 음악과 함께 느꼈던 점을 돌아봄으로써, 간직하고 싶었던 그 때 그 감정을 되살릴 수 있습니다.

### 세뇨란 무엇인가요?

D.S.로 표기되는 "달 세뇨" 음악 기호와 함께 쓰이는 기호입니다. 달 세뇨는, 세뇨로 표시된 지점부터 다시 연주하라는 뜻입니다.

마치 세뇨로 표시되어 있는 지점으로 돌아가 다시 연주를 시작하듯, **추억을 사진과 음악, 위치 등 최대한 여러 가지 정보를 통해 구체적으로 남겨 저장**하고, 나중에 열람할 때 저장해 두었던 사진과 음악을 함께 보고 들으며 추억을 회상할 수 있습니다.

그 때 그 순간 들려오는 음악을 인식해 검색하고, 사진과 함께 저장한다면, 언제든 이 **세뇨**로 돌아와 다시 삶이라는 **연주를 시작**할 수 있습니다.

## iOS 5조, "달 세뇨" (Dal Segno) 팀원 소개
|S035 유태호|S040 이예준|S041 이윤종|S054 최경민|
|---|---|---|---|
|![](https://avatars.githubusercontent.com/u/35491206?v=4)|![](https://avatars.githubusercontent.com/u/107831192?v=4)|![](https://avatars.githubusercontent.com/u/29617557?v=4)|![](https://avatars.githubusercontent.com/u/80261919?v=4)|
|[@BaeRoNuI](https://github.com/BaeRoNuI)|[@rudah7](https://github.com/rudah7)|[@LEEYOONJONG](https://github.com/LEEYOONJONG)|[@radiantchoi](https://github.com/radiantchoi)|
|감동|청춘|감성|낭만|

# Flow Chart
![flowchart](https://user-images.githubusercontent.com/80261919/205933203-5c1e0870-ac03-46a3-b284-9a41ee5158f1.png)

# Architecture
![SegnoPresentation](https://user-images.githubusercontent.com/80261919/207883100-38e74ff7-9f00-46d5-bc77-cd7a3d80f119.jpg)

# 시연 영상
[<img src="https://user-images.githubusercontent.com/29617557/207881176-d27fc5be-2a15-4baa-8978-117e6a54e256.png" width="300">](https://youtu.be/pH8ucljwNdM)

클릭하여 영상을 보실 수 있습니다.

# 🎯 프로젝트 기능

## 일기 목록 열람

- 로그인하고 나면, 지금까지 자신과 다른 사람이 썼던 일기 목록을 썸네일, 제목을 통해 모두 볼 수 있습니다.
- 제목을 기준으로 검색해서 필터링해서 볼 수 있습니다.
<img src="https://user-images.githubusercontent.com/80261919/207882619-aa2d6348-59cf-4433-9cf0-50fdad25a025.gif" width="300">

## 각 일기 열람

- 각 일기에서는 작성했던 일기 내용을 구체적으로 볼 수 있습니다.
    - 기록해 두었다면, 일기를 작성했던 위치를 애플 지도로 확인할 수 있습니다.
    - 기록해 두었다면, 해당 위치에서 기록한 음악을 재생할 수 있습니다.
- [일기 열람 시연 영상](https://windy-crayfish-861.notion.site/cea3fdca26254c1ab14b17af4d4e1723)

## 일기 작성 및 삭제

- 사진과 음악 데이터, 글을 기록, 수정, 삭제할 수 있습니다.
    - 필수 입력 요소 : 사진
    - 선택 입력 요소 : 제목 - 자동 설정된 제목으로 저장됩니다.
    - 선택 입력 요소 : 내용, 위치, 음악 정보
- 자신이 쓰지 않은 일기의 경우, 대신 신고 버튼을 눌러 신고할 수 있습니다.

|일기 작성|일기 수정|일기 삭제|
|---|---|---|
|<img src="https://user-images.githubusercontent.com/80261919/207883367-bcab8948-9694-47ad-a75d-6fc41bdff331.gif" width="300">|<img src="https://user-images.githubusercontent.com/80261919/207883356-45d19d64-ed79-483f-a531-b1a97df2bde5.gif" width="300">|<img src="https://user-images.githubusercontent.com/80261919/207883293-0b0e776c-2549-4ed3-a9ed-81e0cdfdb38e.gif" width="300">|

# ⛳️ 기술 스택

## MVVM-C

**Why?** **→** 학습 스프린트 프로젝트를 진행하는 과정에서 기존의 익숙한 MVC 방식으로 앱을 작성했고, 이 과정에서 View Controller가 지나치게 비대해지는 것을 직접 경험했습니다. 애플 앱에서의 뷰 컨트롤러가 유저와의 상호작용, 상호작용에 따른 데이터의 변화 및 앱의 동작, 그리고 결과를 다시 뷰에 보여주는 것을 모두 담당하고 있기 때문에 벌어진 일이라고 판단했습니다.

**How? →** UI를 보여주는 View와 데이터를 담고 있는 Model, 비즈니스 로직을 담고 있는 ViewModel로 분리함으로써 서로의 역할을 분리하였습니다. 또한 화면에 대한 동작까지도 Coordinator를 이용하여 분리하였습니다.

**Result! →** 전체적인 흐름을 볼 때, 각각의 부분들로 분리하였기에 테스팅 측면에서 수월해졌습니다. 또한 각각의 역할이 다르기에 독립적으로 개발할 수 있었습니다.

## Clean Architecture

**Why?** **→** Segno라는 앱은 친구 추가, DM 등 향후 기능을 확장할 부분이 상당히 많습니다. 기능의 확장에 열려있는 구조를 고민하던 와중, Clean Architecture를 접하게 되었습니다. Layer를 기준으로 분리하고, Outer Layer에 대해 아무것도 모르게 함을 통해 비즈니스 로직의 결합도를 낮추려는 Clean-Architecture의 철학이 저희의 목적과 일치하다고 느껴 채택을 하였습니다.

**How? →** 구현 과정에 코드의 “역할에 따른 분리”에 집중했습니다. 하나의 기능을 나타내는 코드들은 UseCase로 작성하여 관리하였습니다. 또한, 데이터를 주거나 받는 부분은 Repository로 만들어 다루었습니다. 이때, 각각의 Repository는 Protocol을 만들어, 직접적으로 구현체에 의존하지 않도록 하였고, 로직 자체를 쉽게 갈아낄 수 있도록 만들었습니다.

**Result! →** 개발 도중 View의 동작 확인을 위한 테스트를 위한 Mock 객체와, 실제 로직을 위한 Implementation 객체를 만들어 사용하였습니다. 단순히 Mock 객체를 Impl 객체로 변경하는 것만으로 서버 통신을 할지, 안할지 쉽게 변경이 가능하였습니다. 또한, Protocol에 함수의 interface를 작성하는 것만으로 어디에 함수를 구현할지 쉽게 알 수 있었고, 개발하는 과정에서 상당한 편의성을 느낄 수 있었습니다.

## RxSwift

**Why?** **→** 서버와의 통신이 주를 이루는 서비스이기에, URLSession을 이용한 서버 통신이 잦고, 이로 인해 Callback Hell이 일어나기 쉽습니다. 이러한 Callback Hell은 가독성 및 로직의 유연성을 많이 저해합니다. RxSwift는 이러한 로직을 함수형 패러다임에 맞게 데이터를 다룰 수 있도록 도와줍니다.

**How? →** 대표적으로, 서버 통신의 결과를 Single로 만들어 다루었습니다. 하나의 network request는 데이터를 보내거나 받기 위한 단일 통신이기에, Session을 유지할 필요가 없어 Single을 사용하였습니다. 테스트가 용이하고 또한 확장에 유연한 코드, 다시 말해 표현력이 높은 코드를 작성하기 위해 map과 같은 고차함수들의 사용을 지향하였습니다.

**Result! →** Diary를 보내야 하는 경우, 이미지를 보내고, 이후에 다이어리 데이터를 보내야 하기 때문에, 중첩된 Single문이 발생하였습니다. map, flatMap 등의 고차함수 및 operator를 사용하여 보다 가독성있고, 유연한 로직을 작성하였습니다.

## ShazamKit & MusicKit

**Why?** **→** 음원을 검색하고, 재생하는 기능을 구현하기 위해서는 음원 정보가 같은 데이터베이스에 기반하는 것이 좋습니다. 검색한 음원이 막상 재생이 되지 않는다면 앱의 취지를 해치기 때문입니다. 그래서 애플의 퍼스트 파티 SDK이며, Apple Music 데이터베이스에 기반해 음악을 검색하고 재생하는 ShazamKit과 MusicKit을 사용했습니다.

**How? →** ShazamKit을 활용해 마이크로 받은 음성을 Signature로 재구성한 다음, 애플 뮤직 DB에 동일한 정보를 가진 음악이 있는지 찾습니다. 검색에 성공했다면 해당 음원의 정보를 저장한 다음, 해당 음원의 ISRC(국제 음원 식별 코드)를 기반으로 애플 뮤직 DB에 다시 접속한 다음 음악을 찾아 와서 재생합니다.

**Result! →** 음악을 의도한 대로 잘 검색할 수 있었으며, 또한 isrc 정보를 입력하면 의도한 대로 잘 재생되었습니다.

## MapKit

**Why?** **→** 사용자의 현재 위치를 받아 일기에 저장하고, 저장된 위치를 사용자에게 지도를 통해 보여주기 위해 이용했습니다. 퍼스트파티 프레임워크라 안정적이고, 사용 방법이 쉬운 MapKit을 활용하여 빠르게 기능을 구현할 수 있었습니다.

**How? →** 일기 작성 시 현재의 위치에 해당하는 위도/경도 정보를 저장합니다. 추후 일기 열람 시 저장된 위치에 해당하는 장소를 애플 지도를 통해 보여줍니다.

**Result! →** Third-Party 라이브러리와 비교하여 설정해줘야 할 요소들이 적어 빠른 개발이 가능했습니다.

# 📝 고민했던 점에 대한 기록 - Weekly Dal Segno
[Week 2 - Apple OAuth + Clean Architecture](https://windy-crayfish-861.notion.site/11-17-Apple-OAuth-Clean-Architecture-9ea050c70f7b4511b55f6066088064c2)

[Week 3 - RxSwift Materialize](https://windy-crayfish-861.notion.site/11-24-RxSwift-materialize-78afec14d601428e8e71caa9a16ed109)

[Week 4 - ShazamKit + MusicKit](https://windy-crayfish-861.notion.site/12-4-ShazamKit-MusicKit-96d91af95da84dd2a70ff5f338ab4521)

[Week 5 - Delegate to Rx data stream](https://windy-crayfish-861.notion.site/12-10-Delegate-d7501be5476744f690e27c4e5efd2552)

[Week 6 - Testing on Clean Architecture](https://yoonjong.tistory.com/entry/클린-아키텍처-구조에서-유즈케이스-테스트하기)
