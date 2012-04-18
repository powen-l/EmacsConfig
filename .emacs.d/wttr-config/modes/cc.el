;; -*- coding: utf-8 -*-
(setq-default c-basic-offset 4)

(defun wttr/cc-mode:basic-setup ()
  "Set setting for cc mode"
  (c-set-style "stroustrup"))

(add-hook 'c-mode-hook 'wttr/cc-mode:basic-setup)
(add-hook 'c++-mode-hook 'wttr/cc-mode:basic-setup)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
