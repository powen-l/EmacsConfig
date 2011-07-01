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
(require 'json)


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

(defconst gsl-summary-indent-step 2
  "indent for each step")

(defconst gsl-header-configuration-name "http://www.gomez.com/headers"
  "the configuration with `name' attribute to this is a header configuration")

(defconst gsl-summary-format-config-flag "C"
  "flag for configuration")

(defconst gsl-summary-format-config-name-length 50
  "the format length used to configuration")

(defconst gsl-summary-format-config-delimiter ":"
  "delimiter for config
such as `name' : `value' ")

(defconst gsl-summary-format-header-flag "H"
  "flag for header")

(defconst gsl-summary-format-header-length 30
  "the format length used to configuration")

(defconst gsl-summary-format-header-delimiter ":"
  "delimiter for config
such as `header-name' : `header-value' ")

(defconst gsl-summary-format-property-flag "P"
  "flag for header")

(defconst gsl-summary-format-property-length 20
  "the format length used to configuration")

(defconst gsl-summary-format-property-delimiter ":"
  "delimiter for config
such as `header-name' : `header-value' ")

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
    ;(narrow-to-region gsl-summary-region-begin gsl-summary-region-end)))
    ))


(defun gsl-insert-summary-content ( txn )
  "insert the summary content based on the xml txn node"
  ; insert txn part : property , configuration, header
  (insert "[Transaction]\n")
  ; insert properties
  (let ((fmt (gsl-gen-insert-fmt "property")))
    (dolist (attrib (xml-node-attributes txn))
      (insert (format fmt
                      (symbol-name (car attrib))
                      (cdr attrib)))
      (insert "\n"))))
  ; insert configuration of transaction
  ;(gsl-insert-configurations txn)
  ;(insert "\n"))
  ;; insert step of transaction
  ;(gsl-insert-steps-section txn))


(defmacro gsl-gen-insert-fmt(type)
  `(concat ,(intern (concat "gsl-summary-format-" type "-flag"))
           "| %-"
           (number-to-string
            ,(intern (concat "gsl-summary-format-" type "-length")))
           "s"
           ,(intern (concat "gsl-summary-format-" type "-delimiter"))
           "[%s]"))



(defun gsl-insert-configurations (node)
  "insert configuration of current node"
  (let ((configs (xml-get-children node 'Configuration)))
    (dolist (config configs)
      (let ((flag nil))
        (if (string= (xml-get-attribute config 'name)
                     gsl-header-configuration-name)
            (setq flag "H")
          (setq flag "C"))
        (dolist (param (xml-node-children config))
          (insert (format "%s| %-50s: [%s]\n"
                          flag
                          (xml-get-attribute param 'name)
                          (xml-get-attribute param 'value))))))))

(defun gsl-insert-steps-section (txn)
  "insert step for txn"
  (let ((steps (xml-get-children txn 'PageRequest))
        ;(indent (make-string indent-size ?\ ))
        (step-index 1))
    (dolist (step steps)
      (insert (format "[%s%2d]\n"
                      "Step"
                      step-index)))))



;(provide 'gsl-mode)
