;;; Base Setup
(load "~/.emacs.d/sanemacs.el")

;theme and display
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-nord t))

(setq-default column-number-mode t
			  tab-width 4
			  indent-tabs-mode nil)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(setq typescript-indent-level 4
      js-indent-level 4
      vue-html-tab-width 4
      css-indent-offset 2
      c-basic-offset 4)

;Basic programming utilities
(use-package magit
  :ensure t)

(defun vue-eglot-init-options ()
    (let ((tsdk-path (expand-file-name
                      "lib"
                      (shell-command-to-string "npm list --global --parseable typescript | head -n1 | tr -d '\n'"))))
      `(:typescript (:tsdk ,tsdk-path
                           :languageFeatures (:completion
                                              (:defaultTagNameCase "both"
                                                                   :defaultAttrNameCase "kebabCase"
                                                                   :getDocumentNameCasesRequest nil
                                                                   :getDocumentSelectionRequest nil)
                                              :diagnostics
                                              (:getDocumentVersionRequest nil))
                           :documentFeatures (:documentFormatting
                                              (:defaultPrintWidth 100
                                                                  :getDocumentPrintWidthRequest nil)
                                              :documentSymbol t
                                              :documentColor t)))))

(use-package eglot
  :ensure t
  :defer t
  :bind (:map eglot-mode-map
              ("C-c <tab>" . company-complete)
              ("C-c e n" . flymake-goto-next-error)
              ("C-c e p" . flymake-goto-prev-error)
              ("C-c e r" . eglot-rename)
              ("C-c f" . eglot-code-action-quickfix))
  :hook ((rustic-mode c-mode c++-mode typescript-mode vue-mode) . eglot-ensure)
  :config
  ;(add-to-list 'project-vc-extra-root-markers "build.gradle")
  (customize-set-variable 'eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs
               `(rustic-mode . ("rust-analyzer" :initializationOptions
                                ( :procMacro (:enable t)
                                  :cargo ( :buildScripts (:enable t)
                                           :features "all")))))
  (add-to-list 'eglot-server-programs
               `((c-mode c++-mode) . ("clangd-15")))
  (add-to-list 'eglot-server-programs
               `(vue-mode . ("vue-language-server" "--stdio" :initializationOptions ,(vue-eglot-init-options)))))

(use-package eldoc
  :ensure)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.2)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package undo-tree
  :ensure t
  :bind (:map undo-tree-map
			  ("C-c u" . 'undo-tree-undo)
			  ("C-c r" . 'undo-tree-redo)))


;;; Rust
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t
        rustic-lsp-client 'eglot)
  (add-to-list 'project-vc-extra-root-markers "Cargo.toml")
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer")))

;;; Java
;;; https://github.com/yveszoundi/eglot-java
(use-package eglot-java
  :ensure t
  :hook (java-mode . eglot-java-mode))

;;; Docker and yaml
(use-package dockerfile-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)


;;; Web
(use-package typescript-mode
  :ensure t
  :config
  (add-to-list 'project-vc-extra-root-markers "tsconfig.json"))
(use-package js2-mode
  :ensure t)

(use-package vue-mode
  :ensure t
  :hook (vue-mode . (lambda ()
	    (set-face-background 'mmm-default-submode-face nil)))
  :mode "\\.vue$"
  :config
  (add-to-list 'mmm-save-local-variables '(syntax-ppss-table buffer)))
