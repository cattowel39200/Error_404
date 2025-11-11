;===========================================================
; 객체 자동 판별 통계 생성 프로그램 (통합)
; 파일명 : AN_gggg.lsp
; 인코딩 : UTF-8
; 명령어 : gggg
; 작성자 : (주)경성엔지니어링
; 기능 : 블록/선/폴리선/해치 자동 판별 후 통계 생성
;===========================================================

(defun c:gggg ( / ss has-blocks has-lines i en ent ent-type)
  (vl-load-com)
  
  ;-----------------------------
  ; 객체 선택
  ;-----------------------------
  (princ "\n통계를 작성할 객체들을 선택하세요: ")
  (setq ss (ssget))
  
  (if ss
    (progn
      (princ (strcat "\n" (itoa (sslength ss)) "개의 객체가 선택되었습니다."))
      
      ;-----------------------------
      ; 선택된 객체 타입 분석
      ;-----------------------------
      (setq has-blocks nil)
      (setq has-lines nil)
      (setq i 0)
      
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (setq ent (entget en))
        (setq ent-type (cdr (assoc 0 ent)))
        
        (cond
          ((= ent-type "INSERT")
           (setq has-blocks T))
          ((or (= ent-type "LINE") 
               (= ent-type "LWPOLYLINE") 
               (= ent-type "POLYLINE") 
               (= ent-type "HATCH"))
           (setq has-lines T))
        )
        (setq i (1+ i))
      )
      
      ;-----------------------------
      ; 자동 판별 및 실행
      ;-----------------------------
      (cond
        ; 블록만 있는 경우
        ((and has-blocks (not has-lines))
         (princ "\n→ 블록 객체가 감지되었습니다. 블록 통계를 생성합니다.")
         (run-block-stat ss))
        
        ; 선/폴리선/해치만 있는 경우
        ((and (not has-blocks) has-lines)
         (princ "\n→ 선/폴리선/해치 객체가 감지되었습니다. 수량 통계를 생성합니다.")
         (run-line-stat ss))
        
        ; 둘 다 있는 경우 - 통합 표 생성
        ((and has-blocks has-lines)
         (princ "\n→ 블록과 선/해치가 혼합되어 있습니다.")
         (princ "\n→ 통합 통계표를 생성합니다.")
         (run-combined-stat ss))
        
        ; 해당 없음
        (T
         (princ "\n[오류] 블록 또는 선/폴리선/해치가 아닙니다."))
      )
    )
    (princ "\n[취소] 객체가 선택되지 않았습니다.")
  )
  (princ)
)

;===========================================================
; 블록 통계 함수
;===========================================================
(defun run-block-stat (ss / i en blkname layname data item pt blktype 
                          x y row-height col-widths total-width total-height
                          row txt-height current-y all-blocks fixed-table
                          blk-dict sort-order prefix-list)
  
  ;-----------------------------
  ; 블록 분류 체계 사전 정의
  ;-----------------------------
  (setq blk-dict 
    '(("011" . "통합표지(시점)")
      ("011_2" . "통합표지(시점)_비규격")
      ("003" . "통합표지(종점)_해제")
      ("010" . "통합표지(종점)_속도")
      ("003_2" . "통합표지(종점)_해제_비규격")
      ("010_2" . "통합표지(종점)_속도_비규격")
     ("014_2" . "통합표지(종점)_해제_비규격")
      ("015" . "통합표지(세로형)")
      ("015_2" . "통합표지(세로형)_비규격")
      ("018_2" . "통합표지(세로형)종점_비규격")
      ("536" . "노면표시(536,536-2,536-3)")
      ("536_4" . "노면표시(536-4,536-5)")
      ("536_5" . "노면표시(536-4,536-5)")
      ("224" . "최고속도제한(224)")
      ("518" . "속도제한(518)")
      ("601" . "다기능단속장비")
      ("602" . "과속단속장비")
      ("990" . "과속방지턱")
      ("991" . "과속방지턱(이미지)")
      ("533" . "고원식횡단보도(533)")
      ("993" . "고원식교차로")
      ("994" . "미끄럼방지시설")
      ("226" . "서행표지(226)")
      ("519" . "서행표시(519_천천히)")
      ("520" . "서행표시(520_지그재그)")
      ("118" . "폭좁힘, 지그재그도로등")
      ("532" . "횡단보도(532)")
      ("532_2" . "대각선횡단보도(532-2)")
      ("995" . "보행신호기")
      ("322" . "횡단보도표지(322)")
      ("529" . "횡단보도예고(529)")
      ("227" . "일시정지표지(227)")
      ("521" . "일시정지표시(521)")
      ("996" . "보차도분리여부")
      ("997" . "보행친화포장")
      ("998" . "방호울타리")
      ("999" . "무단횡단방지중분대")
      ("218" . "정차주차금지표지(218)")
      ("219" . "주차금지(219)")
      ("515" . "주차금지(점선)(515)")
      ("516" . "주차및정차금지(단선)(516)")
      ("516_2" . "주차및정차금지(복선)(516-2)")
      ("981" . "노상주차장")
      ("982" . "어린이승하차시설")
      ("603" . "주정차단속장비")
      ("984" . "신호등기구")
      ("719" . "횡단보도집중조명")
      ("985" . "활주로형표지병")
      ("986" . "보행신호음성안내")
      ("987" . "바닥신호등")
      ("988" . "차량통행제한")
      ("989" . "일방통행제한")
      ("971" . "제한속도탄력적운영")
      ("604" . "방범CCTV")
      ("605" . "기타CCTV")
      ("972" . "경보등")
      ("324" . "보호표지(지시)")
      ("133" . "보호표지(주의)(133)")
      ("211" . "진입금지표지(211)")
      ("399_1" . "어린이보호도로표지판")
      ("703" . "도로반사경")
    )
  )
  
  (setq sort-order 
    '("통합표지(시점)"
      "통합표지(시점)_비규격"
      "통합표지(종점)_해제"
      "통합표지(종점)_속도"
      "통합표지(종점)_해제_비규격"
      "통합표지(종점)_속도_비규격"
      "통합표지(종점)_해제_비규격"
      "통합표지(세로형)"
      "통합표지(세로형)_비규격"
      "통합표지(세로형)종점_비규격"
      "노면표시(536,536-2,536-3)"
      "노면표시(536-4,536-5)"
      "최고속도제한(224)"
      "속도제한(518)"
      "다기능단속장비"
      "과속단속장비"
      "과속방지턱"
      "과속방지턱(이미지)"
      "고원식횡단보도(533)"
      "고원식교차로"
      "미끄럼방지시설"
      "서행표지(226)"
      "서행표시(519_천천히)"
      "서행표시(520_지그재그)"
      "폭좁힘, 지그재그도로등"
      "횡단보도(532)"
      "대각선횡단보도(532-2)"
      "보행신호기"
      "횡단보도표지(322)"
      "횡단보도예고(529)"
      "일시정지표지(227)"
      "일시정지표시(521)"
      "보차도분리여부"
      "보행친화포장"
      "방호울타리"
      "무단횡단방지중분대"
      "정차주차금지표지(218)"
      "주차금지(219)"
      "주차금지(점선)(515)"
      "주차및정차금지(단선)(516)"
      "주차및정차금지(복선)(516-2)"
      "노상주차장"
      "어린이승하차시설"
      "주정차단속장비"
      "신호등기구"
      "횡단보도집중조명"
      "활주로형표지병"
      "보행신호음성안내"
      "바닥신호등"
      "차량통행제한"
      "일방통행제한"
      "제한속도탄력적운영"
      "방범CCTV"
      "기타CCTV"
      "경보등"
      "보호표지(지시)"
      "보호표지(주의)(133)"
      "진입금지표지(211)"
      "어린이보호도로표지판"
      "도로반사경")
  )
  
  (setq prefix-list 
    '("011_2" "003_2" "010_2" "014_2" "015_2"  "018_2"
      "536_4" "536_5" "532_2" "516_2" "399_1"
      "011" "003" "010" "015"
      "536" "224" "518" "601" "602" "603"
      "990" "991" "533" "993" "994"
      "226" "519" "520" "118"
      "532" "995" "322" "529"
      "227" "521" "996" "997" "998" "999"
      "218" "219" "515" "516"
      "981" "982" "983" "984"
      "719" "985" "986" "987" "988" "989"
      "971" "604" "605" "972"
      "324" "133" "211"
      "703")
  )
  
  (defun get-sort-index (typename / idx)
    (setq idx (vl-position typename sort-order))
    (if idx idx 999)
  )
  
  (defun get-block-type (blkname / code result found blk-prefix test-prefix)
    (setq result "미분류")
    (setq found nil)
    (setq blk-prefix (strcase blkname))
    (foreach code prefix-list
      (if (not found)
        (progn
          (setq test-prefix (strcase code))
          (if (and 
                (>= (strlen blk-prefix) (strlen test-prefix))
                (= (substr blk-prefix 1 (strlen test-prefix)) test-prefix)
              )
            (progn
              (setq result (cdr (assoc code blk-dict)))
              (setq found T)
            )
          )
        )
      )
    )
    result
  )
  
  (defun get-block-color (blkname / upper-name)
    (setq upper-name (strcase blkname))
    (cond
      ((wcmatch upper-name "*신설*") 1)
      ((wcmatch upper-name "*철거*") 3)
      ((wcmatch upper-name "*현황*") 2)
      (T 7)
    )
  )
  
  (defun get-layer-color (layname / upper-name)
    (setq upper-name (strcase layname))
    (cond
      ((wcmatch upper-name "*개선*") 1)
      ((wcmatch upper-name "*제거*") 3)
      ((wcmatch upper-name "*현황*") 2)
      (T 7)
    )
  )
  
  ;-----------------------------
  ; 블록 데이터 수집
  ;-----------------------------
  (setq i 0 data (list))
  (repeat (sslength ss)
    (setq en (ssname ss i))
    (setq ent (entget en))
    (setq ent-type (cdr (assoc 0 ent)))
    
    (if (= ent-type "INSERT")
      (progn
        (setq layname (cdr (assoc 8 ent)))
        (setq blkname (cdr (assoc 2 ent)))
        
        (if (and blkname (not (wcmatch blkname "*|*,`**")))
          (progn
            (setq blktype (get-block-type blkname))
            
            (if (not (assoc layname data))
              (setq data (append data (list (cons layname (list (list blkname blktype 1))))))
              (progn
                (setq item (assoc layname data))
                (setq blk-found nil)
                (foreach blk-item (cdr item)
                  (if (= (car blk-item) blkname)
                    (setq blk-found blk-item)
                  )
                )
                (if blk-found
                  (setq data
                    (subst
                      (cons layname
                        (subst (list blkname blktype (1+ (caddr blk-found)))
                               blk-found
                               (cdr item)))
                      item
                      data))
                  (setq data
                    (subst
                      (cons layname (append (cdr item) (list (list blkname blktype 1))))
                      item
                      data))
                )
              )
            )
          )
        )
      )
    )
    (setq i (1+ i))
  )
  
  ;-----------------------------
  ; 고정 테이블 생성
  ;-----------------------------
  (setq all-blocks (list))
  (foreach layer data
    (setq layname (car layer))
    (foreach blk (cdr layer)
      (setq all-blocks (append all-blocks 
                               (list (list layname (nth 0 blk) (nth 1 blk) (nth 2 blk)))))
    )
  )
  
  (setq fixed-table (list))
  (foreach typename sort-order
    (setq matching-blocks (list))
    (foreach blk all-blocks
      (if (= (caddr blk) typename)
        (setq matching-blocks (append matching-blocks (list blk)))
      )
    )
    
    (if matching-blocks
      (foreach blk matching-blocks
        (setq fixed-table (append fixed-table (list blk)))
      )
      (setq fixed-table (append fixed-table 
                                (list (list "" "" typename 0))))
    )
  )
  
  (setq unclassified (list))
  (foreach blk all-blocks
    (if (= (caddr blk) "미분류")
      (setq unclassified (append unclassified (list blk)))
    )
  )
  (if unclassified
    (setq fixed-table (append fixed-table unclassified))
    (setq fixed-table (append fixed-table 
                              (list (list "" "" "미분류" 0))))
  )
  
  (setq all-blocks fixed-table)
  
  ;-----------------------------
  ; 표 생성
  ;-----------------------------
  (setq pt (getpoint "\n표를 삽입할 위치를 지정하세요: "))
  (if pt
    (progn
      (setq x (car pt))
      (setq y (cadr pt))
      (setq txt-height 2.5)
      (setq row-height (* txt-height 2.5))
      (setq col-widths '(60 80 120 30))
      (setq total-width (apply '+ col-widths))
      (setq total-rows (+ 1 (length all-blocks)))
      (setq total-height (* row-height total-rows))
      
      ; 외곽선
      (draw-line (list x y 0) (list (+ x total-width) y 0))
      (draw-line (list x (- y total-height) 0) 
                (list (+ x total-width) (- y total-height) 0))
      (draw-line (list x y 0) (list x (- y total-height) 0))
      (draw-line (list (+ x total-width) y 0) 
                (list (+ x total-width) (- y total-height) 0))
      
      ; 세로선
      (setq current-x (+ x (nth 0 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 1 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 2 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      
      ; 헤더선
      (setq current-y (- y row-height))
      (draw-line (list x current-y 0) (list (+ x total-width) current-y 0))
      
      ; 헤더 텍스트
      (setq header-y (- y (* row-height 0.5)))
      (draw-text (list (+ x (* (nth 0 col-widths) 0.5)) header-y 0) 
                "레이어 이름" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (* (nth 1 col-widths) 0.5)) header-y 0) 
                "블록 이름" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (* (nth 2 col-widths) 0.5)) header-y 0) 
                "블록 종류" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (* (nth 3 col-widths) 0.5)) header-y 0) 
                "개수" txt-height "CENTER" 7)
      
      ; 데이터
      (setq row 1)
      (foreach blk-data all-blocks
        (setq current-y (- y (* row-height (+ row 0.5))))
        (draw-line (list x (- y (* row-height (+ row 1))) 0) 
                  (list (+ x total-width) (- y (* row-height (+ row 1))) 0))
        
        (setq layer-color (get-layer-color (nth 0 blk-data)))
        (setq block-color (get-block-color (nth 1 blk-data)))
        
        (if (> (nth 3 blk-data) 0)
          (draw-text (list (+ x 2) current-y 0) 
                    (nth 0 blk-data) txt-height "LEFT" layer-color)
        )
        
        (if (> (nth 3 blk-data) 0)
          (draw-text (list (+ x (nth 0 col-widths) 2) current-y 0) 
                    (nth 1 blk-data) txt-height "LEFT" block-color)
        )
        
        (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) 2) current-y 0) 
                  (nth 2 blk-data) txt-height "LEFT" block-color)
        
        (if (> (nth 3 blk-data) 0)
          (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) 
                              (* (nth 3 col-widths) 0.5)) current-y 0) 
                    (itoa (nth 3 blk-data)) txt-height "CENTER" block-color)
        )
        
        (setq row (1+ row))
      )
      
      (command "_.REGEN")
      (princ "\n[완료] 블록 통계표가 생성되었습니다.")
    )
    (princ "\n[취소] 표 삽입이 취소되었습니다.")
  )
)

;===========================================================
; 선/폴리선/해치 통계 함수
;===========================================================
(defun run-line-stat (ss / i en ent layname data item pt
                          x y row-height col-widths total-width total-height
                          row txt-height current-y layer-items
                          quantity unit condition typename layer-keyword
                          all-data fixed-table ent-type qty skip-entity
                          matched-layers total-qty matched final-qty)
  
  (setq layer-items 
    '(("보차도분리여부" "m" "A0033324" "폴리선길이/2")
      ("방호울타리" "m" "방호울타리" "선길이")
      ("무단횡단방지중분대" "m" "무단횡단" "선길이")
      ("주차금지(점선)(515)" "m" "점선" "선길이")
      ("주차및정차금지(단선)(516)" "m" "단선" "선길이")
      ("주차및정차금지(복선)(516-2)" "m" "복선" "선길이/2")
      ("보행신호음성안내" "면" "신호기" "문자음개수")
      ("바닥신호등" "면" "신호기" "문자바개수"))
  )
  
  (defun get-layer-color (layname / upper-name)
    (setq upper-name (strcase layname))
    (cond
      ((wcmatch upper-name "*개선*") 1)
      ((wcmatch upper-name "*제거*") 3)
      ((wcmatch upper-name "*현황*") 2)
      (T 7)
    )
  )
  
  (defun get-line-length (ent / ent-data ent-type length)
    (setq ent-data (entget ent))
    (setq ent-type (cdr (assoc 0 ent-data)))
    (setq length 0.0)
    (cond
      ((= ent-type "LINE")
       (setq length (distance (cdr (assoc 10 ent-data)) 
                              (cdr (assoc 11 ent-data)))))
      ((or (= ent-type "LWPOLYLINE") (= ent-type "POLYLINE"))
       (setq length (vlax-curve-getDistAtParam 
                      (vlax-ename->vla-object ent)
                      (vlax-curve-getEndParam (vlax-ename->vla-object ent)))))
    )
    length
  )
  
  (defun get-hatch-area (ent / ent-data ent-type obj)
    (setq ent-data (entget ent))
    (setq ent-type (cdr (assoc 0 ent-data)))
    (if (= ent-type "HATCH")
      (progn
        (setq obj (vlax-ename->vla-object ent))
        (vlax-get-property obj 'Area))
      0.0)
  )
  
  ;-----------------------------
  ; 레이어별 수량 집계
  ;-----------------------------
  (setq data (list))
  (setq i 0)
  (repeat (sslength ss)
    (setq en (ssname ss i))
    (setq ent (entget en))
    (setq layname (cdr (assoc 8 ent)))
    (setq ent-type (cdr (assoc 0 ent)))
    
    ; 보차도분리여부(A0033324)는 해치 제외
    (setq skip-entity nil)
    (if (and (= ent-type "HATCH")
             (wcmatch (strcase layname) "*A0033324*"))
      (setq skip-entity T)
    )
    
    (if (not skip-entity)
      (progn
        (if (not (assoc layname data))
          (setq data (append data (list (cons layname 0.0))))
        )
        
        (cond
          ((= ent-type "HATCH")
           (setq qty (get-hatch-area en)))
          ((or (= ent-type "LINE") (= ent-type "LWPOLYLINE") (= ent-type "POLYLINE"))
           (setq qty (get-line-length en)))
          (T (setq qty 0.0))
        )
        
        (setq item (assoc layname data))
        (setq data (subst (cons layname (+ (cdr item) qty)) item data))
      )
    )
    
    (setq i (1+ i))
  )
  
  ;-----------------------------
  ; 고정 테이블 생성
  ;-----------------------------
  (setq fixed-table (list))
  (foreach layer-item layer-items
    (setq typename (nth 0 layer-item))
    (setq unit (nth 1 layer-item))
    (setq layer-keyword (nth 2 layer-item))
    (setq condition (nth 3 layer-item))
    
    (setq matched-layers (list))
    (setq total-qty 0.0)
    
    (foreach layer-data data
      (setq layname (car layer-data))
      (setq qty (cdr layer-data))
      
      (if (= layer-keyword "")
        (setq match-key (strcase typename))
        (setq match-key (strcase layer-keyword))
      )
      
      (if (wcmatch (strcase layname) (strcat "*" match-key "*"))
        (progn
          (setq matched-layers (append matched-layers (list (cons layname qty))))
          (setq total-qty (+ total-qty qty))
        )
      )
    )
    
    (cond
      ((wcmatch condition "*/*2*")
       (setq total-qty (/ total-qty 2.0)))
    )
    
    (if matched-layers
      (foreach matched matched-layers
        (setq final-qty (cdr matched))
        (if (wcmatch condition "*/*2*")
          (setq final-qty (/ final-qty 2.0))
        )
        (setq fixed-table (append fixed-table 
                                  (list (list (car matched) typename unit final-qty))))
      )
      (setq fixed-table (append fixed-table 
                                (list (list "" typename unit 0.0))))
    )
  )
  
  ;-----------------------------
  ; 표 생성
  ;-----------------------------
  (setq pt (getpoint "\n표를 삽입할 위치를 지정하세요: "))
  (if pt
    (progn
      (setq x (car pt))
      (setq y (cadr pt))
      (setq txt-height 2.5)
      (setq row-height (* txt-height 2.5))
      (setq col-widths '(60 120 30 40))
      (setq total-width (apply '+ col-widths))
      (setq total-rows (+ 1 (length fixed-table)))
      (setq total-height (* row-height total-rows))
      
      ; 외곽선
      (draw-line (list x y 0) (list (+ x total-width) y 0))
      (draw-line (list x (- y total-height) 0) 
                (list (+ x total-width) (- y total-height) 0))
      (draw-line (list x y 0) (list x (- y total-height) 0))
      (draw-line (list (+ x total-width) y 0) 
                (list (+ x total-width) (- y total-height) 0))
      
      ; 세로선
      (setq current-x (+ x (nth 0 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 1 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 2 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      
      ; 헤더선
      (setq current-y (- y row-height))
      (draw-line (list x current-y 0) (list (+ x total-width) current-y 0))
      
      ; 헤더 텍스트
      (setq header-y (- y (* row-height 0.5)))
      (draw-text (list (+ x (* (nth 0 col-widths) 0.5)) header-y 0) 
                "레이어 이름" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (* (nth 1 col-widths) 0.5)) header-y 0) 
                "시설 종류" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (* (nth 2 col-widths) 0.5)) header-y 0) 
                "단위" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (* (nth 3 col-widths) 0.5)) header-y 0) 
                "수량" txt-height "CENTER" 7)
      
      ; 데이터
      (setq row 1)
      (foreach row-data fixed-table
        (setq current-y (- y (* row-height (+ row 0.5))))
        (draw-line (list x (- y (* row-height (+ row 1))) 0) 
                  (list (+ x total-width) (- y (* row-height (+ row 1))) 0))
        
        (setq layname (nth 0 row-data))
        (setq typename (nth 1 row-data))
        (setq unit (nth 2 row-data))
        (setq qty (nth 3 row-data))
        
        (setq layer-color (get-layer-color layname))
        
        (if (> qty 0.0)
          (draw-text (list (+ x 2) current-y 0) 
                    layname txt-height "LEFT" layer-color)
        )
        
        (draw-text (list (+ x (nth 0 col-widths) 2) current-y 0) 
                  typename txt-height "LEFT" layer-color)
        
        (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (* (nth 2 col-widths) 0.5)) current-y 0) 
                  unit txt-height "CENTER" layer-color)
        
        (if (> qty 0.0)
          (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (* (nth 3 col-widths) 0.5)) current-y 0) 
                    (rtos qty 2 2) txt-height "CENTER" layer-color)
        )
        
        (setq row (1+ row))
      )
      
      (command "_.REGEN")
      (princ "\n[완료] 선/해치 통계표가 생성되었습니다.")
    )
    (princ "\n[취소] 표 삽입이 취소되었습니다.")
  )
)

;===========================================================
; 공통 함수
;===========================================================
(defun draw-line (p1 p2)
  (entmake (list '(0 . "LINE")
                 (cons 10 p1)
                 (cons 11 p2)
                 '(8 . "0")))
)

(defun draw-text (pt txt height align color / text-ent style-name)
  (if (tblsearch "STYLE" "돋움체")
    (setq style-name "돋움체")
    (setq style-name "Standard")
  )
  
  (setq text-ent (list '(0 . "TEXT")
                       (cons 10 pt)
                       (cons 40 height)
                       (cons 1 txt)
                       (cons 7 style-name)
                       '(8 . "0")
                       (cons 62 color)))
  (if (= align "CENTER")
    (setq text-ent (append text-ent 
                          (list '(72 . 1) '(73 . 2) (cons 11 pt))))
  )
  (if (= align "LEFT")
    (setq text-ent (append text-ent 
                          (list '(72 . 0) '(73 . 2) (cons 11 pt))))
  )
  (entmake text-ent)
)

;===========================================================
; 통합 통계 함수 (블록 + 선/해치)
;===========================================================
(defun run-combined-stat (ss / block-data line-data combined-table
                              pt x y txt-height row-height col-widths
                              total-width total-rows total-height
                              current-x current-y header-y row
                              row-data layname typename unit qty
                              layer-color block-color)
  
  ; 블록 데이터 수집 (run-block-stat 로직 사용)
  (princ "\n블록 데이터 수집 중...")
  (setq block-data (collect-block-data ss))
  
  ; 선/해치 데이터 수집 (run-line-stat 로직 사용)
  (princ "\n선/해치 데이터 수집 중...")
  (setq line-data (collect-line-data ss))
  
  ; 통합 테이블 생성
  (setq combined-table (list))
  
  ; 블록 데이터 추가 (레이어, 이름, 종류, 개, 수량)
  (foreach blk block-data
    (setq combined-table 
      (append combined-table 
              (list (list (nth 0 blk)    ; 레이어
                         (nth 1 blk)    ; 블록명
                         (nth 2 blk)    ; 종류
                         "개"            ; 단위
                         (nth 3 blk)    ; 개수
                         "BLOCK"))))    ; 타입
  )
  
  ; 선/해치 데이터 추가 (레이어, "", 종류, 단위, 수량)
  (foreach line line-data
    (setq combined-table 
      (append combined-table 
              (list (list (nth 0 line)   ; 레이어
                         ""              ; 블록명 없음
                         (nth 1 line)    ; 종류
                         (nth 2 line)    ; 단위
                         (nth 3 line)    ; 수량
                         "LINE"))))      ; 타입
  )
  
  ;-----------------------------
  ; 표 생성
  ;-----------------------------
  (setq pt (getpoint "\n\n통합 표를 삽입할 위치를 지정하세요: "))
  (if pt
    (progn
      (setq x (car pt))
      (setq y (cadr pt))
      (setq txt-height 2.5)
      (setq row-height (* txt-height 2.5))
      (setq col-widths '(60 80 120 30 40))  ; 레이어, 블록명, 종류, 단위, 수량
      (setq total-width (apply '+ col-widths))
      (setq total-rows (+ 1 (length combined-table)))
      (setq total-height (* row-height total-rows))
      
      ; 외곽선
      (draw-line (list x y 0) (list (+ x total-width) y 0))
      (draw-line (list x (- y total-height) 0) 
                (list (+ x total-width) (- y total-height) 0))
      (draw-line (list x y 0) (list x (- y total-height) 0))
      (draw-line (list (+ x total-width) y 0) 
                (list (+ x total-width) (- y total-height) 0))
      
      ; 세로선
      (setq current-x (+ x (nth 0 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 1 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 2 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      (setq current-x (+ current-x (nth 3 col-widths)))
      (draw-line (list current-x y 0) (list current-x (- y total-height) 0))
      
      ; 헤더선
      (setq current-y (- y row-height))
      (draw-line (list x current-y 0) (list (+ x total-width) current-y 0))
      
      ; 헤더 텍스트
      (setq header-y (- y (* row-height 0.5)))
      (draw-text (list (+ x (* (nth 0 col-widths) 0.5)) header-y 0) 
                "레이어 이름" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (* (nth 1 col-widths) 0.5)) header-y 0) 
                "블록 이름" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (* (nth 2 col-widths) 0.5)) header-y 0) 
                "종류" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (* (nth 3 col-widths) 0.5)) header-y 0) 
                "단위" txt-height "CENTER" 7)
      (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (nth 3 col-widths) (* (nth 4 col-widths) 0.5)) header-y 0) 
                "수량" txt-height "CENTER" 7)
      
      ; 데이터
      (setq row 1)
      (foreach row-data combined-table
        (setq current-y (- y (* row-height (+ row 0.5))))
        (draw-line (list x (- y (* row-height (+ row 1))) 0) 
                  (list (+ x total-width) (- y (* row-height (+ row 1))) 0))
        
        (setq layname (nth 0 row-data))
        (setq blkname (nth 1 row-data))
        (setq typename (nth 2 row-data))
        (setq unit (nth 3 row-data))
        (setq qty (nth 4 row-data))
        (setq obj-type (nth 5 row-data))
        
        ; 색상 결정
        (setq layer-color (get-layer-color-local layname))
        (if (= obj-type "BLOCK")
          (setq block-color (get-block-color-local blkname))
          (setq block-color layer-color)
        )
        
        ; 레이어 이름 (수량 > 0일 때)
        (if (> qty 0)
          (draw-text (list (+ x 2) current-y 0) 
                    layname txt-height "LEFT" layer-color)
        )
        
        ; 블록 이름 (블록인 경우만, 수량 > 0일 때)
        (if (and (= obj-type "BLOCK") (> qty 0))
          (draw-text (list (+ x (nth 0 col-widths) 2) current-y 0) 
                    blkname txt-height "LEFT" block-color)
        )
        
        ; 종류 (항상 표시)
        (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) 2) current-y 0) 
                  typename txt-height "LEFT" block-color)
        
        ; 단위 (항상 표시)
        (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (* (nth 3 col-widths) 0.5)) current-y 0) 
                  unit txt-height "CENTER" block-color)
        
        ; 수량 (0보다 클 때만)
        (if (> qty 0)
          (progn
            (if (= obj-type "BLOCK")
              (setq qty-str (itoa qty))
              (setq qty-str (rtos qty 2 2))
            )
            (draw-text (list (+ x (nth 0 col-widths) (nth 1 col-widths) (nth 2 col-widths) (nth 3 col-widths) (* (nth 4 col-widths) 0.5)) current-y 0) 
                      qty-str txt-height "CENTER" block-color)
          )
        )
        
        (setq row (1+ row))
      )
      
      (command "_.REGEN")
      (princ "\n[완료] 통합 통계표가 생성되었습니다.")
      (princ (strcat "\n총 " (itoa (- total-rows 1)) "개 항목이 집계되었습니다."))
    )
    (princ "\n[취소] 표 삽입이 취소되었습니다.")
  )
)

;===========================================================
; 블록 데이터 수집 함수
;===========================================================
(defun collect-block-data (ss / i en ent ent-type layname blkname blktype
                                data item blk-dict sort-order prefix-list
                                all-blocks fixed-table typename matching-blocks
                                unclassified)
  
  (setq blk-dict 
    '(("011" . "통합표지(시점)")
      ("011_2" . "통합표지(시점)_비규격")
      ("003" . "통합표지(종점)_해제")
      ("010" . "통합표지(종점)_속도")
      ("003_2" . "통합표지(종점)_해제_비규격")
      ("010_2" . "통합표지(종점)_속도_비규격")
      ("014_2" . "통합표지(종점)_해제_비규격")
      ("015" . "통합표지(세로형)")
      ("015_2" . "통합표지(세로형)_비규격")
      ("018_2" . "통합표지(세로형)종점_비규격")
      ("536" . "노면표시(536,536-2,536-3)")
      ("536_4" . "노면표시(536-4,536-5)")
      ("536_5" . "노면표시(536-4,536-5)")
      ("224" . "최고속도제한(224)")
      ("518" . "속도제한(518)")
      ("601" . "다기능단속장비")
      ("602" . "과속단속장비")
      ("990" . "과속방지턱")
      ("991" . "과속방지턱(이미지)")
      ("533" . "고원식횡단보도(533)")
      ("993" . "고원식교차로")
      ("994" . "미끄럼방지시설")
      ("226" . "서행표지(226)")
      ("519" . "서행표시(519_천천히)")
      ("520" . "서행표시(520_지그재그)")
      ("118" . "폭좁힘, 지그재그도로등")
      ("532" . "횡단보도(532)")
      ("532_2" . "대각선횡단보도(532-2)")
      ("995" . "보행신호기")
      ("322" . "횡단보도표지(322)")
      ("529" . "횡단보도예고(529)")
      ("227" . "일시정지표지(227)")
      ("521" . "일시정지표시(521)")
      ("996" . "보차도분리여부")
      ("997" . "보행친화포장")
      ("998" . "방호울타리")
      ("999" . "무단횡단방지중분대")
      ("218" . "정차주차금지표지(218)")
      ("219" . "주차금지(219)")
      ("515" . "주차금지(점선)(515)")
      ("516" . "주차및정차금지(단선)(516)")
      ("516_2" . "주차및정차금지(복선)(516-2)")
      ("981" . "노상주차장")
      ("982" . "어린이승하차시설")
      ("603" . "주정차단속장비")
      ("984" . "신호등기구")
      ("719" . "횡단보도집중조명")
      ("985" . "활주로형표지병")
      ("986" . "보행신호음성안내")
      ("987" . "바닥신호등")
      ("988" . "차량통행제한")
      ("989" . "일방통행제한")
      ("971" . "제한속도탄력적운영")
      ("604" . "방범CCTV")
      ("605" . "기타CCTV")
      ("972" . "경보등")
      ("324" . "보호표지(지시)")
      ("133" . "보호표지(주의)(133)")
      ("211" . "진입금지표지(211)")
      ("399_1" . "어린이보호도로표지판")
      ("703" . "도로반사경")
    )
  )
  
  (setq sort-order 
    '("통합표지(시점)" "통합표지(시점)_비규격" "통합표지(종점)_해제"
      "통합표지(종점)_속도" "통합표지(종점)_해제_비규격" "통합표지(종점)_속도_비규격"
      "통합표지(종점)_해제_비규격"
      "통합표지(세로형)" "통합표지(세로형)_비규격" "통합표지(세로형)종점_비규격" 
       "노면표시(536,536-2,536-3)"
      "노면표시(536-4,536-5)" "최고속도제한(224)" "속도제한(518)" "다기능단속장비"
      "과속단속장비" "과속방지턱" "과속방지턱(이미지)" "고원식횡단보도(533)"
      "고원식교차로" "미끄럼방지시설" "서행표지(226)" "서행표시(519_천천히)"
      "서행표시(520_지그재그)" "폭좁힘, 지그재그도로등" "횡단보도(532)"
      "대각선횡단보도(532-2)" "보행신호기" "횡단보도표지(322)" "횡단보도예고(529)"
      "일시정지표지(227)" "일시정지표시(521)" "보차도분리여부" "보행친화포장"
      "방호울타리" "무단횡단방지중분대" "정차주차금지표지(218)" "주차금지(219)"
      "주차금지(점선)(515)" "주차및정차금지(단선)(516)" "주차및정차금지(복선)(516-2)"
      "노상주차장" "어린이승하차시설" "주정차단속장비" "신호등기구"
      "횡단보도집중조명" "활주로형표지병" "보행신호음성안내" "바닥신호등"
      "차량통행제한" "일방통행제한" "제한속도탄력적운영" "방범CCTV" "기타CCTV"
      "경보등" "보호표지(지시)" "보호표지(주의)(133)" "진입금지표지(211)"
      "어린이보호도로표지판" "도로반사경")
  )
  
  (setq prefix-list 
    '("011_2" "003_2" "010_2" "014_2" "015_2" "018_2" "536_4" "536_5" "532_2" "516_2" "399_1"
      "011" "003" "010" "015" "536" "224" "518" "601" "602" "603"
      "990" "991" "533" "993" "994" "226" "519" "520" "118" "532" "995" "322" "529"
      "227" "521" "996" "997" "998" "999" "218" "219" "515" "516"
      "981" "982" "983" "984" "719" "985" "986" "987" "988" "989"
      "971" "604" "605" "972" "324" "133" "211" "703")
  )
  
  (defun get-block-type-local (blkname / code result found blk-prefix test-prefix)
    (setq result "미분류")
    (setq found nil)
    (setq blk-prefix (strcase blkname))
    (foreach code prefix-list
      (if (not found)
        (progn
          (setq test-prefix (strcase code))
          (if (and 
                (>= (strlen blk-prefix) (strlen test-prefix))
                (= (substr blk-prefix 1 (strlen test-prefix)) test-prefix))
            (progn
              (setq result (cdr (assoc code blk-dict)))
              (setq found T)))
        )
      )
    )
    result
  )
  
  (defun get-sort-index-local (typename / idx)
    (setq idx (vl-position typename sort-order))
    (if idx idx 999)
  )
  
  ; 블록 데이터 수집
  (setq i 0 data (list))
  (repeat (sslength ss)
    (setq en (ssname ss i))
    (setq ent (entget en))
    (setq ent-type (cdr (assoc 0 ent)))
    
    (if (= ent-type "INSERT")
      (progn
        (setq layname (cdr (assoc 8 ent)))
        (setq blkname (cdr (assoc 2 ent)))
        
        (if (and blkname (not (wcmatch blkname "*|*,`**")))
          (progn
            (setq blktype (get-block-type-local blkname))
            
            (if (not (assoc layname data))
              (setq data (append data (list (cons layname (list (list blkname blktype 1))))))
              (progn
                (setq item (assoc layname data))
                (setq blk-found nil)
                (foreach blk-item (cdr item)
                  (if (= (car blk-item) blkname)
                    (setq blk-found blk-item)))
                (if blk-found
                  (setq data
                    (subst
                      (cons layname
                        (subst (list blkname blktype (1+ (caddr blk-found)))
                               blk-found (cdr item)))
                      item data))
                  (setq data
                    (subst
                      (cons layname (append (cdr item) (list (list blkname blktype 1))))
                      item data)))
              )
            )
          )
        )
      )
    )
    (setq i (1+ i))
  )
  
  ; 고정 테이블 생성
  (setq all-blocks (list))
  (foreach layer data
    (setq layname (car layer))
    (foreach blk (cdr layer)
      (setq all-blocks (append all-blocks 
                               (list (list layname (nth 0 blk) (nth 1 blk) (nth 2 blk))))))
  )
  
  (setq fixed-table (list))
  (foreach typename sort-order
    (setq matching-blocks (list))
    (foreach blk all-blocks
      (if (= (caddr blk) typename)
        (setq matching-blocks (append matching-blocks (list blk)))))
    
    (if matching-blocks
      (foreach blk matching-blocks
        (setq fixed-table (append fixed-table (list blk))))
      (setq fixed-table (append fixed-table (list (list "" "" typename 0)))))
  )
  
  (setq unclassified (list))
  (foreach blk all-blocks
    (if (= (caddr blk) "미분류")
      (setq unclassified (append unclassified (list blk)))))
  (if unclassified
    (setq fixed-table (append fixed-table unclassified))
    (setq fixed-table (append fixed-table (list (list "" "" "미분류" 0)))))
  
  fixed-table
)

;===========================================================
; 선/해치 데이터 수집 함수
;===========================================================
(defun collect-line-data (ss / i en ent layname data item ent-type qty
                              skip-entity layer-items typename unit layer-keyword
                              condition matched-layers total-qty matched final-qty
                              fixed-table)
  
  (setq layer-items 
    '(("보차도분리여부" "m" "A0033324" "폴리선길이/2")
      ("방호울타리" "m" "방호울타리" "선길이")
      ("무단횡단방지중분대" "m" "무단횡단" "선길이")
      ("주차금지(점선)(515)" "m" "점선" "선길이")
      ("주차및정차금지(단선)(516)" "m" "단선" "선길이")
      ("주차및정차금지(복선)(516-2)" "m" "복선" "선길이/2")
      ("보행신호음성안내" "면" "신호기" "문자음개수")
      ("바닥신호등" "면" "신호기" "문자바개수"))
  )
  
  (defun get-line-length-local (ent / ent-data ent-type length)
    (setq ent-data (entget ent))
    (setq ent-type (cdr (assoc 0 ent-data)))
    (setq length 0.0)
    (cond
      ((= ent-type "LINE")
       (setq length (distance (cdr (assoc 10 ent-data)) 
                              (cdr (assoc 11 ent-data)))))
      ((or (= ent-type "LWPOLYLINE") (= ent-type "POLYLINE"))
       (setq length (vlax-curve-getDistAtParam 
                      (vlax-ename->vla-object ent)
                      (vlax-curve-getEndParam (vlax-ename->vla-object ent))))))
    length
  )
  
  (defun get-hatch-area-local (ent / ent-data ent-type obj)
    (setq ent-data (entget ent))
    (setq ent-type (cdr (assoc 0 ent-data)))
    (if (= ent-type "HATCH")
      (progn
        (setq obj (vlax-ename->vla-object ent))
        (vlax-get-property obj 'Area))
      0.0)
  )
  
  ; 레이어별 수량 집계
  (setq data (list))
  (setq i 0)
  (repeat (sslength ss)
    (setq en (ssname ss i))
    (setq ent (entget en))
    (setq layname (cdr (assoc 8 ent)))
    (setq ent-type (cdr (assoc 0 ent)))
    
    (setq skip-entity nil)
    (if (and (= ent-type "HATCH")
             (wcmatch (strcase layname) "*A0033324*"))
      (setq skip-entity T))
    
    (if (not skip-entity)
      (progn
        (if (not (assoc layname data))
          (setq data (append data (list (cons layname 0.0)))))
        
        (cond
          ((= ent-type "HATCH")
           (setq qty (get-hatch-area-local en)))
          ((or (= ent-type "LINE") (= ent-type "LWPOLYLINE") (= ent-type "POLYLINE"))
           (setq qty (get-line-length-local en)))
          (T (setq qty 0.0)))
        
        (setq item (assoc layname data))
        (setq data (subst (cons layname (+ (cdr item) qty)) item data))))
    
    (setq i (1+ i))
  )
  
  ; 고정 테이블 생성
  (setq fixed-table (list))
  (foreach layer-item layer-items
    (setq typename (nth 0 layer-item))
    (setq unit (nth 1 layer-item))
    (setq layer-keyword (nth 2 layer-item))
    (setq condition (nth 3 layer-item))
    
    (setq matched-layers (list))
    (setq total-qty 0.0)
    
    (foreach layer-data data
      (setq layname (car layer-data))
      (setq qty (cdr layer-data))
      
      (if (= layer-keyword "")
        (setq match-key (strcase typename))
        (setq match-key (strcase layer-keyword)))
      
      (if (wcmatch (strcase layname) (strcat "*" match-key "*"))
        (progn
          (setq matched-layers (append matched-layers (list (cons layname qty))))
          (setq total-qty (+ total-qty qty)))))
    
    (cond
      ((wcmatch condition "*/*2*")
       (setq total-qty (/ total-qty 2.0))))
    
    (if matched-layers
      (foreach matched matched-layers
        (setq final-qty (cdr matched))
        (if (wcmatch condition "*/*2*")
          (setq final-qty (/ final-qty 2.0)))
        (setq fixed-table (append fixed-table 
                                  (list (list (car matched) typename unit final-qty)))))
      (setq fixed-table (append fixed-table 
                                (list (list "" typename unit 0.0)))))
  )
  
  fixed-table
)

; 통합 함수용 로컬 색상 함수
(defun get-layer-color-local (layname / upper-name)
  (setq upper-name (strcase layname))
  (cond
    ((wcmatch upper-name "*개선*") 1)
    ((wcmatch upper-name "*제거*") 3)
    ((wcmatch upper-name "*현황*") 2)
    (T 7)))

(defun get-block-color-local (blkname / upper-name)
  (setq upper-name (strcase blkname))
  (cond
    ((wcmatch upper-name "*신설*") 1)
    ((wcmatch upper-name "*철거*") 3)
    ((wcmatch upper-name "*현황*") 2)
    (T 7)))

(princ "\n* gggg 명령어가 로드되었습니다. *")
(princ "\n* 사용법: gggg 입력 후 객체 선택 *")
(princ "\n* 블록/선/폴리선/해치를 자동 판별하여 통계를 생성합니다. *")
(princ)
