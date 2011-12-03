;; -*- coding: utf-8 -*-

;;;; load base settings
(add-to-list 'load-path "~/.emacs.d/my-settings")
(require 'my-basic-setting)
(require 'my-key-setting)
;(require 'my-viper-mode-setting)
(require 'my-evil-setting)
(require 'my-font-setting)
(require 'my-color-theme-setting)

;;;; some complex mode
(require 'my-dired-setting)
(require 'my-linum-mode-setting)
(require 'my-org-mode-setting)
(require 'my-slime-mode-setting)
;(require 'my-tabbar-mode-setting)
(require 'my-auto-complete-mode-setting)
(require 'my-yasnippet-mode-setting)
(require 'my-python-setting)
;(require 'my-cedet-setting)
(require 'my-auctex-setting)

