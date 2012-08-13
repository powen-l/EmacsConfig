;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "actionscript-mode")
(autoload 'actionscript-mode "actionscript-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
