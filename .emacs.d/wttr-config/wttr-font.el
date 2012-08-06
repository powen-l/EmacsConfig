;; -*- coding: utf-8 -*-
(require 'wttr-utils)

(if wttr/os:windowsp
    (setq w32-enable-synthesized-fonts t))

;; create fontset
(create-fontset-from-fontset-spec
 "-outline-Consolas-bold-normal-normal-mono-13-*-*-*-c-*-fontset-Consolas")

(cond 
 (wttr/host:MSWSp
  (set-fontset-font "fontset-Consolas" 'ascii "WenQuanYi Micro Hei Mono-12" nil 'prepend))
 (wttr/host:HOMEp
  (set-fontset-font "fontset-Consolas" 'ascii "文泉驿等宽微米黑-12" nil 'prepend))
 (wttr/os:linuxp
  (set-fontset-font "fontset-Consolas" 'ascii "WenQuanYi Micro Hei Mono-12" nil 'prepend))
 (t
  (wttr/log:message "wttr-font: Not registered host. Need update font setting for 'ascii charset.")))

(cond
 ((or wttr/host:HOMEp wttr/host:MSWSp)
  (set-fontset-font "fontset-Consolas" 'han "Microsoft YaHei-12" nil 'prepend)
  (set-fontset-font "fontset-Consolas" 'kana "MS Gothic-12" nil 'prepend))
 (wttr/os:linuxp
  (set-fontset-font "fontset-Consolas" 'han "Microsoft YaHei-12" nil 'prepend)
  (set-fontset-font "fontset-Consolas" 'kana "MS Gothic-12" nil 'prepend))
 (t
  (wttr/log:message "wttr-font: Not registered host. Need update font setting for 'han and 'kana charset.")))

(set-default-font "fontset-Consolas")

(setq default-frame-alist
      (cons '(font . "fontset-Consolas") default-frame-alist))


;; Very useful tools when you want to know the font description under win32
;(w32-select-font nil nil)

;; test example:
;; Chinese : 测试
;; Katakana: わたし
;; Hirakana: ワタシ

;; background knowledge:
;; =================================================
;; http://stackoverflow.com/questions/7176276/what-is-script-name-symbol-means-for-emacs-set-fontset-font-function/7178821#7178821
;; 
;; what is "script name symbol" means for emacs set-fontset-font function?
;; (char-table-extra-slot char-script-table 0)
;; (list-character-sets)
;;
;; charset-script-alist
;; script-representative-chars
;; char-script-table
;; =================================================

;;; former used, leave here for reference
;; Font
;(create-fontset-from-fontset-spec
; (concat
;  "-outline-Bitstream Vera Sans Mono-bold-normal-normal-mono-14-*-*-*-c-*-fontset-BVSM,"
;  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
;  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
;;(create-fontset-from-fontset-spec
; (concat
;  "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-fontset-Consolas,"
;  "ascii:-outline-Consolas-normal-r-normal-normal-18-*-*-*-c-*-iso8859-1,"
;  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-sans-*-*-*-*-p-*-gb2312*-0,"
;  "chinese-gbk:-outline-YaHei Consolas Hybrid-normal-normal-normal-sans-*-*-*-*-p-*-gb2312*-0,"
;  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
;(set-default-font "fontset-Consolas")


(provide 'wttr-font)


