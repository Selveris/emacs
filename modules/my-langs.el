;;; Common files mode
(prot-emacs-configure
  
  ;;;; Mode for extension-less files
  (add-to-list 'auto-mode-alist '("PKGBUILD" . sh-mode))
  (add-to-list 'auto-mode-alist '("\\`\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'" . text-mode))

  ;;;; Plain text (text-mode)
  (add-hook 'text-mode-hook #'turn-on-auto-fill)

  ;;;; Markdown (markdown-mode)
  (prot-emacs-install markdown-mode)
  (setq markdown-fontify-code-blocks-natively t)

  ;;;; CSV
  (prot-emacs-install csv-mode)

  ;;;; Fish
  (prot-emacs-install fish-mode)

  ;;;; YAML
  (prot-emacs-install yaml-mode)

  ;;;; Docker
  (prot-emacs-install dockerfile-mode)

  )

;;; Programming Languages
;; TODO: enable those conditionaly based on a variable in init.el

;;;; Zig
(defun my-zig-build ()
  (interactive)
  (selv-console-send-command "zig build"))

(defun my-zig-test ()
  (interactive)
  (selv-console-send-command "zig build test"))

(defun my-zig-run ()
  (interactive)
  (selv-console-send-command "zig build run"))

(prot-emacs-configure
  (prot-emacs-install zig-mode)

  (prot-emacs-hook zig-mode-hook eglot-ensure)
  
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
		         `(zig-mode . ("zls"))))

  (prot-emacs-keybind zig-mode-map
    "C-c C-b" #'my-zig-build
    "C-c C-t" #'my-zig-test
    "C-c C-r" #'my-zig-run))

;;;; Rust
;; Change to rust-mode?
(prot-emacs-configure
  (prot-emacs-install rustic)

  (setq rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer"))
  (setq rustic-lsp-client 'eglot)

  (setq rustic-format-on-save t))


;;; Call to provide
(provide 'my-langs)
