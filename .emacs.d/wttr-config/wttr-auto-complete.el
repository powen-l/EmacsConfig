;; -*- coding: utf-8 -*-

;; load
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
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
  (setq ac-auto-start nil)              ;auto complete using clang is CPU sensitive
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-hook 'wttr/ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'wttr/ac-cc-mode-setup)

;; system specific setting
(let ((c++-include-path-list (cond
                              ((string= (system-name) "WINTERTTR-WS")
                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC"))
                              ((string= (system-name) "DONGWANGDSK01")
                               (list "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include"
                                     "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include/gl"
                                     "C:/Program Files/Microsoft SDKs/Windows/v6.1/VC/Include"
                                     "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/include"
                                     "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/atlmfc/include"
                                     "D:/_SRC_/boost/include"))
                              ((string= (system-name) "WINTERTTR-PC")
                               (list "D:/Program Files/Microsoft Visual Studio 10.0/VC/include"
                                     "D:/Program Files/Microsoft Visual Studio 10.0/VC/atlmfc/include"
                                     "D:/_SRC_/boost/include"))
                              (t
                               nil))))
  (setq ac-clang-flags (mapcar (lambda (x) (concat "-I" x)) c++-include-path-list)))
;(when (string-equal (system-name) "WINTERTTR-WS")
;  (setq ac-clang-flags (mapcar (lambda (x) (concat "-I" x)) 
;                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
;                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC")))
;  (setq ac-clang-flags (cons "-D_WIN32_WCE" ac-clang-flags)))


(provide 'wttr-auto-complete)
