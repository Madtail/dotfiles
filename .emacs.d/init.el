;; Theme stuff
(load "~/.emacs.d/wood.el")

;;; custom variables file
(setq byte-compile-warnings '((not cl-functions)))
;;(setq debug-on-error t)
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
(global-set-key (kbd "M--") 'comment-dwim)

;; Movement
(global-set-key "\C-p" 'backward-paragraph)
(global-set-key "\C-n" 'forward-paragraph)

;; line numbers
(global-display-line-numbers-mode 1)  ; always show line numbers

;; Spaces instead of tabs
(setq-default indent-tabs-mode nil)

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
; SETTING VERY HIGH LIMITS FOR UNDO buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

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
                    ;;:height 110
                    :height 200
                    :weight 'normal
                    :width 'normal)


;; Disable system bell
(setq ring-bell-function 'ignore)


;; Cool commands totally my own ---------------------------------------------------------
(defun xah-copy-line-or-region ()
  "Copy current line or selection.

Copy current line. When called repeatedly, append copy subsequent lines.
Except:

If `universal-argument' is called first, copy whole buffer (respects `narrow-to-region').
If `rectangle-mark-mode' is on, copy the rectangle.
If `region-active-p', copy the region.

URL `http://xahlee.info/emacs/emacs/emacs_copy_cut_current_line.html'
Created: 2010-05-21
Version: 2024-06-19"
  (interactive)
  (cond
   (current-prefix-arg (copy-region-as-kill (point-min) (point-max)))
   ((and (boundp 'rectangle-mark-mode) rectangle-mark-mode)
    (copy-region-as-kill (region-beginning) (region-end) t))
   ((region-active-p) (copy-region-as-kill (region-beginning) (region-end)))
   ((eq last-command this-command)
    (if (eobp)
        nil
      (progn
        (kill-append "\n" nil)
        (kill-append (buffer-substring (line-beginning-position) (line-end-position)) nil)
        (end-of-line)
        (forward-char))))
   ((eobp)
    (if (eq (char-before) 10)
        (progn)
      (progn
        (copy-region-as-kill (line-beginning-position) (line-end-position))
        (end-of-line))))
   (t
    (copy-region-as-kill (line-beginning-position) (line-end-position))
    (end-of-line)
    (forward-char))))

(defun xah-cut-line-or-region ()
  "Cut current line or selection.
If `universal-argument' is called first, cut whole buffer (respects `narrow-to-region').

URL `http://xahlee.info/emacs/emacs/emacs_copy_cut_current_line.html'
Created: 2010-05-21
Version: 2015-06-10"
  (interactive)
  (if current-prefix-arg
      (progn ; not using kill-region because we don't want to include previous kill
        (kill-new (buffer-string))
        (delete-region (point-min) (point-max)))
    (progn (if (region-active-p)
               (kill-region (region-beginning) (region-end) t)
             (kill-region (line-beginning-position) (line-beginning-position 2))))))

;; Set keys
(keymap-global-set "<f5>" 'xah-copy-line-or-region)
(keymap-global-set "<f6>" 'xah-cut-line-or-region)


;;; END of Code ;; ------------------------------------------------------------------------------------------------------------------
;;; Install packages
(require 'package)

;;(add-to-list 'package-archives
;;             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

; list the packages you want
(setq package-list
      '(use-package yasnippet comment-tags autothemer
       auto-complete flycheck yaml-mode
       ac-ispell haskell-mode ada-ts-mode
       company gpr-ts-mode gpr-yasnippets
       xref lsp-mode rust-mode eglot smartparens elpy
       lsp-java lsp-ui helm helm-lsp projectile erlang
       flycheck-rust treemacs ivy all-the-icons all-the-icons-ivy
       all-the-icons-dired all-the-icons-ibuffer treemacs-all-the-icons))

;; (use-package rust-mode
;;   :init
;;   (setq rust-mode-treesitter-derive t))

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
;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "/home/madtail/.emacs.d/elpa/use-package-2.4.6")
  (require 'use-package))

(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (setq use-package-always-ensure t)
   (require 'use-package)))


;; Highlights the word/symbol at point and any other occurrences in
;; view. Also allows to jump to the next or previous occurrence.
;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  :ensure t
  :config
  (setq highlight-symbol-on-navigation-p t)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;; Emacs minor mode that highlights numeric literals in source code.
;; https://github.com/Fanael/highlight-numbers
(use-package highlight-numbers
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-numbers-mode))

;; http://www.reddit.com/r/emacs/comments/2keh6u/show_tabs_and_trailing_whitespaces_only/
(use-package whitespace
  :config
  ;; Commented since there are too many 'valid' whitespaces in some modes.
  ;; (setq-default show-trailing-whitespace t)
  (setq whitespace-style '(face tabs trailing))
  (set-face-attribute 'whitespace-tab nil
      :background "red"
      :foreground "yellow"
      :weight 'bold)
  (add-hook 'prog-mode-hook 'whitespace-mode)
  ;; Delete trailing tabs and spaces on save of a file.
  (add-hook 'before-save-hook 'whitespace-cleanup)
  )

;; Bind treemacs to F12
(global-set-key [(f12)] #'treemacs-select-window)

;;;; `COMPANY'
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  ;; To prevent default down-casing.
  ;; https://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text
  (setq company-dabbrev-downcase nil)
  ;; 2023-01-13 From a Reddit post on mixed case issue.
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-code-ignore-case nil))

;; Use `company' everywhere.
(add-hook 'after-init-hook 'global-company-mode)

(require 'flymake)
;; Not mine, it's from: https://olddeuteronomy.github.io/post/cpp-programming-in-emacs/
(defun my/flymake-toggle-diagnostics-buffer ()
  (interactive)
  ;; Check if we are in the diagnostics buffer.
  (if (string-search "*Flymake diagnostics" (buffer-name))
      (delete-window)
    (progn
      ;; Activate the Flymake diagnostics buffer.
      ;; and switch to it
      (flymake-show-buffer-diagnostics)
      (let ((name (flymake--diagnostics-buffer-name)))
        (if (get-buffer name)
            (switch-to-buffer-other-window name)
          (error "No Flymake diagnostics buffer found")
          )))))

;; Bind diagnostics to F7
(global-set-key [(f7)] #'my/flymake-toggle-diagnostics-buffer)

;; Additional bindings.
(global-set-key (kbd "C-c f b") #'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c f p") #'flymake-show-project-diagnostics)

(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (add-hook 'after-init-hook (lambda () (setq ivy-height (/ (window-height) 2))))
)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)
)

(use-package treemacs :ensure t)
(use-package treemacs-projectile :ensure t)

;; Show the current buffer's imenu entries in a separate buffer
(use-package imenu-list
  :ensure t
  :config
  (setq imenu-list-focus-after-activation t)
  (global-set-key (kbd "C-.") #'imenu-list-minor-mode)
)

;; ICONS
;; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons :ensure t)

(use-package all-the-icons-dired :ensure t)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package all-the-icons-ibuffer :ensure t
  :init (all-the-icons-ibuffer-mode 1)
  :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package treemacs-all-the-icons :ensure t)

(use-package all-the-icons-ivy :ensure t
  :after all-the-icons
  :config (all-the-icons-ivy-setup))














;; Beginning of trash

;; Ada stuff
(load "~/.emacs.d/emacs-ada.el")

;; Python stuff
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; Linter
;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)


;; ;; Company
;; (require 'company)
;; ;;(global-company-mode 1)
;; (add-hook 'after-init-hook #'global-company-mode)
;; (use-package company
;;   :ensure t
;;   ;;:hook (after-init . global-company-mode)
;;   :custom
;;   (company-idle-delay 0.3)) ;; how long to wait until popup

;;yasnippet
(add-to-list 'load-path
                "~/path-to-yasnippet")
   (require 'yasnippet)
(yas-global-mode 1)

;; Erlang
(setq load-path (cons  "/usr/lib64/erlang/lib/tools-4.1.3/emacs"
load-path))
(setq erlang-root-dir "/usr/lib64/erlang/")
(setq exec-path (cons "/usr/lib64/erlang/bin" exec-path))
(require 'erlang-start)

;; BEGINNING of rust stuff

(defun sp1ff/rust/mode-hook ()
  "My rust-mode hook"

  (column-number-mode)
  (display-line-numbers-mode)
  (hs-minor-mode)
  (smartparens-mode)
  (define-key rust-mode-map "\C-ca" 'eglot-code-actions)
 ;; (define-key rust-mode-map (kbd "C-<right>")   'sp-forward-slurp-sexp)
 ;; (define-key rust-mode-map (kbd "C-<left>")    'sp-forward-barf-sexp)
 ;; (define-key rust-mode-map (kbd "C-M-<right>") 'sp-backward-slurp-sexp)
 ;; (define-key rust-mode-map (kbd "C-M-<left>")  'sp-backward-barf-sexp)
  (define-key rust-mode-map "\C-c>" 'hs-show-all)
  (define-key rust-mode-map "\C-c<" 'hs-hide-all)
  (define-key rust-mode-map "\C-c;" 'hs-toggle-hiding)
  (define-key rust-mode-map "\C-c'" 'hs-hide-level)
  (setq indent-tabs-mode nil
        tab-width 4
        c-basic-offset 4
        fill-column 100))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . sp1ff/rust/mode-hook)
  :config
  (let ((dot-cargo-bin (expand-file-name "~/.cargo/bin/")))
    (setq rust-rustfmt-bin (concat dot-cargo-bin "rustfmt")
          rust-cargo-bin (concat dot-cargo-bin "cargo")
          rust-format-on-save t)))

(use-package clippy-flymake
  :vc (:url "https://git.sr.ht/~mgmarlow/clippy-flymake" :branch main)
  :hook (rust-mode . clippy-flymake-setup-backend))

(defun clippy-flymake-manually-activate-flymake ()
  "Shim for working around eglot's tendency to suppress flymake backends."
  (add-hook 'flymake-diagnostic-functions #'eglot-flymake-backend nil t)
  (flymake-mode 1))

;; `eglot' by default will suppress all other flymake backends than its own
;; <https://github.com/joaotavora/eglot/issues/268> This workaround will
;; add `flymake-clippy'
(use-package eglot
  :ensure t
  :hook ((rust-mode . eglot-ensure)
         (eglot-managed-mode . clippy-flymake-manually-activate-flymake))
  :config
  (add-to-list 'eglot-stay-out-of 'flymake))

;; flycheck
;;(use-package flycheck :ensure)

(with-eval-after-load 'rust-mode
      (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(remove-hook 'flymake-diagnostic-functions 'rust-ts-flymake)


;; END of rust stuff


;; JAVA stuff
(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;;(use-package projectile)
(use-package flycheck)
(use-package yasnippet :config (yas-global-mode))
(use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration)))
(use-package hydra)
;;(use-package company)
(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package helm-lsp)
(use-package helm
  :config (helm-mode))
(use-package lsp-treemacs)

;; END of JAVA stuff

; auto-complete
;;(package-initialize)
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode 0)

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

(require 'python)

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
         ("\\.rs$" . rust-mode)
         ("\\.erl$" . erlang-mode)
         ("\\.java$" . java-mode)
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
                                    (statement-block-intro .  c-lineup-gnu-DEFUN-intro-cont)
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

;;(add-hook 'c-mode-common-hook 'casey-big-fun-c-hook)


;; C and C++ stuff
(require 'eglot)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-or-c++-mode-hook 'eglot-ensure)

(setq c-default-style "stroustrup")
(setq c-basic-indent 4)
(setq c-basic-offset 4)

;; emacs-fu: don’t indent inside of C++ namespaces
;; http://brrian.tumblr.com/post/9018043954/emacs-fu-dont-indent-inside-of-c-namespaces
(c-set-offset 'innamespace 0)



(provide 'init);;; init.el ends here
