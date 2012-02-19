;; -*- coding: utf-8 -*-

;; load
(wttr/prepend-to-load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
(require 'pos-tip)
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete-1.3.1/dict")
(ac-config-default)

;; custom
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 0.5)          ;default is 1.5
(setq ac-dwim t)                        ;behavior of completion by TAB will be changed as a behavior of completion by RET
(define-key ac-mode-map  [(control return)] 'auto-complete)
(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
(add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
(add-hook 'css-mode-hook 'ac-css-mode-setup)
(add-hook 'auto-complete-mode-hook 'ac-common-setup)
(global-auto-complete-mode t)

;; auto complete clang
(require 'auto-complete-clang)

(defun wttr/ac-cc-mode-setup ()
  (make-local-variable 'ac-auto-start)
  (setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-hook 'wttr/ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'wttr/ac-cc-mode-setup)

;; system specific setting
(let ((extra-clang-flags (cond
                          (wttr/host:MSWSp
                           (list "-IC:/MinGW/include"
                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include"
                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include/c++"
                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include/c++/mingw32"
                                 "-D__MSVCRT__="))
                          (wttr/host:HOMEp
                           (list "-IC:/MinGW/include"
                                 "-IC:/MinGW/include/c++/3.4.5"
                                 "-IC:/MinGW/lib/gcc/mingw32/3.4.5/include"
                                 "-IC:/MinGW/include/c++/3.4.5/mingw32"
                                 "-D__MSVCRT__"))
                          (t
                           nil))))
  (setq ac-clang-flags extra-clang-flags))
;(when (string-equal (system-name) "WINTERTTR-WS")
;  (setq ac-clang-flags (mapcar (lambda (x) (concat "-I" x)) 
;                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
;                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC")))
;  (setq ac-clang-flags (cons "-D_WIN32_WCE" ac-clang-flags)))


(provide 'wttr-auto-complete)
