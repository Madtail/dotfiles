(require 'autothemer)

(autothemer-deftheme
 dinero "Puede ganar más dinero"

 ((((class color) (min-colors #xFFFFFF))) ;; We're only concerned with graphical Emacs

  ;; Define our color palette
  (dinero-black      "#000000")
  (dinero-white      "#ffffff")
  (dinero-background "#292929")
  (dinero-main-orange "#DDB87E")
  (dinero-quote-green "#508563")
  (dinero-func-yellow "#F8C212")
  (dinero-var-color "#E3BD3E")
  (dinero-fileinfo-black "#111418")
  (dinero-comment-gray "#707070"))
 ;; (dinero-dk-orange  "#eb6123")
 ;; (dinero-purple     "MediumPurple2")
 ;; (dinero-dk-purple  "MediumPurple4")
 ;; (dinero-green      "LightGreen"))

 ;; Customize faces
 ((default                   (:foreground dinero-main-orange :background dinero-background))
  (cursor                    (:background dinero-white))
  (region                    (:background dinero-white))
  (mode-line                 (:background dinero-fileinfo-black))
  (font-lock-keyword-face    (:foreground dinero-func-yellow))
  (font-lock-constant-face   (:foreground dinero-func-yellow))
  (font-lock-string-face     (:foreground dinero-quote-green))
  (font-lock-builtin-face    (:foreground dinero-main-orange))
  (font-lock-function        (:foreground dinero-func-yellow))
  (font-lock-variable-name-face     (:foreground dinero-main-orange))
  (font-lock-function-name-face     (:foreground dinero-main-orange))
  (font-lock-type-face              (:foreground dinero-func-yellow))
  (font-lock-comment-face           (:foreground dinero-comment-gray))

  (org-level-1               (:foreground dinero-quote-green))))


(provide-theme 'dinero)
