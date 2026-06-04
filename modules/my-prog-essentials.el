;;; Version Control

(prot-emacs-configure
  (setq vc-follow-symlinks t)

  (with-eval-after-load 'vc
    (require 'vc-git)
    
    ;; Restrict to only use Git.
    (setq vc-handled-backends '(Git))))


;;;; `project'
(prot-emacs-configure
  (prot-emacs-keybind global-map
    "C-x p ." #'project-dired
    "C-x p C-g" #'keyboard-quit
    "C-x p <return>" #'project-dired
    "C-x p <delete>" #'project-forget-project)

  (setopt project-switch-commands
          '((project-find-file "Find file")
            (project-find-regexp "Find regexp")
            (project-find-dir "Find directory")
            (project-dired "Root dired")
            (project-vc-dir "VC-Dir")
            (project-shell "Shell")
            (keyboard-quit "Quit")))
  (setq project-vc-extra-root-markers '(".project")) ; Emacs 29
  (setq project-key-prompt-style t) ; Emacs 30
  )

;;;; diff
;;;;; `diff-hl'
(prot-emacs-configure
  (prot-emacs-install diff-hl)

  (setq diff-hl-draw-borders nil)
  (setq diff-hl-update-async t)

  (prot-emacs-hook (prog-mode-hook vc-dir-mode-hook) turn-on-diff-hl-mode)

  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

;;;;; `ediff'
(prot-emacs-configure
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-merge-revisions-with-ancestor t)
  (setq ediff-show-clashes-only t)

  (with-eval-after-load 'outline
    (add-hook 'ediff-prepare-buffer-hook #'outline-show-all))

  ;; The C-x v prefix is for all "version control" commands that are
  ;; already built into Emacs.  It makes sense to extend it for this
  ;; use-case.
  (prot-emacs-keybind global-map
    "C-x v 2" #'prot-ediff-visible-buffers-2
    "C-x v 3" #'prot-ediff-visible-buffers-3))
  ;; (add-hook 'ediff-before-setup-hook #'prot-ediff-store-layout)
  ;; (add-hook 'ediff-quit-hook #'prot-ediff-restore-layout))

;;;; Magit
(prot-emacs-configure
  (setq transient-show-menu 0.3)

  (prot-emacs-install magit)

  ;; Let `display-buffer-alist' do its job
  (setq magit-display-buffer-function #'display-buffer)

  (setq magit-diff-refine-hunk t)
  (setq magit-diff-fontify-hunk nil)
  (setq magit-diff-refine-ignore-whitespace t)

  (setq git-commit-summary-max-length 80))


;;; LSP (Eglot)
(prot-emacs-configure
  (setq eglot-sync-connect nil)
  (setq eglot-autoshutdown t)

  (with-eval-after-load 'eglot
    (prot-emacs-keybind eglot-mode-map
      "C-c r" #'eglot-rename
      "C-c f" #'eglot-code-action-quickfix))
  )

;;; Eldoc
(prot-emacs-configure
  (add-hook 'prog-mode-hook #'eldoc-mode)
  (setq eldoc-idle-delay 0.8)
  (setq eldoc-message-function #'message)) ; don't use mode line for M-x eval-expression, etc.

;;; Flymake
(prot-emacs-configure
  (with-eval-after-load 'flymake
    (prot-emacs-keybind flymake-mode-map
      "C-c e n" #'flymake-goto-next-error
      "C-c e p" #'flymake-goto-prev-error
      "C-c e s" #'flymake-start
      "C-c e d" #'flymake-show-buffer-diagnostics
      "C-c e D" #'flymake-show-project-diagnostics)

    (setq flymake-fringe-indicator-position 'left-fringe)
    (setq flymake-suppress-zero-counters t)
    (setq flymake-no-changes-timeout 5)
    (setq flymake-start-on-flymake-mode t)
    (setq flymake-start-on-save-buffer t)
    (setq flymake-proc-compilation-prevents-syntax-check t)
    (setq flymake-wrap-around nil)
    (setq flymake-mode-line-format
          '("" flymake-mode-line-exception flymake-mode-line-counters))
    (setq flymake-mode-line-counter-format
          '("" flymake-mode-line-error-counter
            flymake-mode-line-warning-counter
            flymake-mode-line-note-counter ""))))
    ;; (setq flymake-show-diagnostics-at-end-of-line nil)) ; Emacs 31

;;; Call to provide
(provide 'my-prog-essentials)
