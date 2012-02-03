;; -*- coding: utf-8 -*-

;; we need to add the ccl binary path
(when (string-equal system-type "windows-nt")
  (wttr/add-to-exec-path "~/../ccl-1.7-windows")
  (setq inferior-lisp-program
        (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe"))
  (add-to-list 'load-path (expand-file-name "~/../ccl-quicklisp/quicklisp"))
  (autoload 'slime "slime-helper" nil t))

;; we use emacs to slime repl
(when (boundp 'evil-emacs-state-modes)
  (add-to-list 'evil-emacs-state-modes 'slime-repl-mode))


(provide 'wttr-slime)
