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


;; custom keybindings
(global-set-key (kbd "C-c m") 'recompile)

;; line numbers
(global-linum-mode 1) ; always show line numbers



;; Indent mode
(setq c-default-style "linux")

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
; Shows column number
(column-number-mode 1)


;; Linter
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Zoom with mouse-scroll
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

;; smooth scroll
(setq scroll-step 3)

;; set startup directory
(setq default-directory "~/")

;; set font
(add-to-list 'default-frame-alist
             '(font . "Liberation Mono"))

;; Set default font
(set-face-attribute 'default nil
                    :family "Liberation Mono"
                    :height 110
                    :weight 'normal
                    :width 'normal)

;;; END of Code ;; ------------------------------------------------------------------------------------------------------------------
;;; Install packages
(require 'package)

(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")


; list the packages you want
(setq package-list
      '(yasnippet comment-tags omnisharp autothemer
       auto-complete flycheck gdscript-mode
	csharp-mode yaml-mode ac-ispell))


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
(add-to-list 'load-path "C:/Users/alber/AppData/Roaming/.emacs.d/elpa/go-mode-20191018.2048")
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

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

(provide 'init);;; init.el ends here
