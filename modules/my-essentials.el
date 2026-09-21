;;; Vundo
(prot-emacs-configure
  (prot-emacs-install vundo))

;;; Generic settings
(prot-emacs-configure
  (setq backward-delete-char-untabify-method 'hungry)
  (setq blink-matching-paren nil)
  (setq custom-unlispify-tag-names nil)
  (setq delete-pair-blink-delay 0.1) ; Emacs28 -- see `prot-simple-delete-pair-dwim'
  (setq echo-keystrokes-help nil) ; Emacs 30
  (setq epa-keys-select-method 'minibuffer) ; Emacs 30
  (setq eval-expression-print-length nil)
  (setq find-library-include-other-files nil) ; Emacs 29
  (setq help-window-select nil)
  (setq help-window-keep-selected t) ; Emacs 29
  (setq kill-do-not-save-duplicates t)
  (setq mode-require-final-newline 'visit-save)
  (setq next-error-recenter '(4)) ; center of the window
  (setq remote-file-name-inhibit-auto-save t)                 ; Emacs 30
  (setq remote-file-name-inhibit-delete-by-moving-to-trash t) ; Emacs 30
  (setq save-interprogram-paste-before-kill t)
  (setq truncate-partial-width-windows nil)

  (global-auto-revert-mode 1)
  (setq auto-revert-verbose t)

  (delete-selection-mode 1))

;;; Tabs, indentation and electric behaviour
(prot-emacs-configure
  (setq tab-always-indent 'complete)
  (setq tab-first-completion 'word-or-paren-or-punct) ; Emacs 27
  (setq-default tab-width 4
                indent-tabs-mode nil)

  (add-hook 'prog-mode-hook #'electric-indent-local-mode)
  (with-eval-after-load 'electric
    (electric-pair-mode -1)
    (electric-quote-mode -1)
    (electric-indent-mode -1)))

;;; Built-in bookmarking framework (bookmark.el)
(prot-emacs-configure
  (add-hook 'bookmark-bmenu-mode-hook #'hl-line-mode)
  (setq bookmark-use-annotations nil)
  (setq bookmark-automatically-show-annotations nil)
  (setq bookmark-fringe-mark nil) ; Emacs 29 to hide bookmark fringe icon
  ;; Write changes to the bookmark file as soon as 1 modification is
  ;; made (addition or deletion).  Otherwise Emacs will only save the
  ;; bookmarks when it closes, which may never happen properly
  ;; (e.g. power failure).
  (setq bookmark-save-flag 1))

;;; Dired file manager and extras
;;;; Dired tweaks
(prot-emacs-configure
  (with-eval-after-load 'dired
    (setq dired-recursive-copies 'always)
    (setq dired-recursive-deletes 'always)
    (setq dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
    (setq dired-dwim-target t)
    (setq dired-auto-revert-buffer #'dired-directory-changed-p) ; also see `dired-do-revert-buffer'
    (setq dired-make-directory-clickable t) ; Emacs 29.1
    (setq dired-free-space nil) ; Emacs 29.1
    (setq dired-mouse-drag-files t) ; Emacs 29.1

    (prot-emacs-hook dired-mode-hook (hl-line-mode))

    (require 'dired-aux)
    (setq dired-isearch-filenames 'dwim)
    (setq dired-create-destination-dirs 'ask) ; Emacs 27
    (setq dired-vc-rename-file t)             ; Emacs 27
    (setq dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))) ; Emacs 28
    (setq dired-create-destination-dirs-on-trailing-dirsep t) ; Emacs 29

    (require 'dired-x)
    (define-key dired-mode-map (kbd "I") #'dired-info)
    (setq dired-clean-up-buffers-too t)
    (setq dired-clean-confirm-killing-deleted-buffers t)))

;;;; Dired-subtree
(prot-emacs-configure
  (prot-emacs-install dired-subtree)
  (with-eval-after-load 'dired
    (prot-emacs-keybind dired-mode-map
      "<tab>" #'dired-subtree-toggle
      "TAB" #'dired-subtree-toggle
      "<backtab>" #'dired-subtree-remove
      "S-TAB" #'dired-subtree-remove)
    (setq dired-subtree-use-backgrounds nil)))

;;; Global Keybinds
(prot-emacs-configure  
  (prot-emacs-keybind global-map
    "<f2>" #'nil
    "<insert>" #'nil
    "<menu>" #'nil
    "C-M-w" nil ; never use it
    "C-x C-d" #'nil ; never use it
    "C-x C-v" #'nil ; never use it
    "C-x C-c" #'save-buffers-kill-emacs
    "C-h h" #'nil ; Never show that "hello" file
    "M-`" #'nil
    "M-SPC" #'cycle-spacing
    "M-z" #'zap-up-to-char ; NOT `zap-to-char'
    "M-c" #'capitalize-dwim
    "M-l" #'downcase-dwim ; "lower" case
    "M-u" #'upcase-dwim
    "M-=" #'count-words
    "C-x O" #'next-multiframe-window
    "C-x r" #'undo-redo
    "C-h K" #'describe-keymap ; overrides `Info-goto-emacs-key-command-node'
    "C-h u" #'apropos-user-option
    "C-h F" #'apropos-function ; lower case is `describe-function'
    "C-h V" #'apropos-variable ; lower case is `describe-variable'
    "C-h L" #'apropos-library) ; lower case is `view-lossage'

  ;; Keymap for buffers (Emacs28)
  (prot-emacs-keybind ctl-x-x-map
    "f" #'follow-mode  ; override `font-lock-update'
    "r" #'rename-uniquely
    "l" #'visual-line-mode))

;;; Shell (comint) and Compile buffer
(prot-emacs-configure
  (add-hook 'comint-output-filter-functions #'comint-osc-process-output)
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

  (setq ansi-color-for-comint-mode t) ; shell (comint)
  (setq ansi-color-for-compilation-mode t) ; compilation
  (setq comint-prompt-read-only t)
  (setq comint-buffer-maximum-size 9999)
  (setq comint-completion-autolist t)
  (setq comint-input-ignoredups t)
  (setq-default comint-scroll-to-bottom-on-input t)
  (setq-default comint-scroll-to-bottom-on-output nil)
  (setq-default comint-input-autoexpand 'input))

;;; Emacs server (allow emacsclient to connect to running session)
(prot-emacs-configure
  (setq server-client-instructions nil)
  (require 'server)
  (unless (or (server-running-p) (daemonp))
    (server-start)))

;;; Provide module
(provide 'my-essentials)
