;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-always-defer nil)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)

;; UI
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (set-face-attribute 'default nil
                      :font "Fantasque Sans Mono-15")
  :config
  (load-theme 'sanityinc-tomorrow-night t))

(use-package diminish)

(use-package hl-line
  :config
  (global-hl-line-mode t))

(use-package flx)

(use-package swiper
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package ivy
  :diminish ivy-mode
  :init
  (setq
   ivy-wrap t
   ivy-use-virtual-buffers t
   ivy-height 20
   ivy-count-format "(%d/%d) "
   ivy-re-builders-alist  '((t . ivy--regex-fuzzy))
   ivy-initial-inputs-alist nil)
  :config
  (ivy-mode t))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-c k" . counsel-rg)
         ("C-c g" . counsel-git)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h l" . counsel-find-library)
         ("C-h a" . counsel-apropos)
         ("M-y" . counsel-yank-pop)
         :map ivy-minibuffer-map
         ("M-y" . ivy-next-line))
  :config
  (counsel-mode t))

(use-package flx)

(use-package which-key
  :ensure t
  :diminish
  :config
  (which-key-mode))

;; Git
(use-package magit
  :ensure t
  :bind
  ("s-g" . magit-status)
  :init
  (setq magit-prefer-remote-upstream 't))

;; Clojure
(use-package cider
  :hook (clojure-mode . cider-mode)
  :config
  (setq
   nrepl-log-messages t))

(use-package clj-refactor
  :hook (clojure-mode . clj-refactor-mode)
  :config
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(use-package paredit
  :hook (clojure-mode . paredit-mode)
  :hook (cider-repl-mode . paredit-mode))

(use-package company
  :hook (clojure-mode . company-mode)
  :hook (cider-repl-mode . company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1))

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;;; General Global Settings
(tool-bar-mode 0)
(menu-bar-mode 0)
(blink-cursor-mode 0)
(global-display-line-numbers-mode t)
(column-number-mode t)
(show-paren-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default
 ; ui
 confirm-kill-emacs 'yes-or-no-p
 inhibit-startup-screen t
 fill-column 80
 display-line-numbers-type 'relative
 scroll-bar-mode nil
 select-enable-clipboard t

 ; tabs
 indent-tabs-mode nil
 tab-width 8

 ; backup, lock, auto save files
 auto-save-default nil
 create-lockfiles nil
 make-backup-files nil

   custom-file "~/.config/emacs/custom.el"
 )
(load custom-file)

;;; Clojure
;; Set indentation level
(setq clojure-indent-style 'align-arguments)


