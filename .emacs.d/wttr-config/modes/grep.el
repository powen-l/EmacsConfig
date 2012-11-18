;; -*- coding: utf-8 -*-

;; we do not need to setup the grep command, use the correct exec-path
;; and "PATH" env is enough
(require 'grep)
(grep-apply-setting
 'grep-find-use-xargs 'exec)

(grep-apply-setting 'grep-highlight-matches 'always)

(if wttr/os:windowsp
    (grep-apply-setting
     'grep-find-template
     (concat "find . <X> -type f <F> -exec "
             "E:/Tools/emacs/.emacs.d/extra-bin/gnuwin32/grep.exe <C> -nH -e <R> {} \";\"")))

;; for windows perl need to install Win32::Console::ANSI
;; perl -MCPAN -e shell
;; ftp://freesoft.cgi.gov.cn/pub/languages/perl/CPAN
;; install Win32::Console::ANSI

;; (grep-apply-setting
;;  'grep-find-template 
;;  "\"c:/Program Files/git/bin/perl.exe\"
;;  "\"E:/Tools/emacs/.emacs.d/extra-bin/ack/ack-standalone.pl\"
;;  --color --nogroup <R>")

;(when wttr/os:windowsp
;  (defadvice grep-expand-template
;    (around grep-expand-template-w32-around (template &optional regexp files dir excl))
;    "A patch for the windows system, as the [find . -iname \"balabala\" -exec grep \"grep-bala\" {} ;] will
;result as a seperate windows process [grep grep-balaba file-name-from-find].
;When grep-bala contains *, this will lead to very wierd result as the paramter is not quoted in new process.
;So I patch it."
;    (cond
;     ((string-match-p "^find.*grep" template)
;      (let ((regexp (format "\"%s\"" regexp)))
;        ad-do-it))
;     ((string-match-p "^grep.*" template)
;      ad-do-it)
;     (t
;      ad-do-it)))
;  (ad-activate 'grep-expand-template))



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
