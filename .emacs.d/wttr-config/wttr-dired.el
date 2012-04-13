;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; recrusive delete and copy directory
(setq dired-recursive-deletes t)
(setq dired-recursive-copies t)

;; prevent the warning message
(put 'dired-find-alternate-file 'disabled nil)

;; normal we use the Recycle bin
(setq delete-by-moving-to-trash t)

;; use the isearch only for filename
(setq dired-isearch-filenames t)


;; we use extra function
(require 'dired-x)

;; use wdired
(require 'wdired)
(setq wdired-allow-to-change-permissions 'advanced)
(define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)


(provide 'wttr-dired)
