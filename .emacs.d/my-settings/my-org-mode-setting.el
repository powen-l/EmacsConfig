;; -*- coding: utf-8 -*-

;; org-mode setting
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files
      (list
       "E:/My Dropbox/Material/Org/gomez.org") )
(setq org-log-done t)
(setq org-insert-mode-line-in-empty-file t)
(setq org-hierarchical-todo-statistics t)


(setq org-todo-keyword-faces
      '(
        ;; bug workflow
        ("OPEN" . (:foreground "PeachPuff" ) )
        ("REOPEN" . (:foreground "PeachPuff" ) )
        ("STEPPING" . (:foreground "LawnGreen") )
        ("BLOCK" .  (:foreground "IndianRed" ) )
        ("PENDING" . (:foreground "DarkGreen"))
        ("FIXED" . (:foreground "DeepSkyBlue" :weight bold))
        ("WAD" .  (:foreground "DeepSkyBlue" :weight bold) )
        ;; type workflow
        ("Paul"   (:foreground "DarkSlateGray" ) )
        ("Hunter"   (:foreground "DarkSlateGray" ) )
        ("Drizzt"   (:foreground "DarkSlateGray" ) )
        ("Sean"   (:foreground "DarkSlateGray" ) )
        ("Kirill"   (:foreground "DarkSlateGray" ) )
        ;; todo workflow
        ("TODO" . (:foreground "PeachPuff") )
        ("DONE" . (:foreground "DeepSkyBlue" :weight bold) )
        )) 

(provide 'my-org-mode-setting)