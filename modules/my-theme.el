;;; Color theme
(prot-emacs-configure
 (prot-emacs-install ef-themes)

 (ef-themes-take-over-modus-themes-mode 1)

 (prot-emacs-keybind global-map
                     "C-<f5>" #'modus-themes-select)

 (setq modus-themes-variable-pitch-ui t
        modus-themes-mixed-fonts t
        modus-themes-bold-constructs t
        modus-themes-italic-constructs t
        modus-themes-to-rotate nil ; defaults to the return value of `modus-themes-get-themes'
        modus-themes-headings ; read the manual's entry of the doc string
        '((0 . (variable-pitch light 1.9))
          (1 . (variable-pitch light 1.8))
          (2 . (variable-pitch regular 1.7))
          (3 . (variable-pitch regular 1.6))
          (4 . (variable-pitch regular 1.5))
          (5 . (variable-pitch 1.4)) ; absence of weight means `bold'
          (6 . (variable-pitch 1.3))
          (7 . (variable-pitch 1.2))
          (agenda-date . (semilight 1.5))
          (agenda-structure . (variable-pitch light 1.9))
          (t . (variable-pitch 1.1))))

 (modus-themes-load-theme 'ef-owl))

;;; Dashboard startup screen
(prot-emacs-configure
  (prot-emacs-install dashboard)

  (dashboard-setup-startup-hook)

  (setq dashboard-items '((projects . 10) (bookmarks . 5) (recents . 5)))
  (setq dashboard-vertically-center-content t)
  (setq dashboard-show-shortcuts nil))

;;; General window and buffer configurations
(prot-emacs-configure
  ;;;; tab-bar
  (setq tab-bar-new-button-show nil)
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-show 1)

  ;;;; buffer names `uniquify'
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-after-kill-buffer-p t)

  ;;;; Line numbers
  (define-key global-map (kbd "<f1>") #'display-line-numbers-mode)
  (setq display-line-numbers-type 'relative)
  (setq display-line-numbers-major-tick 0)
  (setq display-line-numbers-minor-tick 0)
  (setq-default display-line-numbers-widen t)

  ;;;; fringe
  (set-fringe-mode 4))

;;; Cursor related
(setq-default cursor-type 'bar)
(prot-emacs-configure
  ;;;; parenthesis
  (add-hook 'prog-mode-hook #'show-paren-local-mode)
  (with-eval-after-load 'paren
    (setq show-paren-style 'parenthesis)
    (setq show-paren-when-point-in-periphery nil)
    (setq show-paren-when-point-inside-paren nil)
    (setq show-paren-context-when-offscreen 'overlay)) ; Emacs 29

  ;;;; Line highlight
  (setq hl-line-sticky-flag nil))

;;; Provide module
(provide 'my-theme)
