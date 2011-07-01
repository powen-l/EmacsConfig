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


(require 'xml)


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
  ; delete old summary 
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
    (narrow-to-region gsl-summary-region-begin gsl-summary-region-end)))


(defun gsl-insert-summary-content ( txn )
  "insert the summary content based on the xml txn node"
  (insert "[Transaction]\n")
  ; insert configuration of transaction
  (gsl-insert-configurations txn gsl-summary-indent-txn-config)
  ; insert step of transaction
  (gsl-insert-steps txn gsl-summary-indent-step))


(defun gsl-insert-configurations (node indent-size)
  "insert configuration of current node"
  (let ((configs (xml-get-children node 'Configuration))
        (indent (make-string indent-size ?\ )))
    (dolist (config configs)
      (dolist (param (xml-node-children config))
        (insert (format "%s%-50s: [%s]\n"
                        indent
                        (xml-get-attribute param 'name)
                        (xml-get-attribute param 'value)))))))

(defun gsl-insert-steps (txn indent-size)
  "insert step for txn"
  (let ((steps (xml-get-children txn 'PageRequest))
        (indent (make-string indent-size ?\ ))
        (step-index 1) )
    (dolist (step steps)
      (insert (format "%s[%s%2d]\n"
                      indent
                      "Step"
                      step-index)))))



;(provide 'gsl-mode)
