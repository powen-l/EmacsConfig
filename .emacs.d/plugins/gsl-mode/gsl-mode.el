;;; gsl-mode.el --- a script viewer and editor for gomez script

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author:   winterTTr <winterTTr@gmail.com>
;; Keywords: gomez, gslv2

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;; INTRODUCTION
;;
;; gsl-mode is a major mode for view and edit gomez script, which with
;; the suffix as gsl


(defvar gsl-mode-hook nil
  "*List of the functions called when enter gsl-mode")

(defvar gsl-mode-map nil
  "key map for gsl-mode")

(if gsl-mode-map
    nil
  (setq gsl-mode-map (make-sparse-keymap))
  ;;(define-key gsl-mode-map key command)
  )

(defvar gsl-summary-region-begin nil
  "The marker for begin of summary region")

(defvar gsl-summary-region-end nil
  "The marker for end of summary region")

(defconst gsl-summary-indent-txn-config 4
  "indend for txn config")

(defconst gsl-summary-indent-step 2
  "indent for each step")


(defun gsl-mode ()
  "major mode for edit gsl file"
  (interactive)
  (kill-all-local-variables)
  (text-mode)

  ;; setup major mode
  (setq major-mode 'gsl-mode)
  (setq mode-name "GSLv2")
  (use-local-map gsl-mode-map)

  ;; create local variable
  (make-local-variable 'gsl-summary-region-begin)
  (make-local-variable 'gsl-summary-region-end)

  (gsl-summary-from-buffer)
  (run-hooks 'gsl-mode-hook) )


(defun gsl-summary-from-buffer ()
  "we analyze the buffer to generate information"
  ; clear former summary first
  (interactive)
  (widen)
  (when (not (null gsl-summary-region-begin))
      (delete-region gsl-summary-region-begin gsl-summary-region-end))
  ; make new summary
  (let ( (txn (car (xml-parse-region (point-min) (point-max)))) )
    (if (null txn)
        (error "not a valid xml format"))
    (goto-char (point-max))
    (setq gsl-summary-region-begin (point-marker))
    (gsl-insert-summary-content txn)
    (goto-char (point-max))
    (setq gsl-summary-region-end (point-marker))
    (narrow-to-region gsl-summary-region-begin gsl-summary-region-end) )
  nil)


(defun gsl-insert-summary-content ( txn )
  "insert the summary content based on the xml txn node"
  (insert "[Transaction]\n")
  ; insert config for this transaction
  (let ((configs (gsl-txn-configs txn))
        (indent (make-string gsl-summary-indent-txn-config ?\ )))
    (dolist (config configs)
      (dolist (param (gsl-config-params config))
        (insert (format "%s%-50s: [%s]\n"
                        indent
                        (gsl-param-name param)
                        (gsl-param-value param)))
        ))
    )
  ; insert step for this transaction
  (let ((steps (gsl-txn-steps txn))
        (indent (make-string gsl-summary-indent-step ?\ ))
        (step-index 1) )
    (dolist (step steps)
      (insert (format "%s[%s%2d]\n"
                      indent
                      "Step"
                      step-index))
      ))
  )

(defun gsl-config-params( config )
  (nthcdr 2 config))

(defun gsl-param-name(param)
  (if (not (eq (car param) 'Param))
      (error "Not invalid param item"))
  (let ((name-cons (first (nth 1 param))))
    (cdr name-cons)))
        
(defun gsl-param-value(param)
  (if (not (eq (car param) 'Param))
      (error "Not invalid param item"))
  (let ((value-cons (second (nth 1 param))))
    (cdr value-cons)))

(defun gsl-txn-properties( txn )
  (nth 1 txn))

(defun gsl-txn-configs( txn )
  (remove-if-not (lambda(e)
                   (eq (car e) 'Configuration) )
                 (cdr txn)))


(defun gsl-txn-step( txn )
  (remove-if-not (lambda(e)
                   (eq (car e) 'PageRequest) )
                 (cdr txn)))





;(provide 'gsl-mode)
