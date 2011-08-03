;; -*- coding: utf-8 -*-

(load-file "~/.emacs.d/plugins/cedet/common/cedet.el")
(global-ede-mode 1)
(semantic-load-enable-excessive-code-helpers)
(global-srecode-minor-mode 1) 

(setq senator-minor-mode-name "SN")
(setq semantic-imenu-auto-rebuild-directory-indexes nil)
(global-semantic-mru-bookmark-mode 1)

(require 'semantic-decorate-include)
(require 'semantic-ia)
(require 'semantic-gcc)
;; use need to update the specific path
(let ((c++-include-path-list (cond
                              ((string= (system-name) "DONGWANGDSK01")
                               (list "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include"
                                     "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include/gl"
                                     "C:/Program Files/Microsoft SDKs/Windows/v6.1/VC/Include"
                                     "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/include"
                                     "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/atlmfc/include"
                                     "D:/_SRC_/boost_1_46_1"))
                              ((string= (system-name) "WINTERTTR-PC")
                               (list "C:/Program Files/Microsoft Visual Studio 8/VC/include"
                                     "C:/Program Files/Microsoft Visual Studio 8/VC/atlmfc/include"
                                     "C:/Program Files/Microsoft Visual Studio 8/VC/PlatformSDK/Include"
                                     "C:/Program Files/Microsoft Visual Studio 8/SDK/v2.0/include"
                                     "D:/_SRC_/boost_1_43_0"))
                              (t
                               nil))))
  (mapc (lambda (x) (semantic-add-system-include x 'c++-mode)) c++-include-path-list))



(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))

(require 'eassist)


(require 'semanticdb-global)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(semantic-load-enable-primary-exuberent-ctags-support)


(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  ;;
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))

(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'c++-mode-hook 'my-cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'my-cedet-hook)
(add-hook 'lisp-mode-hook 'my-cedet-hook)


(defun my-c-mode-cedet-hook ()
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref))

(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
(add-hook 'c++-mode-hook 'my-c-mode-cedet-hook)


(require 'semantic-lex-spp)
(ede-enable-generic-projects)


;;Getting information about tags

;;The semantic-ia package implements several commands, that allows to
;;get information about classes, functions & variables. As
;;documentation are used comments, extracted from source code,
;;including comments, written for Doxygen. Now following commands are
;;implemented:

;;semantic-ia-show-doc
;;    shows documentation for function or variable, whose names is
;;    under point. Documentation is shown in separate buffer. For
;;    variables this command shows their declaration, including type
;;    of variable, and documentation string, if it available. For
;;    functions, prototype of the function is shown, including
;;    documentation for arguments and returning value (if comments are
;;    available);
;;semantic-ia-show-summary
;;    shows documentation for name under point, but information is
;;    shown in the mini-buffer, so user will see only variable's
;;    declaration or function's prototype;
;;semantic-ia-describe-class
;;    asks user for a name of the class, and return list of functions
;;    & variables, defined in given class, and all its parent classes.

;semantic-ia-fast-jump
;semantic-mrub-switch-tag


;; ecb
(add-to-list 'load-path "~/.emacs.d/plugins/ecb-2.40/")
(require 'ecb)
;(setq ecb-auto-activate t
;      ecb-tip-of-the-day nil)



(provide 'my-cedet-setting)
