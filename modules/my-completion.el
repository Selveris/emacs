;;; General completion settings
(prot-emacs-configure
  (setq completion-styles '(basic substring partial-completion flex))
  (setq completion-flex-nospace t)
  (setq completion-ignore-case t)
  (setq read-buffer-completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t)
  ;; (setq completion-pcm-leading-wildcard nil) ; Emacs 31
  (with-eval-after-load 'orderless
    (setq completion-styles (append completion-styles '(orderless)))))

;;; Orderless completion style
(prot-emacs-configure
  (prot-emacs-install orderless)
  (require 'orderless)
  ;; Remember to check my `completion-styles' and the
  ;; `completion-category-overrides'.
  (setq orderless-matching-styles '(orderless-prefixes orderless-regexp))
  (setq orderless-smart-case nil)

  ;; SPC should never complete: use it for `orderless' groups.
  ;; The `?' is a regexp construct.
  (prot-emacs-keybind minibuffer-local-completion-map
    "SPC" nil
    "?" nil))

;;; Corfu (in-buffer completion popup)
(prot-emacs-configure
  (prot-emacs-install corfu)

  ;; (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  (global-corfu-mode 1)

  ;; I also have (setq tab-always-indent 'complete) for TAB to complete
  ;; when it does not need to perform an indentation change.
  (define-key corfu-map (kbd "<tab>") #'corfu-complete)

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;;; Completion-preview 
(prot-emacs-configure
  (setq completion-preview-exact-match-only nil)
  (setq completion-preview-minimum-symbol-length 4)
  (setq completion-preview-idle-delay 0.3)
  (setq completion-preview-ignore-case t)
  (setq completion-preview-sort-function #'identity)

  (add-hook 'prog-mode-hook #'completion-preview-mode)

  (with-eval-after-load 'completion-preview
    (prot-emacs-keybind completion-preview-active-mode-map
      "M-n" #'completion-preview-next-candidate
      "M-p" #'completion-preview-prev-candidate
      "<tab>" #'completion-preview-complete
      "C-f" #'completion-preview-insert)))

;;; Call to provide
(provide 'my-completion)
