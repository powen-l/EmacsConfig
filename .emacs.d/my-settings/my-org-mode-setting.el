;; -*- coding: utf-8 -*-

;; org-mode setting
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files (list "O:/gomez.org") )
(setq org-log-done t)

(provide 'my-org-mode-setting)
