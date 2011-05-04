;; -*- coding: utf-8 -*-

;; Font
(create-fontset-from-fontset-spec
 (concat
  "-outline-Bitstream Vera Sans Mono-bold-normal-normal-mono-14-*-*-*-c-*-fontset-BVSM,"
  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
(create-fontset-from-fontset-spec
 (concat
  "-outline-Consolas-bold-normal-normal-mono-14-*-*-*-c-*-fontset-Consolas,"
  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
(set-default-font "fontset-Consolas")

(provide 'my-font-setting)
