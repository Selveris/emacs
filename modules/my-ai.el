;;; AI integration

;;;; agent-shell as coding agent
(prot-emacs-configure
  (prot-emacs-install agent-shell)

  ;; add opencode to path
  (add-to-list 'exec-path (expand-file-name "~/.opencode/bin")))

(provide 'my-ai)
