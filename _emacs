;; -*- encoding=utf8 -*-


;; set user information
(setq user-full-name "winterTTr")
(setq user-mail-address "winterTTr@gmail.com")

;; close startup message
(setq inhibit-startup-message t)


;; Color Theme
(require 'color-theme)
(color-theme-initialize)
(load-file "~/site-lisp/color-theme-subdued.el")
(color-theme-subdued)


;; Font
(create-fontset-from-fontset-spec
 (concat
  "-outline-Bitstream Vera Sans Mono-bold-normal-normal-mono-14-*-*-*-c-*-fontset-BVSM,"
  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
(create-fontset-from-fontset-spec
 (concat
  "-outline-Consolas-bold-normal-normal-mono-14-*-*-*-c-*-fontset-Consolas,"
  "chinese-gb2312:-outline-YaHei Consolas Hybrid-normal-normal-normal-mono-*-*-*-*-c-*-gb2312.1980-0,"
  "sjis:-outline-MS Gothic-normal-normal-normal-mono-13-*-*-*-c-*-jisx0208-sjis" ) )
(set-default-font "fontset-Consolas")


;; turn on syntax hilight
(global-font-lock-mode t)

;; don't ring at error
;(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; show clock at statusline
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)

;;close toolbar
(tool-bar-mode nil)

;; move mouse when cursor is close to it
(mouse-avoidance-mode 'animate)


;; show parent 
(show-paren-mode t)
(setq show-paren-style 'parenthesis )
;(setq show-paren-style 'expression )
(transient-mark-mode t)

;; no backup file
(setq-default make-backup-files nil)

;; line number
(require 'linum)
(global-linum-mode t) 
(setq linum-format "%4d| ")


;; use y --> yes
(fset 'yes-or-no-p 'y-or-n-p)

;; setup for newline auto-appending support
(setq next-line-add-newline t)

;; make the title infomation more useful
(setq frame-title-format
      '( (:eval (system-name) )
        " >> "
        "%f") )

;; setup up a big kill-ring, so i will never miss anything:-)
(setq kill-ring-max 100)

;; set default mode to text-mode
(setq major-mode 'text-mode)

;; name the buffers have same file name in the forward way
(setq uniquify-buffer-name-style 'forward)

;; time stamp support
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S winterTTr")

;; encoding
(set-language-environment 'UTF-8)

;; change C-m and enter
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline )

;; org-mode setting
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; undo tree
(require 'undo-tree)
(global-undo-tree-mode)
;; viper-mode
(setq viper-mode t)
(require 'viper)
(require 'vimpulse)

(load "E:/Tools/ccl-quicklisp/quicklisp/slime-helper.el")
(setq inferior-lisp-program
      (if (getenv "PROGRAMW6432") "wx86cl64.exe" "wx86cl.exe") )


;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3)))   ;; one line at a time
(setq mouse-wheel-progressive-speed nil)              ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                    ;; scroll window under mouse
(setq scroll-step 1)                                  ;; keyboard scroll one line at a time
(setq scroll-margin 3)


;; remove scroll bar
;(set-scroll-bar-mode nil)

;; not use tab, use space to indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; ido mode
(require 'ido)
(ido-mode t)

;; tabbar mode
;(load-file "~/site-lisp/tabbar.el")
(require 'tabbar)
(tabbar-mode t)
(set-face-attribute 'tabbar-default nil
                    :family "Consolas"
                    :background "gray80"
                    :foreground "gray30"
                    :height 1.0
                    )
(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box '(:line-width 1 :color "gray30")
                    )
(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :foreground "DarkGreen"
                    :background "LightGoldenrod"
                    :box '(:line-width 2 :color "DarkGoldenrod")
                    ;; :overline "black"
                    ;; :underline "black"
                    :weight 'bold
                    )
(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :box '(:line-width 2 :color "gray70")
                    )



;; grep custom on window
(setq grep-find-command '("E:/Tools/emacs-23.3/bin/find.exe . -type f -exec E:/Tools/emacs-23.3/bin/grep.exe -nH -e  {} NUL \";\"" . 90 ) )
(setq grep-command "E:/Tools/emacs-23.3/bin/grep.exe -nH -e ")


;; setup startup window size
(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

(defun w32-maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

(run-with-idle-timer 0.2 nil 'w32-send-sys-command 61488)


;; using ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;
(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list 
      '(try-expand-dabbrev
	try-expand-dabbrev-visible
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-complete-file-name-partially
	try-complete-file-name
	try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol))


;; show column number in mode line
(setq column-number-mode t)
;(setq global-mode-string (append global-mode-string  '("  [" default-directory "]") ))
(setq-default mode-line-format
      '( "%e"
         "-"
         ("[" (:eval (format "%s" buffer-file-coding-system)) ":")   ;mode-line-mule-info, use more readable format
         ;mode-line-client, remove
         ("" mode-line-modified "]") ; change format to be together with encoding
         ;mode-line-remote, remove
         ;mode-line-frame-identification, remove
         "["
         mode-line-buffer-identification
         "]"
         mode-line-position
         (vc-mode vc-mode)
         mode-line-modes
         ("" viper-mode-string)    ;global-mode-string, disable time show
         ("[" default-directory "]")
         "-%-" ) )



;; some useful key binding
(global-set-key (kbd "M-1") 'delete-other-windows)

;; quick open internal shell
(defun kid-switch-to-shell ()
  (interactive)
  (when (null (cdr (window-list)))
    (split-window-vertically))
  (let ((file buffer-file-name))
    (other-window 1)
    (shell)
    (when file
      (end-of-buffer)
      (when (looking-back shell-prompt-pattern)
        (insert "cd " (file-name-directory file))
        (call-interactively 'comint-send-input)))))
(global-set-key (kbd "<C-S-f6>") 'kid-switch-to-shell)


;; open file in current buffer from outer explorer
(defun w32-open-current-file-in-explorer ()
  "open the current buffer file in windows explorer"
  (interactive)
  (let ((file buffer-file-name))
    (when file
      (w32-shell-execute
       nil
       "explorer.exe"
       (concat "/e,/select," (replace-in-string file "/" "\\\\") )))))
(global-set-key (kbd "<C-f5>") 'w32-open-current-file-in-explorer)

; open external shell from current file directory
(defun w32-open-shell-from-current-file-directory ()
  "open cmd from current file directory"
  (interactive)
  (let ((file buffer-file-name))
    (when (and file (file-name-directory file))
      (w32-shell-execute
       nil
       "cmd.exe"
       (concat "/k cd /d" (file-name-directory file))))))
(global-set-key (kbd "<C-f6>") 'w32-open-shell-from-current-file-directory)




;; c setting
(setq-default c-basic-offset 4)

;; python
(setq-default py-indent-offset 4)

;; auto complete
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete-1.3.1/dict")
(ac-config-default)


(setq ac-auto-show-menu t)
(setq ac-auto-show-menu 0.8)
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)          ;default is 1.5
(setq ac-dwim t)                        ;behavior of completion by TAB will be changed as a behavior of completion by RET


;(global-auto-complete-mode t)
;(setq-default ac-sources '(ac-source-words-in-same-mode-buffers))
;(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
;(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
;(set-face-background 'ac-candidate-face "lightgray")
;(set-face-underline 'ac-candidate-face "darkgray")
;(set-face-background 'ac-selection-face "steelblue")


;; yasnippet
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")


;(add-to-list 'load-path "~/.emacs.d/plugins/pymacs")
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-load "pymacs" nil t)
; 
;;; Initialize Rope                                                                                             
;(pymacs-load "ropemacs" "rope-")
;(setq ropemacs-enable-autoimport t)

