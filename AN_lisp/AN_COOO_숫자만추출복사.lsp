;; 숫자 객체만 복사하는 함수 (숫자 부분만 추출하여 복사)
;; 여러 객체 중 TEXT 또는 MTEXT 객체이면서 숫자를 포함한 객체의 숫자만 복사합니다.
(defun c:COOO (/ ss_sel temp_ss copy_ss copy_count i ent ent_data txt_content num_only)
  (princ "\n복사할 객체들을 선택하세요: ")
  
  ;; 객체 선택
  (setq ss_sel (ssget))
  
  (if ss_sel
    (progn
      ;; 숫자 객체를 담을 임시 선택셋
      (setq temp_ss (ssadd))
      ;; 최종 복사할 객체를 담을 선택셋
      (setq copy_ss (ssadd))
      (setq copy_count 0)
      (setq i 0)
      
      ;; 선택된 모든 객체 처리
      (repeat (sslength ss_sel)
        (setq ent (ssname ss_sel i))
        (setq ent_data (entget ent))
        
        ;; TEXT 또는 MTEXT 객체인지 확인
        (if (or (= (cdr (assoc 0 ent_data)) "TEXT") 
                (= (cdr (assoc 0 ent_data)) "MTEXT"))
          (progn
            ;; 텍스트 내용 가져오기
            (if (= (cdr (assoc 0 ent_data)) "TEXT")
              (setq txt_content (cdr (assoc 1 ent_data)))
              (setq txt_content (cdr (assoc 3 ent_data)))
            )
            
            ;; 텍스트에서 숫자만 추출
            (setq num_only (ExtractNumericOnly txt_content))
            
            ;; 숫자가 포함되어 있으면 처리
            (if (and num_only (> (strlen num_only) 0))
              (progn
                ;; 숫자 부분이 있는 객체를 임시 선택셋에 추가
                (setq temp_ss (ssadd ent temp_ss))
                (setq copy_count (1+ copy_count))
              )
            )
          )
        )
        
        (setq i (1+ i))
      )
      
      ;; 복사할 숫자 객체가 있으면 처리
      (if (> copy_count 0)
        (progn
          (princ (strcat "\n" (itoa copy_count) "개의 숫자 객체를 복사합니다."))
          
          ;; 새 객체 생성 - 숫자만 포함하도록
          (setq i 0)
          (repeat (sslength temp_ss)
            (setq ent (ssname temp_ss i))
            (setq ent_data (entget ent))
            
            ;; 텍스트 내용 가져오기
            (if (= (cdr (assoc 0 ent_data)) "TEXT")
              (setq txt_content (cdr (assoc 1 ent_data)))
              (setq txt_content (cdr (assoc 3 ent_data)))
            )
            
            ;; 텍스트에서 숫자만 추출
            (setq num_only (ExtractNumericOnly txt_content))
            
            ;; 새 텍스트 객체 생성 (숫자만 포함)
            (if (= (cdr (assoc 0 ent_data)) "TEXT")
              (progn
                ;; TEXT 객체 복제하고 내용 변경
                (setq new_ent_data (subst (cons 1 num_only) (assoc 1 ent_data) ent_data))
                (setq new_ent (entmakex new_ent_data))
                (setq copy_ss (ssadd new_ent copy_ss))
              )
              (progn
                ;; MTEXT 객체 복제하고 내용 변경
                (setq new_ent_data (subst (cons 3 num_only) (assoc 3 ent_data) ent_data))
                (setq new_ent (entmakex new_ent_data))
                (setq copy_ss (ssadd new_ent copy_ss))
              )
            )
            
            (setq i (1+ i))
          )
          
          ;; 새로 만든 숫자 객체들 복사
          (princ "\n복사 기준점을 지정하세요: ")
          (command "_.COPY" copy_ss "" pause)
          (princ "\n복사할 위치를 지정하세요: ")
          (command pause)
          (princ (strcat "\n복사 완료! 단위 없이 숫자만 복사되었습니다."))
          
          ;; 임시로 만든 숫자 객체들 삭제
          (command "_.ERASE" copy_ss "")
        )
        (princ "\n선택한 객체 중 숫자를 포함한 객체가 없습니다.")
      )
    )
    (princ "\n객체가 선택되지 않았습니다.")
  )
  
  (princ)
)

;; 문자열에서 숫자만 추출하는 함수 (소수점, 쉼표, 부호 포함)
(defun ExtractNumericOnly (str / num_str i char last_char)
  (setq num_str "")
  (setq i 1)
  (setq last_char "")
  
  ;; 각 문자 확인
  (while (<= i (strlen str))
    (setq char (substr str i 1))
    
    ;; 숫자, 소수점, 쉼표, 부호만 추출
    (cond
      ;; 숫자는 항상 포함
      ((and (>= (ascii char) 48) (<= (ascii char) 57))
       (setq num_str (strcat num_str char))
       (setq last_char char)
      )
      
      ;; 소수점은 이전에 소수점이 없었고, 마지막 문자가 숫자인 경우만 포함
      ((= char ".")
       (if (and (not (vl-string-search "." num_str))
                (or (= last_char "") 
                    (and (>= (ascii last_char) 48) (<= (ascii last_char) 57))))
         (progn
           (setq num_str (strcat num_str char))
           (setq last_char char)
         )
       )
      )
      
      ;; 쉼표는 숫자 사이에만 포함
      ((= char ",")
       (if (and (> (strlen num_str) 0)
                (>= (ascii last_char) 48) (<= (ascii last_char) 57))
         (progn
           (setq num_str (strcat num_str char))
           (setq last_char char)
         )
       )
      )
      
      ;; 부호는 맨 앞에만 포함
      ((or (= char "+") (= char "-"))
       (if (= (strlen num_str) 0)
         (progn
           (setq num_str (strcat num_str char))
           (setq last_char char)
         )
       )
      )
    )
    
    (setq i (1+ i))
  )
  
  ;; 결과 반환
  num_str
)

;; 명령어 등록
(princ "\n숫자만 복사하는 명령이 로드되었습니다. 'COPYNUM'을 입력하여 실행하세요.")
(princ)