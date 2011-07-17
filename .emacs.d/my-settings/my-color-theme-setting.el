;; -*- coding: utf-8 -*-

;; Color Theme
(add-to-list 'load-path "~/.emacs.d/plugins/color-theme-6.6.0")
(require 'color-theme)
;(add-to-list 'load-path "~/.emacs.d/plugins/emacs-color-theme-solarized")
;(require 'color-theme-solarized)
;(color-theme-solarized-dark)

(require 'color-theme-subdued)
(color-theme-subdued)

(provide 'my-color-theme-setting)
