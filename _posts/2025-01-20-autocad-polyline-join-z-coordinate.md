---
layout: post
title: "AutoCAD 폴리라인 합치기 Z좌표 보존 리습 - JJJ"
description: "선과 폴리라인을 합치면서 Z좌표를 보존하는 AutoCAD LISP 유틸리티"
category: MY LISP
tags: [AutoCAD, LISP, 폴리라인, 3D좌표, JJJ]
date: 2025-01-20
---

## 목적

AutoCAD 기본 PEDIT JOIN 명령은 선과 폴리라인을 합칠 때 Z좌표를 0으로 초기화합니다. 이는 종단도, 배관 설계, 지형 작업 등 3D 정보가 중요한 작업에서 치명적인 문제입니다. JJJ 리습은 선과 폴리라인을 합치면서 Z좌표를 완벽하게 보존합니다.

## 목차

- [개요](#개요)
- [다운로드](#다운로드)
- [사용 방법](#사용-방법)
- [활용 예시](#활용-예시)
- [주의사항](#주의사항)
- [관련 리습](#관련-리습)

## 개요

JJJ(Join with Z preservation) 리습의 주요 기능은 다음과 같습니다.

**주요 기능**
- 선과 폴리라인 합치기
- Z좌표 완벽 보존
- LINE, LWPOLYLINE, POLYLINE 지원
- 혼합 유형 처리 가능
- 자동 허용 거리 설정 (5mm)

**기술적 특징**
- Z좌표 저장 및 복원 알고리즘
- (X,Y) 기준 좌표 매핑
- Undo 그룹 적용
- Visual LISP 기반

**처리 과정**
1. 선택한 객체의 모든 점 Z좌표 저장
2. 임시로 Z좌표를 0으로 변경
3. PEDIT JOIN 실행
4. 저장된 Z좌표 복원

## 다운로드

**파일명:** AN_JJJ_폴리라인합치기.lsp

[다운로드 링크](https://raw.githubusercontent.com/cattowel39200/Error_404/main/AN_lisp/AN_JJJ_%ED%8F%B4%EB%A6%AC%EB%9D%BC%EC%9D%B8%ED%95%A9%EC%B9%98%EA%B8%B0.lsp)

**설치 방법**
1. 링크에서 우클릭하여 "다른 이름으로 저장"
2. 파일을 .lsp 확장자로 저장
3. AutoCAD에서 APPLOAD 명령 실행
4. 저장한 파일 선택 후 로드

## 사용 방법

### 기본 사용법

```
명령: JJJ
선택할 선 또는 폴리라인을 선택하십시오: [드래그로 선택]
선택된 객체를 하나의 폴리라인으로 결합하는 중...
Object Type: AcDbLine
Object Type: AcDbLine
...
선택된 선 및 폴리라인이 하나의 폴리라인으로 결합되었고 원본 Z좌표를 복원하였습니다.
```

### 허용 거리

- 기본 허용 거리: 0.005 (5mm)
- 선들이 완전히 연결되지 않아도 5mm 이내면 자동 연결

## 활용 예시

### 예시 1: 종단도 작성

```
상황: 도로 종단선을 하나의 폴리라인으로 합치기

선 데이터:
- 선1: (0, 0, 100.5)
- 선2: (10, 0, 101.2)
- 선3: (20, 0, 102.8)

PEDIT JOIN 사용: 모든 Z = 0 (높이 정보 손실)
JJJ 사용: Z좌표 완벽 유지
```

종단선의 높이 정보가 보존되어 정확한 종단도를 작성할 수 있습니다.

### 예시 2: 배관 라인

```
상황: 배관 경로를 하나의 폴리라인으로 합치기

배관 심도:
- 구간1: Z = -2.5m (2.5m 매설)
- 구간2: Z = -3.0m (3.0m 매설)
- 구간3: Z = -2.8m (2.8m 매설)

JJJ로 합치면 매설 깊이 정보가 유지됩니다.
```

배관 심도 정보가 손실되지 않습니다.

### 예시 3: 지형 컨투어

```
상황: 등고선을 하나의 폴리라인으로 합치기

표고 100m 등고선 여러 선으로 구성
JJJ 실행 → Z = 100 유지

표고 정보가 손실되지 않아 지형 데이터가 보존됩니다.
```

지형 데이터의 무결성이 유지됩니다.

## 주의사항

**중복 좌표**
- 같은 (X, Y) 위치에 다른 Z 값이 있으면 마지막 값으로 덮어씌워집니다.
- 가능한 중복 없이 작업하십시오.

**LWPOLYLINE 변환**
- LWPOLYLINE은 기본적으로 Z = 0입니다.
- JJJ가 자동으로 POLYLINE(2dPolyline)으로 변환하여 Z좌표를 보존합니다.

**처리 시간**
- 선 100개 이상일 경우 몇 초 소요될 수 있습니다.

**AutoCAD 버전**
- AutoCAD 2000 이상, Visual LISP 필요

**작업 취소**
- U(Undo) 명령으로 전체 작업을 취소할 수 있습니다.

## 관련 리습

- [BRN - 블록명 변경](/my-lisp/2025/01/15/autocad-block-rename-lisp/)
- [TTC - 텍스트 교환](/my-lisp/2025/01/16/autocad-text-swap-lisp/)
- [LOOO - 레이어 단독 표시](/my-lisp/2025/01/17/autocad-layer-isolate-lisp/)
- [COOO - 숫자 추출 복사](/my-lisp/2025/01/18/autocad-extract-numbers-lisp/)
- [TTR - 텍스트 연속 교체](/my-lisp/2025/01/19/autocad-text-repeat-copy-lisp/)
- [BLDEL - 해치 삭제](/my-lisp/2025/01/21/autocad-delete-all-hatches/)
- [BCENT - 블록 중심 기준점](/my-lisp/2025/01/22/autocad-block-center-basepoint/)
- [GGGG - 어린이보호구역 통계](/my-lisp/2025/01/23/autocad-auto-quantity-statistics/)
