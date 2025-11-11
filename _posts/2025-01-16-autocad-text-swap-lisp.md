---
layout: post
title: "AutoCAD 텍스트 교환 리습 - TTC"
description: "두 텍스트의 내용을 서로 교환하는 AutoCAD LISP 유틸리티"
category: MY LISP
tags: [AutoCAD, LISP, 텍스트편집, TTC]
date: 2025-01-16
---

## 목적

AutoCAD 작업 중 두 텍스트의 내용을 서로 교환해야 할 경우, 일반적으로 복사-붙여넣기를 반복해야 합니다. TTC 리습은 두 텍스트를 순차적으로 선택하여 내용을 즉시 교환함으로써 작업 시간을 단축합니다.

## 목차

- [개요](#개요)
- [다운로드](#다운로드)
- [사용 방법](#사용-방법)
- [활용 예시](#활용-예시)
- [주의사항](#주의사항)
- [관련 리습](#관련-리습)

## 개요

TTC(Text To Change) 리습의 주요 기능은 다음과 같습니다.

**주요 기능**
- 두 텍스트 선택으로 내용 즉시 교환
- TEXT 및 MTEXT 모두 지원
- 교차 유형 교환 가능 (TEXT ↔ MTEXT)
- 명령어 2개 제공 (TTC, TTS)

**기술적 특징**
- 텍스트 속성 유지 (위치, 크기, 레이어 등)
- 내용만 교환
- 빠른 실행 속도

## 다운로드

**파일명:** AN_TTC_글자교환.lsp

[다운로드 링크](https://raw.githubusercontent.com/cattowel39200/Error_404/main/AN_lisp/AN_TTC_%EA%B8%80%EC%9E%90%EA%B5%90%ED%99%98.lsp)

**설치 방법**
1. 링크에서 우클릭하여 "다른 이름으로 저장"
2. 파일을 .lsp 확장자로 저장
3. AutoCAD에서 APPLOAD 명령 실행
4. 저장한 파일 선택 후 로드

## 사용 방법

### 기본 사용법

```
명령: TTC (또는 TTS)
첫번째 텍스트 객체를 선택하세요: [텍스트1 클릭]
두번째 텍스트 객체를 선택하세요: [텍스트2 클릭]
두 텍스트 객체의 내용이 교환되었습니다.
```

### 지원 객체 유형

- TEXT (단일행 텍스트)
- MTEXT (여러행 텍스트)
- TEXT와 MTEXT 간 교차 교환 가능

## 활용 예시

### 예시 1: 테이블 데이터 순서 변경

```
변경 전:
| 구역 | 수량 |
| A구역 | 150 |
| B구역 | 200 |

변경 후:
| 구역 | 수량 |
| A구역 | 200 |
| B구역 | 150 |
```

테이블에서 잘못 입력된 수량을 빠르게 교환할 수 있습니다.

### 예시 2: 치수 주석 위치 교정

```
변경 전:
왼쪽 벽체: "3,500"
오른쪽 벽체: "4,200"

변경 후:
왼쪽 벽체: "4,200"
오른쪽 벽체: "3,500"
```

평면도에서 치수 주석이 잘못 배치된 경우 즉시 교정 가능합니다.

### 예시 3: 범례 항목 순서 변경

```
변경 전:
1. 콘크리트
2. 아스팔트

변경 후:
1. 아스팔트
2. 콘크리트
```

범례 순서를 변경할 때 유용합니다.

## 주의사항

**객체 선택**
- 텍스트가 아닌 객체를 선택하면 오류 메시지가 표시됩니다.
- 반드시 TEXT 또는 MTEXT 객체를 선택해야 합니다.

**인코딩**
- 한글이 깨지는 경우 LISP 파일을 UTF-8로 저장하십시오.

**AutoCAD 버전**
- AutoCAD 2000 이상에서 사용 가능합니다.

## 관련 리습

- [BRN - 블록명 변경](/my-lisp/2025/01/15/autocad-block-rename-lisp/)
- [LOOO - 레이어 단독 표시](/my-lisp/2025/01/17/autocad-layer-isolate-lisp/)
- [COOO - 숫자 추출 복사](/my-lisp/2025/01/18/autocad-extract-numbers-lisp/)
- [TTR - 텍스트 연속 교체](/my-lisp/2025/01/19/autocad-text-repeat-copy-lisp/)
- [JJJ - 폴리라인 합치기](/my-lisp/2025/01/20/autocad-polyline-join-z-coordinate/)
- [BLDEL - 해치 삭제](/my-lisp/2025/01/21/autocad-delete-all-hatches/)
- [BCENT - 블록 중심 기준점](/my-lisp/2025/01/22/autocad-block-center-basepoint/)
- [GGGG - 어린이보호구역 통계](/my-lisp/2025/01/23/autocad-auto-quantity-statistics/)
