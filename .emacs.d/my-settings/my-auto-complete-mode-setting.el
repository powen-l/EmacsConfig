;; -*- coding: utf-8 -*-

;; load
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
(require 'pos-tip)
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete-1.3.1/dict")
(ac-config-default)

;; custom
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)          ;default is 1.5
(setq ac-dwim t)                        ;behavior of completion by TAB will be changed as a behavior of completion by RET


(provide 'my-auto-complete-mode-setting)
