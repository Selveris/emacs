;;; General minibuffer settings
(prot-emacs-configure
  ;;;; ignore casing
  (setq-default case-fold-search t)   ; For general regexp
  (setq minibuffer-history-case-insensitive-variables t)

  ;;;; default completion
  (setq minibuffer-default-prompt-format " [%s]") ; Emacs 29
  (minibuffer-electric-default-mode 1)

  ;;;; interaction
  (setq resize-mini-windows t)
  (setq read-answer-short t) ; also check `use-short-answers' for Emacs28
  (setq echo-keystrokes 0.25)

  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  ;; Do not allow the cursor to move inside the minibuffer prompt.  I
  ;; got this from the documentation of Daniel Mendler's Vertico
  ;; package: <https://github.com/minad/vertico>.
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; (setq crm-prompt (format "%s %%p" (propertize "[%d]" 'face 'shadow))) ; Emacs 31

  (file-name-shadow-mode 1))

;;; `savehist' (minibuffer and related histories)
(prot-emacs-configure
  (setq savehist-file (locate-user-emacs-file "savehist"))
  (setq history-length 100)
  (setq history-delete-duplicates t)
  (setq savehist-save-minibuffer-history t)
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'kill-ring))
  (savehist-mode 1))

;;; Enhanced minibuffer commands (consult.el)
(prot-emacs-configure
  (prot-emacs-install consult)

  (prot-emacs-keybind global-map
    "M-g M-g" #'consult-goto-line
    "M-s M-b" #'consult-buffer
    "M-s M-f" #'consult-find
    "M-s M-g" #'consult-grep
    "M-s M-h" #'consult-history
    "M-s M-i" #'consult-imenu
    "M-s M-l" #'consult-line
    "M-s M-m" #'consult-mark
    "M-s M-y" #'consult-yank-pop
    "M-s M-s" #'consult-outline)

  (setq consult-line-numbers-widen t)
  ;; (setq completion-in-region-function #'consult-completion-in-region)
  (setq consult-async-min-input 3)
  (setq consult-async-input-debounce 0.5)
  (setq consult-async-input-throttle 0.8)
  (setq consult-narrow-key nil)
  (setq consult-find-args
        (concat "find . -not ( "
                "-path */.git* -prune "
                "-or -path */.cache* -prune )"))
  (setq consult-preview-key 'any)
  (setq consult-project-function nil) ; always work from the current directory (use `cd' to switch directory)
  )

;;; Detailed completion annotations (marginalia.el)
(prot-emacs-configure
  (prot-emacs-install marginalia)
  (setq marginalia-max-relative-age 0) ; absolute time
  (marginalia-mode 1))

;;; Vertical completion layout (vertico)
(prot-emacs-configure
  (prot-emacs-install vertico)

  (setq vertico-scroll-margin 0)
  (setq vertico-count 5)
  (setq vertico-resize t)
  (setq vertico-cycle t)
  (setq vertico-preselct 'prompt) ; do not select first entry by default

  (with-eval-after-load 'rfn-eshadow
    ;; This works with `file-name-shadow-mode' enabled.  When you are in
    ;; a sub-directory and use, say, `find-file' to go to your home '~/'
    ;; or root '/' directory, Vertico will clear the old path to keep
    ;; only your current input.
    (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

  (vertico-mode 1))

;;; Call to provide
(provide 'my-minibuffer)
