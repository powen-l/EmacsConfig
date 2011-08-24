;; -*- coding: utf-8 -*-

(add-to-list 'load-path "E:/Tools/ccl-quicklisp/quicklisp")
(autoload 'slime "slime-helper" nil t)
(setq inferior-lisp-program
      (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe") )

(provide 'my-slime-mode-setting)
