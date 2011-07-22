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
;(menu-bar-mode nil)

;; move mouse when cursor is close to it
(mouse-avoidance-mode 'animate)

;; show parent 
(show-paren-mode t)
(setq show-paren-style 'parenthesis )

;; hilight mark area
(transient-mark-mode t)

;; no backup file
(setq-default make-backup-files nil)
;; no auto save
(setq auto-save-default nil)

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

;; grep customize
(eval-after-load 'grep
    '(progn
       (grep-apply-setting 
		 'grep-find-command
		 '("E:/Tools/emacs-23.3/bin/find.exe . -type f -exec E:/Tools/emacs-23.3/bin/grep.exe -nH -e  {} NUL \";\"" . 90 ) )
       (grep-apply-setting 
		 'grep-command
		 "E:/Tools/emacs-23.3/bin/grep.exe -nH -e ")
       (grep-apply-setting 
		 'grep-find-template
		 "E:/Tools/emacs-23.3/bin/find.exe . <X> -type f <F> -exec E:/Tools/emacs-23.3/bin/grep.exe <C> -nH -e <R> {} NUL \";\"" )
       (add-to-list 'grep-files-aliases '("js" . "*.js"))
       (add-to-list 'grep-files-aliases '("all" . "*.*"))
       ;; fix for in windows shell auto extension machanisum
       (dolist (item grep-files-aliases)
         (setcdr item (replace-regexp-in-string "\\*\\." "*\\\\\." (cdr item))))
       (setq grep-find-ignored-files 
             (let ( fixed-grep-find-ignored-files )
               (dolist (item grep-find-ignored-files fixed-grep-find-ignored-files)
                 (add-to-list 'fixed-grep-find-ignored-files (replace-regexp-in-string "\\*\\." "*\\\\\." item)))) )
       )) 

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

;; server
(server-start)
(add-hook 'kill-emacs-hook
          (lambda ()
            (if (file-exists-p "~/.emacs.d/server/server")
                (delete-file "~/.emacs.d/server/server"))))

;; auto-load mode
(global-auto-revert-mode 1)
;(setq global-auto-revert-mode-text " GARev")

;; always split window vertically
(setq split-width-threshold nil)


;;js2 mode
(add-to-list 'load-path "~/.emacs.d/plugins/js2-mode-20090723/")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;; ecb
;(add-to-list 'load-path "~/.emacs.d/plugins/ecb-2.40/")
;(require 'ecb)
;(setq ecb-auto-activate t
;      ecb-tip-of-the-day nil)

;; sr-speedbar
;(add-to-list 'load-path "~/.emacs.d/plugins/sr-speedbar-0.1.8/")
;(require 'sr-speedbar)
;(setq sr-speedbar-right-side nil)
;(setq speedbar-show-unknown-files nil)

;; dos mode
(add-to-list 'load-path "~/.emacs.d/plugins/dos-2.16/")
(autoload 'dos-mode "dos" "Edit Dos scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))


;; occur specific setting
(setq list-matching-lines-default-context-lines 3)


;; hilight-symbol
(add-to-list 'load-path "~/.emacs.d/plugins/highlight-symbol-1.1/")
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)


; (when (string-equal system-type "windows-nt")
;   (progn
;     (setq exec-path
;           '(
;             "E:/Tools/emacs-23.3/bin" 
;             "C:/Python27/"
;             "c:/Program Files/Windows Resource Kits/Tools/"
;             "C:/windows/system32"
;             "C:/windows"
;             "C:/Windows/System32/WindowsPowerShell/v1.0/"
;             "c:/Program Files/Git/cmd"
;             "E:/Tools/ccl-1.6-windowsx86")))

;; nXML
(setq nxml-slash-auto-complete-flag t)
(setq nxml-child-indent 2)
(setq nxml-attribute-indent 4)


(add-to-list 'load-path "~/.emacs.d/plugins/browser-king-ring-1.3a/")
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)


;; use gsl-mode
(add-to-list 'load-path "~/.emacs.d/plugins/gsl-mode/")
(add-to-list 'auto-mode-alist '("\\.gsl$" . gsl-mode))
(autoload 'gsl-mode "gsl-mode" "my gsl mode" t)


;; use easy-motion-mode
(add-to-list 'load-path "~/.emacs.d/plugins/ace-jump-mode/")
;(autoload
;  'ace-jump-mode
;  "ace-jump-mode"
;  "Emacs quick move minor mode"
;  t)
(require 'ace-jump-mode)
;; I also use SPC in viper mode to direct start this mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(setq ace-jump-mode-case-sensitive-search nil)



(provide 'my-basic-setting)
