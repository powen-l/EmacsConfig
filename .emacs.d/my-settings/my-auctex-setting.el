;; -*- coding: utf-8 -*-


(add-to-list 'load-path "~/.emacs.d/plugins/auctex-11.86-e23.3-msw/site-lisp/site-start.d")
(add-to-list 'load-path "~/.emacs.d/plugins/auctex-11.86-e23.3-msw/site-lisp/auctex")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(if (string= system-type "windows-nt")
    (require 'tex-mik))

(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'LaTex-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-auto-untabify t     ; remove all tabs before saving
                  TeX-engine 'xetex       ; use xelatex default
                  TeX-show-compilation t) ; display compilation windows
            (TeX-global-PDF-mode t)       ; PDF mode enable, not plain
            (setq TeX-save-query nil)
            (imenu-add-menubar-index)
            (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))

(provide 'my-auctex-setting)