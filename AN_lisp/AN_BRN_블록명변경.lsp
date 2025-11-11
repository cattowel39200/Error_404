(defun c:brn ( / ent ed blkName newName inputName blkObj blkData pt ss)
  (vl-load-com) ; ActiveX 라이브러리 로드
  (princ "\n이름을 변경할 블록을 선택하세요: ")
  (if (setq ent (car (entsel)))
    (if (= (cdr (assoc 0 (entget ent))) "INSERT")
      (progn
        (setq ed (entget ent))
        (setq blkName (cdr (assoc 2 ed)))
        (princ (strcat "\n현재 블록 이름: " blkName))

        ;; 새 블록 이름 입력 (기존 이름이 기본값으로 표시됨)
        (setq newName nil)
        (while (not newName)
          (setq inputName (getstring T (strcat "\n새 블록 이름 입력 <" blkName ">: ")))
          (cond
            ;; Enter만 누른 경우 - 기존 이름 유지
            ((or (not inputName) (= inputName ""))
             (setq newName blkName)
             (princ "\n기존 블록 이름을 유지합니다."))
            ;; 입력한 이름이 기존과 같은 경우
            ((= inputName blkName)
             (setq newName blkName)
             (princ "\n기존 블록 이름과 동일합니다."))
            ;; 입력한 이름이 이미 존재하는 경우
            ((tblobjname "BLOCK" inputName)
             (princ "\n이미 존재하는 블록 이름입니다. 다시 입력하세요."))
            ;; 유효한 새 이름
            (T
             (setq newName inputName))
          )
        )

        ;; 블록 이름 변경 처리
        (if (= blkName newName)
          ;; 기존 이름과 같으면 작업 안 함
          (princ "\n블록 이름이 변경되지 않았습니다.")
          ;; 새 이름으로 변경
          (progn
            ;; 기존 블록 정의 정보 가져오기
            (setq blkObj (tblobjname "BLOCK" blkName))
            (setq blkData (entget blkObj))
            (setq pt (cdr (assoc 10 blkData))) ; 블록 기준점

            ;; 새로운 블록 생성
            (command "_.COPY" ent "" "_non" pt "_non" pt) ; 선택된 블록 임시 복사
            (setq ss (ssget "L")) ; 마지막 생성된 객체 선택
            (command "_.BLOCK" newName "_non" pt ss "") ; 새 블록 정의 생성

            (if (tblobjname "BLOCK" newName)
              (progn
                ;; 선택된 블록 정의 업데이트
                (entmod (subst (cons 2 newName) (assoc 2 ed) ed))
                (entupd ent)
                (princ (strcat "\n블록 이름이 '" blkName "'에서 '" newName "'으로 변경되었습니다."))
                ;; 기존 블록 정의 삭제 시도
                (command "_.PURGE" "_B" blkName "_N")
              )
              (princ "\n블록 생성 실패 - 이름 변경 취소")
            )
          )
        )
      )
      (princ "\n유효한 블록 객체를 선택하지 않았습니다.")
    )
    (princ "\n선택된 객체가 없습니다.")
  )
  (princ)
)