;; -*- coding: utf-8 -*-

;; viper-mode
(setq viper-custom-file-name "~/.emacs.d/wttr-config/wttr-viper-rc.el")
(setq viper-mode t)
(require 'viper)
(wttr/prepend-to-load-path "~/.emacs.d/plugins/vimpulse-0.5")
(require 'vimpulse)


(provide 'wttr-viper)
