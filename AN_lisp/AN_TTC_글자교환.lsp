;; 텍스트 교환 함수
;; 두 개의 텍스트 객체를 선택하여 서로의 내용을 교환하는 함수
(defun c:TTC (/ first_ent second_ent first_data second_data first_txt second_txt)
  (princ "\n첫번째 텍스트 객체를 선택하세요: ")
  (setq first_ent (car (entsel)))
  
  (if first_ent
    (progn
      (setq first_data (entget first_ent))
      
      ;; 첫번째 객체가 TEXT 또는 MTEXT인지 확인
      (if (or (= (cdr (assoc 0 first_data)) "TEXT") 
              (= (cdr (assoc 0 first_data)) "MTEXT"))
        (progn
          ;; 첫번째 텍스트 내용 가져오기
          (if (= (cdr (assoc 0 first_data)) "TEXT")
            (setq first_txt (cdr (assoc 1 first_data)))
            (setq first_txt (cdr (assoc 3 first_data)))
          )
          
          (princ "\n두번째 텍스트 객체를 선택하세요: ")
          (setq second_ent (car (entsel)))
          
          (if second_ent
            (progn
              (setq second_data (entget second_ent))
              
              ;; 두번째 객체가 TEXT 또는 MTEXT인지 확인
              (if (or (= (cdr (assoc 0 second_data)) "TEXT") 
                      (= (cdr (assoc 0 second_data)) "MTEXT"))
                (progn
                  ;; 두번째 텍스트 내용 가져오기
                  (if (= (cdr (assoc 0 second_data)) "TEXT")
                    (setq second_txt (cdr (assoc 1 second_data)))
                    (setq second_txt (cdr (assoc 3 second_data)))
                  )
                  
                  ;; 두 텍스트 객체의 내용 교환 - entmod 사용
                  (if (= (cdr (assoc 0 first_data)) "TEXT")
                    (progn
                      (setq first_data (subst (cons 1 second_txt) (assoc 1 first_data) first_data))
                      (entmod first_data)
                    )
                    (progn
                      (setq first_data (subst (cons 3 second_txt) (assoc 3 first_data) first_data))
                      (entmod first_data)
                    )
                  )
                  
                  (if (= (cdr (assoc 0 second_data)) "TEXT")
                    (progn
                      (setq second_data (subst (cons 1 first_txt) (assoc 1 second_data) second_data))
                      (entmod second_data)
                    )
                    (progn
                      (setq second_data (subst (cons 3 first_txt) (assoc 3 second_data) second_data))
                      (entmod second_data)
                    )
                  )
                  
                  (princ (strcat "\n두 텍스트 객체의 내용이 교환되었습니다."))
                )
                (princ "\n두번째로 선택한 객체는 텍스트 객체가 아닙니다.")
              )
            )
            (princ "\n두번째 객체가 선택되지 않았습니다.")
          )
        )
        (princ "\n첫번째로 선택한 객체는 텍스트 객체가 아닙니다.")
      )
    )
    (princ "\n첫번째 객체가 선택되지 않았습니다.")
  )
  
  (princ)
)

;; 별칭 설정
(defun c:TTS () (c:TTC))
(princ "\n텍스트 교환 명령이 로드되었습니다. 'TTC'를 입력하여 실행하세요.")
(princ)