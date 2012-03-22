;;; windiff-comment-mode.el --- mode for visit the windiff comment

;; Author   : winterTTr <winterTTr@gmail.com>
;; Version  : 1.0
;; Keywords : windiff comment compilation

(setq windiff-comment-regexp-alist
;;  "Rules that need to match format of the windiff comment"
      (list
                                        ;("^File:\\(.+\\), Total comments:[0-9]+$" 1)
       (list "^Comment\\(.*\\)$"
             (lambda ()
               (message "123")
               ))))

;;  '(("^\\(.+?\\)\\(:[ \t]*\\)\\([1-9][0-9]*\\)\\2"

(define-compilation-mode windiff-comment-mode "Windiff-Comment"
  "Used to easily visit the information in windiff comments result."
  (set (make-local-variable 'compilation-error-regexp-alist)
        windiff-comment-regexp-alist))
