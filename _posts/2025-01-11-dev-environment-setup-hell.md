---
layout: post
title: "개발 환경 설정에서 3일을 날린 이야기 (feat. PATH 설정 지옥)"
description: "Node.js, Python, Git 설치 과정에서 겪은 온갖 에러들과 해결 방법"
date: 2025-01-11
category: "500 - Internal Server Error"
tags: [개발환경, PATH설정, 초보자가이드, 에러해결, Node.js, Python]
status: "resolved"
author: "Error404 Developer"
reading_time: "10분"
---

## 📌 들어가며

"개발 환경 설정? 그거 그냥 다운로드 받아서 설치하면 되는 거 아니야?"

네, 저도 그렇게 생각했습니다. **3일 전까지는요.**

![현실](https://i.imgur.com/meme.jpg)
*실제 내 모습*

이 글은 개발 환경 설정하다가 멘탈이 터진 초보 개발자의 리얼 체험기입니다.

---

## 🎯 목표

간단했습니다:
1. Node.js 설치
2. Python 설치
3. Git 설치
4. VS Code 설치

**예상 시간: 30분**
**실제 소요 시간: 3일**

---

## 💥 문제 1: Node.js가 설치되었는데 없다고?

### 상황

Node.js를 다운로드 받아서 설치했습니다.
설치 완료 메시지도 봤습니다.
자신감 넘치게 터미널을 열고:

```bash
node --version
```

결과:

```bash
'node'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는
배치 파일이 아닙니다.
```

### 😱 내 반응

"뭐야? 방금 설치했는데??"

*설치 재시도 x 5회*

여전히 안 됨.

### ✅ 해결 방법

**문제: PATH 환경 변수 미설정**

Windows에서 Node.js를 설치하면 자동으로 PATH에 추가되어야 하는데,
가끔 안 될 때가 있습니다.

**해결 단계:**

1. **Node.js 설치 경로 확인**
   - 보통 `C:\Program Files\nodejs\` 에 설치됨
   - 탐색기에서 직접 확인

2. **환경 변수 설정**
   - Windows 검색에서 "환경 변수" 검색
   - "시스템 환경 변수 편집" 클릭
   - "환경 변수" 버튼 클릭
   - "시스템 변수"에서 `Path` 선택 → "편집"
   - "새로 만들기" → `C:\Program Files\nodejs\` 추가
   - 확인 × 3번

3. **터미널 재시작** (중요!)
   - 기존 터미널 완전히 종료
   - 새로 열기

4. **확인**
```bash
node --version
# v20.10.0 (성공!)

npm --version
# 10.2.3 (이것도!)
```

### 💡 배운 점

- 환경 변수 설정 후엔 **반드시 터미널 재시작**
- PATH는 프로그램 실행 파일의 위치를 시스템에 알려주는 것
- Windows는 경로 구분자가 `\` (백슬래시)

---

## 💥 문제 2: Python 2개 버전 충돌

### 상황

Python 3.11을 설치했는데:

```bash
python --version
# Python 2.7.18
```

엥? 3.11 설치했는데??

### 😱 내 반응

"컴퓨터가 날 싫어하나..."

### ✅ 해결 방법

**문제: 기존 Python 2.x와 신규 Python 3.x 충돌**

Windows에는 여러 버전의 Python이 공존할 수 있는데,
PATH 순서에 따라 어떤 버전이 실행될지 결정됩니다.

**해결 단계:**

1. **설치된 Python 버전 확인**
```bash
where python
# C:\Python27\python.exe
# C:\Users\YourName\AppData\Local\Programs\Python\Python311\python.exe
```

2. **PATH 순서 조정**
   - 환경 변수에서 Python 3.11 경로를 **위로** 이동
   - Python 2.7 경로는 아래로 (또는 삭제)

3. **python3 명령어 사용**
```bash
python3 --version
# Python 3.11.0

# 또는 py 런처 사용
py -3 --version
# Python 3.11.0
```

4. **별칭 설정 (선택사항)**
```bash
# PowerShell에서
Set-Alias python python3
Set-Alias pip pip3
```

### 💡 배운 점

- Windows에서는 `py` 런처가 편리함
- `py -3` : Python 3 실행
- `py -2` : Python 2 실행
- PATH 순서가 중요함 (위에 있는 게 우선)

---

## 💥 문제 3: Git Bash vs CMD vs PowerShell

### 상황

Git을 설치했더니 터미널이 3개:
- Git Bash
- CMD
- PowerShell

각각 명령어가 다르고, 경로 표시도 다르고...

```bash
# Git Bash
$ ls
# 작동 O

# CMD
> ls
'ls'은(는) 내부 또는 외부 명령... (또 너야?)

# PowerShell
PS> ls
# 작동 O (그런데 출력 형식이 다름)
```

### 😱 내 반응

"이게 다 뭐람..."

### ✅ 해결 방법

**각 터미널의 특징 이해하기**

| 터미널 | 명령어 스타일 | 장점 | 단점 |
|--------|---------------|------|------|
| **Git Bash** | Linux 스타일 | Git 작업 편리, Linux 명령어 사용 가능 | Windows 전용 프로그램 실행 불편 |
| **CMD** | Windows 전통 | Windows 명령어 완벽 지원 | 기능 제한적, 구식 |
| **PowerShell** | Windows 현대 | 강력한 스크립팅, 객체 기반 | 초보자에겐 복잡 |

**내가 선택한 방법:**

1. **Git 작업**: Git Bash
2. **일반 개발**: VS Code 내장 터미널 (PowerShell)
3. **Windows 관리**: PowerShell

**VS Code 기본 터미널 설정:**
```json
// settings.json
{
  "terminal.integrated.defaultProfile.windows": "Git Bash"
}
```

### 💡 배운 점

- 용도에 따라 터미널을 구분해서 사용
- VS Code 내장 터미널이 제일 편함
- Git Bash에서 `ls`, `pwd` 같은 Linux 명령어 사용 가능

---

## 💥 문제 4: npm install 권한 오류

### 상황

첫 프로젝트 시작!

```bash
npm install express
```

결과:

```bash
npm ERR! Error: EPERM: operation not permitted
npm ERR! code EPERM
npm ERR! syscall mkdir
```

### 😱 내 반응

"허락도 안 받고 뭘 하려는 거야 npm..."

### ✅ 해결 방법

**문제: 관리자 권한 필요**

**시도 1: 관리자 권한으로 실행**
```bash
# PowerShell을 관리자 권한으로 실행
npm install express
# 성공!
```

**하지만 매번 관리자 권한은 불편...**

**시도 2: npm 캐시 폴더 권한 설정**
```bash
# 현재 사용자에게 npm 폴더 권한 부여
npm config set prefix "C:\Users\YourName\AppData\Roaming\npm"
```

**시도 3: 프로젝트별 설치 (추천)**
```bash
# 글로벌이 아닌 로컬 설치
npm install express --save

# package.json이 있는 프로젝트 폴더에서만 실행
```

### 💡 배운 점

- 가능하면 로컬 설치 (`--save`)
- 글로벌 설치 (`-g`)는 최소화
- 프로젝트 폴더는 사용자 폴더 안에 만들기

---

## 🎯 최종 체크리스트

개발 환경 설정이 제대로 되었는지 확인:

```bash
# Node.js 확인
node --version
npm --version

# Python 확인
python --version
pip --version

# Git 확인
git --version

# 테스트 프로젝트 생성
mkdir test-project
cd test-project
npm init -y
npm install express

# 간단한 서버 실행
echo "console.log('Hello World')" > index.js
node index.js
```

모두 에러 없이 실행되면 성공!

---

## 📚 초보자를 위한 팁

### ✅ DO (이렇게 하세요)

1. **공식 사이트에서 다운로드**
   - Node.js: [nodejs.org](https://nodejs.org)
   - Python: [python.org](https://python.org)
   - Git: [git-scm.com](https://git-scm.com)

2. **LTS 버전 설치**
   - Long Term Support = 안정적인 버전

3. **설치 후 바로 확인**
   ```bash
   node --version
   python --version
   git --version
   ```

4. **경로에 한글/공백 피하기**
   - ❌ `C:\내 문서\프로젝트`
   - ✅ `C:\Users\YourName\projects`

5. **환경 변수 설정 후 터미널 재시작**

### ❌ DON'T (이러지 마세요)

1. **여러 버전 동시 설치 (초보자는 피하기)**
   - nvm, pyenv 같은 버전 관리자는 나중에

2. **임의로 파일 이동**
   - 설치 후 폴더 옮기면 PATH 꼬임

3. **에러 무시하고 진행**
   - 작은 에러가 나중에 큰 문제로

4. **관리자 권한 남용**
   - 꼭 필요할 때만 사용

---

## 🔍 자주 하는 질문

**Q: PATH를 설정했는데도 안 돼요!**
A: 터미널을 완전히 종료하고 다시 열어보세요. 재부팅도 시도해보세요.

**Q: 여러 버전을 사용해야 하는데요?**
A: 어느 정도 익숙해진 후 nvm (Node), pyenv (Python) 사용을 추천합니다.

**Q: VS Code에서 터미널이 안 열려요!**
A: Settings → Terminal → Default Profile에서 터미널 종류를 선택하세요.

**Q: 이거 다 외워야 하나요?**
A: 아니요! 필요할 때 이 글을 다시 보세요. 저도 매번 구글링합니다. 😅

---

## 💭 마치며

개발 환경 설정, 정말 만만치 않죠?

저는 이 과정에서 3일을 날렸지만,
덕분에 PATH, 환경 변수, 터미널에 대해 확실히 이해하게 되었습니다.

**실패는 최고의 선생님**이라는 말이 맞나 봅니다.

여러분은 이 글을 보고 30분 안에 끝내시길 바랍니다! 🙏

---

**다음 글 예고:**
"코딩 첫 주에 알았으면 좋았을 것들 Top 5"

---

### 📌 이 글이 도움이 되셨나요?

같은 문제를 겪으셨다면 댓글로 공유해주세요!
여러분의 해결 방법도 궁금합니다.

**관련 글:**
- Error 404: 개발자를 찾을 수 없습니다 - 블로그 시작하며

---

#### 🏷️ 키워드
`#개발환경설정` `#PATH설정` `#Node.js설치` `#Python설치` `#Git설치` `#초보개발자` `#에러해결` `#Windows개발환경`
