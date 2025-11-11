(vl-load-com) ; Visual LISP 확장 로드

;;;-----------------------------------------------------------------------------
;;; 함수 이름: C:LOOO
;;; 기능: 사용자가 선택한 레이어만 켜고 나머지 모든 레이어를 끕니다.
;;;       현재 레이어는 꺼지지 않도록 예외 처리합니다.
;;;-----------------------------------------------------------------------------
(defun C:LOoo ( / old_cmdecho old_clayer sel_layer layer_name)
  
  ;; 기존 시스템 변수 값 저장
  (setq old_cmdecho (getvar "CMDECHO"))
  (setq old_clayer (getvar "CLAYER"))

  ;; 명령 실행 중 오토캐드 메시지 끄기
  (setvar "CMDECHO" 0)

  ;; 실행 취소 그룹 시작
  (command "._UNDO" "_Group")

  (princ "\n켜고 싶은 레이어를 선택하십시오...")

  ;; 레이어 선택 (레이어 이름을 직접 입력)
  (setq layer_name (getstring "\n레이어 이름을 입력하거나 Enter를 눌러 객체를 선택하십시오: "))
  (if (or (not layer_name) (= layer_name ""))
    (progn
      ;; 객체 선택으로 레이어 지정 시도
      (setq sel_layer (entsel "\n레이어가 포함된 객체를 선택하십시오: "))
      (if sel_layer
        (progn
          (setq layer_name (cdr (assoc 8 (entget (car sel_layer)))))
          (if (not layer_name)
            (progn
              (princ "\n선택된 객체에서 유효한 레이어를 찾을 수 없습니다.")
              (command "._UNDO" "_End")
              (setvar "CMDECHO" old_cmdecho)
              (setvar "CLAYER" old_clayer)
              (exit)
            )
          )
          ;; 레이어가 실제로 존재하는지 확인
          (if (not (tblobjname "LAYER" layer_name))
            (progn
              (princ "\n지정한 레이어가 존재하지 않습니다.")
              (command "._UNDO" "_End")
              (setvar "CMDECHO" old_cmdecho)
              (setvar "CLAYER" old_clayer)
              (exit)
            )
          )
        )
        (progn
          (princ "\n객체 선택이 취소되었습니다.")
          (command "._UNDO" "_End")
          (setvar "CMDECHO" old_cmdecho)
          (setvar "CLAYER" old_clayer)
          (exit)
        )
      )
    )
    (progn
      ;; 입력된 레이어가 실제로 존재하는지 확인
      (if (not (tblobjname "LAYER" layer_name))
        (progn
          (princ "\n지정한 레이어가 존재하지 않습니다.")
          (command "._UNDO" "_End")
          (setvar "CMDECHO" old_cmdecho)
          (setvar "CLAYER" old_clayer)
          (exit)
        )
      )
    )
  )

  ;; 레이어 이름이 유효한 경우 처리
  (if layer_name
    (progn
      (princ (strcat "\n선택된 레이어: " layer_name))

      ;; 모든 레이어 끄기
      (vl-cmdf "._LAYER" "_OFF" "*" "_N" "")

      ;; 선택된 레이어 켜기
      (vl-cmdf "._LAYER" "_ON" layer_name "")

      ;; 현재 레이어가 꺼지지 않도록 보장
      (if (not (equal layer_name old_clayer))
        (vl-cmdf "._LAYER" "_ON" old_clayer "")
      )

      (princ "\n선택한 레이어만 켜졌습니다.")
    )
    (progn
      (princ "\n레이어 선택에 실패했습니다. 작업을 취소합니다.")
      (command "._UNDO" "_End")
      (setvar "CMDECHO" old_cmdecho)
      (setvar "CLAYER" old_clayer)
      (exit)
    )
  )

  ;; 실행 취소 그룹 종료
  (command "._UNDO" "_End")

  ;; 원래 시스템 변수 값 복원
  (setvar "CMDECHO" old_cmdecho)
  (setvar "CLAYER" old_clayer)

  (princ) ; 함수 종료 시 마지막 값 출력 방지
)

;;;-----------------------------------------------------------------------------
;;; 사용 방법:
;;; 1. 이 코드를 메모장에 붙여넣고 "lol.lsp"로 저장합니다.
;;; 2. 오토캐드에서 APPLOAD 명령으로 "lol.lsp" 파일을 로드합니다.
;;; 3. 명령 프롬프트에 'LOL'를 입력하여 실행합니다.
;;; 4. 레이어 이름을 입력하거나 객체를 선택하여 원하는 레이어를 지정합니다.
;;;
;;; 주의사항:
;;; - 현재 레이어는 꺼지지 않습니다.
;;; - AutoCAD 버전이 2000 이상이어야 Visual LISP 함수가 제대로 작동합니다.
;;; - 시스템 변수와 UNDO 그룹을 사용하여 안정적으로 동작합니다.
;;; - 레이어 선택 실패 시 적절한 메시지 출력 후 종료합니다.
;;; - 파일 끝에 불필요한 공백이나 문자가 없도록 저장하세요.
;;;-----------------------------------------------------------------------------