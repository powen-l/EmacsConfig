;; -*- coding: utf-8 -*-

;; set user information
(setq user-full-name "winterTTr")
(setq user-mail-address "winterTTr@gmail.com")

;; encoding
(set-language-environment 'UTF-8)

;; close startup message
(setq inhibit-startup-message t)

;; turn on syntax hilight
(global-font-lock-mode t)

;; don't ring at error
(setq ring-bell-function 'ignore)

;; show clock at statusline, now i close the clock
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)

;; close toolbar and menu bar
(tool-bar-mode nil)
(menu-bar-mode nil)

;; move mouse when cursor is close to it
(mouse-avoidance-mode 'animate)

;; show parent 
(show-paren-mode t)
(setq show-paren-style 'parenthesis )

;; hilight mark area
(transient-mark-mode t)

;; no backup file
(setq-default make-backup-files nil)

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
(setq-default major-mode 'text-mode)

;; name the buffers have same file name in the forward way
(setq uniquify-buffer-name-style 'forward)

;; time stamp support
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S winterTTr")

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

;; c setting
(setq-default c-basic-offset 4)

;; python
(setq-default py-indent-offset 4)


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

(provide 'my-basic-setting)
