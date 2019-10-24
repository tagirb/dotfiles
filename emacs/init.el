;;; Packages

;; Define package repositories
(require 'package)
;; Workaround until Emacs 26.3+ comes out
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	("org" . "http://orgmode.org/elpa/")))
(package-initialize)

;;; TODO: update with the current list
(defvar my-packages
  '(;; UI
    flatui-theme
;    sanityinc-tomorrow-night
    ido-vertical-mode
    ;; Editing
    avy
    ;; VCS
    magit
    ;; Project Management
    projectile

    ;; DevOps
    ansible
    ))

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq quelpa-checkout-melpa-p nil)
(quelpa '(devdocs-lookup :fetcher github :repo "skeeto/devdocs-lookup"))
(quelpa '(terraform-mode :fetcher file :path "~/git/emacs/terraform-mode"))

;;; General
;; disable backup and lock files
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; replace 'yes/no' with 'y/n'
(defalias 'yes-or-no-p 'y-or-n-p)

;; custom file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Theme
(load-theme 'sanityinc-tomorrow-night)
(require 'sanityinc-tomorrow-eighties-theme)
(set-face-attribute 'default nil
		    :font "Fantasque Sans Mono-13")
;;; UI
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq column-number-mode 't)

(setq next-screen-context-lines 5)

;; IDO
(require 'ido-vertical-mode)
(require 'flx-ido)
(require 'ido-completing-read+)
(ido-mode 1)
(ido-everywhere 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
(ido-ubiquitous-mode 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights
(setq ido-enable-flex-matching t
      ido-use-faces nil)


;;; Evil
(require 'evil)
(evil-mode 1)
(setq evil-disable-insert-state-bindings 't)
(setq-default evil-want-Y-yank-to-eol 't)
(setq-default display-line-numbers 'relative)
(setq-default evil-default-state 'emacs)
(setq evil-insert-state-modes '())
;; TODO: extend with all modes where Evil is wanted
(setq-default evil-normal-state-modes
	      '(ansible
		conf-mode
		emacs-lisp-mode
		dockerfile-mode
		json-mode
		markdown-mode
		nginx-mode
		python-mode
		shell-script-mode
		terraform-mode))

;;; Eyebrowse
(require 'eyebrowse)
(eyebrowse-mode t)
(eyebrowse-setup-opinionated-keys)
(setq eyebrowse-new-workspace 't)

;; binding to enable/disable evil explicitly
(global-set-key (kbd "H-v") 'evil-mode)
;; scroll by 4 lines by default
(define-key evil-normal-state-map (kbd "C-e") (lambda () (interactive) (evil-scroll-line-down 4)))
(define-key evil-normal-state-map (kbd "C-y") (lambda () (interactive) (evil-scroll-line-up 4)))
(define-key evil-motion-state-map (kbd "C-e") (lambda () (interactive) (evil-scroll-line-down 4)))
(define-key evil-motion-state-map (kbd "C-y") (lambda () (interactive) (evil-scroll-line-up 4)))

;; open dired with "-" in normal mode
(define-key evil-normal-state-map (kbd "-") 'dired-jump)
;; open parent directory with "-" in dired-mode
;; TODO: use find-alternate-file ".." instead
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map (kbd "-") '(lambda() (find-alternate-file "..")))))

;; Tramp
(setq tramp-default-method "ssh")

;; Magit
(global-set-key (kbd "s-g") 'magit-status)
(setq magit-prefer-remote-upstream 't)

;; Projectile
(projectile-global-mode)
;(diminish 'projectile-mode)

(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)

;; DevDocs
(require 'devdocs-lookup)
(devdocs-setup)

;; Elfeed
(require 'elfeed)
(global-set-key (kbd "s-r") 'elfeed)
(setq elfeed-feeds
      '("https://hnrss.org/newest?points=200"
	"https://www.reddit.com/r/programming/top.rss?t=week"
	"https://www.reddit.com/r/emacs/top.rss?t=week"
	"http://sachachua.com/blog/category/emacs-news/feed"
	))
(setq-default elfeed-search-filter "@1-week-ago +unread")

;; JSON
(setq js-indent-level 2)

;; Ansible
(add-hook 'yaml-mode-hook '(lambda () (ansible 1)))

;; Terraform

;; auto-formatting
(defun terraform-format-buffer ()
  "Rewrite current buffer in a canonical format using terraform fmt."
  (interactive)
  (let ((point (point)))
    (shell-command-on-region (point-min) (point-max) "terraform fmt -" 't 't)
    (deactivate-mark)
    (goto-char point)))

(if (boundp 'terraform-mode)
    (add-hook 'before-save-hook #'terraform-format-buffer nil t)
    (remove-hook 'before-save-hook #'terraform-format-buffer t))

(define-compilation-mode terraform-validate-compilation-mode "terraform-validate-compilation-mode"
  "Compilation mode for `terraform validate'"
  (progn
    (set (make-local-variable 'compilation-error-regexp-alist)
	 '(("^\\(.+\\):.+\n\n  on \\(.+\\) line \\([0-9]+\\)," 2 3 nil 1)))
    (add-hook 'compilation-filter-hook
	      (lambda ()
		(read-only-mode)
		(ansi-color-apply-on-region compilation-filter-start (point))
		(read-only-mode))
	      nil t)))

(define-compilation-mode terraform-compilation-mode "terraform-compilation-mode"
  "Terraform compilation mode."
  (progn
    (set (make-local-variable 'compilation-scroll-output) 't)
    (add-hook 'compilation-filter-hook
	      (lambda ()
		(read-only-mode)
		(ansi-color-apply-on-region compilation-filter-start (point))
		(read-only-mode))
	      nil t)))

(defun terraform-cleanup ()
  (interactive)
  (if (y-or-n-p "Clean up the `.terraform/' ?")
      (condition-case err
	  (delete-directory (concat projectile-project-root "/.terraform") 't)
	(error (concat "Failed to remove the `.terraform/': " (error-message-string err))))
    (message "Terraform cleaning aborted")))

(defun terraform-init ()
  (interactive)
  (when (eq major-mode 'terraform-mode)
    (let* (
	   (command "terraform init")
	   (default-directory (projectile-project-root)))
      (compile command 'terraform-compilation-mode))))

(defun terraform-validate ()
  (interactive)
  (when (eq major-mode 'terraform-mode)
    (let* (
	   (command "terraform validate")
	   (default-directory (projectile-project-root)))
      (compile command 'terraform-validate-compilation-mode))))

(defun terraform-plan ()
  (interactive)
  (when (eq major-mode 'terraform-mode)
    (let* (
	   (command "terraform plan")
	   (default-directory (projectile-project-root)))
      (compile command 'terraform-compilation-mode))))

;;;; Diverse configs
;;; Editing
(setq require-final-newline 't)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;; Diverse bindings
;;; Common operations
;; Buffer management
(global-set-key (kbd "s-f") 'ido-find-file)
(global-set-key (kbd "s-b") 'ido-switch-buffer)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-k") 'ido-kill-buffer)
(global-set-key (kbd "s-d") 'ido-dired)

;; ELISP
(add-hook 'emacs-lisp-mode-hook
	  (lambda()
	     (local-set-key (kbd "s-e b") 'eval-buffer)
	     (local-set-key (kbd "s-e e") 'eval-last-sexp)
	     (local-set-key (kbd "s-e f") 'eval-defun)
	     (local-set-key (kbd "s-e r") 'eval-region)))

;; Minor modes
(global-set-key (kbd "H-w") 'whitespace-mode)
(global-set-key (kbd "H-r") 're-builder)
