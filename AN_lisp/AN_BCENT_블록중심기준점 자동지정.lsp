(defun C:BCENT (/ ss i ent blk-name processed-blocks)
  (vl-load-com)
  (princ "\n=== 블록 기준점 중심으로 변경 ===")
  (princ "\n여러 종류의 블록을 선택할 수 있습니다.")
  
  ;; 블록 선택
  (setq ss (ssget '((0 . "INSERT"))))
  
  (if ss
    (progn
      (setq i 0)
      (setq processed-blocks '()) ;; 이미 처리한 블록 이름 저장
      
      (princ (strcat "\n선택된 블록 개수: " (itoa (sslength ss))))
      (princ "\n처리 중...")
      
      ;; 선택된 모든 블록 처리
      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq blk-name (cdr (assoc 2 (entget ent))))
        
        ;; 이미 처리한 블록이 아닌 경우에만 처리
        (if (not (member blk-name processed-blocks))
          (progn
            (princ (strcat "\n\n블록 '" blk-name "' 처리 중..."))
            
            ;; 블록 기준점 변경 실행
            (if (change-block-basepoint blk-name)
              (progn
                (princ (strcat "\n  ✓ '" blk-name "' 기준점이 중심으로 변경되었습니다."))
                (setq processed-blocks (cons blk-name processed-blocks))
              )
              (princ (strcat "\n  ✗ '" blk-name "' 처리 실패"))
            )
          )
          (princ (strcat "\n블록 '" blk-name "'은(는) 이미 처리되었습니다."))
        )
        
        (setq i (1+ i))
      )
      
      (princ (strcat "\n\n=== 완료 ==="))
      (princ (strcat "\n총 " (itoa (length processed-blocks)) "개의 서로 다른 블록이 처리되었습니다."))
      (princ "\n처리된 블록: ")
      (foreach blk processed-blocks
        (princ (strcat "\n  - " blk))
      )
    )
    (princ "\n블록이 선택되지 않았습니다.")
  )
  
  (princ)
)

;; 블록 기준점을 중심으로 변경하는 함수
(defun change-block-basepoint (blk-name / blk-obj temp-ent obj-list min-pt max-pt 
                                         center-pt old-base offset all-blocks 
                                         blk-def ss-temp exploded-ents)
  
  ;; 임시 블록 삽입하여 객체들 분석
  (command "_.INSERT" blk-name '(0 0 0) 1 1 0)
  (setq temp-ent (entlast))
  
  (if temp-ent
    (progn
      (setq blk-obj (vlax-ename->vla-object temp-ent))
      
      ;; 바운딩 박스로 중심점 계산
      (vla-getboundingbox blk-obj 'min-pt 'max-pt)
      (setq min-pt (vlax-safearray->list min-pt))
      (setq max-pt (vlax-safearray->list max-pt))
      
      ;; 중심점 계산
      (setq center-pt (list
                        (/ (+ (car min-pt) (car max-pt)) 2.0)
                        (/ (+ (cadr min-pt) (cadr max-pt)) 2.0)
                        0.0
                      ))
      
      ;; 블록 정의의 현재 기준점
      (setq blk-def (tblsearch "BLOCK" blk-name))
      (setq old-base (cdr (assoc 10 blk-def)))
      
      ;; 오프셋 계산
      (setq offset (mapcar '- center-pt old-base))
      
      (princ (strcat "\n    현재 기준점: (" (rtos (car old-base) 2 2) ", " 
                                          (rtos (cadr old-base) 2 2) ")"))
      (princ (strcat "\n    새 기준점: (" (rtos (car center-pt) 2 2) ", " 
                                        (rtos (cadr center-pt) 2 2) ")"))
      
      ;; 임시 블록 분해
      (command "_.EXPLODE" temp-ent)
      
      ;; 분해된 객체들 선택
      (setq ss-temp (ssget "_P"))
      
      (if ss-temp
        (progn
          ;; 분해된 객체들을 오프셋만큼 이동 (음수 방향)
          (command "_.MOVE" ss-temp "" '(0 0 0) (mapcar '- '(0 0 0) offset))
          
          ;; 새 블록으로 재정의
          (command "_.BLOCK" blk-name "_Y" '(0 0 0) ss-temp "")
          
          ;; 도면의 모든 해당 블록 인스턴스 업데이트
          (setq all-blocks (ssget "_X" (list '(0 . "INSERT") (cons 2 blk-name))))
          
          (if all-blocks
            (progn
              (setq i 0)
              (repeat (sslength all-blocks)
                (setq ent (ssname all-blocks i))
                (setq ent-data (entget ent))
                (setq ins-pt (cdr (assoc 10 ent-data)))
                (setq rotation (cdr (assoc 50 ent-data)))
                (setq x-scale (cdr (assoc 41 ent-data)))
                (setq y-scale (cdr (assoc 42 ent-data)))
                
                ;; 회전과 스케일 고려한 새 삽입점 계산
                (setq rotated-offset 
                  (list
                    (- (* (car offset) (cos rotation) x-scale)
                       (* (cadr offset) (sin rotation) y-scale))
                    (+ (* (car offset) (sin rotation) x-scale)
                       (* (cadr offset) (cos rotation) y-scale))
                    0.0
                  ))
                
                (setq new-ins-pt (mapcar '+ ins-pt rotated-offset))
                
                ;; 삽입점 업데이트
                (setq ent-data (subst (cons 10 new-ins-pt) (assoc 10 ent-data) ent-data))
                (entmod ent-data)
                (entupd ent)
                
                (setq i (1+ i))
              )
            )
          )
          
          (command "_.REGEN")
          T ;; 성공
        )
        (progn
          (princ "\n  분해된 객체를 선택할 수 없습니다.")
          nil
        )
      )
    )
    (progn
      (princ "\n  임시 블록 삽입 실패")
      nil
    )
  )
)

(princ "\n블록 기준점 중심 변경 프로그램 로드됨")
(princ "\n명령어: BCENTER")
(princ "\n사용법: BCENTER 입력 후 블록들을 선택하세요.")
(princ)