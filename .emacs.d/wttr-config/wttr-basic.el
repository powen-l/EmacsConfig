;; -*- coding: utf-8 -*-

;; set user information
(setq user-full-name "winterTTr")
(setq user-mail-address "winterTTr@gmail.com")

;====================================
;  UI
;====================================
;; close startup message
(setq inhibit-startup-message t)

;; turn on syntax hilight
(global-font-lock-mode t)

;; close toolbar and menu bar
(tool-bar-mode 0)
;(menu-bar-mode 0)
;; remove scroll bar
;(set-scroll-bar-mode nil)

;; show clock at statusline, now i close the clock
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)

;; show column number in mode line
(setq column-number-mode t)

;; show parent 
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; hilight mark area
(transient-mark-mode t)

;; make the title infomation more useful
(setq frame-title-format
      '( (:eval (system-name) )
        " >> "
        "%f") )

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
         ;("" viper-mode-string)    ;global-mode-string contains it
         global-mode-string
         ;("[" default-directory "]")
         "-%-" ) )

;; setup startup window size
(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

(defun w32-maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

(run-with-idle-timer 0.2 nil 'w32-maximize-frame)

;===================================
; Control
;===================================
;; don't ring at error
(setq ring-bell-function 'ignore)

;; can use the narrow to region
(put 'narrow-to-region 'disabled nil)

;; use mouse to copy thing automatically
(setq mouse-drag-copy-region t)


;; move mouse when cursor is close to it
;(mouse-avoidance-mode 'animate)
(mouse-avoidance-mode 'none)

;; no backup file, and auto save
(setq-default make-backup-files nil)
(setq auto-save-default nil)

;; use y --> yes
(fset 'yes-or-no-p 'y-or-n-p)

;; setup for newline auto-appending support
(setq next-line-add-newline t)

;; encoding
(set-language-environment 'UTF-8)

;; setup up a big kill-ring, so i will never miss anything:-)
(setq kill-ring-max 100)

;; set default mode to text-mode
(setq-default major-mode 'text-mode)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3)))   ;; one line at a time
(setq mouse-wheel-progressive-speed nil)              ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                    ;; scroll window under mouse
(setq scroll-step 1)                                  ;; keyboard scroll one line at a time
(setq scroll-margin 3)

;; not use tab, use space to indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

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

;; c setting
(setq-default c-basic-offset 4)

;; auto-load mode
(global-auto-revert-mode 1)

;; always split window vertically
(setq split-width-threshold nil)

;; server
;(setq server-mode-forbidden-list '("WINTERTTR-WS"))
(setq server-mode-forbidden-list nil)
(when (not (member (system-name) server-mode-forbidden-list))
    (server-start)
    (add-hook 'kill-emacs-hook
              (lambda ()
                (if (file-exists-p "~/.emacs.d/server/server")
                    (delete-file "~/.emacs.d/server/server")))))

;; add extra binary path
(when (string-equal system-type "windows-nt")
  (mapc #'wttr/add-to-exec-path
        '("~/.emacs.d/extra-bin"
          "~/.emacs.d/unix-utils-bin"
          "~/bin")))

;; time stamp support
;(setq time-stamp-active t)
;(setq time-stamp-warn-inactive t)
;(add-hook 'write-file-hooks 'time-stamp)
;(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S winterTTr")


;========================================
; Some mode setting
;========================================
;; grep mode customize
;;
;; we do not need to setup the grep command, use the correct exec-path
;; and "PATH" env is enough
;;
;(grep-apply-setting 
; 'grep-find-command
; '("E:/Tools/Emacs/bin/find.exe . -type f -exec E:/Tools/Emacs/bin/grep.exe -nH -ie  {} NUL \";\"" . 80 ) )
;(grep-apply-setting 
; 'grep-command
; "E:/Tools/Emacs/bin/grep.exe -nH -ie ")
;(grep-apply-setting 
; 'grep-find-template
; "E:/Tools/Emacs/bin/find.exe . <X> -type f <F> -exec E:/Tools/Emacs/bin/grep.exe <C> -nH -ie <R> {} NUL \";\"" )
;(setq grep-program "grep.exe")
;(setq find-program "find.exe")

;; quick for use ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;js2 mode
(add-to-list 'load-path "~/.emacs.d/plugins/js2-mode-20090723/")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; dos mode
(add-to-list 'load-path "~/.emacs.d/plugins/dos-2.16/")
(autoload 'dos-mode "dos" "Edit Dos scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))

;; occur specific setting
(setq list-matching-lines-default-context-lines 2)

;; hilight-symbol
(add-to-list 'load-path "~/.emacs.d/plugins/highlight-symbol-1.1/")
(autoload 'highlight-symbol-at-point "highlight-symbol" nil t)
(global-set-key [f3] 'highlight-symbol-at-point)
;(global-set-key [(control f3)] 'highlight-symbol-at-point)
;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;(global-set-key [(meta f3)] 'highlight-symbol-prev)


;; nXML
(setq nxml-slash-auto-complete-flag t)
(setq nxml-child-indent 2)
(setq nxml-attribute-indent 4)


;browser kill ring mode
(add-to-list 'load-path "~/.emacs.d/plugins/browser-king-ring-1.3a/")
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; use gsl-mode, for gomez, but there is no use now
;(add-to-list 'load-path "~/.emacs.d/plugins/gsl-mode/")
;(add-to-list 'auto-mode-alist '("\\.gsl$" . gsl-mode))
;(autoload 'gsl-mode "gsl-mode" "my gsl mode" t)

;; use ace-jump-mode
(add-to-list 'load-path "~/.emacs.d/plugins/ace-jump-mode/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; I also use SPC in viper mode to direct start this mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(setq ace-jump-mode-case-sensitive-search nil)

;; window move mode
(windmove-default-keybindings 'meta)

;; gtags
(add-to-list 'load-path "~/.emacs.d/plugins/gtags")
(autoload 'gtags-mode "gtags" "" t)

;; package manager
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))

;; powershell-mode
(add-to-list 'load-path "~/.emacs.d/plugins/powershell-mode-0.5")
(autoload 'powershell-mode "powershell-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ps[12]?$" . powershell-mode))

;; undo tree mode
(add-to-list 'load-path "~/.emacs.d/plugins/undo-tree-0.3")
(require 'undo-tree)
(global-undo-tree-mode)

;; ido mode
(require 'ido)
(ido-mode t)

;; tempbuf mode
(add-to-list 'load-path "~/.emacs.d/plugins/tempbuf-mode")
(require 'tempbuf)
(add-hook 'help-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'grep-mode-hook 'turn-on-tempbuf-mode)

;; sr-speedbar
;(add-to-list 'load-path "~/.emacs.d/plugins/sr-speedbar-0.1.8/")
;(require 'sr-speedbar)
;(setq sr-speedbar-right-side nil)
;(setq speedbar-show-unknown-files nil)

(add-to-list 'load-path "~/.emacs.d/plugins/csharp-mode")
(autoload 'csharp-mode "csharp-mode-0.8.5" nil t)
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))

;(add-to-list 'load-path "~/.emacs.d/plugins/anything")
;(require 'anything-config)

(provide 'wttr-basic)
