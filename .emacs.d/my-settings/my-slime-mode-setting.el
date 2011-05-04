;; -*- coding: utf-8 -*-

(load "E:/Tools/ccl-quicklisp/quicklisp/slime-helper.el")
(setq inferior-lisp-program
      (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe") )


(provide 'my-slime-mode-setting)
