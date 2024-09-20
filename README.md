# Sachosaeng-iOS


## 📌 프로젝트 소개
협업 동아리 프로그라피에서 P.O, 디자이너, 마케터, 백엔드, AOS, iOS 로 구성된 팀으로 
AOS, iOS를 지원하는 “**사초생**”을 개발했습니다.

- 개발 기간 - 2024.06 ~ 출시예정(테스트 플라이트 등록)

### 사회생활 집단지성 투표 플랫폼
- 사회초년생이 사회생활에서 겪는 주관적인 고민에 대해 투표 시스템을 활용해 가장 실용적인 해결책을 찾도록 돕는 서비스
- 사회 초년생들을 위한 실용적인 정보를 제공하면서, 어디에서도 찾을 수 없는 정보를 파악하며 내 또래의 사람들로부터 공감을 얻을 수 있는 ‘정보 서비스'

<br/><br/>


## 📌 설치 / 실행 방법
1. 아래 파일은 필수 파일이므로 다음 이메일로 파일을 요청해주세요. (dasom8899981@gmail.com)
```
- Config.xcconfig
```
2. Sachosaeng.xcodeproj 파일 실행을 해주세요.
3. Config 폴더에 필수파일을 추가한 뒤 빌드해주세요.

<br/><br/>

## 📌 기능 소개
### 메인기능 
- 투표: 투표 별 투표 기능 제공
- 유저가 직접 투표 후 투표 결과 확인 > 타 유저들의 의견 확인 가능
- 정보 안내: 투표 연관 콘텐츠 안내
- 북마크 기능: 투표 북마크 기능으로 탐색

### 마이페이지/설정
- 프로필 수정 / 관심사 설정 / 1:1 문의
- 설정: 버전 안내 / 오픈소스 라이브러리 / 개인정보 처리 방침 / 서비스 이용 약관 / FAQ / 탈퇴하기

<br/><br/>

## 📌 IA

![Information architecture](https://github.com/user-attachments/assets/adebc5c4-a8a3-4c67-9252-33f55648791e)

<br/><br/>

## 📌 개발 도구 및 기술 스택
<img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white"><img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"><img src="https://img.shields.io/badge/figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white"><img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=black"><img src="https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">

#### 개발환경
- Swift 5.9, Xcode 15.0.1, iOS 16.0 이상

#### 협업도구
- Figma
- Github
- Team Notion
- TestFlight

#### 기술스택
- SwiftUI
- UIKit
- Lottie
- GoogleCloud
- KakaoSdk
<br/><br/>

## 📌 Folder Convention 
```
📦 Sachosaeng
+-- 🗂 Config
+-- 🗂 Resource 
+-- 🗂 Extention 
|    +-- 🗂 ColorExtension
|    +-- 🗂 FontExtension
|    +-- 🗂 ViewExtension
|    +-- 🗂 ViewModifier
+-- 🗂 Utility
+-- 🗂 Service
|    +-- 🗂 NetworkService
|    +-- 🗂 UserService
|    +-- 🗂 AuthService
|    +-- 🗂 VersionService
+-- 🗂 Model
+-- 🗂 ViewModel
+-- 🗂 View
|    +-- 🗂 SignView
|    |    +-- 🗂 Cell
|    +-- 🗂 HomeView
|    |    +-- 🗂 HomeViewCell
|    |    +-- 🗂 MyPageCell
|    +-- 🗂 BookmarkView
|    |    +-- 🗂 BookmarkViewCell
```
