;; -*- coding: utf-8 -*-

(wttr/plugin:prepend-to-load-path "highlight-symbol-1.1")
(autoload 'highlight-symbol-at-point "highlight-symbol" nil t)
(global-set-key [f3] 'highlight-symbol-at-point)
;(global-set-key [(control f3)] 'highlight-symbol-at-point)
;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;(global-set-key [(meta f3)] 'highlight-symbol-prev)
