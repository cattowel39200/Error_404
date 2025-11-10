# Error 404: 개발자를 찾을 수 없음

> 초보 개발자의 에러, 삽질, 그리고 성장 이야기를 기록하는 블로그

```
┌─────────────────────────┐
│  ERROR 404              │
│  ⚠️ 개발자를 찾을 수 없음 │
└─────────────────────────┘
```

**현재 상태:** `404 Not Found` → **목표:** `200 OK`

---

## 📖 소개

"Error 404: 개발자를 찾을 수 없음"은 초보 개발자의 성장 과정을 기록하는 Jekyll 기반 블로그입니다.

### 특징
- ✅ 초보자 눈높이의 쉬운 설명
- ✅ 실제 경험한 에러와 해결 과정
- ✅ HTTP 상태 코드 기반 카테고리
- ✅ 다크 테마 디자인
- ✅ SEO 최적화

---

## 🚀 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
```

### 2. 의존성 설치

Ruby가 설치되어 있어야 합니다. ([Ruby 설치 가이드](https://www.ruby-lang.org/ko/documentation/installation/))

```bash
# Bundler 설치
gem install bundler

# 의존성 설치
bundle install
```

### 3. 로컬에서 실행

```bash
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000` 접속

---

## 📝 새 글 작성하기

### 1. 파일 생성

`_posts` 폴더에 다음 형식으로 파일 생성:

```
_posts/YYYY-MM-DD-title.md
```

예: `_posts/2025-01-15-my-new-post.md`

### 2. Front Matter 작성

```yaml
---
layout: post
title: "글 제목"
description: "글 설명 (SEO용)"
date: 2025-01-15
category: "404 - Not Found"  # 또는 다른 카테고리
tags: [태그1, 태그2, 태그3]
status: "resolved"  # resolved, progress, error 중 하나
author: "Error404 Developer"
reading_time: "5분"
---
```

### 3. 본문 작성

Markdown 형식으로 작성:

```markdown
## 제목

본문 내용...

### 소제목

- 리스트 항목
- 리스트 항목

\`\`\`javascript
// 코드 블록
console.log("Hello World");
\`\`\`
```

### 4. 티스토리용 파일 생성 (선택사항)

`_posts_for_tistory` 폴더에 동일한 내용을 복사하고,
맨 아래에 원본 링크 추가:

```markdown
### 🔗 원문 보기
이 글의 원문은 [Error 404 블로그](https://yourusername.github.io/...)에서 확인하실 수 있습니다.
```

---

## 📂 프로젝트 구조

```
.
├── _config.yml           # 블로그 설정
├── _layouts/             # HTML 레이아웃 템플릿
│   ├── default.html
│   └── post.html
├── _posts/               # 블로그 글 (메인)
│   ├── 2025-01-10-blog-launch.md
│   └── ...
├── _posts_for_tistory/   # 티스토리용 복사본
├── assets/
│   ├── css/
│   │   └── style.css     # 스타일시트
│   └── images/           # 이미지 파일
├── index.md              # 메인 페이지
├── Gemfile               # Ruby 의존성
└── README.md             # 이 파일
```

---

## 🎨 카테고리

블로그는 HTTP 상태 코드를 카테고리로 사용합니다:

| 카테고리 | 설명 | 색상 |
|---------|------|------|
| **404 - Not Found** | 개발자를 찾을 수 없는 순간들 | 🔴 Red |
| **500 - Internal Server Error** | 내부 서버가 터진 순간들 | 🔴 Dark Red |
| **301 - Moved Permanently** | 방향을 바꾼 순간들 | 🔵 Blue |
| **200 - OK** | 성공한 순간들 | 🟢 Green |
| **100 - Continue** | 계속 배우는 중 | 🟡 Yellow |

---

## ⚙️ 설정 변경

### _config.yml 수정

```yaml
# 블로그 정보
title: "블로그 제목"
description: "블로그 설명"
url: "https://yourusername.github.io"

# 작성자 정보
author:
  name: "이름"
  email: "이메일"
  github: "GitHub아이디"

# Google Analytics (선택)
google_analytics: "G-XXXXXXXXXX"
```

### 스타일 변경

`assets/css/style.css` 파일에서 색상 변수 수정:

```css
:root {
    --error-red: #FF6B6B;
    --success-green: #4ECDC4;
    --dark-bg: #1A1A2E;
    /* ... */
}
```

---

## 🌐 GitHub Pages 배포

### 1. GitHub 저장소 설정

1. GitHub에서 새 저장소 생성
2. 저장소 이름:
   - `yourusername.github.io` (개인 사이트) 또는
   - 원하는 이름 (프로젝트 사이트)

### 2. 코드 푸시

```bash
git remote add origin https://github.com/yourusername/your-repo-name.git
git add .
git commit -m "Initial commit: Error 404 blog setup"
git branch -M main
git push -u origin main
```

### 3. GitHub Pages 활성화

1. GitHub 저장소 → Settings → Pages
2. Source: **GitHub Actions** 선택
3. 자동으로 배포됨 (`.github/workflows/jekyll.yml` 사용)

### 4. 사이트 확인

- 개인 사이트: `https://yourusername.github.io`
- 프로젝트 사이트: `https://yourusername.github.io/repo-name`

---

## 📊 SEO 최적화

이 블로그는 다음 SEO 기능을 포함합니다:

- ✅ `jekyll-seo-tag` 플러그인
- ✅ `sitemap.xml` 자동 생성
- ✅ RSS Feed (`feed.xml`)
- ✅ Open Graph 메타 태그
- ✅ 구조화된 데이터

### Google Search Console 등록

1. [Google Search Console](https://search.google.com/search-console) 접속
2. 사이트 추가
3. `sitemap.xml` 제출: `https://yourusername.github.io/sitemap.xml`

---

## 🔄 티스토리 연동 전략

### 발행 플로우

1. **GitHub Pages 우선 발행** (원본)
2. **24시간 후 티스토리 발행** (복사본)
3. **티스토리 글에 Canonical 태그 추가**

### Canonical 태그 추가 방법

티스토리 글 편집 모드에서 HTML 탭 선택 후 상단에 추가:

```html
<link rel="canonical" href="https://yourusername.github.io/2025/01/10/post-title/" />
```

이렇게 하면 구글이 원본을 GitHub Pages로 인식합니다.

---

## 🛠️ 문제 해결

### Jekyll 빌드 오류

```bash
# 캐시 삭제
bundle exec jekyll clean

# 의존성 재설치
bundle install

# 다시 빌드
bundle exec jekyll serve
```

### GitHub Actions 실패

1. GitHub 저장소 → Actions 탭 확인
2. 에러 로그 확인
3. 주로 `Gemfile.lock` 또는 플러그인 문제

### 로컬에서는 되는데 GitHub Pages에서 안 됨

- `_config.yml`의 `url`과 `baseurl` 확인
- `Gemfile`에 `github-pages` gem 추가:

```ruby
gem "github-pages", group: :jekyll_plugins
```

---

## 📚 참고 자료

- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [GitHub Pages 가이드](https://docs.github.com/en/pages)
- [Markdown 가이드](https://www.markdownguide.org/)
- [Jekyll SEO Tag](https://github.com/jekyll/jekyll-seo-tag)

---

## 🤝 기여

이 블로그 테마를 사용하고 싶으시다면 자유롭게 Fork 하세요!

개선 제안이나 버그 리포트는 Issues에 남겨주세요.

---

## 📄 라이선스

MIT License - 자유롭게 사용하세요!

---

## 💬 연락처

- 블로그: https://yourusername.github.io
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: dev@error404.blog

---

**현재 상태: 404** → **목표: 200 OK** 🚀

함께 404에서 200으로 가는 여정을 시작해봅시다!
