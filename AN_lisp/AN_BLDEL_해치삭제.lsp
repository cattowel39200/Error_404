(defun c:bldel (/ ss cnt doc blks i blk blkname blkents j ent opt selblks selblknames)
  (princ "\n모든 해치를 삭제합니다 (블록 내부 포함)...")
  (setq cnt 0)
  
  ;; 옵션 선택
  (initget "1 2")
  (setq opt (getkword "\n[1-전체 블록 / 2-선택한 블록만] <1>: "))
  (if (not opt) (setq opt "1"))
  
  ;; 선택 블록 모드인 경우 블록 선택
  (if (= opt "2")
    (progn
      (princ "\n해치를 삭제할 블록을 선택하세요...")
      (setq selblks (ssget '((0 . "INSERT"))))
      (if selblks
        (progn
          (setq selblknames '())
          (setq i 0)
          (repeat (sslength selblks)
            (setq blkname (cdr (assoc 2 (entget (ssname selblks i)))))
            (if (not (member blkname selblknames))
              (setq selblknames (cons blkname selblknames))
            )
            (setq i (1+ i))
          )
          (princ (strcat "\n선택된 블록 종류: " (itoa (length selblknames)) "개"))
        )
        (progn
          (princ "\n블록이 선택되지 않았습니다. 종료합니다.")
          (exit)
        )
      )
    )
  )
  
  ;; 일반 해치 삭제
  (if (setq ss (ssget "X" '((0 . "HATCH"))))
    (progn
      (setq cnt (sslength ss))
      (command "_.ERASE" ss "")
      (princ (strcat "\n일반 해치 " (itoa cnt) "개 삭제"))
    )
  )
  
  ;; Visual LISP를 사용한 블록 내부 해치 삭제
  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (setq blks (vla-get-blocks doc))
  
  ;; 모든 블록 정의 순회
  (vlax-for blk blks
    (setq blkname (vla-get-name blk))
    
    ;; 시스템 블록 제외
    (if (and (not (wcmatch blkname "*Model_Space*,*Paper_Space*,`*U*,`*D*,`*A*,`*X*"))
             (= (vla-get-isLayout blk) :vlax-false)
             (= (vla-get-isXref blk) :vlax-false))
      (progn
        ;; 선택 모드일 경우 선택된 블록만 처리
        (if (or (= opt "1") 
                (and (= opt "2") (member blkname selblknames)))
          (progn
            (princ (strcat "\n블록 검사: " blkname))
            
            ;; 블록 내 엔티티 검사
            (vlax-for ent blk
              (if (= (vla-get-objectname ent) "AcDbHatch")
                (progn
                  (vla-delete ent)
                  (setq cnt (1+ cnt))
                  (princ (strcat "\n  - 해치 삭제됨"))
                )
              )
            )
          )
        )
      )
    )
  )
  
  (princ (strcat "\n\n총 " (itoa cnt) "개의 해치가 삭제되었습니다."))
  (command "_.REGEN")
  (princ)
)