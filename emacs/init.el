;;;; Packages

(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;;;; Sane defaults

(setq-default

 ;; always load newest byte code
 load-prefer-newer t

 inhibit-startup-screen t

 custom-file "~/.emacs.d/custom.el"

 ;; disable backup and lock files
 make-backup-files nil
 create-lockfiles nil

 ;; do not use hard tabs
 indent-tabs-mode nil
 ;; but retain proper tab width if any appear
 tab-width 8

 fill-column 80

 display-line-numbers-type 'relative

 ;; put autosave #files# into /tmp
 backup-directory-alist `((".*" . ,temporary-file-directory))
 auto-save-file-name-transforms `((".*" ,temporary-file-directory t))

 ;; reduce GC sensitivity
 gc-cons-threshold 50000000

 ;; warn when opening files larger than 10MB
 large-file-warning-threshold 10000000

 ;; enable auto refresh
 global-auto-revert-non-file-buffers t
 auto-revert-verbose nil

 ;; disable bell
 ring-bell-function 'ignore
 next-screen-context-lines 5

 ;; add new line at the end of file
 require-final-newline t

 ;; if line is already indented, try completing it instead
 tab-always-indent 'complete

 ;; deactivate the delay before showing the matching paren
 show-paren-delay 0

 cursor-type 'bar
 )

;; auto refresh externally changed buffers
(global-auto-revert-mode 1)

;; handle trailing whitespace properly
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; replace 'yes/no' with 'y/n'
(defalias 'yes-or-no-p 'y-or-n-p)

(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(line-number-mode t)
(column-number-mode t)
(show-paren-mode 1)

;;;; Packages

;;; use-package and its dependencies
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)

(use-package diminish
  :ensure t)

;;; built-in packages

(use-package windmove
  :config
  (windmove-default-keybindings))

(use-package hl-line
  :config
  (global-hl-line-mode t))

(use-package whitespace-mode
  :bind
  ("H-s" . whitespace-mode))

(use-package re-builder
  :bind
  (("H-r" . re-builder)
   :map reb-mode-map
   ("H-r" . reb-quit)))

(use-package tramp
  :init
  (setq tramp-default-method "ssh"))

(use-package js
  :init
  (setq js-indent-level 2))

;;; theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (set-face-attribute 'default nil
                      :font "Fantasque Sans Mono-13")
  :config
  (load-theme 'sanityinc-tomorrow-night t))

(use-package eyebrowse
  :ensure t
  :init
  (setq eyebrowse-keymap-prefix (kbd "s-w")
        eyebrowse-new-workspace t)
  :config
  (eyebrowse-mode t)
  (eyebrowse-setup-opinionated-keys))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :init
  (setq
   ivy-wrap t
   ivy-use-virtual-buffers t
   ivy-height 20
   ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode t))

;; swiper replaces isearch, both forward and backward
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h l" . counsel-find-library)
         ("C-h a" . counsel-apropos)
         ("C-c g" . counsel-git)
         ("M-y" . counsel-yank-pop)
         :map ivy-minibuffer-map
         ("M-y" . ivy-next-line)))

(use-package flx
  :ensure t)

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char-timer))
  :config
  (set-face-foreground 'avy-background-face "gray40")
  (setq avy-background t))

(use-package dimmer
  :ensure t
  :init
  (dimmer-configure-magit)
  (dimmer-configure-which-key)
  :config
  (dimmer-mode))

(use-package org
  :ensure t
  :init
  '(org-export-backends '(ascii html md odt))
  )

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h l" . counsel-find-library)
         ("C-h a" . counsel-apropos)
         ("C-c g" . counsel-git)
         ("M-y" . counsel-yank-pop)
         :map ivy-minibuffer-map
         ("M-y" . ivy-next-line)))

(use-package flx
  :ensure t)

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char-timer))
  :config
  (set-face-foreground 'avy-background-face "gray40")
  (setq avy-background t))

(use-package org
  :ensure t
  :init
  '(org-export-backends '(ascii html md odt))
  )

;; evil is used with insert mode replaced with emacs mode, emacs mode being the default state
;; normal mode is entered with C-z
(use-package evil
  :ensure t
  :init
  (setq
   evil-disable-insert-state-bindings t
   evil-want-Y-yank-to-eol t
   evil-default-state 'normal)
  (evil-mode -1)
  (defun toggle-evil-mode ()
    (interactive)
    (if (bound-and-true-p evil-local-mode)
        (progn
          (turn-off-evil-mode)
          (set-variable 'cursor-type 'bar)
          (display-line-numbers-mode -1))
      (progn
        (turn-on-evil-mode)
        (set-variable 'cursor-type 'box)
        (display-line-numbers-mode t))))
  :bind ("M-<tab>" . 'toggle-evil-mode))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)

(use-package projectile
  :ensure t
  :diminish
  :init
  (setq
   projectile-completion-system 'ivy
   projectile-git-command "fd . -0 --type f --hidden --color=never")
  :bind (:map projectile-mode-map ("s-p" . 'projectile-command-map))
  :config
  (projectile-global-mode))

(use-package which-key
  :ensure t
  :diminish
  :config
  (which-key-mode))

(use-package magit
  :ensure t
  :bind
  ("s-g" . magit-status)
  :init
  (setq magit-prefer-remote-upstream 't))

;;; Coding

;; Completion
(use-package company
  :ensure t
  :defer t
  :diminish
  :init
  (global-company-mode)
  :config
  (use-package company-jedi
    :ensure t
    :defer t
    :init
    (defun enable-jedi()
      (setq-local company-backends
                  (append '(company-jedi) company-backends)))
    (with-eval-after-load 'company
      (add-hook 'python-mode-hook 'enable-jedi))))

;; LSP
(use-package lsp-mode
  :defer t
  :config
  (add-hook 'python-mode-hook #'lsp))

;; Python

;;; DevOps
(use-package ansible
  :ensure t
  :config
  (add-hook 'yaml-mode-hook '(lambda () (ansible 1))))


;; Terraform
(use-package terraform-mode
  :ensure t
  :config
  (defun terraform-format-buffer ()
    "Rewrite current buffer in a canonical format using terraform fmt."
    (interactive)
    (let ((point (point)))
      (shell-command-on-region (point-min) (point-max) "terraform fmt -" 't 't)
      (deactivate-mark)
      (goto-char point)))
  (add-hook 'terraform-mode-hook
            (lambda () (add-hook 'before-save-hook terraform-format-buffer nil 'local))))

(use-package elfeed
  :ensure t
  :bind ("s-r" . 'elfeed)
  :init
  (setq elfeed-feeds
        '("https://allatravesti.com/rss"
          "https://hnrss.org/newest?points=200"
          "https://www.reddit.com/r/programming/top.rss?t=week"
          "https://www.reddit.com/r/emacs/top.rss?t=week"
          "http://sachachua.com/blog/category/emacs-news/feed"
          ))
  (setq elfeed-search-filter "@1-week-ago +unread"))


;;;; Diverse configs
;;; Editing

;;;; Diverse bindings
;;; Common operations
;; Buffer management
(global-set-key (kbd "s-f") 'find-file)
(global-set-key (kbd "s-b") 'switch-to-buffer)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-k") 'kill-buffer)
(global-set-key (kbd "s-d") 'dired)
(global-set-key (kbd "s-;") 'comment-line)
(global-set-key (kbd "M-n") (lambda() (interactive) (scroll-up-command 5)))
(global-set-key (kbd "M-p") (lambda() (interactive) (scroll-down-command 5)))
