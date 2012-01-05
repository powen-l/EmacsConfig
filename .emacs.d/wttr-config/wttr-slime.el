;; -*- coding: utf-8 -*-

;; we need to add the ccl binary path
(when (string-equal system-type "windows-nt")
  (setq exec-path
        (append (list (expand-file-name "~/../ccl-1.7-windows"))
                exec-path))
  (setenv "PATH" (concat (expand-file-name "~/../ccl-1.7-windows") path-separator
                         (getenv "PATH"))))

;; we use emacs to slime repl
(when (boundp 'evil-emacs-state-modes)
  (add-to-list 'evil-emacs-state-modes 'slime-repl-mode))

(add-to-list 'load-path "E:/Tools/ccl-quicklisp/quicklisp")
(autoload 'slime "slime-helper" nil t)
(setq inferior-lisp-program
      (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe") )

(provide 'wttr-slime)
