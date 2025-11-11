;; 텍스트 복제 함수
;; 첫번째 선택한 텍스트 객체의 내용을 이후 선택하는 모든 텍스트 객체에 적용하는 함수
(defun c:TTR (/ source_ent source_data source_txt target_ent target_data done)
  (princ "\n기준이 될 텍스트 객체를 선택하세요: ")
  (setq source_ent (car (entsel)))
  
  (if source_ent
    (progn
      (setq source_data (entget source_ent))
      
      ;; 첫번째 객체가 TEXT 또는 MTEXT인지 확인
      (if (or (= (cdr (assoc 0 source_data)) "TEXT") 
              (= (cdr (assoc 0 source_data)) "MTEXT"))
        (progn
          ;; 기준 텍스트의 내용 가져오기
          (if (= (cdr (assoc 0 source_data)) "TEXT")
            (setq source_txt (cdr (assoc 1 source_data)))
            (setq source_txt (cdr (assoc 1 source_data))) ; MTEXT도 DXF 코드 1 사용
          )
          
          (princ (strcat "\n기준 텍스트: \"" source_txt "\""))
          (princ "\n이 내용을 복사할 텍스트 객체들을 선택하세요 (종료하려면 Enter): ")
          
          (setq done nil)
          (while (not done)
            (setq target_ent (car (entsel)))
            (if target_ent
              (progn
                (setq target_data (entget target_ent))
                
                ;; 대상 객체가 TEXT 또는 MTEXT인지 확인
                (if (or (= (cdr (assoc 0 target_data)) "TEXT") 
                        (= (cdr (assoc 0 target_data)) "MTEXT"))
                  (progn
                    ;; 텍스트 내용 변경 - 통일된 방식 사용
                    (setq target_data (subst (cons 1 source_txt) (assoc 1 target_data) target_data))
                    (entmod target_data)
                    (entupd target_ent) ; 화면 업데이트
                    (princ "\n텍스트 내용이 변경되었습니다.")
                  )
                  (princ "\n선택한 객체는 텍스트 객체가 아닙니다.")
                )
              )
              (setq done T) ; Enter 키 입력 시 종료
            )
          )
          (princ "\n텍스트 복제 작업이 완료되었습니다.")
        )
        (princ "\n기준 객체는 텍스트 객체가 아닙니다.")
      )
    )
    (princ "\n기준 객체가 선택되지 않았습니다.")
  )
  
  (princ)
)

;; 별칭 설정
(defun c:TR () (c:TTR))

;; 로드 메시지
(princ "\n텍스트 복제 명령이 로드되었습니다. 'TTR' 또는 'TR'을 입력하여 실행하세요.")
(princ)