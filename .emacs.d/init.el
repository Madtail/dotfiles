;;; custom variables file
(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; ------------------------------------------------------------------------------------------------------------------
;;; Code:

; toolbars
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

; Startup Windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(split-window-horizontally)


;;; custom keybindings
(global-set-key (kbd "C-c m") 'recompile)

;; Movement
(global-set-key "\C-p" 'backward-paragraph)
(global-set-key "\C-n" 'forward-paragraph)

;; line numbers
(global-display-line-numbers-mode 1)  ; always show line numbers

; 4-space tabs
(setq-default tab-width 4
	      indent-tabs-mode nil)
(setq indent-line-function 'insert-tab)

; Get rid of the startup message
(setq inhibit-startup-message t)
; Show file full path in title bar
(setq-default frame-title-format
   (list '((buffer-file-name " %f"
             (dired-directory
              dired-directory
              (revert-buffer-function " %b"
              ("%b - Dir:  " default-directory)))))))
; Shows parenthesis
(show-paren-mode 1)
;; Automatic pairing
(electric-pair-mode 1)
; Shows column number
(column-number-mode 1)


; Stop Emacs from losing undo information by
; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; Linter
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Zoom with mouse-scroll
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

;; smooth scroll
(setq scroll-step 3)

;; set startup directory
(setq default-directory "~/work")

;; set font
(add-to-list 'default-frame-alist
             '(font . "Hack"))

;; Set default font
(set-face-attribute 'default nil
                    :family "Hack"
                    :height 110
                    :weight 'normal
                    :width 'normal)



;;; END of Code ;; ------------------------------------------------------------------------------------------------------------------
;;; Install packages
(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")


; list the packages you want
(setq package-list
      '(yasnippet comment-tags omnisharp autothemer
       auto-complete flycheck gdscript-mode
	csharp-mode yaml-mode ac-ispell haskell-mode ada-mode))


; activate all the packages
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; -----------------------------------------------------

; csharp
(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (electric-pair-mode 1)       ;; Emacs 24
  (electric-pair-local-mode 1) ;; Emacs 25
  )
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

(package-install 'omnisharp)

; auto-complete
;;(package-initialize)
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;yasnippet
(add-to-list 'load-path
                "~/path-to-yasnippet")
   (require 'yasnippet)
   (yas-global-mode 1)

;; TODO Highlighting
(require 'comment-tags)
(autoload 'comment-tags-mode "comment-tags-mode")
(setq comment-tags-keymap-prefix (kbd "C-c t"))
(with-eval-after-load "comment-tags"
  (setq comment-tags-keyword-faces
        `(("TODO" . ,(list :weight 'bold :foreground "#28ABE3"))
          ("FIXME" . ,(list :weight 'bold :foreground "#DB3340"))
          ("BUG" . ,(list :weight 'bold :foreground "#DB3340"))
          ("HACK" . ,(list :weight 'bold :foreground "#E8B71A"))
          ("KLUDGE" . ,(list :weight 'bold :foreground "#E8B71A"))
          ("XXX" . ,(list :weight 'bold :foreground "#F7EAC8"))
          ("INFO" . ,(list :weight 'bold :foreground "#F7EAC8"))
          ("DONE" . ,(list :weight 'bold :foreground "#1FDA9A"))))
  (setq comment-tags-comment-start-only t
        comment-tags-require-colon t
        comment-tags-case-sensitive t
        comment-tags-show-faces t
        comment-tags-lighter nil))
(add-hook 'prog-mode-hook 'comment-tags-mode)

;; GDscript

(require 'python)

(defvar gdscript-mode-map
  (make-keymap)
  "Keymap for gdscript major mode.")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.gd\\'" . gdscript-mode))


(defvar gdscript-font-lock-keywords
  `((,(concat "\\<"
              (regexp-opt '("if" "elif" "else" "for" "do" "while" "switch" "case"
	                    "break" "continue" "pass" "return" "class" "extends" "tool"
	                    "signal" "func" "static" "const" "enum" "var" "onready"
	                    "export" "setget" "breakpoint"))
              "\\>")
     . font-lock-keyword-face)
    ("func +\\([A-Za-z0-9_]+\\)" (1 font-lock-function-name-face))
    ("\\([A-Za-z0-9_.]+\\)\s*=" (1 font-lock-variable-name-face))))

(defvar gdscript-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    st)
  "Syntax table for `gdscript-mode'.")

(defvar gdscript-imenu-generic-expression
  (setq gdscript-imenu-generic-expression
	'((nil "func +\\|class +\\([A-Za-z0-9_]+\\)" 1))))

(defvar gdscript-mode-abbrev-table)

;;;###autoload
(define-derived-mode gdscript-mode prog-mode "GDScript"
  "Major mode for editing Godot GDScript files"
  :syntax-table gdscript-mode-syntax-table
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+\\s-*")
  (setq-local font-lock-defaults '(gdscript-font-lock-keywords))
  (setq-local indent-line-function 'python-indent-line-function)
  (setq-local indent-tabs-mode t)
  (setq-local tab-width 4)
  (setq-local imenu-generic-expression gdscript-imenu-generic-expression))

(provide 'gdscript-mode)

;; go mode
;;(add-to-list 'load-path "C:/Users/alber/AppData/Roaming/.emacs.d/elpa/go-mode-20191018.2048")
;;(autoload 'go-mode "go-mode" nil t)
;;(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; spelling
(add-hook 'some-mode-hook 'ac-ispell-ac-setup)



(eval-after-load "auto-complete"
  '(progn
      (ac-ispell-setup)))

(add-hook 'git-commit-mode-hook 'ac-ispell-ac-setup)
(add-hook 'mail-bbmode-hook 'ac-ispell-ac-setup)

;; assembly language
(defun my-asm-mode-hook ()
  ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (local-unset-key (vector asm-comment-char))
  ;; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent)))

(add-hook 'asm-mode-hook #'my-asm-mode-hook)



;; YAML
 (require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

; Accepted file extensions and their appropriate modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))

; C++ indentation style
(defconst casey-big-fun-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
    "Casey's Big Fun C++ Style")

; CC++ mode handling
(defun casey-big-fun-c-hook ()
  ; Set my style for the current buffer
  (c-add-style "BigFun" casey-big-fun-c-style t)

 ; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ; Newline indents, semi-colon doesn't
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

  ; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t))

  ; Abbrevation expansion
  (abbrev-mode 1)


  

(provide 'init);;; init.el ends here
