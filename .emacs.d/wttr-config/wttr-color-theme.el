;; -*- coding: utf-8 -*-

;; Color Theme
(wttr/prepend-to-load-path "~/.emacs.d/plugins/color-theme-6.6.0")
(require 'color-theme)

;; Color theme subdued
(require 'color-theme-subdued)
(color-theme-subdued)

;; color theme solarized
;(wttr/prepend-to-load-path "~/.emacs.d/plugins/color-theme-solarized")
;(require 'color-theme-solarized)
;(color-theme-solarized-light)



(provide 'wttr-color-theme)
