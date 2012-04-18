;; -*- coding: utf-8 -*-
(wttr/plugin:prepend-to-load-path "ace-jump-mode")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; I also use SPC in eval mode to direct start this mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
