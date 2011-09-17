;; -*- coding: utf-8 -*-

;;auto load, but maybe have sequence problem
;(mapc 'load (directory-files "~/.emacs.d/my-settings" t "\\.el$"))


;; load all settings
(add-to-list 'load-path "~/.emacs.d/my-settings")
(require 'my-basic-setting)
(require 'my-key-setting)
(require 'my-font-setting)
(require 'my-color-theme-setting)
(require 'my-dired-setting)
(require 'my-linum-mode-setting)
(require 'my-org-mode-setting)
(require 'my-undo-tree-mode-setting)
;(require 'my-viper-mode-setting)
(require 'my-evil-setting)
(require 'my-slime-mode-setting)
(require 'my-ido-mode-setting)
;(require 'my-tabbar-mode-setting)
(require 'my-auto-complete-mode-setting)
(require 'my-yasnippet-mode-setting)
(require 'my-python-setting)
(require 'my-cedet-setting)
(require 'my-auctex-setting)

