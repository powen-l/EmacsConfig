;; -*- coding: utf-8 -*-

(eval-when-compile
  (require 'cl))

(defun wttr/mode-line:current-height ()
  "Return the mode line height of the current window.
NOTE: this function should be used after you apply any font settings.
Otherwise, the return value may not be the corrent value for current fontset."
  (- (elt (window-pixel-edges) 3)
     (elt (window-inside-pixel-edges) 3)))

(defun wttr/mode-line:generate-triangle-image-data (height width)
  (let* ((min-triagle-width (+ (/ height 2) (% height 2)))
         (final-width (max min-triagle-width width))
         (line-format "\"%s%s\",")
         (top-part
          (loop for offset from 1 to (/ height 2)
                collect (format line-format
                                (make-string offset ?.)
                                (make-string (- final-width offset) ? )))))
    (mapconcat #'identity
               (append top-part
                       (if (equal (% height 2) 1)
                           (list (format line-format
                                         (make-string min-triagle-width ?.)
                                         (make-string (- final-width min-triagle-width) ? ))))
                       (reverse top-part))
               "\n")))



(defun wttr/mode-line:create-xpm (height width fg-color bg-color data-generator)
  "Create the xpm image for showing based on the HEIGHT.
The color the triangle is FG-COLOR, and other part is BG-COLOR."
  nil)



;(defun arrow-right-xpm (color1 color2)
;  "Return an XPM right arrow string representing."
;  (format "/* XPM */
;static char * arrow_right[] = {
;\"12 22 2 1\",
;\".	c %s\",
;\" 	c %s\",
;\".           \",
;\"..          \",
;\"...         \",
;\"....        \",
;\".....       \",
;\"......      \",
;\".......     \",
;\"........    \",
;\".........   \",
;\"..........  \",
;\"........... \",
;\"............\",
;\"........... \",
;\"..........  \",
;\".........   \",
;\"........    \",
;\".......     \",
;\"......      \",
;\".....       \",
;\"....        \",
;\"...         \",
;\"..          \",
;\".           \"};"  color1 color2))
;
;(defun arrow-left-xpm (color1 color2)
;  "Return an XPM right arrow string representing."
;  (format "/* XPM */
;static char * arrow_right[] = {
;\"12 22 2 1\",
;\".	c %s\",
;\" 	c %s\",
;\"           .\",
;\"          ..\",
;\"         ...\",
;\"        ....\",
;\"       .....\",
;\"      ......\",
;\"     .......\",
;\"    ........\",
;\"   .........\",
;\"  ..........\",
;\" ...........\",
;\"............\",
;\" ...........\",
;\"   .........\",
;\"    ........\",
;\"     .......\",
;\"      ......\",
;\"       .....\",
;\"        ....\",
;\"         ...\",
;\"          ..\",
;\"           .\"};"  color2 color1))
;
;
;(setq color1 "#00AA00")
;(setq color2 "#AAAAAA")
;
;(setq arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
;(setq arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
;(setq arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
;(setq arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))
;
;(setq-default mode-line-format
; (list  '(:eval (concat (propertize " %b " 'face 'mode-line-color-1)
;                        (propertize " " 'display arrow-right-1)))
;        '(:eval (concat (propertize " %m " 'face 'mode-line-color-2)
;                        (propertize " " 'display arrow-right-2)))
;
;        ;; Justify right by filling with spaces to right fringe - 16
;        ;; (16 should be computed rahter than hardcoded)
;        '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))
;
;        '(:eval (concat (propertize " " 'display arrow-left-2)
;                        (propertize " %p " 'face 'mode-line-color-2)))
;        '(:eval (concat (propertize " " 'display arrow-left-1)
;                        (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
;)) 
;
;(make-face 'mode-line-color-1)
;(set-face-attribute 'mode-line-color-1 nil
;                    :foreground "#0f0f0f"
;                    :background color1)
;
;(make-face 'mode-line-color-2)
;(set-face-attribute 'mode-line-color-2 nil
;                    :foreground "#0f0f0f"
;                    :background color2)
;
;(set-face-attribute 'mode-line nil
;                    :foreground "#0f0f0f"
;                    :background "#000000"
;                    :box nil)
;(set-face-attribute 'mode-line-inactive nil
;                    :foreground "#0f0f0f"
;                    :background "#000000")

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


(provide 'wttr-modeline)
