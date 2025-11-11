---
layout: post
title: "AutoCAD 블록 이름 변경 리습 - BRN"
description: "블록을 클릭하여 이름을 빠르게 변경하는 AutoCAD LISP 유틸리티"
category: MY LISP
tags: [AutoCAD, LISP, 블록관리, BRN]
date: 2025-01-15
---

## 목적

AutoCAD에서 블록 이름을 변경할 때 기본 RENAME 명령어는 블록 이름을 직접 입력해야 하는 불편함이 있습니다. BRN 리습은 블록을 직접 클릭하여 선택하고, 기존 이름을 수정하는 방식으로 작업 효율을 높입니다.

## 목차

- [개요](#개요)
- [다운로드](#다운로드)
- [사용 방법](#사용-방법)
- [활용 예시](#활용-예시)
- [주의사항](#주의사항)
- [관련 리습](#관련-리습)

## 개요

BRN(Block Rename) 리습의 주요 기능은 다음과 같습니다.

**주요 기능**
- 블록 클릭 방식으로 대상 선택
- 기존 블록 이름을 기본값으로 표시
- 중복 이름 자동 검사
- Enter 키로 작업 취소 가능
- 블록 재정의 방식으로 안전한 변경
- 기존 블록 정의 자동 정리(PURGE)

**기술적 특징**
- 도면 내 모든 해당 블록 인스턴스 자동 업데이트
- 회전 및 스케일 정보 유지
- 블록 속성 정보 보존

## 다운로드

**파일명:** AN_BRN_블록명변경.lsp

[다운로드 링크](https://raw.githubusercontent.com/cattowel39200/Error_404/main/AN_lisp/AN_BRN_%EB%B8%94%EB%A1%9D%EB%AA%85%EB%B3%80%EA%B2%BD.lsp)

**설치 방법**
1. 링크에서 우클릭하여 "다른 이름으로 저장"
2. 파일을 .lsp 확장자로 저장
3. AutoCAD에서 APPLOAD 명령 실행
4. 저장한 파일 선택 후 로드

## 사용 방법

### 기본 사용법

```
명령: BRN
이름을 변경할 블록을 선택하세요: [블록 클릭]
현재 블록 이름: CHAIR01
새 블록 이름 입력 <CHAIR01>: CHAIR_TYPE-A
블록 이름이 'CHAIR01'에서 'CHAIR_TYPE-A'으로 변경되었습니다.
```

### 옵션

- **Enter만 입력**: 변경 취소 (기존 이름 유지)
- **같은 이름 입력**: 변경하지 않음
- **중복 이름 입력**: 경고 메시지 표시 후 재입력

## 활용 예시

### 예시 1: 블록 이름 규칙 통일

```
변경 전: TB01, CH01, DK01
변경 후: TABLE-01, CHAIR-01, DESK-01
```

회사 도면 표준에 맞춰 블록 이름을 일괄 변경할 때 유용합니다.

### 예시 2: 블록 이름 오타 수정

```
잘못된 이름: CHIAR01
수정된 이름: CHAIR01
```

오타가 발견된 블록 이름을 빠르게 수정할 수 있습니다.

### 예시 3: 블록 이름 확인

```
명령: BRN
[블록 클릭]
현재 블록 이름: UNKNOWN-BLOCK-01
새 이름 <UNKNOWN-BLOCK-01>: [Enter]
```

블록 이름만 확인하고 변경하지 않을 수 있습니다.

## 주의사항

**블록 정의 변경**
- 블록 이름 변경 시 블록 정의가 수정됩니다.
- 다른 도면에서도 사용하는 블록의 경우 주의가 필요합니다.

**중복 이름**
- 이미 존재하는 블록 이름으로 변경할 수 없습니다.
- 중복 시 경고 메시지가 표시되며 재입력을 요구합니다.

**작업 취소**
- 실행 취소(U 명령)로 변경 전 상태로 복구할 수 있습니다.

**AutoCAD 버전**
- AutoCAD 2000 이상에서 사용 가능합니다.

## 관련 리습

- [TTC - 텍스트 교환](/my-lisp/2025/01/16/autocad-text-swap-lisp/)
- [LOOO - 레이어 단독 표시](/my-lisp/2025/01/17/autocad-layer-isolate-lisp/)
- [COOO - 숫자 추출 복사](/my-lisp/2025/01/18/autocad-extract-numbers-lisp/)
- [TTR - 텍스트 연속 교체](/my-lisp/2025/01/19/autocad-text-repeat-copy-lisp/)
- [JJJ - 폴리라인 합치기](/my-lisp/2025/01/20/autocad-polyline-join-z-coordinate/)
- [BLDEL - 해치 삭제](/my-lisp/2025/01/21/autocad-delete-all-hatches/)
- [BCENT - 블록 중심 기준점](/my-lisp/2025/01/22/autocad-block-center-basepoint/)
- [GGGG - 어린이보호구역 통계](/my-lisp/2025/01/23/autocad-auto-quantity-statistics/)
