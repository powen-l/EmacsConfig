;; -*- coding: utf-8 -*-

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

(create-fontset-from-fontset-spec
 "-outline-Consolas-normal-normal-normal-mono-16-*-*-*-c-*-fontset-Consolas")
(set-fontset-font "fontset-Consolas" 'ascii "Consolas-14" nil 'prepend)
(set-fontset-font "fontset-Consolas" 'han "YaHei Consolas Hybrid-12" nil 'prepend)
(set-fontset-font "fontset-Consolas" 'kana "MS Gothic-12" nil 'prepend)
(set-default-font "fontset-Consolas")

(setq default-frame-alist
      (append
       '((font . "fontset-Consolas")) default-frame-alist))

;; test example:
;; Chinese : 测试
;; Katakana: わたし
;; Hirakana: ワタシ

(provide 'my-font-setting)


