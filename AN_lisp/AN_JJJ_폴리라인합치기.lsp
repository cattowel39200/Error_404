(vl-load-com) ; Visual LISP 확장 로드

;;;-----------------------------------------------------------------------------
;;; 함수 이름: C:jjj
;;; 기능: 사용자가 선택한 연결된 선 또는 폴리라인을 하나의 폴리라인으로 결합합니다.
;;;       Z 좌표가 다른 객체도 연결 가능하도록 수정됨.
;;;       오토캐드의 PEDIT JOIN 명령을 활용합니다.
;;;       퍼즈 거리는 기본값 0.005로 설정됨.
;;;-----------------------------------------------------------------------------
(defun C:jjj ( / ss old_cmdecho old_blipmode fuzz_dist i ent obj z_coords new_obj coords idx pt x y z)
  
  ;; 기존 시스템 변수 값 저장
  (setq old_cmdecho (getvar "CMDECHO"))
  (setq old_blipmode (getvar "BLIPMODE"))

  ;; 명령 실행 중 오토캐드 메시지 및 블립(점) 표시 끄기
  (setvar "CMDECHO" 0)
  (setvar "BLIPMODE" 0)

  (princ "\n연결할 선 또는 폴리라인을 선택하십시오...")

  ;; 선(LINE) 또는 폴리라인(LWPOLYLINE, POLYLINE) 객체 선택
  (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE"))))

  ;; 선택된 객체가 있는지 확인
  (if ss
    (progn
      ;; 퍼즈 거리 기본값 설정 (0.005로 고정)
      (setq fuzz_dist 0.005)

      ;; 실행 취소 그룹 시작
      (command "._UNDO" "_Group")

      (princ "\n선택된 객체를 하나의 폴리라인으로 결합하는 중...")

      ;; Z 좌표 저장 (연관 리스트 사용)
      (setq z_coords nil)
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        (princ (strcat "\nObject Type: " (vla-get-ObjectName obj))) ; 디버깅용
        (if (vlax-property-available-p obj 'StartPoint)
          (progn
            (setq pt (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint obj))))
            (setq x (car pt) y (cadr pt) z (caddr pt))
            (setq z_coords (cons (cons (list x y) z) z_coords))
          )
        )
        (if (vlax-property-available-p obj 'EndPoint)
          (progn
            (setq pt (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint obj))))
            (setq x (car pt) y (cadr pt) z (caddr pt))
            (setq z_coords (cons (cons (list x y) z) z_coords))
          )
        )
        (if (vlax-property-available-p obj 'Coordinates)
          (progn
            (setq coords (vlax-safearray->list (vlax-variant-value (vla-get-Coordinates obj))))
            (princ (strcat "\nCoordinates: " (vl-princ-to-string coords))) ; 디버깅용
            (setq idx 0)
            (if (eq (vla-get-ObjectName obj) "AcDbPolyline") ; LWPOLYLINE
              (while (< idx (length coords))
                (setq x (nth idx coords))
                (setq y (nth (1+ idx) coords))
                (setq z 0.0) ; LWPOLYLINE은 Z 좌표가 없음
                (setq z_coords (cons (cons (list x y) z) z_coords))
                (setq idx (+ idx 2))
              )
              (while (< idx (length coords)) ; POLYLINE (2dPolyline)
                (setq x (nth idx coords))
                (setq y (nth (1+ idx) coords))
                (setq z (nth (+ idx 2) coords))
                (setq z_coords (cons (cons (list x y) z) z_coords))
                (setq idx (+ idx 3))
              )
            )
          )
        )
        (setq i (1+ i))
      )

      ;; 선택된 객체의 Z 좌표를 0으로 설정 (CHANGE 명령 사용)
      (command "._CHANGE" ss "" "_P" "_E" 0.0 "")

      ;; PEDIT 명령 실행 (오류 처리 포함)
      (if (vl-catch-all-error-p
            (vl-catch-all-apply 'vl-cmdf (list "._PEDIT" "_M" "_P" "" "_Y")))
        (progn
          (princ "\nPEDIT 명령 실행 중 오류가 발생했습니다. 작업을 취소합니다.")
          (command "._UNDO" "_End")
          (setvar "CMDECHO" old_cmdecho)
          (setvar "BLIPMODE" old_blipmode)
          (exit)
        )
      )

      ;; JOIN 옵션 실행 (오류 처리 포함)
      (if (vl-catch-all-error-p
            (vl-catch-all-apply 'vl-cmdf (list "_J" fuzz_dist "")))
        (progn
          (princ "\nJOIN 명령 실행 중 오류가 발생했습니다. 객체가 연결되어 있지 않을 수 있습니다.")
          (command "._UNDO" "_End")
          (setvar "CMDECHO" old_cmdecho)
          (setvar "BLIPMODE" old_blipmode)
          (exit)
        )
      )

      ;; 결합된 폴리라인의 Z 좌표 복원
      (setq new_obj (vlax-ename->vla-object (entlast))) ; 마지막으로 생성된 객체 (결합된 폴리라인)
      (if (and new_obj (vlax-property-available-p new_obj 'Coordinates))
        (progn
          (princ (strcat "\nNew Object Type: " (vla-get-ObjectName new_obj))) ; 디버깅용
          ;; LWPOLYLINE일 경우 POLYLINE으로 변환
          (if (eq (vla-get-ObjectName new_obj) "AcDbPolyline")
            (progn
              (vl-cmdf "._CONVERTPOLY" "_H" (vlax-vla-object->ename new_obj) "")
              (setq new_obj (vlax-ename->vla-object (entlast))) ; 변환된 객체 다시 가져오기
            )
          )
          (setq coords (vlax-safearray->list (vlax-variant-value (vla-get-Coordinates new_obj))))
          (princ (strcat "\nNew Coordinates: " (vl-princ-to-string coords))) ; 디버깅용
          (setq idx 0)
          (while (< idx (length coords))
            (setq x (nth idx coords))
            (setq y (nth (1+ idx) coords))
            (setq z (cdr (assoc (list x y) z_coords)))
            (if (not z) (setq z 0.0))
            (if (vl-catch-all-error-p
                  (vl-catch-all-apply 'vla-put-Coordinate (list new_obj idx (vlax-3D-point x y z))))
              (princ (strcat "\nZ 좌표 복원 중 오류: (" (vl-princ-to-string x) ", " (vl-princ-to-string y) ")"))
              (vla-put-Coordinate new_obj idx (vlax-3D-point x y z))
            )
            (setq idx (+ idx 3)) ; POLYLINE으로 변환했으므로 3씩 증가
          )
        )
      )

      ;; 실행 취소 그룹 종료
      (command "._UNDO" "_End")

      (princ "\n선택된 선 및 폴리라인을 하나의 폴리라인으로 성공적으로 결합했습니다.")
    )
    (princ "\n선택된 객체가 없습니다. 작업을 취소합니다.")
  )

  ;; 원래 시스템 변수 값 복원
  (setvar "CMDECHO" old_cmdecho)
  (setvar "BLIPMODE" old_blipmode)

  (princ) ; 함수 종료 시 마지막 값 출력 방지
)

;;;-----------------------------------------------------------------------------
;;; 사용 방법:
;;; 1. 이 코드를 메모장에 붙여넣고 "jjj.lsp"로 저장합니다.
;;; 2. 오토캐드에서 APPLOAD 명령으로 "jjj.lsp" 파일을 로드합니다.
;;; 3. 명령 프롬프트에 'JJJ'를 입력하여 실행합니다.
;;; 4. 선 또는 폴리라인을 선택하면 퍼즈 거리 0.005로 자동 결합됩니다.
;;;
;;; 주의사항:
;;; - 선택한 객체는 끝점이 연결되어 있어야 PEDIT JOIN이 성공적으로 작동합니다.
;;; - 퍼즈 거리는 0.005로 고정되어 있으며, 약간의 틈이 있는 객체도 결합 가능합니다.
;;; - Z 좌표가 다른 객체도 결합 가능합니다.
;;; - AutoCAD 버전이 2000 이상이어야 Visual LISP 함수가 제대로 작동합니다.
;;; - Z 좌표 복원은 (X, Y) 좌표 쌍을 기준으로 이루어지며, 중복 좌표는 마지막 Z 값으로 덮어씌워질 수 있습니다.
;;; - 결합된 폴리라인은 POLYLINE(2dPolyline)으로 변환되어 Z 좌표를 복원합니다.
;;;-----------------------------------------------------------------------------