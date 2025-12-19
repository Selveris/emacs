;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sanemacs version 0.3.2 ;;;
;;; https://sanemacs.com   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; For performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb


(add-hook 'after-init-hook #'(lambda ()
                               ;; restore after startup
                               (setq gc-cons-threshold 800000)))

;;; Disable menu-bar, tool-bar, and scroll-bar.
(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;;; Fix this bug:
;;; https://www.reddit.com/r/emacs/comments/cueoug/the_failed_to_download_gnu_archive_is_a_pretty/
(when (version< emacs-version "26.3")
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

;;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")
             t)
(package-initialize)

;;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;; Useful Defaults
(setq-default cursor-type 'bar)           ; Line-style cursor similar to other text editors
(setq inhibit-startup-screen t)           ; Disable startup screen
(setq initial-scratch-message "")         ; Make *scratch* buffer blank
(setq-default frame-title-format '("%b")) ; Make window title the buffer name
(setq ring-bell-function 'ignore)         ; Disable bell sound
(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(show-paren-mode 1)                       ; Show closing parens by default
(setq linum-format "%4d ")                ; Line number format
(delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
(global-auto-revert-mode t)               ; Auto-update buffer if file has changed on disk
(use-package undo-tree                    ; Enable undo-tree, sane undo/redo behavior
  :init (global-undo-tree-mode)
  :config (setq-default undo-tree-auto-save-history nil))
(add-hook 'before-save-hook
	  'delete-trailing-whitespace)    ; Delete trailing whitespace on save

(defun sanemacs/backward-kill-word ()
  (interactive "*")
  (push-mark)
  (backward-word)
  (delete-region (point) (mark)))

(defun comment-delete (arg)
  "Delete the first comment on this line, if any.  Don't touch
the kill ring.  With prefix ARG, delete comments on that many
lines starting with this one."
  (interactive "P")
  (comment-normalize-vars)
  (dotimes (_i (prefix-numeric-value arg))
    (save-excursion
      (beginning-of-line)
      (let ((cs (comment-search-forward (line-end-position) t)))
    (when cs
      (goto-char cs)
      (skip-syntax-backward " ")
      (setq cs (point))
      (comment-forward)
      ;; (kill-region cs (if (bolp) (1- (point)) (point))) ; original
      (delete-region cs (if (bolp) (1- (point)) (point)))  ; replace kill-region with delete-region
      (indent-according-to-mode))))
    (if arg (forward-line 1))))

(defun comment-delete-dwim (beg end arg)
  "Delete comments without touching the kill ring.  With active
region, delete comments in region.  With prefix, delete comments
in whole buffer.  With neither, delete comments on current line."
  (interactive "r\nP")
  (let ((lines (cond (arg
                      (count-lines (point-min) (point-max)))
                     ((region-active-p)
                      (count-lines beg end)))))
    (save-excursion
      (when lines
        (goto-char (if arg (point-min) beg)))
      (comment-delete (or lines 1)))))

;;; Keybindings
(global-set-key [mouse-3] 'mouse-popup-menubar-stuff)          ; Gives right-click a context menu
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop) ; Indent selection by one tab length
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)  ; De-indent selection by one tab length
(global-set-key (kbd "M-DEL") 'sanemacs/backward-kill-word)    ; Kill word without copying it to your clipboard
(global-set-key (kbd "C-DEL") 'sanemacs/backward-kill-word)    ; Kill word without copying it to your clipboard

;;; Offload the custom-set-variables to a separate file
;;; This keeps your init.el neater and you have the option
;;; to gitignore your custom.el if you see fit.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
;;; Load custom file. Don't hide errors. Hide success message
(load custom-file nil t)

;;; Put Emacs auto-save and backup files to /tmp/ or C:/Temp/
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq
   backup-by-copying t                                        ; Avoid symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t
   auto-save-list-file-prefix emacs-tmp-dir
   auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir))
   lock-file-name-transforms `(("\\`/.*/\\([^/]+\\)\\'" "/tmp/\\1" t)))

;;; Load wheatgrass as the default theme if one is not loaded already

(if (not custom-enabled-themes)
    (load-theme 'wheatgrass t))

(defun reload-config ()
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory)))
