(require 'autothemer)

(autothemer-deftheme
 dinero "Puede ganar más dinero"

 ((((class color) (min-colors #xFFFFFF))) ;; We're only concerned with graphical Emacs

  ;; Define our color palette
  (dinero-black      "#000000")
  (dinero-white      "#ffffff")
  ;; (dinero-background "#292929")
  (dinero-background "#1F1F1F")
  (dinero-main-orange "#DDB87E")
  (dinero-quote-green "#667B28")
  (dinero-func-yellow "#F8C212")
  (dinero-var-color "#E3BD3E")
  (dinero-fileinfo-black "#111418")
  ;;  (dinero-comment-gray "#707070"))
  (dinero-comment-gray "#7A7A7A")
  (dinero-mark-blue "#002D8F")
  (dinero-modeline-gray "#D6D6D6")
 ;; (dinero-dk-orange  "#eb6123")
  (dinero-purple     "#AA3ECF")
  (dinero-another-purple "#3F0B7A")
  (dinero-number-green "#AFEB78")
  (dinero-another-orange     "#FA7602")
  (dinero-special-orange     "#FAB002")
  (dinero-ref-orange "#FCE979"))
 ;; (dinero-dk-purple  "MediumPurple4")
 ;; (dinero-green      "LightGreen"))

 ;; Customize faces
 ((default                   (:foreground dinero-main-orange :background dinero-background))
  (cursor                    (:background dinero-quote-green))
  (region                    (:background dinero-mark-blue))
  (mode-line                 (:foreground dinero-black :background dinero-modeline-gray))
  (mode-line-faces           (:foreground dinero-black))
  (font-lock-keyword-face    (:foreground dinero-func-yellow))
  (font-lock-constant-face   (:foreground dinero-another-orange))
  (font-lock-string-face     (:foreground dinero-quote-green))
  (font-lock-builtin-face    (:foreground dinero-ref-orange))
  (font-lock-function        (:foreground dinero-func-yellow))
  (font-lock-function-call-face     (:foreground dinero-func-yellow))
  (font-lock-variable-name-face     (:foreground dinero-main-orange))
  (font-lock-function-name-face     (:foreground dinero-special-orange))
  (font-lock-type-face              (:foreground dinero-func-yellow))
  (font-lock-comment-face           (:foreground dinero-comment-gray))
  (font-lock-number-face            (:foreground dinero-purple))
  (font-lock-operator-face          (:foreground dinero-number-green))
  (font-lock-variable-use-face      (:foreground dinero-ref-orange))
;;  (font-lock-preprocessor-face      (:foreground dinero-another-purple))
  (font-lock-extra-types     (:foreground dinero-purple))

  (org-level-1               (:foreground dinero-quote-green))))


(provide-theme 'dinero)
