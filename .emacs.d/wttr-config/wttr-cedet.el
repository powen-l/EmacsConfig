;; -*- coding: utf-8 -*-
(require 'wttr-utils)

;; compile command:
;;   emacs -Q -l cedet-build.el -f cedet-build

;; Don't need to call these explicitly, cedet.el will handle all
;(wttr/plugin:prepend-to-load-path "cedet/common")
;(wttr/plugin:prepend-to-load-path "cedet/eieio")
;(wttr/plugin:prepend-to-load-path "cedet/semantic")
;(wttr/plugin:prepend-to-load-path "cedet/speedbar")
;(require 'cedet)
(load (wttr/plugin:expand-file-name "cedet/common/cedet.el"))


;; use gnu global for semantic
(require 'semanticdb-global)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(semantic-load-enable-primary-exuberent-ctags-support)

;; which mode is prefer? min -> max
;(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;(semantic-load-enable-gaudy-code-helpers)
;(semantic-load-enable-excessive-code-helpers)
;(semantic-load-enable-semantic-debugging-helpers)

;; Enable EDE(Emacs Develpment Enviroment) mode
(global-ede-mode t)

;;; EDE example
;(ede-cpp-root-project "CedetTest"
;                :name "Test Cedet"
;                :file "d:/_SRC_/_mine_/__CPP__/cedet/anchor.TXT"
;                :include-path '("/"
;                                "/a"
;                                "/b"
;                               )
;                :system-include-path '()
;                :spp-table '(("BOOST_TEST_DYN_LINK" . "")))

;; Use Re-Code mode, a template mode, I use yasnippet, so ignore it.
;(global-srecode-minor-mode 1)


;; the function can be folded
(global-semantic-tag-folding-mode 1)


;; 
;; (setq senator-minor-mode-name "SN")
;; (setq semantic-imenu-auto-rebuild-directory-indexes nil)
;; (global-semantic-mru-bookmark-mode 1)
;; 
;; (require 'semantic-decorate-include)
;; (require 'semantic-ia)
;; (require 'semantic-gcc)
;;; use need to update the specific path
;(let ((c++-include-path-list (cond
;                              (wttr/host:MSWSp
;                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
;                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC"))
;                              (wttr/host:HOMEp
;                               (list "D:/Program Files/Microsoft Visual Studio 10.0/VC/include"
;                                     "D:/Program Files/Microsoft Visual Studio 10.0/VC/atlmfc/include"
;                                     "D:/_SRC_/boost/include"))
;                              (t
;                               nil))))
;  (mapc (lambda (x)
;          (semantic-add-system-include x 'c++-mode)
;          (semantic-add-system-include x 'c-mode))
;        c++-include-path-list))
;; 
;; 
;; 
;; (setq-mode-local c-mode semanticdb-find-default-throttle
;;                  '(project unloaded system recursive))
;; (setq-mode-local c++-mode semanticdb-find-default-throttle
;;                  '(project unloaded system recursive))
;; 
;; (require 'eassist)
;; 
;; 
;; (require 'semanticdb-global)
;; (semanticdb-enable-gnu-global-databases 'c-mode)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)
;; (semantic-load-enable-primary-exuberent-ctags-support)
;; 
;; 
;(defun wttr/cedet-hook ()
;  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
;  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
;  ;;
;  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;  (local-set-key "\C-c=" 'semantic-decoration-include-visit)
;
;  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
;  (local-set-key "\C-cq" 'semantic-ia-show-doc)
;  (local-set-key "\C-cs" 'semantic-ia-show-summary)
;  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))
;
;(add-hook 'c-mode-common-hook 'wttr/cedet-hook)
;(add-hook 'c++-mode-hook 'wttr/cedet-hook)
;(add-hook 'emacs-lisp-mode-hook 'wttr/cedet-hook)
;(add-hook 'lisp-mode-hook 'wttr/cedet-hook)
;; 
;; 
;(defun wttr/c-mode-cedet-hook ()
;  ;(local-set-key "." 'semantic-complete-self-insert)
;  ;(local-set-key ">" 'semantic-complete-self-insert)
;  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
;  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
;  (local-set-key "\C-ce" 'eassist-list-methods)
;  (local-set-key "\C-c\C-r" 'semantic-symref))
;
;(add-hook 'c-mode-common-hook 'wttr/c-mode-cedet-hook)
;(add-hook 'c++-mode-hook 'wttr/c-mode-cedet-hook)
;
;;; Always use C++ mode for file
;(add-to-list 'auto-mode-alist '("\\.[hc]$" . c++-mode))
;; 
;; 
;; (require 'semantic-lex-spp)
;; (ede-enable-generic-projects)
;
;
;;;Getting information about tags
;
;;;The semantic-ia package implements several commands, that allows to
;;;get information about classes, functions & variables. As
;;;documentation are used comments, extracted from source code,
;;;including comments, written for Doxygen. Now following commands are
;;;implemented:
;
;;;semantic-ia-show-doc
;;;    shows documentation for function or variable, whose names is
;;;    under point. Documentation is shown in separate buffer. For
;;;    variables this command shows their declaration, including type
;;;    of variable, and documentation string, if it available. For
;;;    functions, prototype of the function is shown, including
;;;    documentation for arguments and returning value (if comments are
;;;    available);
;;;semantic-ia-show-summary
;;;    shows documentation for name under point, but information is
;;;    shown in the mini-buffer, so user will see only variable's
;;;    declaration or function's prototype;
;;;semantic-ia-describe-class
;;;    asks user for a name of the class, and return list of functions
;;;    & variables, defined in given class, and all its parent classes.
;
;;semantic-ia-fast-jump
;;semantic-mrub-switch-tag
;
;
;; ============================
;;         ecb mode
;; ============================
(wttr/plugin:prepend-to-load-path "ecb-2.40")
(require 'ecb-autoloads)

;;error reports if i do not set this var
(setq stack-trace-on-error t)           
;;disable tips, kinda noisy
(setq ecb-tip-of-the-day nil)
;;use 'image style, i like this than 'ascii-guide
(setq ecb-tree-buffer-style 'image)
;;do not remove record in history when kill-buffer
(setq ecb-kill-buffer-clears-history nil)
;;bucket the history by major-mode
(setq ecb-history-make-buckets 'mode)
;use manually update, c-c . r
;(setq ecb-analyse-buffer-sync nil)
;; start ecb in a new frame
(setq ecb-new-ecb-frame nil)
;; use mouse 1 instead of mouse 2
(setq ecb-primary-secondary-mouse-buttons 'mouse-1--C-mouse-1)
;; compile window
;(setq ecb-compile-window-height nil)
;; whether show file in directory-buffer
;(setq ecb-show-sources-in-directories-buffer 'always)
(setq ecb-show-sources-in-directories-buffer
      (list "left7" "left13" "left14" "left15"))


(defun wttr/ecb:smart-switch-layout (layout-name)
  "If the layout name is not current layout, open/swtich to it.
Other close current ecb layout."
  (if (and (boundp 'ecb-minor-mode) ecb-minor-mode)
      (if (string-equal ecb-layout-name layout-name)
          (ecb-deactivate)
        (ecb-layout-switch layout-name))
    (progn
      (setq ecb-layout-name layout-name)
      (ecb-activate))))

(defun wttr/ecb:left-method-layout ()
  (interactive)
  (wttr/ecb:smart-switch-layout "left9"))
  

(defun wttr/ecb:left-directory-layout ()
  (interactive)
  (wttr/ecb:smart-switch-layout "left13"))

    
(defun wttr/ecb:left-directory-method-layout ()
  "Open left directory window, default to left15 layout"
  (interactive)
  (wttr/ecb:smart-switch-layout "left15"))

(global-set-key (kbd "<f11>") 'wttr/ecb:left-directory-layout)
(global-set-key (kbd "<f12>") 'wttr/ecb:left-method-layout)



(provide 'wttr-cedet)
















